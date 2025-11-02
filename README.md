# Firebase Crashlytics Web Platform Issue - Reproduction

> **⚠️ ARCHIVED REPOSITORY**
>
> This repository has been archived and is now read-only. The issue documented here has been resolved and the root cause identified. This repository serves as a reference for developers encountering similar Firebase Crashlytics web platform issues.
>
> **Related Flutter Issue**: [flutter/flutter#177892](https://github.com/flutter/flutter/issues/177892) (closed - not a Flutter bug)

This repository demonstrates a common issue when using Firebase Crashlytics in Flutter web applications.

## Issue Summary

When running `flutter run -d chrome` in debug mode on a Flutter web application with Firebase Crashlytics initialization, the app fails with a runtime assertion error because **Crashlytics is not supported on the web platform**.

## Environment

- **Flutter**: 3.35.7 (Dart 3.9.2)
- **Platforms tested**: Flutter 3.35.0, 3.35.7
- **Platform**: macOS (Darwin 25.0.0)

## Root Cause Discovered ✅

The issue was **NOT a DDC hang** as initially suspected. Instead, it's a **Firebase Crashlytics web platform compatibility issue**.

Firebase Crashlytics attempts to initialize on the web platform, but it's **not supported** on web. This causes a runtime assertion failure:

```
DartError: Assertion failed:
pluginConstants['isCrashlyticsCollectionEnabled'] != null
is not true
```

### The Solution

Add a platform check before initializing Crashlytics:

```dart
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Firebase Crashlytics is NOT supported on web platform
  // See: https://firebase.google.com/docs/crashlytics/get-started?platform=flutter#availability
  if (!kIsWeb) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  }

  runApp(const MyApp());
}
```

## Test Results

### Before Fix (Crashlytics without platform check)
- App launches in ~12 seconds
- Runtime assertion error occurs
- Error: `pluginConstants['isCrashlyticsCollectionEnabled'] != null is not true`

### After Fix (with kIsWeb check)
- App launches successfully in ~10.8 seconds ✅
- No errors ✅
- Full debug functionality available ✅

## Repository Contents

This test repository includes:
- All 85+ dependencies from a production Flutter application
- Drift with web worker support for SQLite
- Complete Firebase suite (Core, Auth, Analytics, Crashlytics, Performance)
- GetX, Riverpod, google_sign_in, and many other common packages
- 148 generated Dart files to simulate a realistic codebase
- build_runner with drift_dev and build_web_compilers

## Key Takeaway

If you're experiencing what appears to be a "hang" or "freeze" when running `flutter run -d chrome` on your Flutter web app with Firebase, check if you're initializing Crashlytics without a web platform check. This is a common mistake that causes a runtime error, not a compiler issue.

## References

- [Firebase Crashlytics Platform Availability](https://firebase.google.com/docs/crashlytics/get-started?platform=flutter#availability)
- Official Firebase documentation clearly states Crashlytics is not supported on web
