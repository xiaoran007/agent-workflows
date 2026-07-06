#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source_root="$repo_root/subagents/codex"
codex_home="${CODEX_HOME:-$HOME/.codex}"
dest_root="$codex_home/agents"
dry_run=0
project_root=""
scan_details=0
scan_diff=0

usage() {
  cat <<'EOF'
Usage:
  scripts/codex-subagents.sh install [--all | AGENT_PATH...]
  scripts/codex-subagents.sh update  [--all | AGENT_PATH...]
  scripts/codex-subagents.sh remove  [--all | AGENT_PATH...]
  scripts/codex-subagents.sh scan    [--all | AGENT_PATH...]
  scripts/codex-subagents.sh copy    [--all | AGENT_PATH...]

Options:
  --all             Operate on every custom agent under subagents/codex.
  -p, --project PATH
                    Install to PATH/.codex/agents instead of ~/.codex/agents.
  --details         With scan, show repository version and local/repository dates.
  --diff            With scan, show file diffs for changed custom agents.
  -n, --dry-run     Print actions without changing files.
  -h, --help        Show this help.

Examples:
  scripts/codex-subagents.sh install --all
  scripts/codex-subagents.sh update subagents/codex/reviewer.toml
  scripts/codex-subagents.sh scan --all
  scripts/codex-subagents.sh scan reviewer --details --diff
  scripts/codex-subagents.sh copy reviewer
  scripts/codex-subagents.sh remove reviewer
  scripts/codex-subagents.sh install --all --project /path/to/repo

Set CODEX_HOME to override the default ~/.codex location for personal agents.
EOF
}

run() {
  if [[ "$dry_run" == "1" ]]; then
    printf '[dry-run] %q' "$1"
    shift
    printf ' %q' "$@"
    printf '\n'
  else
    "$@"
  fi
}

die() {
  printf 'error: %s\n' "$*" >&2
  exit 1
}

stat_mtime_epoch() {
  local path="$1"
  stat -f '%m' "$path" 2>/dev/null || stat -c '%Y' "$path" 2>/dev/null || printf '0\n'
}

latest_mtime_epoch() {
  local path="$1"
  if [[ -e "$path" ]]; then
    stat_mtime_epoch "$path"
  else
    printf '0\n'
  fi
}

format_epoch() {
  local epoch="$1"
  if [[ ! "$epoch" =~ ^[0-9]+$ || "$epoch" == "0" ]]; then
    printf '-\n'
    return
  fi

  date -r "$epoch" '+%Y-%m-%d %H:%M:%S %z' 2>/dev/null ||
    date -d "@$epoch" '+%Y-%m-%d %H:%M:%S %z' 2>/dev/null ||
    printf '%s\n' "$epoch"
}

repo_version_for_path() {
  local path="$1"
  local rel
  local version

  if [[ ! -e "$path" ]]; then
    printf '-\n'
    return
  fi

  rel="${path#$repo_root/}"
  version="$(git -C "$repo_root" log -1 --format='%h %cs' -- "$rel" 2>/dev/null || true)"
  if [[ -n "$version" ]]; then
    printf '%s\n' "$version"
  else
    printf 'untracked\n'
  fi
}

