██████╗ █████╗ ███████╗███████╗██╗ ██████╗ ██████╗ ███████╗██╗ █████╗
██╔════╝██╔══██╗██╔════╝██╔════╝██║██╔═══██╗██╔══██╗██╔════╝██║██╔══██╗
██║     ███████║███████╗███████╗██║██║   ██║██████╔╝█████╗  ██║███████║
██║     ██╔══██║╚════██║╚════██║██║██║   ██║██╔═══╝ ██╔══╝  ██║██╔══██║
╚██████╗██║  ██║███████║███████║██║╚██████╔╝██║     ███████╗██║██║  ██║
╚═════╝╚═╝  ╚═╝╚══════╝╚══════╝╚═╝ ╚═════╝ ╚═╝     ╚══════╝╚═╝╚═╝  ╚═╝ 

# 🛡️ Cassiopeia Pentest Framework

> ⚠️ **LEGAL DISCLAIMER — AUTHORIZED USE ONLY**
>
> This tool is intended for **educational purposes** and **authorized security testing** only.
> - You must have **written permission** from the target owner before using this tool.
> - Unauthorized access to computer systems is **illegal** under laws such as UU ITE (Indonesia), CFAA (USA), Computer Misuse Act (UK), etc.
> - The developer assumes **NO liability** for any damage, legal consequences, or misuse caused by this tool.
> - By using this tool, you agree to hold the developer harmless from any legal action.
> - **Responsible disclosure only.** Do not use against targets without explicit authorization.

---

## 📜 Overview

**Cassiopeia** is an all-in-one automated penetration testing framework designed for **Arch Linux / Garuda Linux** environments. It streamlines the entire security assessment workflow from OPSEC setup to final reporting with **40+ integrated tools** across **15+ phases**.

**Version:** 4.0.0  
**Developer:** Xyra77  
**Platform:** Arch Linux / Garuda Linux (Required)  
**License:** MIT License

---

## 🚀 Features

### 🔐 OPSEC & Anonymity
- Tor + ProxyChains automatic configuration
- MAC address spoofing
- IP rotation during scan
- DNS leak protection
- Real IP masking

### 🔍 Reconnaissance (15+ Phases)
| Phase | Description |
|-------|-------------|
| Phase 1 | OSINT & Passive Recon (theHarvester, Shodan, GitLeaks) |
| Phase 2 | Subdomain Enumeration (Subfinder, Amass, Assetfinder) |
| Phase 3 | Port & Service Scanning (Masscan, Nmap, testssl.sh) |
| Phase 4 | Fingerprinting & WAF Detection (WhatWeb, WAFW00F) |
| Phase 5 | URL & Parameter Discovery (GAU, Katana, Gospider, Arjun) |
| Phase 6 | Directory Fuzzing (FFUF, Gobuster, Feroxbuster, Nikto) |
| Phase 7 | XSS Hunting (Dalfox, KXSS, CRLFuzz) |
| Phase 8 | SQL Injection (SQLMap automated) |
| Phase 9 | SSRF Detection |
| Phase 10 | LFI / Path Traversal |
| Phase 11 | SSTI / XXE / RCE |
| Phase 12 | CORS / HTTP Smuggling / JWT |
| Phase 13 | GraphQL & API Discovery |
| Phase 14 | Nuclei Vulnerability Scan |
| Phase 15 | Metasploit Automation |

### 🧩 Advanced Addons
- Prototype Pollution detection
- Code Injection (PHP, Python, NodeJS)
- Browser-based XSS verification (Playwright headless)
- JavaScript Secret Hunting (API keys, tokens, credentials)
- 403 Bypass testing
- Subdomain Takeover check
- Race Condition testing
- WebSocket security test
- Password Spraying (login endpoints)
- Open Redirect chaining
- JWT Brute Force & None algorithm attack

### 📊 Reporting
- HTML Report with interactive charts (Chart.js)
- PDF Export (via WeasyPrint or Chromium)
- CVSS Scoring for all findings
- OWASP Top 10 2021 mapping
- Risk Breakdown (Critical, High, Medium, Low, Info)
- Remediation Recommendations per vulnerability
- Caido Integration — auto-send findings for manual testing

### ⚡ Smart Features
- Time Budget System — Max 6 hours with Turbo Mode
- Auto Resume — Continue from interrupted scans
- Smart Skip — Skip completed phases/tools
- Cloudflare Bypass mode
- False Positive Verification — Re-verify findings with OAST

---

## 📋 Requirements

### Operating System
- **Arch Linux** (Required)
- **Garuda Linux** (Recommended)
- Other Arch-based distros: Manjaro, EndeavourOS, Artix, BlackArch, CachyOS

> ⚠️ **Other Linux distributions are NOT supported** and may cause errors.

### Permissions
- **Root access** (`sudo`) required for full functionality

### Dependencies (Auto-installed)
```bash
tor proxychains-ng curl netcat macchanger
nmap masscan whatweb wafw00f wpscan nikto testssl.sh
subfinder amass assetfinder httpx dnsx gau waybackurls
hakrawler katana gospider paramspider arjun ffuf gobuster feroxbuster
dalfox kxss sqlmap nuclei msfconsole tplmap commix crlfuzz
theharvester shodan gitleaks s3scanner fierce dnsrecon gf cariddi
gowitness aquatone subjack subzy interactsh-client
python3 nodejs npm playwright
```

---

## 🛠️ Installation

### 1. Clone Repository
```bash
git clone https://github.com/Xyra77/Cassiopeia.git
cd Cassiopeia
```

### 2. Make Executable
```python
chmod +x launcher.py
```

### 3. Install System Dependencies
```bash
sudo pacman -S --noconfirm --needed base-devel git python python-pip nodejs npm
```

