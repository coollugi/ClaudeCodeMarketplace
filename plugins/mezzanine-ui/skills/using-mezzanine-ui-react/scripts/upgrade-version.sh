#!/bin/bash

# Mezzanine-UI Version Upgrade Analysis Script
# Purpose: Compare component structure between two versions, fetch changelogs,
#          and generate a work manifest for .md documentation updates.
#
# Usage: ./scripts/upgrade-version.sh --from 1.0.0-rc.5 --to 1.0.0-rc.6

set -euo pipefail

# ─── Paths (resolved after parse_args, once FRAMEWORK is known) ───────────────

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_SKILLS_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
SKILL_DIR=""
CACHE_DIR=""
COMPONENTS_DIR=""
MANIFEST_FILE=""

# ─── Color output ─────────────────────────────────────────────────────────────

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

info()    { echo -e "${GREEN}[INFO]${NC} $1"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $1"; }
error()   { echo -e "${RED}[ERROR]${NC} $1" >&2; }
step()    { echo -e "${CYAN}${BOLD}[STEP]${NC} $1"; }
detail()  { echo -e "       $1"; }
dry_run() { echo -e "${BLUE}[DRY-RUN]${NC} $1"; }

# ─── Globals ──────────────────────────────────────────────────────────────────

FRAMEWORK=""
FROM_VERSION=""
TO_VERSION=""
DRY_RUN=false

GITHUB_BRANCH="main"
GITHUB_RAW_BASE="https://raw.githubusercontent.com/Mezzanine-UI/mezzanine/$GITHUB_BRANCH"
GITHUB_API_BASE="https://api.github.com/repos/Mezzanine-UI/mezzanine"

# Cache: PascalCase component name → package sub-path + main source file (Angular only).
# Populated by build_ng_component_source_map(), consumed by ng-specific diff steps.
NG_COMPONENT_MAP_FILE="/tmp/mzn_ng_component_map.json"

# ─── Helpers ──────────────────────────────────────────────────────────────────

show_help() {
    echo ""
    echo -e "${BOLD}Mezzanine-UI Version Upgrade Analysis Script${NC}"
    echo ""
    echo "Usage:"
    echo "  $0 --framework <react|ng> --from <version> --to <version> [options]"
    echo ""
    echo "Required arguments:"
    echo "  --framework <name> Target framework skill: 'react' or 'ng'"
    echo "  --from <version>   Current version (e.g. 1.0.3, 1.0.0-rc.3)"
    echo "  --to   <version>   Target version (e.g. 1.1.0, 1.0.0-rc.4)"
    echo ""
    echo "Options:"
    echo "  --dry-run          Show what would be done without writing any files"
    echo "  --help             Show this help message"
    echo ""
    echo "Output:"
    echo "  skills/using-mezzanine-ui-<framework>/scripts/upgrade-manifest.json"
    echo ""
    echo "Examples:"
    echo "  $0 --framework react --from 1.0.3 --to 1.1.0"
    echo "  $0 --framework ng    --from 1.0.0-rc.3 --to 1.0.0-rc.4 --dry-run"
    echo ""
}

check_dependencies() {
    local missing=()

    if ! command -v curl &> /dev/null; then
        missing+=("curl")
    fi

    if ! command -v jq &> /dev/null; then
        missing+=("jq")
    fi

    if [ ${#missing[@]} -gt 0 ]; then
        error "Missing required dependencies: ${missing[*]}"
        echo "  macOS:  brew install ${missing[*]}"
        echo "  Linux:  apt install ${missing[*]}"
        exit 1
    fi
}

parse_args() {
    if [ $# -eq 0 ]; then
        show_help
        exit 1
    fi

    while [[ $# -gt 0 ]]; do
        case $1 in
            --framework)
                FRAMEWORK="${2:-}"
                if [ -z "$FRAMEWORK" ]; then
                    error "--framework requires a value (react|ng)"
                    exit 1
                fi
                shift 2
                ;;
            --from)
                FROM_VERSION="${2:-}"
                if [ -z "$FROM_VERSION" ]; then
                    error "--from requires a version argument"
                    exit 1
                fi
                shift 2
                ;;
            --to)
                TO_VERSION="${2:-}"
                if [ -z "$TO_VERSION" ]; then
                    error "--to requires a version argument"
                    exit 1
                fi
                shift 2
                ;;
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            --help|-h)
                show_help
                exit 0
                ;;
            *)
                error "Unknown argument: $1"
                show_help
                exit 1
                ;;
        esac
    done

    if [ -z "$FRAMEWORK" ]; then
        error "--framework is required (react|ng)"
        show_help
        exit 1
    fi

    case "$FRAMEWORK" in
        react|ng) ;;
        *)
            error "Invalid --framework value: '$FRAMEWORK'. Must be 'react' or 'ng'."
            exit 1
            ;;
    esac

    if [ -z "$FROM_VERSION" ] || [ -z "$TO_VERSION" ]; then
        error "Both --from and --to are required"
        show_help
        exit 1
    fi

    # Resolve framework-scoped paths.
    SKILL_DIR="$PLUGIN_SKILLS_DIR/using-mezzanine-ui-$FRAMEWORK"
    CACHE_DIR="$SKILL_DIR/cache"
    COMPONENTS_DIR="$SKILL_DIR/references/components"
    MANIFEST_FILE="$SKILL_DIR/scripts/upgrade-manifest.json"

    if [ ! -d "$SKILL_DIR" ]; then
        error "Skill directory not found: $SKILL_DIR"
        exit 1
    fi
    mkdir -p "$SKILL_DIR/scripts"
}

# ─── Framework-specific helpers ───────────────────────────────────────────────

# Package sub-path under `packages/` on GitHub.
package_path() {
    case "$FRAMEWORK" in
        react) echo "packages/react/src" ;;
        ng)    echo "packages/ng" ;;
    esac
}

# npm release tag prefix used to filter changelog entries.
# Legacy tags like "v1.0.2" are picked up separately for the react track only.
release_tag_prefix() {
    case "$FRAMEWORK" in
        react) echo "@mezzanine-ui/react@" ;;
        ng)    echo "@mezzanine-ui/ng@" ;;
    esac
}

# Given a PascalCase component name, print the main source file path on
# GitHub (relative to repo root). Angular requires the ng component map
# to have been built first by build_ng_component_source_map().
component_source_path() {
    local component="$1"
    case "$FRAMEWORK" in
        react)
            echo "packages/react/src/$component/$component.tsx"
            ;;
        ng)
            if [ -f "$NG_COMPONENT_MAP_FILE" ]; then
                jq -r --arg c "$component" '.[$c].mainFile // empty' "$NG_COMPONENT_MAP_FILE"
            fi
            ;;
    esac
}

