# TODO — Firebase "not configured" / initialization

- [ ] Confirm exact error stacktrace by running flutter run on the target platform.
- [ ] Fix main.dart to use DefaultFirebaseOptions.currentPlatform and Firebase.initializeApp(options: ...).
- [ ] Ensure main.dart imports firebase_options.dart.
- [ ] Run flutter analyze.
- [ ] Run flutter run on Android device.
- [ ] If still failing: check android/app/build.gradle.kts, android/settings.gradle.kts, google-services.json presence and package name match.

