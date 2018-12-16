# Make KaiOS Install

Command-line tools to install packaged and hosted apps using the KaiOS remote debugging protocols.

## How it works

1. `Makefile`: *(Packaged app only)* Package all files from folder into `application.zip`
2. `Makefile`: Move important files to phone via `adb`
3. `Makefile`: Forward remote debugging port (6000) from device to computer (via `adb`)
4. `Makefile`: Run `install.js` via `xpcshell`
5. `install.js`: Remotely install app from folder using the [Webapp Actor](http://mxr.mozilla.org/mozilla-central/source/b2g/chrome/content/dbg-webapps-actors.js).

The script infers the app id, which is required for the install script, from the last folder in the app path. Optionally it can be provided in the command line via `ID=`. The id should to be lower case.

## Dependencies

1. `make` installed on your system.

- On Mac: run `xcode-select --install`. Then follow the on-screen prompts.

- On Linux: Should be preinstalled. If not, follow your distribution's instructions.

2. Extract the following packages to `~/bin`.

If you choose a different path, change the variables in `Makefile`):

	XPCSHELL = ~/bin/xulrunner-sdk/bin/xpcshell
	ADB = ~/bin/android-sdk/platform-tools/adb

### XULRunner (contains XPCShell command)

Download XULRunner from [Mozilla](http://ftp.mozilla.org/pub/mozilla.org/xulrunner/releases/18.0.2/sdk/).

### Android SDK (contains ADB command)

Download adb from [XDADevelopers](https://www.xda-developers.com/install-adb-windows-macos-linux/).

### Enable Debugging on Device

While on the home screen, type `*#*#33284#*#*` to enable debug mode. A bug icon should appear on the status bar.

## Usage

### Packaged

Your app should at least have an `index.html` and a `manifest.webapp` with the correct `launch_path`. App `type` can be `web`, `privileged` or `certified`.

From folder:

	make FOLDER=/some/folder packaged install

From another folder, setting app id (recommended if the folder name is not useful as unique app id):

	make FOLDER=/some/folder ID=some-id packaged install

### Hosted

Your folder only needs to contain `manifest.webapp` and a `metadata.json`. In most cases you only need to adapt `origin` in `metadata.json` and `launch_path` in the manifest.

Install hosted app from folder `my-hosted`:

	make FOLDER=/some/app hosted install

## Thanks

To [Fabrice](https://github.com/fabricedesre) for `install.js`, its remote debugging counterpart and for always fixing broken things.