# Concatenated source of every file in a component's family.
# React has one file per component; Angular families span several, so diffing
# only the "main" file produced phantom removals for every sibling directive.
component_source_contents() {
    local component="$1"
    case "$FRAMEWORK" in
        react)
            curl -sf "$GITHUB_RAW_BASE/$(component_source_path "$component")" 2>/dev/null || true
            ;;
        ng)
            [ -f "$NG_COMPONENT_MAP_FILE" ] || return 0
            local files
            files=$(jq -r --arg c "$component" '.[$c].allFiles // [] | .[]' "$NG_COMPONENT_MAP_FILE")
            [ -z "$files" ] && files=$(jq -r --arg c "$component" '.[$c].mainFile // empty' "$NG_COMPONENT_MAP_FILE")
            while IFS= read -r f; do
                [ -z "$f" ] && continue
                curl -sf "$GITHUB_RAW_BASE/$f" 2>/dev/null || true
                echo ""
            done <<< "$files"
            ;;
    esac
}

# Convert kebab-case to PascalCase: "date-picker" -> "DatePicker".
kebab_to_pascal() {
    echo "$1" | awk -F'-' '{ for (i=1;i<=NF;i++) printf "%s%s", toupper(substr($i,1,1)), substr($i,2); print "" }'
}

# Walk packages/ng/*/ folders and build a map keyed on folder-derived PascalCase
# component name (one entry per folder — the "family" unit). Each entry records
# the folder's main .component.ts file (preferred: a file matching the folder's
# base name; fallback: the first exported Mzn* class's source file).
#
# Rationale: ng organises each component family in its own folder with many
# sub-components re-exported from index.ts (e.g. accordion/ exports
# MznAccordion, MznAccordionGroup, MznAccordionTitle, ...). For add/remove
# diffing we treat the FOLDER as the unit, matching the .md docs layout.
build_ng_component_source_map() {
    [ "$FRAMEWORK" = "ng" ] || return 0

    local ng_root_api="$GITHUB_API_BASE/contents/packages/ng?ref=$GITHUB_BRANCH"
    local folders_json
    if ! folders_json=$(curl -sfL -H "Accept: application/vnd.github+json" "$ng_root_api" 2>/dev/null); then
        warn "Could not list packages/ng folders — ng component map will be empty"
        echo '{}' > "$NG_COMPONENT_MAP_FILE"
        return
    fi

    # Filter out non-component dirs: leading _ or . (e.g. _internal), and
    # the shared library buckets (services, utils, src).
    local folders
    folders=$(echo "$folders_json" | jq -r '.[] | select(.type == "dir") | .name' \
        | grep -vE '^(_|\.)' \
        | grep -vxE '(services|utils|src)' \
        | sort -u)

    local map='{}'
    while IFS= read -r folder; do
        [ -z "$folder" ] && continue
        local idx_url="$GITHUB_RAW_BASE/packages/ng/$folder/index.ts"
        local idx_content
        if ! idx_content=$(curl -sfL "$idx_url" 2>/dev/null); then
            continue
        fi

        local comp_name
        comp_name=$(kebab_to_pascal "$folder")

        # Parse exported Mzn* classes from this folder's index.ts. Handles both
        # single-line (`export { MznX } from './foo';`) and multi-line
        # (`export {\n  MznX,\n  MznY,\n} from './foo';`) export blocks by
        # collapsing each block onto one line first with awk.
        #
        # Prefer the class whose source path matches the folder's base name
        # (e.g. in accordion/, './accordion.component' -> MznAccordion is the
        # "main"). If none matches, fall back to the first Mzn class exported.
        local main_cls="" main_src="" first_cls="" first_src=""
        # Every source path re-exported from index.ts. A component "family" is a
        # folder, not a file: dropdown/ ships MznDropdown plus MznDropdownItem,
        # MznDropdownAction and MznDropdownItemCard, and picker/ spans nine files.
        # Diffing against a single arbitrarily-chosen main file reported every
        # sibling directive's inputs/outputs as removed, and made an unrelated
        # sibling's selector look like a rename.
        local all_srcs=""
        local flat_exports
        flat_exports=$(echo "$idx_content" | awk '
            /^export[[:space:]]+\{/ && !/^export[[:space:]]+type/ {
                buf = $0
                while (index(buf, "}") == 0 && (getline nextline) > 0) {
                    buf = buf " " nextline
                }
                # Also absorb the trailing `from '...';` if not yet included.
                while (index(buf, "from ") == 0 && (getline nextline) > 0) {
                    buf = buf " " nextline
                }
                print buf
            }
        ')

        # Service-only fallback: if a folder exports only MznXService (e.g.
        # notifier/, message/), we still want it in the component list for
        # add/remove diffing — props/selector diffs will just skip it later.
        local svc_cls="" svc_src=""

        while IFS= read -r line; do
            [ -z "$line" ] && continue
            local src
            src=$(echo "$line" | grep -oE "from '\./[^']+'" | sed -E "s|from '\./||; s|'||" || true)
            [ -z "$src" ] && continue

            all_srcs="$all_srcs$src\n"

            # All Mzn* identifiers inside the braces are candidate class names.
            local classes
            classes=$(echo "$line" | grep -oE 'Mzn[A-Z][A-Za-z0-9]*' || true)
            [ -z "$classes" ] && continue

            while IFS= read -r cls; do
                [ -z "$cls" ] && continue
                case "$cls" in
                    MZN_*) continue ;;
                    *Service)
                        [ -z "$svc_cls" ] && { svc_cls="$cls"; svc_src="$src"; }
                        continue
                        ;;
                esac

                if [ -z "$first_cls" ]; then
                    first_cls="$cls"
                    first_src="$src"
                fi
                if [ "$src" = "$folder.component" ] && [ -z "$main_cls" ]; then
                    main_cls="$cls"
                    main_src="$src"
                fi
            done <<< "$classes"
        done <<< "$flat_exports"

        [ -z "$main_cls" ] && { main_cls="$first_cls"; main_src="$first_src"; }
        [ -z "$main_cls" ] && { main_cls="$svc_cls"; main_src="$svc_src"; }
        [ -z "$main_cls" ] && continue

        local main_file="packages/ng/$folder/$main_src.ts"
        local all_files_json
        all_files_json=$(printf '%b' "$all_srcs" \
            | grep -v '^$' | sort -u \
            | sed "s|^|packages/ng/$folder/|; s|$|.ts|" \
            | jq -R . | jq -sc '[.[] | select(. != "")]')
        map=$(echo "$map" | jq \
            --arg k "$comp_name" \
            --arg cls "$main_cls" \
            --arg folder "packages/ng/$folder" \
            --arg file "$main_file" \
            --argjson all "$all_files_json" \
            '. + {($k): {className: $cls, sourceDir: $folder, mainFile: $file, allFiles: $all}}')
    done <<< "$folders"

    echo "$map" > "$NG_COMPONENT_MAP_FILE"
    local count
    count=$(echo "$map" | jq 'length')
    info "Built Angular component source map ($count components)"
}

