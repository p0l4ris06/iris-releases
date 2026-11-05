# IRIS

IRIS keeps a searchable memory of your notes and conversations on your own computer. This page is where you download it.

**Get it:** open [Releases](https://github.com/p0l4ris06/iris-releases/releases) and choose the newest version. Under **Assets**, download the file for your computer:

| Your computer | File |
| --- | --- |
| Windows 10 or 11 (64-bit) | `IRIS-Setup-<version>.exe` |
| Mac with Apple Silicon (M1 or later) | `IRIS-<version>-macos-arm64.dmg` |
| Linux (64-bit Intel or AMD), any distribution | `IRIS-<version>-linux-x86_64.AppImage` |
| Linux, Debian or Ubuntu | `iris_<version>_amd64.deb` |

Also download `SHA256SUMS` if you want to check your download (see [Check your download](#check-your-download)).

IRIS is in testing (beta). Macs with an Intel processor and Linux on ARM are not supported yet.

## Install

IRIS is not yet signed with a Microsoft or Apple developer certificate. Your computer will warn you the first time you open it. The steps below show how to continue. Each one works with the keyboard alone, and there is a terminal alternative where one exists.

### Windows

1. Open the downloaded `IRIS-Setup-<version>.exe`. In File Explorer, select it and press Enter.
2. Windows SmartScreen may say "Windows protected your PC". Choose **More info**, then **Run anyway**. With the keyboard: press Tab until "More info" is selected and press Enter, then Tab to **Run anyway** and press Enter.
3. Follow the installer. It installs for your user account only and does not ask for administrator rights. IRIS then appears in the Start menu.

Terminal alternative (PowerShell, in the folder with the download). This removes the "downloaded from the internet" mark, so SmartScreen does not ask, then starts the installer:

```powershell
Unblock-File .\IRIS-Setup-<version>.exe
.\IRIS-Setup-<version>.exe
```

### macOS (Apple Silicon)

1. Open the downloaded `.dmg` and drag **IRIS** into **Applications**. With the keyboard: in Finder, select IRIS, press ⌘C, open Applications (⌘⇧A) and press ⌘V.
2. Open IRIS from Applications. macOS will say it cannot check IRIS for malicious software; choose **Done** (not "Move to Bin").
3. Open **System Settings → Privacy & Security**. Near the bottom, next to the message about IRIS, choose **Open Anyway**, then confirm with your password or Touch ID. IRIS opens. From then on it opens normally.

With the keyboard: open System Settings with ⌘Space, type "Privacy" and press Return. If Tab only moves between text fields, turn on **System Settings → Keyboard → Keyboard navigation** first.

Terminal alternative (Terminal app). This removes the quarantine mark that causes the warning:

```sh
xattr -dr com.apple.quarantine /Applications/IRIS.app
open /Applications/IRIS.app
```

### Linux

**AppImage** (any distribution): make the file executable, then run it.

```sh
chmod +x IRIS-<version>-linux-x86_64.AppImage
./IRIS-<version>-linux-x86_64.AppImage
```

In a file manager you can instead open the file's Properties and turn on "Allow executing file as program". On Ubuntu 22.04 and newer, and other recent distributions, AppImages need the FUSE 2 library. Install it once:

```sh
sudo apt install libfuse2        # Ubuntu 22.04, Debian 12
sudo apt install libfuse2t64     # Ubuntu 24.04 and newer
```

**Debian or Ubuntu package**:

```sh
sudo apt install ./iris_<version>_amd64.deb
```

IRIS then appears in your applications menu, or start it with `iris`.

## Check your download

Each release has a file called `SHA256SUMS` with a checksum for every download. If your file's checksum matches, it is exactly the file we built. Put `SHA256SUMS` in the same folder as your download, then:

**Windows** (PowerShell in that folder):

```powershell
Get-FileHash .\IRIS-Setup-<version>.exe -Algorithm SHA256
Select-String -Path .\SHA256SUMS -Pattern "IRIS-Setup-<version>.exe"
```

The two long codes must be the same; `Get-FileHash` prints capital letters and `SHA256SUMS` lower-case, which does not matter. Without PowerShell: `certutil -hashfile IRIS-Setup-<version>.exe SHA256`.

**macOS** (Terminal in that folder):

```sh
shasum -a 256 -c SHA256SUMS --ignore-missing
```

**Linux**:

```sh
sha256sum -c SHA256SUMS --ignore-missing
```

On macOS and Linux, "OK" after your file's name means it matches. "FAILED" means it does not: do not install it. Download it again, and tell us if it still fails.

## Updates

IRIS does not update itself. To see whether there is a newer version, choose **Help → Check for updates…** (with the keyboard: Alt+H on Windows and Linux, then the underlined letter). If there is one, download it from this page and install it over the old one. Your memory is kept.

## Uninstall

- **Windows**: Settings → Apps → Installed apps → IRIS → Uninstall.
- **macOS**: drag IRIS from Applications to the Bin.
- **Linux**: delete the AppImage. For the package, find its name with `apt list --installed 2>/dev/null | grep -i iris`, then `sudo apt remove <that name>`.

Uninstalling keeps your memory. To delete it too, delete the memory folder yourself afterwards. **That cannot be undone.**

| | Memory folder |
| --- | --- |
| Windows | `%APPDATA%\IRIS` |
| macOS | `~/Library/Application Support/IRIS` |
| Linux | `~/.local/share/IRIS` |

Do not run the Windows uninstaller with the `--delete-app-data` option unless you want to delete your memory. That option removes `%APPDATA%\IRIS`.

## Privacy

- **Your memory stays on your computer.** IRIS has no account and sends no usage or crash data.
- **IRIS only goes online when you choose Help → Check for updates….** That sends one request to GitHub for the list of IRIS releases, and nothing about you or your memory. IRIS never checks in the background.
- **If you connect IRIS to Claude** (Help → Connect to Claude…), Claude can search your memory. Whatever Claude reads from it is sent to Anthropic under your own Claude account, like anything else you share in a conversation. Connecting is read-only unless you choose the variant that also lets Claude save notes. IRIS never changes your Claude settings: you copy the setting and add it yourself.

## Known limits

- Not signed with a developer certificate (see [Install](#install)).
- No automatic updates.
- No build yet for Macs with an Intel processor, or for Linux on ARM.
- Reviewing and approving items is not in this version.

## Accessibility and other problems

We aim for IRIS to meet WCAG 2.2 AA. If anything does not work with your screen reader, keyboard, zoom or contrast settings, please [open an issue](https://github.com/p0l4ris06/iris-releases/issues/new). Say what you use (for example NVDA with Firefox, VoiceOver, or keyboard only), what you tried and what happened. Accessibility reports are handled first.

For any problem, Help → About IRIS → **Copy these details** puts the version information on the clipboard, and Help → **Copy diagnostics** adds a log, so you can paste them into the issue. Check the diagnostics before posting: they include folder names from your computer.
