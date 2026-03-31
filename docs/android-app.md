# Building an Andorid App for this project

Config for JDK 21

```bash
flutter config --jdk-dir=/usr/lib/jvm/java-21-openjdk-amd64/
```

Then prepape the Android app:

```bash
flutter create --platforms=android .
```

You can find general documentation for Flutter at: <https://docs.flutter.dev/>
Detailed API documentation is available at: <https://api.flutter.dev/>
If you prefer video documentation, consider: <https://www.youtube.com/c/flutterdev>

```bash
# download android studio
sudo tar xvf android-studio-panda2-linux.tar.gz -C /opt/

# update path
export PATH=$PATH:/opt/android-studio/bin

# install commandline tools
mkdir -p ~/tmp/cmdline-tools/
unzip commandlinetools-linux-*.zip -d ~/tmp/cmdline-tools/
mv ~/tmp/cmdline-tools/cmdline-tools/ ~/tmp/cmdline-tools/latest

# check if anything is missing
flutter doctor

# validate installation
flutter config --android-sdk
flutter doctor --android-licenses
flutter doctor
```

```text
$ flutter doctor
Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel stable, 3.41.6, on Debian GNU/Linux forky/sid 6.19.8+deb14-amd64, locale en_AU.UTF-8)
[✓] Android toolchain - develop for Android devices (Android SDK version 36.1.0)
[✓] Chrome - develop for the web
[✓] Linux toolchain - develop for Linux desktop
[✓] Connected device (2 available)
[✓] Network resources

• No issues found!
```

```bash
# check devices
flutter devices
```

```text
$ flutter devices
Found 2 connected devices:
  Linux (desktop) • linux  • linux-x64      • Debian GNU/Linux forky/sid 6.19.8+deb14-amd64
  Chrome (web)    • chrome • web-javascript • Google Chrome 146.0.7680.164

Run "flutter emulators" to list and start any available device emulators.

If you expected another device to be detected, please run "flutter doctor" to diagnose potential issues. You may also try increasing the time to wait for connected devices
with the "--device-timeout" flag. Visit https://flutter.dev/setup/ for troubleshooting tips.
```

## To Do

Set up an Android Virtual Device (AVD), or connect a physical Android device via USB with USB Debugging enabled.

## Dependencies
a
* JDK: openjdk-21-jdk (Debian package) <https://openjdk.java.net/>
* Android Studio: <https://developer.android.com/studio/>
* Android SDK: <https://developer.android.com/tools/releases/platform-tools>
* Android Command Line Tools: <https://developer.android.com/tools>
