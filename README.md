# Flutter DDC Hang Bug - Reproduction Attempt

This repository was created to reproduce a DDC (Dart Dev Compiler) hang issue in Flutter 3.35.x for web debug mode.

## Issue Summary

When running `flutter run -d chrome` in debug mode on a large Flutter web application, the DDC frontend_server process hangs indefinitely at 100% CPU utilization, consuming ~1.6GB RAM.

## Environment

- **Flutter**: 3.35.7 (Dart 3.9.2)
- **Platforms tested**: Flutter 3.35.0, 3.35.7
- **Platform**: macOS (Darwin 25.0.0)

## Reproduction Status

⚠️ **This minimal reproduction DOES NOT reproduce the issue**

The bug appears to be related to application **code size/complexity** rather than specific dependencies. This test repository includes:

### Tested Configurations
1. **Vanilla Flutter app**: ✅ Works (~10 seconds)
2. **+ Drift with WASM/web workers**: ✅ Works
3. **+ Firebase suite**: ✅ Works
4. **+ 60+ packages from production app**: ✅ Works (~12 seconds)
5. **+ ALL 85+ production dependencies**: ✅ Works (~10.3 seconds)
6. **+ 148 generated Dart files** (models, controllers, widgets, screens): ✅ Works

### What This Test Includes
- All 85+ dependencies from production application
- Drift with web worker support
- Complete Firebase suite (Core, Auth, Analytics, Crashlytics, Performance)
- GetX, Riverpod, google_sign_in, and 60+ other packages
- 148 generated source files to simulate codebase size
- build_runner with drift_dev and build_web_compilers

Despite matching the production dependency set exactly, the test app launches successfully in debug mode, suggesting the issue is triggered by:
- Specific code patterns or architecture
- Generated code from build_runner (drift schemas, flutter_gen assets)
- Combination of actual application logic
- Unknown complexity threshold beyond simple generated files

## What Works

✅ This minimal app with drift + Firebase runs successfully in debug mode
✅ `flutter run -d chrome --release` (uses dart2js)
✅ `flutter run -d chrome --profile` (uses dart2js)
✅ `flutter build web`
✅ Small to medium Flutter web apps

## What Fails

❌ Large production Flutter web apps in debug mode (DDC)
❌ Apps with 80+ dependencies and substantial codebase

## Observed Behavior in Failing Apps

```bash
$ flutter run -d chrome
Launching lib/main.dart on Chrome in debug mode...
Waiting for connection from debug service on Chrome...
[hangs indefinitely]
```

Process characteristics:
```bash
$ ps aux | grep frontend_server
user  99999  99.9  3.2  2685316 1679504   ??  R  2:13PM  45:23.45
.../dart-sdk/bin/snapshots/frontend_server_aot.dart.snapshot
```

- **CPU**: 99.9% (single core maxed)
- **Memory**: ~1.6GB RAM
- **Duration**: Never completes (tested 45+ minutes)

## Hypothesis

The issue appears to be a **DDC scalability problem** where:
1. DDC cannot handle the code size/complexity of large applications
2. The incremental compiler enters an infinite loop or extremely slow compilation path
3. dart2js (used in release/profile) handles the same code fine

## Workarounds

1. Use `flutter run -d chrome --profile` for development
2. Use `flutter run -d chrome --release` (loses all debug features)
3. Develop on desktop platforms (macOS/Windows/Linux) where debug mode works
4. Use `flutter build web --release` for deployment

## Related Flutter Issues

- [#153094](https://github.com/flutter/flutter/issues/153094) - DDC crash in 3.24.x (supposedly fixed)
- [#153165](https://github.com/flutter/flutter/issues/153165) - Frontend server hang in 3.24.x (supposedly fixed)
- [#171221](https://github.com/flutter/flutter/issues/171221) - 3.32.5 issue (closed as invalid)

This appears to be a **regression** in the 3.35.x series affecting large applications.

## Impact

This is a blocking issue for large-scale Flutter web development in debug mode:
- ❌ No hot reload
- ❌ No hot restart
- ❌ No debugger breakpoints
- ❌ No DevTools profiling in debug mode
- ❌ Limited error stack traces