# Compare two semver strings. Returns 0 if $1 < $2, 1 otherwise.
# Used to filter releases between from/to versions.
semver_lt() {
    local a="$1"
    local b="$2"

    # Normalize: strip leading 'v', replace pre-release '-' with '~' for sort order
    local na nb
    na=$(echo "$a" | sed 's/^v//' | sed 's/-/~/')
    nb=$(echo "$b" | sed 's/^v//' | sed 's/-/~/')

    [ "$na" != "$nb" ] && [ "$(printf '%s\n%s\n' "$na" "$nb" | sort -V | head -n1)" = "$na" ]
}

# ─── Step 1: Fetch target index.ts and compare component list ─────────────────

fetch_and_compare_components() {
    step "Step 1: Comparing component list"

    local target_components
    case "$FRAMEWORK" in
        react)
            local index_url="$GITHUB_RAW_BASE/packages/react/src/index.ts"
            detail "Fetching: $index_url"

            local index_content
            if ! index_content=$(curl -sf "$index_url" 2>/dev/null); then
                warn "Could not fetch index.ts from GitHub. Skipping component list comparison."
                echo "[]"
                return
            fi

            # Extract exported component names (uppercase-starting exports)
            # Handles both: export * from './ComponentName/...'  and  export { Foo } from './ComponentName'
            # Excludes utils/ and hooks/ sub-paths
            target_components=$(echo "$index_content" \
                | grep -oE "from '\./([A-Z][A-Za-z0-9]+)(/|')" \
                | grep -oE "[A-Z][A-Za-z0-9]+" \
                | sort -u)
            ;;
        ng)
            build_ng_component_source_map
            if [ ! -f "$NG_COMPONENT_MAP_FILE" ] || [ "$(jq 'length' "$NG_COMPONENT_MAP_FILE")" = "0" ]; then
                warn "Empty Angular component map — skipping comparison"
                echo "[]"
                return
            fi
            target_components=$(jq -r 'keys[]' "$NG_COMPONENT_MAP_FILE" | sort -u)
            ;;
    esac

    # Get current components from .md filenames
    local current_components
    current_components=$(ls "$COMPONENTS_DIR"/*.md 2>/dev/null \
        | xargs -I{} basename {} .md \
        | sort -u)

    # Compute diff
    local added=()
    local removed=()
    local unchanged=()

    while IFS= read -r comp; do
        if echo "$current_components" | grep -qx "$comp"; then
            unchanged+=("$comp")
        else
            added+=("$comp")
        fi
    done <<< "$target_components"

    while IFS= read -r comp; do
        if ! echo "$target_components" | grep -qx "$comp"; then
            removed+=("$comp")
        fi
    done <<< "$current_components"

    echo ""
    info "Component list comparison (${#added[@]} added, ${#removed[@]} removed, ${#unchanged[@]} unchanged):"

    if [ ${#added[@]} -gt 0 ]; then
        echo -e "  ${GREEN}ADDED:${NC}"
        for c in "${added[@]}"; do detail "  + $c"; done
    fi

    if [ ${#removed[@]} -gt 0 ]; then
        echo -e "  ${RED}REMOVED:${NC}"
        for c in "${removed[@]}"; do detail "  - $c"; done
    fi

    if [ ${#unchanged[@]} -gt 0 ]; then
        echo -e "  ${NC}UNCHANGED: ${#unchanged[@]} components${NC}"
    fi

    # Return JSON arrays for manifest. The `select(. != "")` strips the lone
    # empty element that `printf '%s\n'` emits when the array is empty (bash
    # idiom: `"${arr[@]+"${arr[@]}"}"` expands to "" for empty arrays).
    local added_json removed_json unchanged_json
    added_json=$(printf '%s\n' "${added[@]+"${added[@]}"}" | jq -R . | jq -sc '[.[] | select(. != "")]')
    removed_json=$(printf '%s\n' "${removed[@]+"${removed[@]}"}" | jq -R . | jq -sc '[.[] | select(. != "")]')
    unchanged_json=$(printf '%s\n' "${unchanged[@]+"${unchanged[@]}"}" | jq -R . | jq -sc '[.[] | select(. != "")]')

    # Write temp file for downstream consumption
    jq -n \
        --argjson added "$added_json" \
        --argjson removed "$removed_json" \
        --argjson unchanged "$unchanged_json" \
        '{added: $added, removed: $removed, unchanged: $unchanged}' \
        > /tmp/mzn_component_diff.json

    info "Component diff written to /tmp/mzn_component_diff.json"
}

# ─── Step 2: Fetch release changelog between versions ─────────────────────────

fetch_changelog() {
    step "Step 2: Fetching release changelog from GitHub API"

    # Releases API paginates (30 per page). Fetch up to 3 pages = 90 most recent
    # releases, which covers well over a year of Mezzanine-UI history.
    local releases_raw='[]'
    local page=1
    while [ "$page" -le 3 ]; do
        local page_json
        if ! page_json=$(curl -sf \
            -H "Accept: application/vnd.github+json" \
            -H "X-GitHub-Api-Version: 2022-11-28" \
            "$GITHUB_API_BASE/releases?per_page=30&page=$page" 2>/dev/null); then
            [ "$page" -eq 1 ] && {
                warn "Could not fetch releases from GitHub API. Skipping changelog."
                echo "[]" > /tmp/mzn_changelog.json
                return
            }
            break
        fi
        local count
        count=$(echo "$page_json" | jq 'length')
        [ "$count" = "0" ] && break
        releases_raw=$(jq -s '.[0] + .[1]' <(echo "$releases_raw") <(echo "$page_json"))
        page=$((page + 1))
    done

    local prefix
    prefix=$(release_tag_prefix)

    # Extract semver from tag: "@mezzanine-ui/react@1.1.0" → "1.1.0"; "v1.0.2" → "1.0.2".
    # For the react track we accept BOTH the per-package prefix and legacy "v*" tags,
    # since releases before mid-2026 used generic version tags (react was the only
    # published package at the time). Ng has no legacy tag stream.
    local all_tags_versions
    all_tags_versions=$(echo "$releases_raw" | jq -r --arg prefix "$prefix" --arg framework "$FRAMEWORK" '
        .[] |
        select(
            (.tag_name | startswith($prefix)) or
            ($framework == "react" and (.tag_name | test("^v[0-9]+\\.[0-9]+\\.[0-9]+")))
        ) |
        [
            .tag_name,
            (if (.tag_name | startswith($prefix))
                then (.tag_name | ltrimstr($prefix))
                else (.tag_name | ltrimstr("v"))
            end)
        ] | @tsv
    ')

    local relevant_tags=()
    while IFS=$'\t' read -r tag ver; do
        [ -z "$tag" ] && continue
        # Include if ver > FROM_VERSION and ver <= TO_VERSION
        if semver_lt "$FROM_VERSION" "$ver" || [ "$ver" = "$TO_VERSION" ]; then
            if semver_lt "$ver" "$TO_VERSION" || [ "$ver" = "$TO_VERSION" ]; then
                if ! semver_lt "$ver" "$FROM_VERSION" && [ "$ver" != "$FROM_VERSION" ] || [ "$ver" = "$TO_VERSION" ]; then
                    relevant_tags+=("$tag")
                fi
            fi
        fi
    done <<< "$all_tags_versions"

    # Build filtered JSON from relevant tags
    local tags_json
    tags_json=$(printf '%s\n' "${relevant_tags[@]+"${relevant_tags[@]}"}" | jq -R . | jq -sc .)

    local changelog_json
    changelog_json=$(echo "$releases_raw" | jq --argjson tags "$tags_json" '
        map(select(.tag_name as $t | $tags | index($t) != null)) |
        map({
            tag:       .tag_name,
            name:      .name,
            published: .published_at,
            url:       .html_url,
            body:      .body
        })
    ')

    echo "$changelog_json" > /tmp/mzn_changelog.json

    local count
    count=$(echo "$changelog_json" | jq 'length')
    info "Found $count release(s) between v$FROM_VERSION and v$TO_VERSION"

    if [ "$count" -gt 0 ]; then
        echo "$changelog_json" | jq -r '.[] | "  \(.tag): \(.name // "(no title)")"'
    fi
}

# ─── Step 3: Fetch component source and diff props ────────────────────────────

fetch_component_props_diff() {
    step "Step 3: Analyzing component props/inputs changes"

    # Per-framework config: cache file holding the current (documented) prop list
    # and the jq path that extracts prop names for a given component.
    local api_index_file current_lookup_jq
    case "$FRAMEWORK" in
        react)
            api_index_file="$CACHE_DIR/component-api-index.json"
            current_lookup_jq='.[$comp].props // {} | keys[]'
            ;;
        ng)
            api_index_file="$CACHE_DIR/component-index.json"
            # ng component-index.json stores inputs/outputs under .components.<Name>.inputs
            current_lookup_jq='.components[$comp].inputs // {} | keys[]'
            ;;
    esac

    if [ ! -f "$api_index_file" ]; then
        warn "$(basename "$api_index_file") not found. Skipping props diff."
        echo "[]" > /tmp/mzn_props_diff.json
        return
    fi

    # Get list of components to check from current .md files
    local components
    components=$(ls "$COMPONENTS_DIR"/*.md 2>/dev/null | xargs -I{} basename {} .md | sort -u)

    local props_diff_entries=()

    while IFS= read -r component; do
        local source_path
        source_path=$(component_source_path "$component")
        [ -z "$source_path" ] && continue

        local source_content
        source_content=$(component_source_contents "$component")
        if [ -z "$source_content" ]; then
            # Component source file not found under expected path
            continue
        fi

        local source_prop_names=""

        # `|| true` tolerates components whose Props are declared as a type union
        # (e.g. `type FooProps = A & B`) rather than `interface FooProps`, where
        # the grep produces no match and would otherwise trip `pipefail`.
        if [ "$FRAMEWORK" = "react" ]; then
            # Extract top-level field names from the component's Props interface.
            #
            # HISTORY: this was `grep -A 60 "interface ${component}Props" | awk '/^\}$/{exit}'`,
            # which was the root cause of large-scale FALSE "props removed" reports
            # (Drawer -33, Dropdown -39, Calendar -18, ...). Those false positives were
            # consumed by the updater agents and written into SKILL.md as bogus
            # "API 重構" claims such as "Calendar 移除 mode/value/onChange" and
            # "Drawer 移除內建底部操作按鈕" — none of which ever happened.
            #
            # Two defects:
            #   1. `-A 60` hard-capped the scan window at 60 lines. Long interfaces
            #      (DrawerProps spans 200+ lines with JSDoc) had every field past the
            #      cut-off silently reported as removed.
            #   2. The awk terminated at the FIRST line consisting solely of `}`,
            #      firing early on nested object types and on braces inside JSDoc
            #      `@example` blocks.
            #
            # The replacement tracks brace depth, tolerates multi-line declarations
            # (`interface X\n  extends A,\n  Pick<B,'c'> {`), strips line/block
            # comments before counting braces, and only emits fields at depth 1 so
            # nested object-literal members (e.g. `arrow: { padding?: number }`)
            # are not promoted to top-level props.
            source_prop_names=$(echo "$source_content" | awk -v comp="$component" '
                BEGIN { started = 0; seenOpen = 0; depth = 0; inBlock = 0 }
                # Match the Props interface AND same-file base interfaces that it
                # extends by convention (`<Comp>PropsBase`, `<Comp>PropsCommon`, ...).
                # Without this, components declared as
                #   `interface XProps extends XPropsBase {}`
                # report every inherited field as removed (observed on SelectionCard).
                !started && $0 ~ ("(interface|type)[[:space:]]+" comp "Props[A-Za-z0-9_]*([^A-Za-z0-9_]|$)") {
                    started = 1; seenOpen = 0; depth = 0
                }
                started {
                    line = $0
                    if (inBlock) {
                        if (line ~ /\*\//) { sub(/^.*\*\//, "", line); inBlock = 0 } else { next }
                    }
                    while (line ~ /\/\*/) {
                        if (line ~ /\/\*.*\*\//) { sub(/\/\*.*\*\//, "", line) }
                        else { sub(/\/\*.*$/, "", line); inBlock = 1; break }
                    }
                    sub(/\/\/.*$/, "", line)

                    nOpen  = gsub(/\{/, "{", line)
                    nClose = gsub(/\}/, "}", line)

                    # A declaration that terminates before any `{` is a non-object
                    # alias, e.g. `type SliderProps = Omit<SliderComponentProps, "innerRef">;`
                    # Previously the scan latched on and never closed, running into the
                    # component body and emitting function parameter names (`e`, `handler`)
                    # as if they were props.
                    if (!seenOpen && nOpen == 0 && line ~ /;/) {
                        started = 0
                        next
                    }

                    if (seenOpen && depth == 1) {
                        cand = line
                        sub(/^[[:space:]]+/, "", cand)
                        sub(/^readonly[[:space:]]+/, "", cand)
                        # `foo:` / `foo?:` and the method shorthand `foo?(args): T;`
                        # Accordion declares `onChange?(e: boolean): void;` — requiring a
                        # colon reported it as removed.
                        if (match(cand, /^[a-zA-Z_][a-zA-Z0-9_]*[?]?[[:space:]]*[:(]/)) {
                            name = substr(cand, 1, RLENGTH)
                            sub(/[[:space:]]*[:(]$/, "", name)
                            sub(/[?]$/, "", name)
                            print name
                        }
                    }

                    depth += nOpen
                    if (nOpen > 0) seenOpen = 1
                    depth -= nClose
                    if (seenOpen && depth <= 0) { started = 0; seenOpen = 0; depth = 0 }
                }
            ' | sort -u || true)
        else
            # Angular signal inputs.
            #
            # HISTORY: the previous regex was
            #   '^[[:space:]]+[a-zA-Z_][a-zA-Z0-9_]*[[:space:]]*=[[:space:]]*input[.<(]'
            # which required the identifier to sit immediately after the leading
            # indentation. Every directive in @mezzanine-ui/ng declares inputs as
            #   `readonly variant = input.required<BadgeVariant>();`
            # so the `readonly` modifier made the pattern match NOTHING — measured
            # 0/6 on badge, 0/33 on select, 0/5 on toggle. Feeding that to the
            # updater agents would report 100% of every directive's inputs as
            # "removed" and strip every Inputs table in the Angular skill.
            #
            # The replacement tolerates visibility/readonly modifiers and both
            # `input(...)` and `input.required<...>()` forms, plus legacy @Input().
            local signal_inputs legacy_inputs
            signal_inputs=$(echo "$source_content" | awk '
                match($0, /^[[:space:]]*(public[[:space:]]+|protected[[:space:]]+|private[[:space:]]+)?(readonly[[:space:]]+)?[A-Za-z_][A-Za-z0-9_]*[[:space:]]*=[[:space:]]*input[.<(]/) {
                    seg = substr($0, RSTART, RLENGTH)
                    sub(/[[:space:]]*=[[:space:]]*input[.<(]$/, "", seg)
                    sub(/^[[:space:]]*/, "", seg)
                    sub(/^(public|protected|private)[[:space:]]+/, "", seg)
                    sub(/^readonly[[:space:]]+/, "", seg)
                    if (seg != "") print seg
                }
            ' || true)
            legacy_inputs=$(echo "$source_content" \
                | grep -oE '@Input\([^)]*\)[[:space:]]+[a-zA-Z_][a-zA-Z0-9_]*' \
                | grep -oE '[a-zA-Z_][a-zA-Z0-9_]*$' || true)
            source_prop_names=$(printf '%s\n%s\n' "$signal_inputs" "$legacy_inputs" \
                | grep -v '^$' | sort -u || true)
        fi

        # Get current (documented) prop names from the framework's api index.
        local current_prop_names
        current_prop_names=$(jq -r \
            --arg comp "$component" \
            "$current_lookup_jq" \
            "$api_index_file" 2>/dev/null | sort -u || true)

        # Compute prop-level diff
        local props_added=()
        local props_removed=()

        if [ -n "$source_prop_names" ]; then
            while IFS= read -r prop; do
                [ -z "$prop" ] && continue
                if ! echo "$current_prop_names" | grep -qx "$prop"; then
                    props_added+=("$prop")
                fi
            done <<< "$source_prop_names"
        fi

        if [ -n "$current_prop_names" ]; then
            while IFS= read -r prop; do
                [ -z "$prop" ] && continue
                if [ -n "$source_prop_names" ] && ! echo "$source_prop_names" | grep -qx "$prop"; then
                    props_removed+=("$prop")
                fi
            done <<< "$current_prop_names"
        fi

        # Only record components with actual changes
        if [ ${#props_added[@]} -gt 0 ] || [ ${#props_removed[@]} -gt 0 ]; then
            local added_json removed_json
            added_json=$(printf '%s\n' "${props_added[@]+"${props_added[@]}"}" | jq -R . | jq -sc .)
            removed_json=$(printf '%s\n' "${props_removed[@]+"${props_removed[@]}"}" | jq -R . | jq -sc .)

            local entry
            entry=$(jq -n \
                --arg comp "$component" \
                --argjson added "$added_json" \
                --argjson removed "$removed_json" \
                '{component: $comp, propsAdded: $added, propsRemoved: $removed}')
            props_diff_entries+=("$entry")

            local label=""
            [ ${#props_added[@]} -gt 0 ]   && label+="${GREEN}+${#props_added[@]} props${NC} "
            [ ${#props_removed[@]} -gt 0 ]  && label+="${RED}-${#props_removed[@]} props${NC}"
            echo -e "  ${BOLD}$component${NC}: $label"
        fi

    done <<< "$components"

    # Write to temp file
    if [ ${#props_diff_entries[@]} -eq 0 ]; then
        echo "[]" > /tmp/mzn_props_diff.json
        info "No prop-level changes detected"
    else
        printf '%s\n' "${props_diff_entries[@]}" | jq -sc . > /tmp/mzn_props_diff.json
        info "${#props_diff_entries[@]} component(s) have prop changes"
    fi
}

# ─── Step 3b: Angular-specific diff (selector / CVA / DI tokens / imports) ────

fetch_angular_specific_diff() {
    [ "$FRAMEWORK" = "ng" ] || { echo "[]" > /tmp/mzn_ng_specific.json; return; }

    step "Step 3b: Analyzing Angular-specific changes"

    local api_index="$CACHE_DIR/component-index.json"
    [ -f "$api_index" ] || { warn "component-index.json missing — skipping ng-specific diff"; echo "[]" > /tmp/mzn_ng_specific.json; return; }

    local components
    components=$(ls "$COMPONENTS_DIR"/*.md 2>/dev/null | xargs -I{} basename {} .md | sort -u)

    local entries=()

    while IFS= read -r component; do
        local source_path
        source_path=$(component_source_path "$component")
        [ -z "$source_path" ] && continue

        # Whole-family source: inputs/outputs/CVA/token scanning must see every
        # directive the folder exports, not just the main file.
        local content
        content=$(component_source_contents "$component")
        [ -z "$content" ] && continue

        # The main file's own selector, used as the "current" value when reporting.
        local main_content
        main_content=$(curl -sf "$GITHUB_RAW_BASE/$source_path" 2>/dev/null || true)

        # Selector: first string inside @Component({ selector: '...' }) or @Directive.
        # `|| true` guards against components with no explicit selector.
        local source_selector
        source_selector=$(echo "$main_content" \
            | grep -oE "selector:[[:space:]]*['\"][^'\"]+['\"]" \
            | head -n1 \
            | sed -E "s/selector:[[:space:]]*['\"]//; s/['\"]//" || true)
        local source_selector_kind="tag"
        [[ "$source_selector" == \[*\] ]] && source_selector_kind="attribute"

        # Every selector declared anywhere in the family. A cached selector that
        # still exists on a sibling directive has NOT been renamed — the main-file
        # heuristic simply picked a different file. Without this check the diff
        # claimed renames like `[mznCardGroup] -> [mznBaseCard]` and
        # `mzn-alert-banner-container -> [mznAlertBanner]`, where both selectors
        # coexist in the same folder.
        local family_selectors
        family_selectors=$(echo "$content" \
            | grep -oE "selector:[[:space:]]*['\"][^'\"]+['\"]" \
            | sed -E "s/selector:[[:space:]]*['\"]//; s/['\"]//" \
            | sort -u || true)

        # CVA: implements ControlValueAccessor or provideValueAccessor(X).
        local source_has_cva="false"
        if echo "$content" | grep -qE 'implements[[:space:]][^{]*ControlValueAccessor|provideValueAccessor\('; then
            source_has_cva="true"
        fi

        # DI tokens provided BY this component: lines like "provide: MZN_XXX".
        local source_tokens
        source_tokens=$(echo "$content" \
            | grep -oE 'provide:[[:space:]]*MZN_[A-Z_]+' \
            | grep -oE 'MZN_[A-Z_]+' | sort -u || true)

        # Standalone imports: extract the `imports: [...]` array from the
        # decorator block (may span multiple lines). Awk grabs the first array
        # starting at `imports:`; regex then strips identifiers. `|| true`
        # tolerates components with no `imports` array.
        local source_imports
        source_imports=$(echo "$content" \
            | awk '/imports:[[:space:]]*\[/{flag=1; buf=""} flag{buf=buf $0; if (index($0,"]")>0){print buf; flag=0}}' \
            | head -n1 \
            | grep -oE '[A-Z][A-Za-z0-9]+' \
            | grep -v '^NgIf$\|^NgFor$\|^NgTemplateOutlet$' \
            | sort -u || true)

        # Outputs: `readonly foo = output<T>()`. NOT previously tracked — which meant
        # the rc.9 breaking rename wave (MznSelect selectionChange->change,
        # onScroll->scroll; MznDropdown closed->close, selected->select, ...) was
        # completely invisible to this manifest. Output renames are the single
        # highest-blast-radius Angular change: consumer templates bind `(oldName)`
        # and simply stop firing, with no compile error.
        local source_outputs
        source_outputs=$(echo "$content" | awk '
            match($0, /^[[:space:]]*(public[[:space:]]+|protected[[:space:]]+|private[[:space:]]+)?(readonly[[:space:]]+)?[A-Za-z_][A-Za-z0-9_]*[[:space:]]*=[[:space:]]*output[.<(]/) {
                seg = substr($0, RSTART, RLENGTH)
                sub(/[[:space:]]*=[[:space:]]*output[.<(]$/, "", seg)
                sub(/^[[:space:]]*/, "", seg)
                sub(/^(public|protected|private)[[:space:]]+/, "", seg)
                sub(/^readonly[[:space:]]+/, "", seg)
                if (seg != "") print seg
            }
        ' || true)
        # Legacy decorator outputs: `@Output() readonly foo = new EventEmitter<T>()`.
        # Still used deliberately in places — MznDescriptionContent keeps clickIcon on
        # the decorator API so `.observed` can tell whether a listener is bound.
        # Missing these reported real outputs as removed.
        local legacy_outputs
        legacy_outputs=$(echo "$content" \
            | grep -oE '@Output\([^)]*\)[[:space:]]+(readonly[[:space:]]+)?[a-zA-Z_][a-zA-Z0-9_]*' \
            | grep -oE '[a-zA-Z_][a-zA-Z0-9_]*$' || true)
        source_outputs=$(printf '%s\n%s\n' "$source_outputs" "$legacy_outputs" \
            | grep -v '^$' | sort -u || true)

        # Cached (current documented) values.
        local cache_selector cache_has_cva cache_tokens cache_imports cache_outputs
        cache_selector=$(jq -r --arg c "$component" '.components[$c].selector // empty' "$api_index")
        cache_has_cva=$(jq -r --arg c "$component" '.components[$c].cva // false | tostring' "$api_index")
        cache_tokens=$(jq -r --arg c "$component" '.components[$c].providesTokens // [] | .[]' "$api_index" 2>/dev/null | sort -u)
        cache_imports=$(jq -r --arg c "$component" '.components[$c].standaloneImports // [] | .[]' "$api_index" 2>/dev/null | sort -u)
        cache_outputs=$(jq -r --arg c "$component" '.components[$c].outputs // [] | .[] | (if type == "object" then .name else . end)' "$api_index" 2>/dev/null | sort -u)

        # Skip if no cache entry for this component (can't diff what doesn't exist).
        [ -z "$cache_selector" ] && continue

        # Compute diffs.
        local selector_change='null'
        if [ -n "$source_selector" ] && [ "$source_selector" != "$cache_selector" ] \
           && ! echo "$family_selectors" | grep -qxF "$cache_selector"; then
            local cache_kind="tag"
            [[ "$cache_selector" == \[*\] ]] && cache_kind="attribute"
            local kind_changed="false"
            [ "$cache_kind" != "$source_selector_kind" ] && kind_changed="true"
            selector_change=$(jq -n \
                --arg from "$cache_selector" \
                --arg to   "$source_selector" \
                --arg kc   "$kind_changed" \
                '{from: $from, to: $to, typeChanged: ($kc == "true")}')
        fi

        local cva_change='null'
        if [ "$cache_has_cva" != "$source_has_cva" ]; then
            [ "$source_has_cva" = "true" ] && cva_change='"added"' || cva_change='"removed"'
        fi

        local tokens_added_json tokens_removed_json
        tokens_added_json=$(comm -23 <(echo "$source_tokens") <(echo "$cache_tokens") | jq -R . | jq -sc '[.[] | select(. != "")]')
        tokens_removed_json=$(comm -13 <(echo "$source_tokens") <(echo "$cache_tokens") | jq -R . | jq -sc '[.[] | select(. != "")]')

        local outputs_added_json outputs_removed_json
        outputs_added_json=$(comm -23 <(echo "$source_outputs") <(echo "$cache_outputs") | jq -R . | jq -sc '[.[] | select(. != "")]')
        outputs_removed_json=$(comm -13 <(echo "$source_outputs") <(echo "$cache_outputs") | jq -R . | jq -sc '[.[] | select(. != "")]')

        local imports_added_json imports_removed_json
        imports_added_json=$(comm -23 <(echo "$source_imports") <(echo "$cache_imports") | jq -R . | jq -sc '[.[] | select(. != "")]')
        imports_removed_json=$(comm -13 <(echo "$source_imports") <(echo "$cache_imports") | jq -R . | jq -sc '[.[] | select(. != "")]')

        # Only emit entry if any field actually changed.
        local any_change="false"
        [ "$selector_change" != "null" ] && any_change="true"
        [ "$cva_change" != "null" ]      && any_change="true"
        [ "$(echo "$tokens_added_json"   | jq 'length')" != "0" ] && any_change="true"
        [ "$(echo "$tokens_removed_json" | jq 'length')" != "0" ] && any_change="true"
        [ "$(echo "$imports_added_json"   | jq 'length')" != "0" ] && any_change="true"
        [ "$(echo "$imports_removed_json" | jq 'length')" != "0" ] && any_change="true"
        [ "$(echo "$outputs_added_json"   | jq 'length')" != "0" ] && any_change="true"
        [ "$(echo "$outputs_removed_json" | jq 'length')" != "0" ] && any_change="true"

        [ "$any_change" = "false" ] && continue

        local entry
        entry=$(jq -n \
            --arg comp "$component" \
            --argjson selectorChanged "$selector_change" \
            --argjson cvaChange        "$cva_change" \
            --argjson tokensAdded      "$tokens_added_json" \
            --argjson tokensRemoved    "$tokens_removed_json" \
            --argjson importsAdded     "$imports_added_json" \
            --argjson importsRemoved   "$imports_removed_json" \
            --argjson outputsAdded     "$outputs_added_json" \
            --argjson outputsRemoved   "$outputs_removed_json" \
            '{
                component: $comp,
                selectorChanged: $selectorChanged,
                cvaChange:       $cvaChange,
                providersTokensChanged:  { added: $tokensAdded,  removed: $tokensRemoved  },
                standaloneImportsChanged:{ added: $importsAdded, removed: $importsRemoved },
                outputsChanged:          { added: $outputsAdded, removed: $outputsRemoved }
             }')
        entries+=("$entry")

        local label=""
        [ "$selector_change" != "null" ] && label+="${YELLOW}selector${NC} "
        [ "$cva_change"      != "null" ] && label+="${CYAN}cva${NC} "
        [ "$(echo "$tokens_added_json$tokens_removed_json" | jq -s 'map(length) | add')" != "0" ] && label+="${BLUE}tokens${NC} "
        [ "$(echo "$imports_added_json$imports_removed_json" | jq -s 'map(length) | add')" != "0" ] && label+="${GREEN}imports${NC} "
        [ "$(echo "$outputs_added_json$outputs_removed_json" | jq -s 'map(length) | add')" != "0" ] && label+="${RED}outputs${NC}"
        echo -e "  ${BOLD}$component${NC}: $label"
    done <<< "$components"

    if [ ${#entries[@]} -eq 0 ]; then
        echo "[]" > /tmp/mzn_ng_specific.json
        info "No Angular-specific changes detected"
    else
        printf '%s\n' "${entries[@]}" | jq -sc . > /tmp/mzn_ng_specific.json
        info "${#entries[@]} component(s) have Angular-specific changes"
    fi
}

# ─── Step 4: Update version metadata in cache files ───────────────────────────

update_cache_metadata() {
    step "Step 4: Updating cache file version metadata"

    local now
    now=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    local today
    today=$(date -u +"%Y-%m-%d")

    # Framework-specific cache file list. Each entry: "file_basename|jq_expr".
    local cache_updates=()
    case "$FRAMEWORK" in
        react)
            cache_updates=(
                "component-api-index.json|._meta.version = \"$TO_VERSION\" | ._meta.generatedAt = \"$today\""
                "import-paths-index.json|.meta.sourceVersion = \"$TO_VERSION\" | .meta.generatedAt = \"$today\""
                "component-index.json|.lastUpdated = \"$now\""
                "design-tokens-index.json|.lastUpdated = \"$now\" // ."
                "figma-sync.json|.lastSync = \"$now\""
                "token-values.json|.lastUpdated = \"$now\""
            )
            ;;
        ng)
            cache_updates=(
                "component-index.json|.version = \"$TO_VERSION\" | .lastUpdated = \"$now\""
                "import-paths-index.json|.version = \"$TO_VERSION\" | .lastUpdated = \"$now\""
                "services-index.json|.version = \"$TO_VERSION\" | .lastUpdated = \"$now\""
            )
            ;;
    esac

    for entry in "${cache_updates[@]}"; do
        local filename="${entry%%|*}"
        local jq_expr="${entry#*|}"
        local filepath="$CACHE_DIR/$filename"

        if [ ! -f "$filepath" ]; then
            warn "Cache file not found, skipping: $filename"
            continue
        fi

        if [ "$DRY_RUN" = true ]; then
            dry_run "Would update $filename: $jq_expr"
        else
            local updated
            if updated=$(jq "$jq_expr" "$filepath" 2>/dev/null); then
                echo "$updated" > "$filepath"
                info "Updated $filename"
            else
                warn "Failed to apply jq update to $filename — skipping"
            fi
        fi
    done
}

# ─── Step 5: Generate work manifest ───────────────────────────────────────────

generate_manifest() {
    step "Step 5: Generating work manifest"

    local component_diff="{}"
    local changelog="[]"
    local props_diff="[]"
    local ng_specific="[]"

    [ -f /tmp/mzn_component_diff.json ] && component_diff=$(cat /tmp/mzn_component_diff.json)
    [ -f /tmp/mzn_changelog.json ]      && changelog=$(cat /tmp/mzn_changelog.json)
    [ -f /tmp/mzn_props_diff.json ]     && props_diff=$(cat /tmp/mzn_props_diff.json)
    [ -f /tmp/mzn_ng_specific.json ]    && ng_specific=$(cat /tmp/mzn_ng_specific.json)

    # Build per-component work items with priority.
    # Every work item, regardless of priority, must be resolved during verification;
    # priority only controls review ordering, not whether it's addressed.
    local work_items
    work_items=$(jq -n \
        --argjson comp_diff "$component_diff" \
        --argjson props_diff "$props_diff" \
        --argjson ng_specific "$ng_specific" \
        '
        # New components need docs created — HIGH priority
        ($comp_diff.added // []) | map({
            component:  .,
            action:     "CREATE",
            reason:     "New component not yet documented",
            priority:   "HIGH"
        }) as $new_items |

        # Removed components — HIGH priority (mark as deprecated or remove)
        ($comp_diff.removed // []) | map({
            component:  .,
            action:     "REMOVE_OR_DEPRECATE",
            reason:     "Component no longer exported from index.ts",
            priority:   "HIGH"
        }) as $removed_items |

        # Components with prop (or Angular input) changes
        ($props_diff // []) | map({
            component:  .component,
            action:     "UPDATE_PROPS",
            reason:     (
                (if (.propsAdded | length) > 0 then
                    "Props added: " + (.propsAdded | join(", "))
                else "" end) +
                (if (.propsAdded | length) > 0 and (.propsRemoved | length) > 0 then "; " else "" end) +
                (if (.propsRemoved | length) > 0 then
                    "Props removed: " + (.propsRemoved | join(", "))
                else "" end)
            ),
            priority:   (if (.propsRemoved | length) > 0 then "HIGH" else "MEDIUM" end),
            propsAdded:   .propsAdded,
            propsRemoved: .propsRemoved
        }) as $changed_items |

        # Angular-specific work items — one per triggered field per component.
        # String-building uses jq interpolation `\(...)` everywhere to avoid
        # `+` ambiguity between jq versions.
        ($ng_specific // []) | map(
            . as $c |
            [
                (if .selectorChanged != null then {
                    component: $c.component,
                    action:    "UPDATE_SELECTOR",
                    reason:    "Selector changed: \($c.selectorChanged.from) -> \($c.selectorChanged.to)\(if $c.selectorChanged.typeChanged then " (kind change: attribute<->tag)" else "" end)",
                    priority:  "HIGH"
                } else empty end),
                (if .cvaChange != null then {
                    component: $c.component,
                    action:    "UPDATE_CVA",
                    reason:    "ControlValueAccessor \($c.cvaChange) - affects Reactive Forms integration docs",
                    priority:  "HIGH"
                } else empty end),
                (.providersTokensChanged.added   // [] | (if length > 0 then {
                    component: $c.component,
                    action:    "UPDATE_PROVIDERS_TOKENS",
                    reason:    "DI tokens added (\(length))",
                    priority:  "MEDIUM",
                    tokens:    .
                } else empty end)),
                (.providersTokensChanged.removed // [] | (if length > 0 then {
                    component: $c.component,
                    action:    "UPDATE_PROVIDERS_TOKENS",
                    reason:    "DI tokens removed (\(length))",
                    priority:  "HIGH",
                    tokens:    .
                } else empty end)),
                (.standaloneImportsChanged.added   // [] | (if length > 0 then {
                    component: $c.component,
                    action:    "UPDATE_STANDALONE_IMPORTS",
                    reason:    "Imports added (\(length))",
                    priority:  "MEDIUM",
                    imports:   .
                } else empty end)),
                (.standaloneImportsChanged.removed // [] | (if length > 0 then {
                    component: $c.component,
                    action:    "UPDATE_STANDALONE_IMPORTS",
                    reason:    "Imports removed (\(length))",
                    priority:  "MEDIUM",
                    imports:   .
                } else empty end))
            ]
        ) | add // [] as $ng_items |

        $new_items + $removed_items + $changed_items + $ng_items
        ')

    local manifest
    manifest=$(jq -n \
        --arg framework "$FRAMEWORK" \
        --arg branch "$GITHUB_BRANCH" \
        --arg package_path "$(package_path)" \
        --arg from_ver "$FROM_VERSION" \
        --arg to_ver "$TO_VERSION" \
        --arg generated_at "$(date -u +"%Y-%m-%dT%H:%M:%SZ")" \
        --argjson comp_diff "$component_diff" \
        --argjson changelog "$changelog" \
        --argjson props_diff "$props_diff" \
        --argjson ng_specific "$ng_specific" \
        --argjson work_items "$work_items" \
        '{
            meta: {
                framework:    $framework,
                branch:       $branch,
                packagePath:  $package_path,
                fromVersion:  $from_ver,
                toVersion:    $to_ver,
                generatedAt:  $generated_at,
                description:  "Mezzanine-UI upgrade work manifest. Consume this file to drive .md documentation updates."
            },
            summary: {
                componentsAdded:    ($comp_diff.added   // [] | length),
                componentsRemoved:  ($comp_diff.removed // [] | length),
                componentsUnchanged:($comp_diff.unchanged // [] | length),
                componentsWithPropChanges: ($props_diff | length),
                componentsWithAngularChanges: ($ng_specific | length),
                releasesCovered:    ($changelog | length),
                workItemsTotal:     ($work_items | length),
                workItemsHigh:      ($work_items | map(select(.priority == "HIGH"))   | length),
                workItemsMedium:    ($work_items | map(select(.priority == "MEDIUM")) | length),
                workItemsLow:       ($work_items | map(select(.priority == "LOW"))    | length)
            },
            componentDiff:    $comp_diff,
            changelog:        $changelog,
            propsDiff:        $props_diff,
            angularSpecific:  $ng_specific,
            workItems:        $work_items
        }')

    if [ "$DRY_RUN" = true ]; then
        dry_run "Would write manifest to: $MANIFEST_FILE"
        echo ""
        echo "$manifest" | jq .
    else
        echo "$manifest" | jq . > "$MANIFEST_FILE"
        info "Manifest written to: $MANIFEST_FILE"
    fi
}

# ─── Cleanup temp files ───────────────────────────────────────────────────────

cleanup() {
    rm -f /tmp/mzn_component_diff.json
    rm -f /tmp/mzn_changelog.json
    rm -f /tmp/mzn_props_diff.json
    rm -f /tmp/mzn_ng_specific.json
    rm -f "$NG_COMPONENT_MAP_FILE"
}

# ─── Main ─────────────────────────────────────────────────────────────────────

main() {
    parse_args "$@"
    check_dependencies

    echo ""
    echo -e "${BOLD}Mezzanine-UI Upgrade Analysis${NC}"
    echo -e "  Framework: ${CYAN}$FRAMEWORK${NC}  (branch: ${CYAN}$GITHUB_BRANCH${NC})"
    echo -e "  From: ${YELLOW}v$FROM_VERSION${NC}  →  To: ${GREEN}v$TO_VERSION${NC}"
    if [ "$DRY_RUN" = true ]; then
        echo -e "  Mode: ${BLUE}DRY RUN${NC} (no files will be written)"
    fi
    echo ""

    fetch_and_compare_components
    echo ""

    fetch_changelog
    echo ""

    fetch_component_props_diff
    echo ""

    fetch_angular_specific_diff
    echo ""

    update_cache_metadata
    echo ""

    generate_manifest

    cleanup

    echo ""
    info "Done! Review the manifest before running the agent team update."
    if [ "$DRY_RUN" = false ]; then
        echo ""
        echo "  Manifest: $MANIFEST_FILE"
    fi
    echo ""
}

main "$@"
