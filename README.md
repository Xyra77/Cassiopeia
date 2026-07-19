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
**Distribution:** Signed launcher (GPG-verified, tamper-proof execution)

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
- Addon B — Code Injection (PHP, Python, NodeJS)
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
- Auto-install missing tools via native package repos, with `go install` / `pipx` / `cargo` / `git clone` fallbacks
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

### Launcher Requirements
- **Python 3** (runs `cassiopeia.py`)
- **GPG** (`gnupg`) available on `PATH` — used by the launcher to verify the script signature before execution

### Dependencies (auto-installed on first run)
```
nmap masscan whatweb wafw00f wpscan nikto testssl.sh curl
subfinder amass assetfinder httpx dnsx gau waybackurls hakrawler
katana gospider paramspider arjun ffuf gobuster feroxbuster
dalfox kxss sqlmap nuclei msfconsole smuggler tplmap
commix crlfuzz theharvester shodan gitleaks s3scanner fierce
dnsrecon gf
```
Tools not available via `pacman`/`apt` are fetched automatically through `go install`, `pipx`, `cargo`, or `git clone`, depending on the tool.

### How Dependency Installation Works
No manual dependency setup is needed — everything happens automatically on first run:

1. Run `sudo python3 cassiopeia.py` (root required)
2. The launcher verifies the signature, decodes `cassiopeia.sh`, and hands off execution to it
3. `cassiopeia.sh` runs `detect_os()` to pick the right package manager (`pacman` for Arch-based, `apt` for Debian-based)
4. It checks every tool in `TOOLS_LIST` against what's already installed, and for anything missing:
   - Installs it from the distro's official repo (`pacman`/`apt`) if available there
   - Otherwise falls back to `go install`, `pipx install`, `cargo install`, or `git clone`, per-tool, as defined in the script's tool manifest
5. Once all tools are resolved, the OPSEC and pentest phases begin

If you'd rather pre-install everything yourself before running Cassiopeia, install the tool list above via your distro's package manager plus `go`, `pipx`, and `cargo` for whatever isn't packaged natively.

---

## 🔒 Signed Launcher — How Distribution Works

Cassiopeia ships as a **signed, encoded artifact**, not a plaintext script:

| File | Purpose |
|------|---------|
| `cassiopeia.py` | Launcher. Has a GPG public key embedded at build time. Locates/downloads `cassiopeia.sh.enc` + `cassiopeia.sh.enc.sig`, verifies the signature against the embedded key, and only then decodes and executes the script. |
| `cassiopeia.sh.enc` | The obfuscated/encoded pentest script — safe to publish. |
| `cassiopeia.sh.enc.sig` | Detached GPG signature for the `.enc` file. |
| `pubkey.asc` | The maintainer's public key (same one embedded in `cassiopeia.py`), published for reference/verification. |
| `cassiopeia.sh` | Plaintext source of truth. **Not published** — kept private by the maintainer, only distributed as `.enc`/`.sig`. |
| `encode_and_sign.py` | Maintainer-only tool: encodes + signs `cassiopeia.sh` to produce the `.enc`/`.sig` pair after each update. |

**Why this matters:** if the GitHub repo is ever compromised and an attacker swaps in a malicious `.enc`/`.sig` pair signed with their own key, the launcher still refuses to run it — it only trusts the single public key embedded in `cassiopeia.py` at distribution time, not whatever key shows up in the repo. Because of this, `cassiopeia.py` itself is **not auto-updated** from GitHub; get it once through a channel you trust rather than re-pulling it on every run.

If signature verification fails, the launcher exits immediately with an error — no pentest code is ever executed. See [`SETUP.md`](SETUP.md) for the full maintainer setup/signing workflow and a tamper-test procedure.

---

## 🛠️ Installation

### 1. Clone Repository
```bash
git clone https://github.com/Xyra77/Cassiopeia.git
cd Cassiopeia
```

### 2. Run the Launcher
```bash
sudo python3 cassiopeia.py
```
The launcher looks for `cassiopeia.sh.enc` locally, downloads it from GitHub if missing, verifies its signature against the embedded public key, then decodes and runs it. On first successful run, Cassiopeia detects your OS/package manager, checks the tool list, and auto-installs anything missing before starting the OPSEC and pentest sections.

> Advanced/offline use: if you already hold the plaintext `cassiopeia.sh` yourself, it can also be run directly with `sudo bash cassiopeia.sh` — this skips signature verification, so only do this with a copy you trust.

---

## 📝 Usage

### Basic Scan
```bash
sudo python3 cassiopeia.py
```

### Resume an Interrupted Scan
```bash
sudo python3 cassiopeia.py pentest_target.com_20260101_120000
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
├── code_injection/          # PHP, Python, NodeJS injection
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

## 🔧 Maintainer: Releasing an Update

Only relevant if you're Xyra77 pushing a new version, not for end users.

```bash
# After editing the private cassiopeia.sh:
python3 encode_and_sign.py cassiopeia.sh --key "your-gpg-key-email"
# -> produces cassiopeia.sh.enc + cassiopeia.sh.enc.sig
```
Upload only `cassiopeia.sh.enc` and `cassiopeia.sh.enc.sig` to the repo. Never commit plaintext `cassiopeia.sh`, and never commit the private GPG key. Full setup, key generation, and a tamper-test procedure are in [`SETUP.md`](SETUP.md).

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
