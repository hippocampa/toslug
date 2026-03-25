
# toslug

`toslug` a CLI tool to convert text to slug[^1].

Lihat `readme.md` bahasa Indonesia [here](../readme.md)

## Usage

```
toslug

usage:
toslug <text> <flags>

flags:
-u      Use hyphen separator. (default)
-U      Use underscore separator.
-h      Show help
```

## Examples

```sh
toslug "Hello world"

//Output : hello-world
```

```sh
toslug "Hello world" -U

//Output: hello_world
```

```sh
toslug "Hello       world 123#!" -u

//Output: hello-world
```

## Notes

* Currently,`toslug` is _case agnostic_ i.e. it produces lower-case output text.
* Currently, `toslug` is not supporting Unicode[^2].

## Installation

### Linux (Bash)

This script will download latest library and move it to `/usr/local/bin`.

```sh
REPO="hippocampa/toslug"; APP="toslug"; \
set -e; \
VERSION=$(curl -fsSL https://api.github.com/repos/$REPO/releases/latest | grep tag_name | cut -d '"' -f4 | sed 's/^v//') && \
URL="https://github.com/$REPO/releases/download/v$VERSION/${APP}-${VERSION}-linux" && \
echo "Installing $APP v$VERSION..." && \
curl -fL "$URL" -o "$APP" && \
chmod +x "$APP" && \
sudo mv "$APP" /usr/local/bin/ && \
echo "Done. Run '$APP'"
```

### Windows (PowerShell)

This script will create `bin` folder in User directory, and add it to `PATH` permanently (if not registered yet), and download the `.exe` file.

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
Write-Host "Done! Please restart your Terminal/VS Code." -ForegroundColor Green
```

---
[^1]: A slug is text without spaces, typically using hyphens (-) to separate words, making it simpler for page names or titles.
[^2]: <https://home.unicode.org/>
