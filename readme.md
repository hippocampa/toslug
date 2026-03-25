# toslug

`toslug` alat CLI untuk mengubah teks jadi _slug_[^1].

View english `readme.md` [here](docs/readme-eng.md)

## Cara pakai

```
toslug

usage:
toslug <text> <flags>

flags:
-u      Use hyphen separator. (default)
-U      Use underscore separator.
-h      Show help
```

## Contoh

```sh
toslug "Hello world" -u

//akan menghasilkan : hello-world
```

```sh
toslug "Hello world" -U

//akan menghasilkan : hello_world
```

```sh
toslug "Hello       world 123#!" -u

//akan menghasilkan : hello-world
```

## Catatan

* Saat ini `toslug` bersifat _case agnostic_ alias hasilnya huruf kecil semua.
* Saat ini `toslug` **belum** mendukung unicode[^2].

## Instalasi

### Linux (Bash)

Skrip ini akan mengunduh binary terbaru dan memindahkannya ke `/usr/local/bin`.

```sh
REPO="hippocampa/toslug"; APP="toslug"; \
set -e; \
VERSION=$(curl -fsSL https://api.github.com/repos/$REPO/releases/latest | grep tag_name | cut -d '"' -f4 | sed 's/^v//') && \
URL="https://github.com/$REPO/releases/download/v$VERSION/${APP}-${VERSION}-linux" && \
echo "Installing $APP v$VERSION..." && \
curl -fL "$URL" -o "$APP" && \
chmod +x "$APP" && \
sudo mv "$APP" /usr/local/bin/ && \
echo "Done. Coba jalankan '$APP --version'"
```

### Windows (PowerShell)

Skrip ini akan membuat folder `bin` di direktori User, menambahkannya ke `PATH` secara permanen (jika belum ada), dan mengunduh file `.exe`.

```powershell
$REPO="hippocampa/toslug"; $APP="toslug"; `
$binDir="$env:USERPROFILE\bin"; `
if (!(Test-Path $binDir)) { New-Item -Path $binDir -ItemType Directory | Out-Null }; `
$oldPath = [Environment]::GetEnvironmentVariable("Path", "User"); `
if ($oldPath -notlike "*$binDir*") { [Environment]::SetEnvironmentVariable("Path", "$oldPath;$binDir", "User") }; `
$v=(Invoke-RestMethod "https://api.github.com/repos/$REPO/releases/latest").tag_name.TrimStart('v'); `
$URL="https://github.com/$REPO/releases/download/v$v/$APP-$v-windows.exe"; `
Write-Host "Installing $APP v$v to $binDir..." -ForegroundColor Cyan; `
Invoke-WebRequest -Uri $URL -OutFile "$binDir\$APP.exe"; `
Write-Host "Done! Silakan restart Terminal/VS Code Anda agar PATH diperbarui." -ForegroundColor Green
```

---
[^1]: slug itu teks tanpa spasi, biasanya pakai tanda hubung (-) buat misahin kata, jadi lebih simpel buat nama halaman atau judul
[^2]: <https://home.unicode.org/>