agent_name_from_path() {
  local target="$1"
  local path=""

  if [[ -f "$target" && "${target##*.}" == "toml" ]]; then
    path="$target"
  elif [[ -f "$repo_root/$target" && "${target##*.}" == "toml" ]]; then
    path="$repo_root/$target"
  elif [[ -f "$source_root/$target.toml" ]]; then
    path="$source_root/$target.toml"
  elif [[ -f "$dest_root/$target.toml" ]]; then
    path="$dest_root/$target.toml"
  elif [[ "$target" != */* ]]; then
    printf '%s\n' "$target"
    return
  else
    die "not a custom agent path or known agent name: $target"
  fi

  basename "$path" .toml
}

source_path_for_name() {
  local name="$1"
  local path="$source_root/$name.toml"
  [[ -f "$path" ]] || die "missing tracked custom agent: $name"
  printf '%s\n' "$path"
}

local_path_for_name() {
  local name="$1"
  local path="$dest_root/$name.toml"
  [[ -f "$path" ]] || die "missing installed custom agent: $name"
  printf '%s\n' "$path"
}

all_agent_names() {
  find "$source_root" -mindepth 1 -maxdepth 1 -type f -name '*.toml' -print |
    while IFS= read -r path; do basename "$path" .toml; done |
    sort
}

all_local_agent_names() {
  [[ -d "$dest_root" ]] || return 0
  find "$dest_root" -mindepth 1 -maxdepth 1 -type f -name '*.toml' -print |
    while IFS= read -r path; do basename "$path" .toml; done |
    sort
}

all_scan_agent_names() {
  {
    all_agent_names
    all_local_agent_names
  } | sort -u
}

validate_agent_file() {
  local path="$1"

  grep -Eq '^[[:space:]]*name[[:space:]]*=' "$path" ||
    die "missing required name field: $path"
  grep -Eq '^[[:space:]]*description[[:space:]]*=' "$path" ||
    die "missing required description field: $path"
  grep -Eq '^[[:space:]]*developer_instructions[[:space:]]*=' "$path" ||
    die "missing required developer_instructions field: $path"
}

install_or_update() {
  local name="$1"
  local src
  src="$(source_path_for_name "$name")"
  validate_agent_file "$src"

  run mkdir -p "$dest_root"
  run cp "$src" "$dest_root/$name.toml"
  if [[ "$dry_run" == "1" ]]; then
    printf 'would %s %s -> %s\n' "$command" "$src" "$dest_root/$name.toml"
  else
    printf '%s %s -> %s\n' "$command" "$src" "$dest_root/$name.toml"
  fi
}

remove_agent() {
  local name="$1"
  local dest="$dest_root/$name.toml"

  if [[ ! -e "$dest" ]]; then
    printf 'skip missing %s\n' "$dest"
    return
  fi

  run rm -f "$dest"
  if [[ "$dry_run" == "1" ]]; then
    printf 'would remove %s\n' "$dest"
  else
    printf 'removed %s\n' "$dest"
  fi
}

scan_agent() {
  local name="$1"
  local src="$source_root/$name.toml"
  local dest="$dest_root/$name.toml"
  local status

  if [[ -f "$src" && -f "$dest" ]]; then
    if cmp -s "$src" "$dest"; then
      status="same"
    else
      status="changed"
    fi
  elif [[ -f "$src" ]]; then
    status="missing-local"
  elif [[ -f "$dest" ]]; then
    status="local-only"
  else
    status="missing-both"
  fi

  printf '%s %s\n' "$status" "$name"

  if [[ "$scan_details" == "1" ]]; then
    print_scan_details "$src" "$dest"
  fi

  if [[ "$scan_diff" == "1" && "$status" == "changed" ]]; then
    diff -u "$src" "$dest" || true
  fi
}

print_scan_details() {
  local src="$1"
  local dest="$2"

  printf '  repo_version: %s\n' "$(repo_version_for_path "$src")"
  printf '  repo_modified: %s\n' "$(format_epoch "$(latest_mtime_epoch "$src")")"
  printf '  local_modified: %s\n' "$(format_epoch "$(latest_mtime_epoch "$dest")")"
}

copy_from_local() {
  local name="$1"
  local local_path
  local repo_path="$source_root/$name.toml"
  local_path="$(local_path_for_name "$name")"
  validate_agent_file "$local_path"

  run mkdir -p "$source_root"
  run cp "$local_path" "$repo_path"
  if [[ "$dry_run" == "1" ]]; then
    printf 'would copy %s -> %s\n' "$local_path" "$repo_path"
  else
    printf 'copy %s -> %s\n' "$local_path" "$repo_path"
  fi
}

if [[ $# -eq 0 ]]; then
  usage
  exit 1
fi

command="$1"
shift

case "$command" in
  install|update|remove|scan|copy) ;;
  -h|--help)
    usage
    exit 0
    ;;
  *)
    usage
    die "unknown command: $command"
    ;;
esac

targets=()
use_all=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --all)
      use_all=1
      ;;
    -p|--project)
      shift
      [[ $# -gt 0 ]] || die "--project requires a path"
      project_root="$1"
      ;;
    --details)
      scan_details=1
      ;;
    --diff)
      scan_diff=1
      ;;
    -n|--dry-run)
      dry_run=1
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    -*)
      usage
      die "unknown option: $1"
      ;;
    *)
      targets+=("$1")
      ;;
  esac
  shift
done

[[ -d "$source_root" ]] || die "missing source custom agent root: $source_root"

if [[ -n "$project_root" ]]; then
  dest_root="$project_root/.codex/agents"
fi

if [[ "$command" != "scan" && ( "$scan_details" == "1" || "$scan_diff" == "1" ) ]]; then
  die "--details and --diff can only be used with scan"
fi

if [[ "$use_all" == "1" && "${#targets[@]}" -gt 0 ]]; then
  die "use either --all or explicit custom agent paths, not both"
fi

names=()
if [[ "$use_all" == "1" || "${#targets[@]}" -eq 0 ]]; then
  case "$command" in
    scan)
      while IFS= read -r name; do
        names+=("$name")
      done < <(all_scan_agent_names)
      ;;
    copy)
      while IFS= read -r name; do
        names+=("$name")
      done < <(all_local_agent_names)
      ;;
    *)
      while IFS= read -r name; do
        names+=("$name")
      done < <(all_agent_names)
      ;;
  esac
else
  for target in "${targets[@]}"; do
    names+=("$(agent_name_from_path "$target")")
  done
fi

if [[ "${#names[@]}" -eq 0 ]]; then
  printf 'no custom agents selected\n'
  exit 0
fi

for name in "${names[@]}"; do
  case "$command" in
    install|update)
      install_or_update "$name"
      ;;
    remove)
      remove_agent "$name"
      ;;
    scan)
      scan_agent "$name"
      ;;
    copy)
      copy_from_local "$name"
      ;;
  esac
done
