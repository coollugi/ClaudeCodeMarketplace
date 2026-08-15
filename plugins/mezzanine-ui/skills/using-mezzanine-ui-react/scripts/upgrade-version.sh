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
# Optional local monorepo checkout. RECONCILIATION.md makes the local repo the
# source of truth; without it every component costs one HTTP round trip per file.
SOURCE_DIR=""
WORK_DIR=""

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
    echo "  --source-dir <path> Read source from a local mezzanine checkout instead of"
    echo "                     raw.githubusercontent.com/main. Report it when the checkout"
    echo "                     and main disagree; do not silently prefer one."
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

    # The API extractor / doc parser / comparer are Python; comparing types and
    # defaults needs the declaration text, not a grep.
    if ! command -v python3 &> /dev/null; then
        missing+=("python3")
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
            --source-dir)
                SOURCE_DIR="${2:-}"
                if [ -z "$SOURCE_DIR" ]; then
                    error "--source-dir requires a path to a mezzanine checkout"
                    exit 1
                fi
                SOURCE_DIR="${SOURCE_DIR%/}"
                if [ ! -d "$SOURCE_DIR/packages" ]; then
                    error "--source-dir does not look like a mezzanine checkout: $SOURCE_DIR"
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

    WORK_DIR=$(mktemp -d "${TMPDIR:-/tmp}/mzn-upgrade.XXXXXX")

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

    # Local checkout: the folder listing IS the component list, no API calls.
    if [ -n "$SOURCE_DIR" ]; then
        local map='{}'
        local folder base comp all_files main_file
        for folder in "$SOURCE_DIR"/packages/ng/*/; do
            base=$(basename "$folder")
            case "$base" in _*|.*|services|utils|src) continue ;; esac
            [ -f "$folder/index.ts" ] || continue
            comp=$(kebab_to_pascal "$base")
            all_files=$(ls "$folder"*.ts 2>/dev/null \
                | grep -vE '\.(spec|stories)\.ts$' \
                | sed "s|$SOURCE_DIR/||" | jq -R . | jq -sc .)
            main_file="packages/ng/$base/$base.component.ts"
            [ -f "$SOURCE_DIR/$main_file" ] || main_file="packages/ng/$base/$base.directive.ts"
            [ -f "$SOURCE_DIR/$main_file" ] || main_file="packages/ng/$base/index.ts"
            map=$(echo "$map" | jq --arg k "$comp" --arg folder "packages/ng/$base" \
                --arg file "$main_file" --argjson all "$all_files" \
                '. + {($k): {className: "", sourceDir: $folder, mainFile: $file, allFiles: $all}}')
        done
        echo "$map" > "$NG_COMPONENT_MAP_FILE"
        info "Built Angular component source map from $SOURCE_DIR ($(echo "$map" | jq 'length') components)"
        return
    fi

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
            local index_content
            if [ -n "$SOURCE_DIR" ]; then
                detail "Reading: $SOURCE_DIR/packages/react/src/index.ts"
                if ! index_content=$(cat "$SOURCE_DIR/packages/react/src/index.ts" 2>/dev/null); then
                    warn "Could not read index.ts from $SOURCE_DIR. Skipping component list comparison."
                    echo "[]"
                    return
                fi
            else
                local index_url="$GITHUB_RAW_BASE/packages/react/src/index.ts"
                detail "Fetching: $index_url"
                if ! index_content=$(curl -sf "$index_url" 2>/dev/null); then
                    warn "Could not fetch index.ts from GitHub. Skipping component list comparison."
                    echo "[]"
                    return
                fi
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

# ─── Step 3: Compare documented API against source (names, types, defaults) ───
#
# Extraction lives in extract-api.py, doc parsing in doc-api.py, comparison in
# reconcile-api.py. It used to be awk in this file, and every trap that produced
# a wrong doc edit came from that: a 60-line scan window, a `}` that terminated
# early inside a JSDoc @example, `readonly` before a signal input, an `alias:`
# that renames the public input, a component family treated as a single file.
# Those cases are now regression-documented at the point of parse. What the shell
# still owns: deciding WHERE the source comes from, and folding results into the
# manifest.

# Populate $WORK_DIR/src/<Component>/ with the component family's sources and
# print a batch manifest for extract-api.py.
prepare_source_batch() {
    local batch="$WORK_DIR/batch.json"
    local components
    components=$(ls "$COMPONENTS_DIR"/*.md 2>/dev/null | xargs -I{} basename {} .md | sort -u)

    local entries='[]'
    while IFS= read -r component; do
        [ -z "$component" ] && continue
        local dir=""
        if [ -n "$SOURCE_DIR" ]; then
            case "$FRAMEWORK" in
                react) dir="$SOURCE_DIR/packages/react/src/$component" ;;
                ng)
                    local rel
                    rel=$(jq -r --arg c "$component" '.[$c].sourceDir // empty' "$NG_COMPONENT_MAP_FILE" 2>/dev/null)
                    [ -n "$rel" ] && dir="$SOURCE_DIR/$rel"
                    ;;
            esac
            [ -d "$dir" ] || continue
        else
            dir="$WORK_DIR/src/$component"
            mkdir -p "$dir"
            local files=""
            case "$FRAMEWORK" in
                react)
                    files=$(curl -sfL -H "Accept: application/vnd.github+json" \
                        "$GITHUB_API_BASE/contents/packages/react/src/$component?ref=$GITHUB_BRANCH" 2>/dev/null \
                        | jq -r '.[]? | select(.type == "file") | .path' \
                        | grep -E '\.tsx?$' | grep -vE '\.(spec|stories|test)\.' || true)
                    ;;
                ng)
                    files=$(jq -r --arg c "$component" '.[$c].allFiles // [] | .[]' "$NG_COMPONENT_MAP_FILE" 2>/dev/null)
                    local src_dir
                    src_dir=$(jq -r --arg c "$component" '.[$c].sourceDir // empty' "$NG_COMPONENT_MAP_FILE" 2>/dev/null)
                    # index.ts carries the public export list, which is what a
                    # consumer puts in `imports: []`.
                    [ -n "$src_dir" ] && files="$files
$src_dir/index.ts"
                    ;;
            esac
            local fetched=0
            while IFS= read -r f; do
                [ -z "$f" ] && continue
                if curl -sfL "$GITHUB_RAW_BASE/$f" -o "$dir/$(basename "$f")" 2>/dev/null; then
                    fetched=$((fetched + 1))
                fi
            done <<< "$files"
            [ "$fetched" -eq 0 ] && continue
        fi
        entries=$(echo "$entries" | jq --arg c "$component" --arg d "$dir" '. + [{component: $c, dir: $d}]')
    done <<< "$components"

    echo "$entries" > "$batch"
    echo "$batch"
}

fetch_component_props_diff() {
    step "Step 3: Comparing documented API against source (names, types, defaults)"

    local batch
    batch=$(prepare_source_batch)
    local count
    count=$(jq 'length' "$batch")
    detail "Source located for $count component(s)$([ -n "$SOURCE_DIR" ] && echo " (local: $SOURCE_DIR)" || echo " (github: $GITHUB_BRANCH)")"

    local root_args=()
    if [ "$FRAMEWORK" = "react" ] && [ -n "$SOURCE_DIR" ]; then
        # Lets a base declared in a sibling component folder resolve
        # (DatePickerProps extends Omit<PickerTriggerProps, ...>) instead of
        # being reported as 30 removed props.
        root_args=(--root "$SOURCE_DIR/packages/react/src")
    fi

    if ! python3 "$SCRIPT_DIR/extract-api.py" --framework "$FRAMEWORK" --batch "$batch" \
        "${root_args[@]+"${root_args[@]}"}" > "$WORK_DIR/source-api.json" 2>"$WORK_DIR/extract.err"; then
        warn "extract-api.py failed: $(head -n3 "$WORK_DIR/extract.err")"
        echo "[]" > /tmp/mzn_props_diff.json
        return
    fi

    if ! python3 "$SCRIPT_DIR/doc-api.py" --framework "$FRAMEWORK" \
        --components-dir "$COMPONENTS_DIR" > "$WORK_DIR/doc-api.json" 2>"$WORK_DIR/doc.err"; then
        warn "doc-api.py failed: $(head -n3 "$WORK_DIR/doc.err")"
        echo "[]" > /tmp/mzn_props_diff.json
        return
    fi

    python3 "$SCRIPT_DIR/reconcile-api.py" --framework "$FRAMEWORK" \
        --docs "$WORK_DIR/doc-api.json" --source "$WORK_DIR/source-api.json" --summary \
        > /tmp/mzn_props_diff.json

    local changed
    changed=$(jq 'length' /tmp/mzn_props_diff.json)
    if [ "$changed" = "0" ]; then
        info "Documented API matches source for every component"
    else
        info "$changed component(s) differ from source — triage per RECONCILIATION.md before editing"
    fi
}

# ─── Step 3b: Angular-specific diff (selector / CVA / DI tokens / imports) ────
#
# Selector and CVA come from the source extraction and are compared against the
# cache; tokens and standalone imports are compared against the DOCS by
# reconcile-api.py (Step 3), because that is the claim a consumer copies.
fetch_angular_specific_diff() {
    [ "$FRAMEWORK" = "ng" ] || { echo "[]" > /tmp/mzn_ng_specific.json; return; }

    step "Step 3b: Analyzing Angular-specific changes (selector / CVA)"

    local api_index="$CACHE_DIR/component-index.json"
    if [ ! -f "$api_index" ] || [ ! -f "$WORK_DIR/source-api.json" ]; then
        warn "component-index.json or source extraction missing — skipping ng-specific diff"
        echo "[]" > /tmp/mzn_ng_specific.json
        return
    fi

    # A cached selector that still exists on ANY directive in the family has not
    # been renamed — the main-file heuristic just picked a different file. That
    # check is why `[mznCardGroup] -> [mznBaseCard]` is not reported.
    jq -n \
        --slurpfile src "$WORK_DIR/source-api.json" \
        --slurpfile cache "$api_index" \
        '
        ($src[0]) as $s | ($cache[0].components) as $c |
        [ $c | to_entries[]
          | .key as $name | .value as $entry
          | ($s[$name] // empty) as $api
          | {
              component: $name,
              selectorChanged: (
                if ($api.selector // "") != "" and ($entry.selector // "") != ""
                   and $api.selector != $entry.selector
                   and (($api.selectors // []) | index($entry.selector)) == null
                then {
                  from: $entry.selector,
                  to: $api.selector,
                  typeChanged: ((($entry.selector | startswith("[")) != ($api.selector | startswith("["))))
                } else null end
              ),
              cvaChange: (
                if ($entry.cva // false) != ($api.cva // false)
                then (if $api.cva then "added" else "removed" end)
                else null end
              )
            }
          | select(.selectorChanged != null or .cvaChange != null)
        ]' > /tmp/mzn_ng_specific.json

    local changed
    changed=$(jq 'length' /tmp/mzn_ng_specific.json)
    if [ "$changed" = "0" ]; then
        info "No selector or CVA changes detected"
    else
        jq -r '.[] | "  \(.component): \(if .selectorChanged then "selector " else "" end)\(if .cvaChange then "cva" else "" end)"' /tmp/mzn_ng_specific.json
        info "$changed component(s) have Angular-specific changes"
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

        # Components whose documented API differs from source. Names, types and
        # defaults are separate work items: a wrong type is not fixed by adding
        # the missing prop, and reviewers triage them differently.
        ($props_diff // []) | map(
            . as $d |
            [
                (if ((.propsAdded | length) > 0 or (.propsRemoved | length) > 0) then {
                    component: $d.component,
                    action:    "UPDATE_PROPS",
                    reason:    (
                        (if (.propsAdded | length) > 0 then ("Undocumented in source: " + (.propsAdded | join(", "))) else "" end) +
                        (if (.propsAdded | length) > 0 and (.propsRemoved | length) > 0 then "; " else "" end) +
                        (if (.propsRemoved | length) > 0 then ("Documented but not found in source: " + (.propsRemoved | join(", "))) else "" end)
                    ),
                    priority:     (if (.propsRemoved | length) > 0 then "HIGH" else "MEDIUM" end),
                    propsAdded:   .propsAdded,
                    propsRemoved: .propsRemoved
                } else empty end),
                (if (.typeMismatches | length) > 0 then {
                    component: $d.component,
                    action:    "UPDATE_TYPES",
                    reason:    ("Type differs from source: " + ([.typeMismatches[] | "\(.prop // .output) doc=\(.doc) source=\(.source)"] | join("; "))),
                    priority:  "HIGH",
                    typeMismatches: .typeMismatches
                } else empty end),
                (if (.defaultMismatches | length) > 0 then {
                    component: $d.component,
                    action:    "UPDATE_DEFAULTS",
                    reason:    ("Default differs from source: " + ([.defaultMismatches[] | "\(.prop) doc=\(.doc) source=\(.source)"] | join("; "))),
                    priority:  "HIGH",
                    defaultMismatches: .defaultMismatches
                } else empty end),
                (if ((.defaultMissing // []) | length) > 0 then {
                    component: $d.component,
                    action:    "UPDATE_DEFAULTS",
                    reason:    ("Source sets a default the table leaves blank: " + ([.defaultMissing[] | "\(.prop)=\(.source)"] | join("; "))),
                    priority:  "MEDIUM",
                    defaultMissing: .defaultMissing
                } else empty end),
                (if ((.requiredMismatches // []) | length) > 0 then {
                    component: $d.component,
                    action:    "UPDATE_REQUIRED",
                    reason:    ("Required in source, optional in docs: " + ([.requiredMismatches[] | .prop] | join(", "))),
                    priority:  "HIGH",
                    requiredMismatches: .requiredMismatches
                } else empty end),
                (if ((.outputsAdded // []) | length) > 0 or ((.outputsRemoved // []) | length) > 0 then {
                    component: $d.component,
                    action:    "UPDATE_OUTPUTS",
                    reason:    (
                        (if ((.outputsAdded // []) | length) > 0 then ("Undocumented outputs: " + (.outputsAdded | join(", "))) else "" end) +
                        (if ((.outputsAdded // []) | length) > 0 and ((.outputsRemoved // []) | length) > 0 then "; " else "" end) +
                        (if ((.outputsRemoved // []) | length) > 0 then ("Documented outputs absent from source: " + (.outputsRemoved | join(", "))) else "" end)
                    ),
                    priority:  "HIGH",
                    outputsAdded:   (.outputsAdded // []),
                    outputsRemoved: (.outputsRemoved // [])
                } else empty end),
                (if ((.tokensAdded // []) | length) > 0 then {
                    component: $d.component,
                    action:    "UPDATE_PROVIDERS_TOKENS",
                    reason:    ("Provided by the component but never mentioned in the doc: " + (.tokensAdded | join(", "))),
                    priority:  "MEDIUM",
                    tokens:    .tokensAdded
                } else empty end),
                (if ((.importsAdded // []) | length) > 0 or ((.importsRemoved // []) | length) > 0 then {
                    component: $d.component,
                    action:    "UPDATE_STANDALONE_IMPORTS",
                    reason:    (
                        (if ((.importsAdded // []) | length) > 0 then ("Exported but not in the doc Import block: " + (.importsAdded | join(", "))) else "" end) +
                        (if ((.importsAdded // []) | length) > 0 and ((.importsRemoved // []) | length) > 0 then "; " else "" end) +
                        (if ((.importsRemoved // []) | length) > 0 then ("Doc tells consumers to import a symbol the package does not export as a directive: " + (.importsRemoved | join(", "))) else "" end)
                    ),
                    priority:  (if ((.importsRemoved // []) | length) > 0 then "HIGH" else "MEDIUM" end),
                    importsAdded:   (.importsAdded // []),
                    importsRemoved: (.importsRemoved // [])
                } else empty end)
            ]
        ) | add // [] as $changed_items |

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
                } else empty end)
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
    [ -n "$WORK_DIR" ] && rm -rf "$WORK_DIR"
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