### 4. Install Python Dependencies
```bash
pip3 install requests cloudscraper playwright reportlab weasyprint
playwright install chromium
```

### 5. Run Cassiopeia
```python
python3 cassiopeia.py
```

---

## 📝 Usage

### Basic Scan
```bash
python3 cassiopeia.py
# Enter target URL when prompted
```

### Resume Interrupted Scan
```bash
python3 cassiopeia.py pentest_target.com_20250101_120000
```

### With Config File
```bash
# Edit config first
nano ~/.cassiopeia.conf

# Then run
python3 cassiopeia.py
```

### Target URL Format
```
https://target.com
https://www.target.com
http://subdomain.target.com
```

---

## 📁 Output Structure

```
pentest_target.com_YYYYMMDD_HHMMSS/
├── opsec/                  # Tor, ProxyChains, MAC spoof status
├── recon/                  # Subdomains, live hosts, WAF, fingerprints
├── osint/                  # OSINT data (theHarvester, Shodan, GitLeaks)
├── ports/                  # Nmap, Masscan, SSL/TLS results
├── params/                 # URLs, parameters, GF patterns
├── dirs/                   # Directory fuzzing results
├── xss/                    # XSS findings (Dalfox, KXSS, Browser)
├── sqli/                   # SQLMap output
├── ssrf/                   # SSRF candidates
├── lfi/                    # LFI / Path Traversal
├── ssti/                   # SSTI / XXE / RCE
├── cors/                   # CORS misconfiguration
├── smuggling/              # HTTP Smuggling
├── jwt/                    # JWT tokens & brute results
├── graphql/                # GraphQL endpoints & tests
├── vulns/                  # Nuclei findings
├── metasploit/             # Metasploit scan output
├── prototype_pollution/    # Prototype pollution findings
├── code_injection/         # PHP, Python, NodeJS injection
├── browser_xss/            # Headless browser XSS results
├── js_analysis/            # JavaScript secrets & sinks
├── auth/                   # 403 bypass, race condition, password spray
├── api/                    # API discovery & versioning
├── screenshots/            # Live host screenshots
├── report/                 # HTML & PDF reports
└── master_log.txt          # Full scan log
```

---

## ⚙️ Configuration

Edit `~/.cassiopeia.conf` to customize:

```bash
# Scan Settings
MAX_SCAN_SECONDS=21600        # 6 hours max
DEFAULT_TIMEOUT=30
MAX_THREADS=50

# Tor Settings
TOR_ENTRY_NODES=""
TOR_EXIT_NODES=""

# Tool Settings
SQLMAP_LEVEL=3
SQLMAP_RISK=2
NUCLEI_RATE_LIMIT=100
DALFOX_WORKERS=30
FFUF_THREADS=80

# Report Settings
GENERATE_PDF=1
AUTO_OPEN_REPORT=0

# Caido Integration
CAIDO_PROXY_PORT=8080
CAIDO_GUI_PORT=7777
CAIDO_AUTO_SEND=1
```

---

## 📊 Report Sample

The HTML report includes:
- Severity Summary Cards (Critical, High, Medium, Low, Info)
- Risk Distribution Donut Chart
- Vulnerability Type Breakdown
- OWASP Top 10 2021 Mapping
- CVSS Score Distribution
- Detailed Findings per Category
- Remediation Recommendations
- Manual Verification Checklist
- Caido Integration Buttons

---

## 🔗 Caido Integration

Cassiopeia automatically sends all discovered URLs and verified findings to **Caido Proxy** for manual testing:

1. All URLs replayed through Caido proxy (127.0.0.1:8080)
2. Verified findings tagged with `X-Cassiopeia-Source: verified-finding`
3. Caido GUI auto-opens at `http://127.0.0.1:7777`
4. Filter by priority in Caido History tab

---

## ⚠️ Warnings

| Warning | Description |
|---------|-------------|
| 🔴 **Legal** | Only use on systems you own or have written permission to test |
| 🔴 **Network** | This tool generates significant network traffic |
| 🔴 **Detection** | Scans may trigger IDS/IPS/WAF alerts |
| 🔴 **Stability** | Aggressive scanning may cause service disruption |
| 🔴 **Privacy** | Do not share scan results containing sensitive data |

---

## 🛡️ Responsible Use

1. **Get Written Permission** — Always obtain explicit authorization before testing
2. **Define Scope** — Clearly document which systems are in scope
3. **Report Findings** — Provide detailed reports to system owners
4. **Disclose Responsibly** — Follow responsible disclosure practices
5. **Comply with Laws** — Understand local cybersecurity laws (UU ITE, CFAA, etc.)

---

## 📄 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.

```
MIT License

Copyright (c) 2025 Xyra77

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

## 📞 Support

- **Issues:** Open an issue on GitHub
- **Updates:** Check repository for latest version
- **Community:** For educational discussion only

---

## 🙏 Acknowledgments

Thanks to all open-source tool developers whose projects are integrated into Cassiopeia:
- ProjectDiscovery (Nuclei, Subfinder)
- SQLMap Team
- Metasploit Framework
- OWASP Foundation
- And many more...

---

## 📌 Version History

| Version | Date | Changes |
|---------|------|---------|
| 4.0.0 | 2026 March    | Full rewrite, 15 phases, Caido integration, HTML/PDF report |
| 3.0.0 | 2025 Desember | Added browser XSS, prototype pollution, race condition |
| 2.0.0 | 2025 November | Added Nuclei, Metasploit automation |
| 1.0.0 | 2025 June     | Initial release |

---

> **⚠️ REMEMBER: With great power comes great responsibility. Use Cassiopeia ethically and legally.**

---

**Developer:** Xyra77  
**Last Updated:** 2026  
**Status:** Active Development
