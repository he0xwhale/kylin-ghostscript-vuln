# Ghostscript Vulnerability Detection & Research for Kylin OS

## Description

This repository provides a vulnerability detection script for Ghostscript on Kylin OS. Ghostscript is a widely used PostScript and PDF interpreter, often utilized in printing systems, PDF preview, and image processing. The official Kylin security advisory **KYSA-202406-0043** highlights a security vulnerability in Ghostscript on Kylin Desktop V10 SP1 that allows attackers to execute arbitrary code via specially crafted files.

Affected packages include:

- ghostscript
- ghostscript-x
- libgs9
- libgs9-common

Affected versions: any version below `9.50~dfsg-5kylin4.12`.

Official advisory link: [https://www.kylinos.cn/support/loophole/patch/7113.html](https://www.kylinos.cn/support/loophole/patch/7113.html)

---

## Overview

This repository provides a shell script **kylin\_ghostscript\_vuln\_check.sh** to:

- Detect the Kylin OS version and build information
- Check installed Ghostscript-related packages against known vulnerable versions
- Output results with clear upgrade recommendations

The script can be used in both connected and offline environments.

---

## Features

- Checks `ghostscript`, `ghostscript-x`, `libgs9`, and `libgs9-common` package versions
- Reports whether installed versions meet the minimum secure version (`9.50~dfsg-5kylin4.12`)
- Provides upgrade instructions for both online and offline scenarios
- Displays Ghostscript binary version (reference only)
- Handles missing packages gracefully

---

## Usage

1. Clone the repository:

```bash
git clone https://github.com/he0xwhale/kylin-ghostscript-vuln.git
cd kylin-ghostscript-vuln
```

2. Make the script executable:

```bash
chmod +x kylin_ghostscript_vuln_check.sh
```

3. Run the script:

```bash
./kylin_ghostscript_vuln_check.sh
```

---

## Example Output

| Package       | Installed Version    | Status (>= 9.50\~dfsg-5kylin4.12) |
| ------------- | -------------------- | --------------------------------- |
| ghostscript   | 9.50\~dfsg-5kylin4.2 | Needs Upgrade                     |
| ghostscript-x | -                    | Not Installed                     |
| libgs9        | 9.50\~dfsg-5kylin4.2 | Needs Upgrade                     |
| libgs9-common | 9.50\~dfsg-5kylin4.2 | Needs Upgrade                     |

Detected OS: Kylin V10 SP1\
Recommendation: upgrade all affected packages.

---

## Upgrade Recommendations

### 1. Online Upgrade (Recommended)

```bash
sudo apt update && sudo apt install ghostscript ghostscript-x libgs9 libgs9-common
```

### 2. Offline Upgrade

1. Download `.deb` packages according to your system architecture from the official repository:\
   [https://update.kylinos.cn/update/v10sp1/amd64/pool/main/g/ghostscript/](https://update.kylinos.cn/update/v10sp1/amd64/pool/main/g/ghostscript/)
2. Packages to download:

- `ghostscript_9.50~dfsg-5kylin4.12_amd64.deb`
- `ghostscript-x_9.50~dfsg-5kylin4.12_amd64.deb`
- `libgs9_9.50~dfsg-5kylin4.12_amd64.deb`
- `libgs9-common_9.50~dfsg-5kylin4.12_all.deb`

3. Install downloaded packages:

```bash
sudo dpkg -i ghostscript_*.deb ghostscript-x_*.deb libgs9_*.deb libgs9-common_*.deb
sudo apt -f install
```

---

## Future Work

- Compare vulnerable and patched Ghostscript binaries to understand exploit mechanisms
- Document potential PoC scenarios
- Automate patch management for Kylin OS environments

---

## References

- [KylinOS Security Advisory KYSA-202406-0043](https://www.kylinos.cn/support/loophole/patch/7113.html)

---

## License

This project is licensed under the Apache 2.0 License - see the LICENSE file for details.

