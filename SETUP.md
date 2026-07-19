# Setup: Cassiopeia Signed Launcher

## Kenapa ini beda dari obfuscation biasa

`cassiopeia.py` (launcher) sekarang **menolak menjalankan** `cassiopeia.sh`
kalau isinya berubah sedikit pun dari yang kamu sign. Ini beda total dari
sekadar "encode" -- obfuscation cuma nyusahin baca, ini nyegah eksekusi
kalau ada modifikasi.

Yang bikin ini aman: **public key ditanam di `cassiopeia.py` yang kamu
distribusikan/simpan sendiri**, bukan didownload ulang tiap run. Jadi
kalau GitHub repo kamu suatu saat di-compromise dan attacker ganti
`cassiopeia.sh.enc` + `cassiopeia.sh.enc.sig` dengan versi jahat yang
di-sign pakai key attacker sendiri -- launcher tetap nolak, karena cuma
percaya SATU public key yang sudah ditanam sejak awal.

**Implikasi penting:** `cassiopeia.py` sendiri JANGAN auto-update dari
GitHub (makanya launcher versi ini sengaja gak download ulang dirinya
sendiri). Kalau launcher-nya sendiri yang diganti attacker, public key
di dalamnya juga bisa diganti -- makanya distribusikan `cassiopeia.py`
lewat jalur yang kamu percaya (misal user download manual sekali, bukan
auto-pull tiap saat).

## Langkah setup (sekali di awal)

### 1. Generate GPG keypair (kalau belum punya)
```bash
gpg --full-generate-key
# Pilih: (9) ECC (sign and encrypt) -> Curve 25519 -> gak expire (0) juga oke
# Isi nama & email (bebas, contoh: "Xyra77 <you@example.com>")
```

Cek key ID kamu:
```bash
gpg --list-keys
```

### 2. Export public key, tempel ke launcher
```bash
gpg --armor --export "you@example.com" > pubkey.asc
cat pubkey.asc
```
Copy isi `pubkey.asc` (termasuk baris `-----BEGIN/END PGP PUBLIC KEY BLOCK-----`),
tempel menggantikan placeholder `EMBEDDED_PUBKEY` di `cassiopeia.py`.

### 3. Encode + sign cassiopeia.sh (tiap kali ada update)
```bash
python3 tools/encode_and_sign.py cassiopeia.sh --key "you@example.com"
```
Ini menghasilkan:
- `cassiopeia.sh.enc`      (obfuscated, aman diupload publik)
- `cassiopeia.sh.enc.sig`  (signature, aman diupload publik)

### 4. Upload ke GitHub
Upload **`cassiopeia.sh.enc`** dan **`cassiopeia.sh.enc.sig`** ke repo.
**JANGAN** upload `cassiopeia.sh` plaintext lagi ke repo publik --
kalau plaintext-nya ada di repo, orang bisa liat isi aslinya langsung,
gak perlu tunggu launcher decode.

Simpan `cassiopeia.sh` plaintext (source of truth) di tempat privat kamu
sendiri (laptop/private repo), bukan di repo publik.

### 5. Jaga private key kamu
Private GPG key **jangan pernah** ke-commit/ke-upload kemanapun. Kalau
private key bocor, siapapun bisa sign ulang script jahat dan launcher
bakal nganggep valid.

## Cara user pakai (gak berubah)
```bash
sudo python3 cassiopeia.py
```
Launcher otomatis: cari file lokal -> kalau gak ada, download dari
GitHub -> verifikasi signature -> kalau valid, decode & jalanin.
Kalau signature invalid, langsung exit dengan pesan error, TIDAK ada
kode yang dieksekusi.

## Testing sebelum rilis (opsional tapi disarankan)
```bash
# Harus BERHASIL jalan:
sudo python3 cassiopeia.py

# Coba tamper 1 byte terus jalanin lagi -- HARUS ditolak:
python3 -c "
d = bytearray(open('cassiopeia.sh.enc','rb').read())
d[1000] ^= 0xFF
open('cassiopeia.sh.enc.tampered','wb').write(d)
"
cp cassiopeia.sh.enc cassiopeia.sh.enc.bak
cp cassiopeia.sh.enc.tampered cassiopeia.sh.enc
sudo python3 cassiopeia.py    # harus print "SIGNATURE TIDAK VALID"
mv cassiopeia.sh.enc.bak cassiopeia.sh.enc
rm cassiopeia.sh.enc.tampered
```
