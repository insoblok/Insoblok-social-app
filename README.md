# insoblok-flutter
InSoBlok Social App (Image to AI Image)

adb connect localhost:5555
dart run build_runner build --delete-conflicting-outputs
flutter pub upgrade --major-versions

## Provider Fetch Temp
if (isBusy) return;
    clearErrors();
    
await runBusyFuture(() async {
    try {} catch (e) {
    setError(e);
    logger.e(e);
    } finally {
    notifyListeners();
    }
}());

if (hasError) {
    Fluttertoast.showToast(msg: modelError.toString());
}

## Firebase Time Convertor
Timestamp timestamp = doc['createdAt'] as Timestamp;
DateTime utcDateTime = timestamp.toDate(); // This is already in UTC
print(utcDateTime.toIso8601String()); // UTC ISO format

## Firebase Cloud Function Config
npm install -g firebase-tools
firebase login
firebase init functions

firebase login
firebase logout
npx eslint index.js --fix
firebase deploy --only functions

## Flutter Special Build
taskkill /f /im java.exe
flutter run --dart-define=PROJECT_ID=9296d8bab961cfb830ef10f47bc495bc
flutter build apk --no-tree-shake-icons --dart-define=PROJECT_ID=9296d8bab961cfb830ef10f47bc495bc

flutter pub cache clean
flutter pub get
flutter pub cache repair