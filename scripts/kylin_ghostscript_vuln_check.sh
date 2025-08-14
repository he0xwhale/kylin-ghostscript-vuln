#!/usr/bin/env bash
# KYSA-202406-0043 Self-Check Script (Ghostscript)
# Reference Advisory: https://www.kylinos.cn/support/loophole/patch/7113.html
# Target: Kylin Desktop OS V10 SP1
# Exit Codes: 0=Secure; 1=Vulnerable package found; 2=Not applicable (non-V10 SP1 or dpkg not found); 3=Execution error

set -euo pipefail

FIX_VER="9.50~dfsg-5kylin4.12"
PKGS=("ghostscript" "ghostscript-x" "libgs9" "libgs9-common")
VULN_FOUND=0
NOT_APPLICABLE=0
RED=$(tput setaf 1 || true)
GRN=$(tput setaf 2 || true)
YLW=$(tput setaf 3 || true)
RST=$(tput sgr0 || true)

echo "== KYSA-202406-0043 (Ghostscript) Vulnerability Self-Check =="
date +"Check Time: %F %T"
echo "Target Fix Version: ${FIX_VER}"
echo

# 1) Check dpkg environment
if ! command -v dpkg >/dev/null 2>&1; then
  echo "${YLW}Non-dpkg system detected (possibly not Kylin/Ubuntu/Debian). Script not applicable.${RST}"
  exit 2
fi

# 2) Rough check for Kylin V10 SP1
OS_INFO=$( (grep -E 'Kylin|银河麒麟' -i /etc/*release 2>/dev/null || true) | tr -s ' ')
if ! echo "$OS_INFO" | grep -qiE 'V10'; then
  echo "${YLW}V10 information not found in /etc/*release, package check will continue for reference.${RST}"
  NOT_APPLICABLE=1
fi

if ! echo "$OS_INFO" | grep -qiE 'SP1'; then
  echo "${YLW}SP1 information not found, advisory targets V10 SP1; package check will continue.${RST}"
  NOT_APPLICABLE=1
fi
echo

# 3) List installed versions and compare
printf "Package\t\tInstalled Version\tStatus (>= %s)\n" "$FIX_VER"
printf -- "---------------------------------------------------------------\n"

for p in "${PKGS[@]}"; do
  if dpkg-query -W -f='${Status}\t${Version}\n' "$p" 2>/dev/null | grep -q "install ok installed"; then
    ver=$(dpkg-query -W -f='${Version}\n' "$p" 2>/dev/null | head -n1)
    if dpkg --compare-versions "$ver" ge "$FIX_VER"; then
      printf "%-16s%-24s%s\n" "$p" "$ver" "${GRN}Up-to-date${RST}"
    else
      printf "%-16s%-24s%s\n" "$p" "$ver" "${RED}Needs Upgrade${RST}"
      VULN_FOUND=1
    fi
  else
    printf "%-16s%-24s%s\n" "$p" "-" "${YLW}Not Installed${RST}"
  fi
done

echo
# 4) Additional cross-check: gs binary version (reference only)
if command -v gs >/dev/null 2>&1; then
  echo "gs binary version (reference only):"
  gs --version || true
  echo
fi

# 5) Result summary and upgrade recommendations
if [[ "$VULN_FOUND" -eq 1 ]]; then
  echo "${RED}[Conclusion] Vulnerable Ghostscript packages detected. Upgrade required.${RST}"
  echo
  echo "Online Upgrade (Recommended):"
  echo "  sudo apt update && sudo apt install ghostscript ghostscript-x libgs9 libgs9-common"
  echo
  echo "Offline Upgrade:"
  echo "  1. Visit the official advisory:"
  echo "     https://www.kylinos.cn/support/loophole/patch/7113.html"
  echo "  2. Download the .deb packages for your system architecture (x86_64/aarch64)."
  echo "     Example x86_64 package location:"
  echo "     https://archive.kylinos.cn/kylin/KYLIN-ALL/pool/main/g/ghostscript/ghostscript-x_9.50~dfsg-5kylin4.12_amd64.deb"
  echo "  3. Download the following packages:"
  echo "     - ghostscript_${FIX_VER}_amd64.deb"
  echo "     - ghostscript-x_${FIX_VER}_amd64.deb"
  echo "     - libgs9_${FIX_VER}_amd64.deb"
  echo "     - libgs9-common_${FIX_VER}_all.deb"
  echo "  4. Install them using:"
  echo "     sudo dpkg -i ghostscript_*.deb ghostscript-x_*.deb libgs9_*.deb libgs9-common_*.deb"
  echo "  5. Fix dependencies if needed:"
  echo "     sudo apt -f install"
  EXIT_CODE=1
else
  echo "${GRN}[Conclusion] No vulnerable packages detected or packages not installed.${RST}"
  EXIT_CODE=0
fi

exit "$EXIT_CODE"
