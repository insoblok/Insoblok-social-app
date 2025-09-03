# insoblok-flutter
InSoBlok Social App (Image to AI Image)

adb connect localhost:5555
dart run build_runner build --delete-conflicting-outputs
flutter pub upgrade --major-versions
dart run flutter_native_splash:create

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

### Example Code of Firebase Cloud
exports.fetchNews = functions.https.onRequest((request, response) => {
  axios.get(url)
    .then(async (response) => {
      var currentDate = new Date(Date.now());
      var perigonTime = admin.firestore().collection("perigon").get()
      const data = response.data;
      logger.info(data["articles"].length);
      for (let i = 0; i < data["articles"].length; i++) {
        const article = data["articles"][i];
        logger.info(article);
        await admin.firestore().collection("perigon").add({
          ...article,
        });
      }
      await admin.firestore().collection("perigon").add({
        'timestamp': admin.firestore.FieldValue.serverTimestamp(),
      });
    })
    .catch((error) => {
      logger.error(error);
    });
  response.send("Hello from Firebase!");
});

firebase login
firebase logout
npx eslint index.js --fix
firebase deploy --only functions

## Flutter Special Build
taskkill /f /im java.exe
flutter run --dart-define=PROJECT_ID=9296d8bab961cfb830ef10f47bc495bc
flutter build apk --no-tree-shake-icons --dart-define=PROJECT_ID=9296d8bab961cfb830ef10f47bc495bc

taskkill /f /im java.exe
flutter run --no-tree-shake-icons
flutter run

taskkill /f /im java.exe
flutter clean
flutter pub get
flutter run

flutter pub cache clean
flutter pub get
flutter pub cache repair

message_provider.dart
account_wallet_page.dart

VS Code: "Developer: Restart Dart Analysis Server"