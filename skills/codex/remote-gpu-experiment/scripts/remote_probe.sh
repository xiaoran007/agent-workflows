#!/usr/bin/env bash
set -u

remote_root="${1:-}"

section() {
  printf '\n## %s\n' "$1"
}

status_line() {
  printf '%s: %s\n' "$1" "$2"
}

print_cmd() {
  printf '$ %s\n' "$*"
  "$@" 2>&1 || printf '[command failed: %s]\n' "$*"
}

section "Probe"
status_line "timestamp_utc" "$(date -u '+%Y-%m-%dT%H:%M:%SZ' 2>/dev/null || date)"
status_line "remote_root" "${remote_root:-<missing>}"

section "Identity"
status_line "hostname" "$(hostname 2>/dev/null || printf '<unknown>')"
status_line "user" "$(whoami 2>/dev/null || printf '<unknown>')"
status_line "pwd" "$(pwd 2>/dev/null || printf '<unknown>')"
status_line "shell" "${SHELL:-<unset>}"

section "Environment"
for name in PATH CONDA_PREFIX VIRTUAL_ENV CUDA_HOME CUDA_VISIBLE_DEVICES LD_LIBRARY_PATH; do
  value="$(printenv "$name" 2>/dev/null || true)"
  status_line "$name" "${value:-<unset>}"
done

section "Project Path"
if [ -z "$remote_root" ]; then
  status_line "Blocker" "remote_root argument is missing"
elif [ ! -e "$remote_root" ]; then
  status_line "Blocker" "remote_root does not exist"
elif [ ! -d "$remote_root" ]; then
  status_line "Blocker" "remote_root exists but is not a directory"
else
  status_line "OK" "remote_root exists"
  if [ -w "$remote_root" ]; then
    status_line "OK" "remote_root is writable"
  else
    status_line "Risk" "remote_root is not writable by current user"
  fi
  print_cmd df -h "$remote_root"
fi

section "Python"
python_path="$(command -v python 2>/dev/null || true)"
if [ -z "$python_path" ]; then
  status_line "Blocker" "no python found on PATH"
else
  status_line "OK" "python=$python_path"
  print_cmd python -V
  python - <<'PY'
import importlib.util
import os
import sys

print(f"sys.executable={sys.executable}")
print(f"sys.version={sys.version.split()[0]}")
print(f"cwd={os.getcwd()}")

for name in ["torch", "torchvision", "numpy"]:
    spec = importlib.util.find_spec(name)
    if spec is None:
        print(f"package.{name}=MISSING")
        continue
    try:
        module = __import__(name)
        print(f"package.{name}=OK version={getattr(module, '__version__', '<unknown>')}")
    except Exception as exc:
        print(f"package.{name}=RISK import_failed={type(exc).__name__}: {exc}")

try:
    import torch
    print(f"torch.cuda.is_available={torch.cuda.is_available()}")
    print(f"torch.version.cuda={getattr(torch.version, 'cuda', None)}")
    print(f"torch.cuda.device_count={torch.cuda.device_count()}")
    for idx in range(torch.cuda.device_count()):
        print(f"torch.cuda.device.{idx}={torch.cuda.get_device_name(idx)}")
except Exception as exc:
    print(f"torch.cuda=UNKNOWN {type(exc).__name__}: {exc}")
PY
fi

section "Project Dependencies"
if [ -n "$remote_root" ] && [ -d "$remote_root" ]; then
  found_dependency_file=0
  for file in requirements.txt pyproject.toml environment.yml environment.yaml setup.py; do
    if [ -f "$remote_root/$file" ]; then
      status_line "found" "$file"
      found_dependency_file=1
    fi
  done
  if [ "$found_dependency_file" -eq 0 ]; then
    status_line "Unknown" "no common dependency manifest found"
  fi
else
  status_line "Unknown" "remote_root is unavailable"
fi

section "GPU"
if command -v nvidia-smi >/dev/null 2>&1; then
  status_line "OK" "nvidia-smi=$(command -v nvidia-smi)"
  print_cmd nvidia-smi --query-gpu=index,name,driver_version,memory.total,memory.used,utilization.gpu --format=csv,noheader
  print_cmd nvidia-smi
else
  status_line "Risk" "nvidia-smi not found on PATH"
fi

section "Git"
if [ -n "$remote_root" ] && [ -d "$remote_root" ] && git -C "$remote_root" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  print_cmd git -C "$remote_root" status --short --branch
  print_cmd git -C "$remote_root" rev-parse --short HEAD
  print_cmd git -C "$remote_root" remote
else
  status_line "Unknown" "remote_root is not a git worktree"
fi

section "Long Running Tools"
for tool in tmux screen nohup; do
  path="$(command -v "$tool" 2>/dev/null || true)"
  if [ -n "$path" ]; then
    status_line "OK" "$tool=$path"
  else
    status_line "Risk" "$tool not found"
  fi
done
