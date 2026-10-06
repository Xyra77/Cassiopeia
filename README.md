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

**Cassiopeia** is an all-in-one automated Bash penetration testing framework (~4,000+ lines) that runs the full assessment pipeline — **OPSEC → Recon/Pentest → Advanced Addons → Report → Caido handoff** — in a single script, with **40+ integrated tools** across **15+ phases** plus a set of advanced addon modules.

```
 ██████╗ █████╗ ███████╗███████╗██╗ ██████╗ ██████╗ ███████╗██╗ █████╗
██╔════╝██╔══██╗██╔════╝██╔════╝██║██╔═══██╗██╔══██╗██╔════╝██║██╔══██╗
██║     ███████║███████╗███████╗██║██║   ██║██████╔╝█████╗  ██║███████║
██║     ██╔══██║╚════██║╚════██║██║██║   ██║██╔═══╝ ██╔══╝  ██║██╔══██║
╚██████╗██║  ██║███████║███████║██║╚██████╔╝██║     ███████╗██║██║  ██║
 ╚═════╝╚═╝  ╚═╝╚══════╝╚══════╝╚═╝ ╚═════╝ ╚═╝     ╚══════╝╚═╝╚═╝  ╚═╝
```

**Version:** 4.0.0
**Developer:** [Xyra77](https://github.com/Xyra77)
**Repository:** [github.com/Xyra77/Cassiopeia](https://github.com/Xyra77/Cassiopeia.git)
**Platform:** Arch-based Linux (primary) + Debian-based Linux (auto-detected)
**License:** MIT License
**Distribution:** Direct Bash execution

---

## 🚀 Features

### 🔐 OPSEC & Anonymity (Section 1)
- Tor + ProxyChains automatic configuration
- MAC address spoofing
- Real IP masking / IP-via-Tor verification

### 🔍 Main Pentest — 15 Phases, 40+ Tools (Section 2)
| Phase | Description |
|-------|-------------|
| Phase 1 | OSINT & Passive Recon (theHarvester, Shodan, GitLeaks) |
| Phase 2 | Subdomain Enumeration (Subfinder, Amass, Assetfinder) |
| Phase 3 | Port & Service Scanning (Masscan, Nmap, testssl.sh) |
| Phase 4 | Fingerprinting & WAF Detection (WhatWeb, WAFW00F) |
| Phase 5 | URL & Parameter Discovery (GAU, Katana, Gospider, Arjun) |
| Phase 6 | Directory & File Fuzzing (FFUF, Gobuster, Feroxbuster, Nikto) |
| Phase 7 | XSS Hunting (Dalfox, KXSS) |
| Phase 8 | SQL Injection (SQLMap automated) |
| Phase 9 | SSRF Detection |
| Phase 10 | LFI / Path Traversal |
| Phase 11 | SSTI / XXE / RCE |
| Phase 12 | CORS / HTTP Smuggling / JWT |
| Phase 13 | GraphQL & API Discovery |
| Phase 14 | Nuclei Ultra Scan |
| Phase 15 | Metasploit Automation |

### 🧩 Advanced Pentest Addons (Section 3)
- Addon A — Prototype Pollution detection
- Addon B — Code Injection (PHP, NodeJS)
- Addon C — Real Browser XSS verification (headless Playwright)
- Addon D — JavaScript Secret Hunting (API keys, tokens, credentials)
- Addon F — CVE Correlation
- Upgrade P1 — Anti False-Positive Verification (OAST re-check)
- Upgrade P2 — Coverage Enhancements: live-host screenshots, subdomain takeover check, 403 bypass testing, API discovery, parameter mining from JS
- Upgrade P6 — Race Condition + WebSocket security + Password Spraying

### 📊 Reporting (Section 4)
- Self-contained HTML report with interactive charts
- PDF export (WeasyPrint → Chromium/Chrome headless fallback)
- Full audit trail via `master_log.txt`

### 🔗 Caido Integration
- Auto-detects a running Caido instance (`127.0.0.1:8080`) and offers to start it
- Replays all discovered URLs through the Caido proxy for manual testing
- Sends verified findings (XSS, LFI, SSRF, 403 bypass, API endpoints) tagged `X-Cassiopeia-Source: verified-finding`
- Auto-opens the Caido GUI (`http://127.0.0.1:7777`)

### ⚡ Smart Features
- Auto OS detection (Arch-based vs Debian-based) with matching package manager (`pacman` / `apt`)
- Auto-install missing tools via native package repos, with `go install` / `cargo` / `git clone` fallbacks
- Resume mode — continue an interrupted scan from its existing output directory
- Colorized, phased console output with per-phase notifications

---

## 📋 Requirements

### Operating System
- **Arch-based**: Arch, Garuda, Manjaro, EndeavourOS, Artix, BlackArch, CachyOS, Archcraft, ArcoLinux
- **Debian-based**: Debian, Ubuntu, Kali, Parrot, Linux Mint, Pop!_OS, Raspbian, Zorin, Neon
- OS family is auto-detected via `/etc/os-release`; unsupported OSes get a warning prompt before continuing

### Permissions
- **Root access** (`sudo`) required for full functionality

### Runtime Requirements
- **Bash**
- **sudo** for privileged operations
- Standard Unix utilities required by the integrated tools

### Dependencies (auto-installed on first run)
```
nmap masscan whatweb wafw00f wpscan nikto testssl.sh curl
subfinder amass assetfinder httpx dnsx gau waybackurls hakrawler
katana gospider paramspider arjun ffuf gobuster feroxbuster
dalfox kxss sqlmap nuclei msfconsole smuggler tplmap
commix crlfuzz theharvester shodan gitleaks s3scanner fierce
dnsrecon gf
```
Tools not available via `pacman`/`apt` are fetched automatically through `go install`, `cargo`, or `git clone`, depending on the tool.

### How Dependency Installation Works


On first run:

1. Run `sudo bash cassiopeia.sh`.
2. `cassiopeia.sh` detects the operating-system family through `/etc/os-release`.
3. It selects `pacman` for Arch-based systems or `apt` for Debian-based systems.
4. It checks the configured tool list against the local system.
6. Once dependencies are available, the OPSEC and pentest phases begin.

If you'd rather pre-install everything yourself, install the required tools
through your distribution's package manager and the supported native/upstream
installation methods.

---

## ▶️ Direct Bash Execution


| File | Purpose |
|------|---------|
| `cassiopeia.sh` | Main Cassiopeia runtime and entry point |

The official runtime command is:

```bash
sudo bash cassiopeia.sh
```

Cassiopeia executes its phases directly from `cassiopeia.sh`, including OS
detection, dependency checks, reconnaissance, scanning, validation, reporting,
and optional Caido integration.

------|---------|



---

## 🛠️ Installation

### 1. Clone Repository
```bash
git clone https://github.com/Xyra77/Cassiopeia.git
cd Cassiopeia
```

### 2. Run the Launcher
```bash
sudo bash cassiopeia.sh
```
Cassiopeia executes directly from `cassiopeia.sh`. On startup it detects the
OS/package manager, checks the tool list, and auto-installs missing
dependencies before starting the OPSEC and pentest sections.

---

## 📝 Usage

### Basic Scan
```bash
sudo bash cassiopeia.sh
```

### Resume an Interrupted Scan
```bash
sudo bash cassiopeia.sh pentest_target.com_20260101_120000
```
Pass the existing output directory as the first argument — Cassiopeia reads the target URL and last completed phase from `master_log.txt` inside it and picks up where it left off.

---

## 📁 Output Structure

```
pentest_target.com_YYYYMMDD_HHMMSS/
├── recon/                   # Subdomains, live hosts, WAF, fingerprints
├── osint/                   # OSINT data (theHarvester, Shodan, GitLeaks)
├── ports/                   # Nmap, Masscan, SSL/TLS results
├── params/                  # URLs, parameters, GF patterns
├── dirs/                    # Directory/file fuzzing results
├── xss/                     # XSS findings (Dalfox, KXSS, browser-verified)
├── sqli/                    # SQLMap output
├── ssrf/                    # SSRF candidates
├── lfi/                     # LFI / path traversal
├── ssti/                    # SSTI / XXE / RCE
├── cors/                    # CORS misconfiguration
├── jwt/                     # JWT tokens & brute-force results
├── graphql/                 # GraphQL endpoints & tests
├── vulns/                   # Nuclei findings
├── metasploit/              # Metasploit scan output
├── prototype_pollution/     # Prototype pollution findings
├── browser_xss/             # Headless browser XSS results
├── js_analysis/             # JavaScript secrets & sinks
├── auth/                    # 403 bypass, race condition, password spray
├── api/                     # API discovery & versioning
├── screenshots/             # Live host screenshots
├── report/                  # HTML & PDF reports
└── master_log.txt           # Full scan log (also used for resume)
```

---

## 🔗 Caido Integration Details

1. Cassiopeia checks for a running Caido instance at `127.0.0.1:8080` and offers to start it if not found
2. All discovered URLs are replayed through the Caido proxy for manual review
3. Verified findings (XSS, LFI, SSRF, 403 bypass, API endpoints) are sent with header `X-Cassiopeia-Source: verified-finding`
4. Caido GUI auto-opens at `http://127.0.0.1:7777`
5. Filter by `X-Cassiopeia-Source: verified-finding` in the Caido History tab for priority findings

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

---

## 📄 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.

---

## 📞 Support

- **Repository:** [github.com/Xyra77/Cassiopeia](https://github.com/Xyra77/Cassiopeia.git)
- **Community:** For educational discussion only

---

## 🙏 Acknowledgments

Thanks to all open-source tool developers whose projects are integrated into Cassiopeia — ProjectDiscovery (Nuclei, Subfinder, Httpx, Katana...), SQLMap, Metasploit, OWASP, and the many others behind the 40+ tools this framework orchestrates.

---

> **⚠️ REMEMBER: With great power comes great responsibility. Use Cassiopeia ethically and legally.**

---

**Developer:** Xyra77
**Status:** Cyber Security Enthusiast
