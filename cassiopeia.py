#!/usr/bin/env python3
"""
Cassiopeia Launcher (v2 -- signed & verified)

- Cari cassiopeia.sh.enc + cassiopeia.sh.enc.sig lokal
- Kalau gak ada / ada versi baru di GitHub -> download keduanya
- Verifikasi signature GPG pakai public key yang di-embed di bawah
  (bukan public key yang didownload -- itu kunci: attacker yang
  compromise repo GitHub TETAP GAK BISA bikin signature valid,
  karena private key gak pernah ada di repo/server manapun)
- Kalau signature valid -> decode di memory -> jalanin via bash
- Kalau signature invalid / gak ada -> REFUSE, gak dijalanin sama sekali
"""

import base64
import codecs
import hashlib
import os
import subprocess
import sys
import tempfile
import urllib.request
import zlib

if os.geteuid() != 0:
    print("[!] Must be run as root!")
    print(f"[>] sudo python3 {os.path.basename(__file__)}")
    sys.exit(1)

# ── CONFIG ────────────────────────────────────────────
GITHUB_USER = "Xyra77"
GITHUB_REPO = "Cassiopeia"
ENC_FILE    = "cassiopeia.sh.enc"
SIG_FILE    = "cassiopeia.sh.enc.sig"

RAW_ENC_URL = f"https://raw.githubusercontent.com/{GITHUB_USER}/{GITHUB_REPO}/main/{ENC_FILE}"
RAW_SIG_URL = f"https://raw.githubusercontent.com/{GITHUB_USER}/{GITHUB_REPO}/main/{SIG_FILE}"

XOR_KEY = bytes.fromhex("59656c696e4d7942696e69")

# ── EMBEDDED PUBLIC KEY ───────────────────────────────
# GANTI blok ini dengan hasil: gpg --armor --export YOUR_KEY_ID
# Ini yang bikin verifikasi "nyata" -- attacker yang cuma bisa nulis
# ke repo GitHub TIDAK bisa sign ulang tanpa private key kamu.
EMBEDDED_PUBKEY = """-----BEGIN PGP PUBLIC KEY BLOCK-----

mDMEalzXPRYJKwYBBAHaRw8BAQdA3pbOHFbwKHqZ1B2AqMQOUmuGnsGLkoJqNits
Q28Ewie0Ilh5cmE3NyA8eHlyYTc3Lm9mZmljaWFsQGdtYWlsLmNvbT6IkAQTFgoA
OBYhBDTkKx2PHxd20dKe+hizSkLGByzgBQJqXNc9AhsDBQsJCAcCBhUKCQgLAgQW
AgMBAh4BAheAAAoJEBizSkLGByzgT24BAJMynGf/PLRyWxbZ9jY1fEwVMxy4kR+p
ddnV9MBsMiJTAQDEICtWVF5rN8pz7JonEFHJNb1Tf58/POnR/AXz//LfCrg4BGpc
1z0SCisGAQQBl1UBBQEBB0D6nv1MQchpEvmGavLqjUIKcFlk4LLPS2cv9i2C5fgE
QwMBCAeIeAQYFgoAIBYhBDTkKx2PHxd20dKe+hizSkLGByzgBQJqXNc9AhsMAAoJ
EBizSkLGByzgNoYA/ipLXGpJ/7pzmpWKCWbRI+NrDJIIJEz6RTEzzjphW8IuAP9k
KKxJPp3JMAvT0onHD6fIdxaLl1avi0f4GTjn0vsiDA==
=muQJ

-----END PGP PUBLIC KEY BLOCK-----"""


def fetch_bytes(url: str, timeout=20) -> bytes:
    req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
    with urllib.request.urlopen(req, timeout=timeout) as r:
        return r.read()


def find_local(name: str):
    base = os.path.dirname(os.path.abspath(__file__))
    for d in (base, os.getcwd()):
        p = os.path.join(d, name)
        if os.path.isfile(p):
            return p
    return None


