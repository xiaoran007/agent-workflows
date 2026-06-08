#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source_root="$repo_root/skills/codex"
agents_home="${AGENTS_HOME:-$HOME/.agents}"
dest_root="$agents_home/skills"
dry_run=0

usage() {
  cat <<'EOF'
Usage:
  scripts/codex-skills.sh install [--all | SKILL_PATH...]
  scripts/codex-skills.sh update  [--all | SKILL_PATH...]
  scripts/codex-skills.sh remove  [--all | SKILL_PATH...]

Options:
  --all       Operate on every skill under skills/codex.
  -n, --dry-run
              Print actions without changing files.
  -h, --help  Show this help.

Examples:
  scripts/codex-skills.sh install --all
  scripts/codex-skills.sh update skills/codex/ssh-git-sync
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

  die "not a skill path or known skill name: $target"
}

source_path_for_name() {
  local name="$1"
  local path="$source_root/$name"
  [[ -d "$path" && -f "$path/SKILL.md" ]] || die "missing tracked skill: $name"
  printf '%s\n' "$path"
}

all_skill_names() {
  find "$source_root" -mindepth 1 -maxdepth 1 -type d -exec test -f '{}/SKILL.md' ';' -print |
    while IFS= read -r path; do basename "$path"; done |
    sort
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

if [[ $# -eq 0 ]]; then
  usage
  exit 1
fi

command="$1"
shift

case "$command" in
  install|update|remove) ;;
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

if [[ "$use_all" == "1" && "${#targets[@]}" -gt 0 ]]; then
  die "use either --all or explicit skill paths, not both"
fi

names=()
if [[ "$use_all" == "1" || "${#targets[@]}" -eq 0 ]]; then
  while IFS= read -r name; do
    names+=("$name")
  done < <(all_skill_names)
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
  esac
done
