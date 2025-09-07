import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:insoblok/locator.dart';             // your GetIt instance: `final locator = GetIt.instance;`
import 'package:insoblok/pages/auths/login_page.dart';
import 'package:insoblok/providers/auths/login_provider.dart'; // if needed for types
import 'package:insoblok/services/services.dart';    // <-- must export AuthService, ReownService, etc.

/// --- Mocks / Fakes ---

class MockAuthService extends Mock implements AuthService {}

class MockReownService extends Mock implements ReownService {}

/// BuildContext is used in ReownService.init(context); mocktail needs a fallback.
class FakeBuildContext extends Fake implements BuildContext {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    // Register fallback for any<BuildContext>()
    registerFallbackValue(FakeBuildContext());
  });

  setUp(() async {
    // Fresh DI container for every test
    await locator.reset();

    // Register mocks so AuthHelper.service (GetIt<AuthService>) succeeds
    final mockAuth = MockAuthService();
    final mockReown = MockReownService();

    locator.registerLazySingleton<AuthService>(() => mockAuth);
    locator.registerLazySingleton<ReownService>(() => mockReown);

    // Stub ReownService.init(context) called by LoginProvider.init(...)
    when(() => mockReown.init(any())).thenAnswer((_) async {});

    // If anything reads these later, you can stub them too:
    when(() => mockReown.isConnected).thenReturn(false);
    // when(() => mockReown.connect()).thenAnswer((_) async {});
    // when(() => mockReown.walletAddress).thenReturn('0xTEST');
  });

  tearDown(() async {
    await locator.reset();
  });

  testWidgets('LoginPage renders and shows wallet button', (tester) async {
    // Pump inside MaterialApp to provide theme, MediaQuery, etc.
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));

    // Allow first frame + ViewModel init() microtasks
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Sign in with Wallet'), findsOneWidget);
    expect(find.text('Enable Vybecam'), findsOneWidget);
  });

  testWidgets('Vybecam switch toggles', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));
    await tester.pump(const Duration(milliseconds: 100));

    // Find Switch (there’s only one in your LoginPage)
    final switchFinder = find.byType(Switch);
    expect(switchFinder, findsOneWidget);

    // Tap to toggle
    await tester.tap(switchFinder);
    await tester.pump();

    // If you want to assert state change visually, you can check semantics or color;
    // since state is in a ViewModel, this smoke-test ensures no exceptions.
  });

  // (Optional) If you want to verify the loader appears when starting login,
  // keep the flow short by stubbing connect() quickly and leaving isConnected false.
  testWidgets('Tapping wallet shows loading briefly (no crash)', (tester) async {
    final mockReown = locator<ReownService>();
    when(() => mockReown.connect()).thenAnswer((_) async {});

    await tester.pumpWidget(const MaterialApp(home: LoginPage()));
    await tester.pump(const Duration(milliseconds: 100));

    // Tap the wallet button
    await tester.tap(find.text('Sign in with Wallet'));
    await tester.pump(); // start loading animation

    // Loader text (from GradientPillButton) should appear
    expect(find.text('Signing in…'), findsOneWidget);

    // Let the microtasks finish; provider sets loading=false in finally
    await tester.pump(const Duration(milliseconds: 200));
  });
}
