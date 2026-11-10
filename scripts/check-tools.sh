#!/usr/bin/env bash
# Lab 5 - checks that the tools are installed and that Docker is running.
# Usage: bash scripts/check-tools.sh
ok()  { printf '  [OK]  %s\n' "$1"; }
ko()  { printf '  [!!]  %s\n' "$1"; ERR=$((ERR+1)); }
ERR=0
echo "== Lab 5 tools =="
for t in docker az kubectl minikube git; do
  if command -v "$t" >/dev/null 2>&1; then ok "$t found: $(command -v "$t")"; else ko "$t not found (see Part 0, installation step)"; fi
done
if docker info >/dev/null 2>&1; then ok "Docker engine answers (version $(docker version --format '{{.Server.Version}}' 2>/dev/null))"
else ko "Docker engine does not answer: start Docker Desktop and wait for 'Engine running'"; fi
if command -v az >/dev/null 2>&1; then
  ok "Azure CLI $(az version --query '"azure-cli"' -o tsv 2>/dev/null)"
  SUB=$(az account show --query name -o tsv 2>/dev/null)
  if [ -n "$SUB" ]; then ok "signed in to Azure, subscription: $SUB"; else ko "not signed in to Azure: run 'az login'"; fi
fi
command -v kubectl >/dev/null 2>&1 && ok "kubectl $(kubectl version --client -o json 2>/dev/null | grep -m1 gitVersion | tr -d ' ",' | cut -d: -f2)"
command -v minikube >/dev/null 2>&1 && ok "$(minikube version --short 2>/dev/null)"
case "$(uname -s)" in
  MINGW*|MSYS*) [ "$MSYS_NO_PATHCONV" = "1" ] && ok "Git Bash: MSYS_NO_PATHCONV=1" || ko "Git Bash: run 'source ~/lab5.env' (it contains export MSYS_NO_PATHCONV=1)";;
esac
echo
if [ "$ERR" -eq 0 ]; then echo "Everything is ready. Enjoy the lab!"; else echo "$ERR item(s) to fix before going on."; fi
