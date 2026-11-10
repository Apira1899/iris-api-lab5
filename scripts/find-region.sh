#!/usr/bin/env bash
# Lab 5 - finds an allowed region AND a usable VM size for the AKS node.
# Usage: bash scripts/find-region.sh      (after 'az login')
# Azure for Students: only ~5 regions are allowed and some sizes are blocked there.
SIZES="Standard_B2als_v2 Standard_B2as_v2 Standard_B2s_v2 Standard_D2as_v5 Standard_D2s_v5"
echo "Reading the 'Allowed resource deployment regions' policy..."
REGIONS=$(az policy assignment list --disable-scope-strict-match \
  --query "[?parameters.listOfAllowedLocations].parameters.listOfAllowedLocations.value[]" -o tsv 2>/dev/null | sort -u)
if [ -z "$REGIONS" ]; then
  echo "No region policy found (not a student subscription?). Testing default regions."
  REGIONS="francecentral westeurope northeurope swedencentral germanywestcentral"
fi
echo "Allowed regions: $(echo $REGIONS)"; echo
FOUND=""
for R in $REGIONS; do
  USE=$(az vm list-usage --location "$R" --query "[?name.value=='cores'].[currentValue,limit]" -o tsv 2>/dev/null)
  printf '%-20s vCPU used/limit: %s\n' "$R" "${USE:-?}"
  OKS=$(az vm list-skus --location "$R" --resource-type virtualMachines --all \
        --query "[?length(restrictions[?type=='Location'])==\`0\`].name" -o tsv 2>/dev/null)
  for S in $SIZES; do
    if echo "$OKS" | grep -qx "$S"; then
      printf '    %-20s available\n' "$S"
      [ -z "$FOUND" ] && FOUND="LOCATION=$R  NODE_SIZE=$S"
    fi
  done
done
echo
if [ -n "$FOUND" ]; then
  echo "Proposal: $FOUND"
  echo "Copy these two values into ~/lab5.env (LOCATION=... and NODE_SIZE=...)."
else
  echo "No size available: try again later or ask the teacher."
fi