def verify_signature(enc_data: bytes, sig_data: bytes) -> bool:
    """Verify detached GPG signature pakai embedded public key SAJA
    (bukan key hasil download), pakai keyring temporer yang dibuang
    setelah selesai."""
    with tempfile.TemporaryDirectory() as gnupg_home:
        os.chmod(gnupg_home, 0o700)
        env = os.environ.copy()
        env["GNUPGHOME"] = gnupg_home

        r = subprocess.run(
            ["gpg", "--batch", "--import"],
            input=EMBEDDED_PUBKEY.encode(), env=env,
            capture_output=True
        )
        if r.returncode != 0:
            print("[X] Gagal import embedded public key -- launcher rusak/belum di-setup?")
            print(r.stderr.decode(errors="replace"))
            return False

        with tempfile.NamedTemporaryFile(suffix=".enc", delete=False) as ef:
            ef.write(enc_data)
            enc_path = ef.name
        with tempfile.NamedTemporaryFile(suffix=".sig", delete=False) as sf:
            sf.write(sig_data)
            sig_path = sf.name

        try:
            r = subprocess.run(
                ["gpg", "--batch", "--verify", sig_path, enc_path],
                env=env, capture_output=True
            )
            return r.returncode == 0
        finally:
            os.unlink(enc_path)
            os.unlink(sig_path)


def deobfuscate(data: bytes) -> str:
    unxored = bytes(b ^ XOR_KEY[i % len(XOR_KEY)] for i, b in enumerate(data))
    unrot = codecs.decode(unxored.decode('latin-1'), 'rot_13').encode('latin-1')
    unb64 = base64.b64decode(unrot)
    plain = zlib.decompress(unb64, -15)
    return plain.decode('utf-8')


def run_script_source(src: str, args: list) -> int:
    """Tulis ke file temp mode 0700 (bukan world-readable), jalanin,
    lalu hapus -- jadi plaintext gak nongkrong lama di disk."""
    fd, path = tempfile.mkstemp(suffix=".sh", prefix="cassiopeia-")
    try:
        os.write(fd, src.encode('utf-8'))
        os.close(fd)
        os.chmod(path, 0o700)
        print(f"[>] Signature valid -- menjalankan script terverifikasi...")
        return subprocess.run(["bash", path] + args).returncode
    finally:
        try:
            os.remove(path)
        except OSError:
            pass


def main():
    args = sys.argv[1:]
    local_enc = find_local(ENC_FILE)
    local_sig = find_local(SIG_FILE)

    print("╔══════════════════════════════════════╗")
    print("║      Cassiopeia Launcher (signed)    ║")
    print(f"║  github.com/{GITHUB_USER}/{GITHUB_REPO:<14}  ║")
    print("╚══════════════════════════════════════╝\n")

    if local_enc and local_sig:
        print(f"[+] Pakai file lokal: {local_enc}")
        with open(local_enc, "rb") as f:
            enc_data = f.read()
        with open(local_sig, "rb") as f:
            sig_data = f.read()
    else:
        print("[*] File lokal gak lengkap, download dari GitHub...")
        try:
            enc_data = fetch_bytes(RAW_ENC_URL)
            sig_data = fetch_bytes(RAW_SIG_URL)
        except Exception as e:
            print(f"[X] Gagal download: {e}")
            sys.exit(1)

    print("[*] Verifikasi signature GPG...")
    if not verify_signature(enc_data, sig_data):
        print("[X] SIGNATURE TIDAK VALID -- script DITOLAK.")
        print("    File ini mungkin sudah diubah/di-tamper dan BUKAN")
        print("    berasal dari maintainer resmi. Cassiopeia tidak akan")
        print("    dijalankan demi keamanan.")
        sys.exit(1)
    print(f"[+] Signature VALID (sha256 konten: {hashlib.sha256(enc_data).hexdigest()[:16]}...)")

    src = deobfuscate(enc_data)
    rc = run_script_source(src, args)
    sys.exit(rc)


if __name__ == "__main__":
    main()
