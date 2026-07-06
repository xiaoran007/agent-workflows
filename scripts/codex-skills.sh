#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source_root="$repo_root/skills/codex"
agents_home="${AGENTS_HOME:-$HOME/.agents}"
dest_root="$agents_home/skills"
dry_run=0
scan_details=0
scan_diff=0

usage() {
  cat <<'EOF'
Usage:
  scripts/codex-skills.sh install [--all | SKILL_PATH...]
  scripts/codex-skills.sh update  [--all | SKILL_PATH...]
  scripts/codex-skills.sh remove  [--all | SKILL_PATH...]
  scripts/codex-skills.sh scan    [--all | SKILL_PATH...]
  scripts/codex-skills.sh copy    [--all | SKILL_PATH...]

Options:
  --all       Operate on every skill under skills/codex.
  --details   With scan, show repository version and local/repository dates.
  --diff      With scan, show directory diffs for changed skills.
  -n, --dry-run
              Print actions without changing files.
  -h, --help  Show this help.

Examples:
  scripts/codex-skills.sh install --all
  scripts/codex-skills.sh update skills/codex/ssh-git-sync
  scripts/codex-skills.sh scan --all
  scripts/codex-skills.sh scan ssh-git-sync --details --diff
  scripts/codex-skills.sh copy ssh-git-sync
  scripts/codex-skills.sh remove ssh-git-sync

Set AGENTS_HOME to override the default ~/.agents location.
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
  local latest=0
  local file
  local mtime

  if [[ ! -e "$path" ]]; then
    printf '0\n'
    return
  fi

  if [[ -f "$path" ]]; then
    stat_mtime_epoch "$path"
    return
  fi

  while IFS= read -r -d '' file; do
    mtime="$(stat_mtime_epoch "$file")"
    if [[ "$mtime" =~ ^[0-9]+$ && "$mtime" -gt "$latest" ]]; then
      latest="$mtime"
    fi
  done < <(find "$path" -type f -print0)

  if [[ "$latest" == "0" ]]; then
    stat_mtime_epoch "$path"
  else
    printf '%s\n' "$latest"
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

skill_name_from_path() {
  local target="$1"

  if [[ -d "$target" && -f "$target/SKILL.md" ]]; then
    basename "$target"
    return
  fi

  if [[ -f "$target" && "$(basename "$target")" == "SKILL.md" ]]; then
    basename "$(dirname "$target")"
    return
  fi

  if [[ -d "$repo_root/$target" && -f "$repo_root/$target/SKILL.md" ]]; then
    basename "$target"
    return
  fi

  if [[ -f "$repo_root/$target" && "$(basename "$target")" == "SKILL.md" ]]; then
    basename "$(dirname "$target")"
    return
  fi

  if [[ -d "$source_root/$target" && -f "$source_root/$target/SKILL.md" ]]; then
    basename "$target"
    return
  fi

  if [[ -d "$dest_root/$target" && -f "$dest_root/$target/SKILL.md" ]]; then
    basename "$target"
    return
  fi

  if [[ "$target" != */* ]]; then
    printf '%s\n' "$target"
    return
  fi

  die "not a skill path or known skill name: $target"
}

source_path_for_name() {
  local name="$1"
  local path="$source_root/$name"
  [[ -d "$path" && -f "$path/SKILL.md" ]] || die "missing tracked skill: $name"
  printf '%s\n' "$path"
}

local_path_for_name() {
  local name="$1"
  local path="$dest_root/$name"
  [[ -d "$path" && -f "$path/SKILL.md" ]] || die "missing installed skill: $name"
  printf '%s\n' "$path"
}

all_skill_names() {
  find "$source_root" -mindepth 1 -maxdepth 1 -type d -exec test -f '{}/SKILL.md' ';' -print |
    while IFS= read -r path; do basename "$path"; done |
    sort
}

all_local_skill_names() {
  [[ -d "$dest_root" ]] || return 0
  find "$dest_root" -mindepth 1 -maxdepth 1 -type d -exec test -f '{}/SKILL.md' ';' -print |
    while IFS= read -r path; do basename "$path"; done |
    sort
}

all_scan_skill_names() {
  {
    all_skill_names
    all_local_skill_names
  } | sort -u
}

install_or_update() {
  local name="$1"
  local src
  src="$(source_path_for_name "$name")"

  run mkdir -p "$dest_root"
  run rm -rf "$dest_root/$name"
  run cp -R "$src" "$dest_root/$name"
  if [[ "$dry_run" == "1" ]]; then
    printf 'would %s %s -> %s\n' "$command" "$src" "$dest_root/$name"
  else
    printf '%s %s -> %s\n' "$command" "$src" "$dest_root/$name"
  fi
}

remove_skill() {
  local name="$1"
  local dest="$dest_root/$name"

  if [[ ! -e "$dest" ]]; then
    printf 'skip missing %s\n' "$dest"
    return
  fi

  run rm -rf "$dest"
  if [[ "$dry_run" == "1" ]]; then
    printf 'would remove %s\n' "$dest"
  else
    printf 'removed %s\n' "$dest"
  fi
}

scan_skill() {
  local name="$1"
  local src="$source_root/$name"
  local dest="$dest_root/$name"
  local status

  if [[ -d "$src" && -f "$src/SKILL.md" && -d "$dest" && -f "$dest/SKILL.md" ]]; then
    if diff -qr "$src" "$dest" >/dev/null; then
      status="same"
    else
      status="changed"
    fi
  elif [[ -d "$src" && -f "$src/SKILL.md" ]]; then
    status="missing-local"
  elif [[ -d "$dest" && -f "$dest/SKILL.md" ]]; then
    status="local-only"
  else
    status="missing-both"
  fi

  printf '%s %s\n' "$status" "$name"

  if [[ "$scan_details" == "1" ]]; then
    print_scan_details "$src" "$dest"
  fi

  if [[ "$scan_diff" == "1" && "$status" == "changed" ]]; then
    diff -ruN "$src" "$dest" || true
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
  local repo_path="$source_root/$name"
  local_path="$(local_path_for_name "$name")"

  run mkdir -p "$source_root"
  run rm -rf "$repo_path"
  run cp -R "$local_path" "$repo_path"
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

[[ -d "$source_root" ]] || die "missing source skill root: $source_root"

if [[ "$command" != "scan" && ( "$scan_details" == "1" || "$scan_diff" == "1" ) ]]; then
  die "--details and --diff can only be used with scan"
fi

if [[ "$use_all" == "1" && "${#targets[@]}" -gt 0 ]]; then
  die "use either --all or explicit skill paths, not both"
fi

names=()
if [[ "$use_all" == "1" || "${#targets[@]}" -eq 0 ]]; then
  case "$command" in
    scan)
      while IFS= read -r name; do
        names+=("$name")
      done < <(all_scan_skill_names)
      ;;
    copy)
      while IFS= read -r name; do
        names+=("$name")
      done < <(all_local_skill_names)
      ;;
    *)
      while IFS= read -r name; do
        names+=("$name")
      done < <(all_skill_names)
      ;;
  esac
else
  for target in "${targets[@]}"; do
    names+=("$(skill_name_from_path "$target")")
  done
fi

[[ "${#names[@]}" -gt 0 ]] || die "no skills selected"

for name in "${names[@]}"; do
  case "$command" in
    install|update)
      install_or_update "$name"
      ;;
    remove)
      remove_skill "$name"
      ;;
    scan)
      scan_skill "$name"
      ;;
    copy)
      copy_from_local "$name"
      ;;
  esac
done
