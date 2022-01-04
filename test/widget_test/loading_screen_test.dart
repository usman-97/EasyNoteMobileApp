import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:note_taking_app/components/linear_progress_bar.dart';
import 'package:note_taking_app/views/loading_screen.dart';
import 'package:mockito/mockito.dart';
import 'package:note_taking_app/views/login_screen.dart';

class LoadingScreenNavigationObserver extends Mock
    implements NavigatorObserver {}

void main() {
  // group('loading_screen_test', () {
  //   late LoadingScreenNavigationObserver loadingScreenMockObserver;
  //
  //   setUp(() {
  //     loadingScreenMockObserver = LoadingScreenNavigationObserver();
  //   });
  //
  //   Future<void> _buildLoadingScreen(WidgetTester tester) async {
  //     MaterialApp(
  //       home: const LoadingScreen(),
  //       navigatorObservers: [loadingScreenMockObserver],
  //     );
  //     verify(loadingScreenMockObserver.didPush(, any));
  //   }
  //
  //   Future<void> _navigationToLoginPage(WidgetTester tester) async {
  //     await tester.pump(const Duration(
  //       seconds: 2,
  //       milliseconds: 500,
  //     ));
  //   }
  //
  //   testWidgets('LoadingScreen navigation test', (WidgetTester tester) async {
  //     await _buildLoadingScreen(tester);
  //     await _navigationToLoginPage(tester);
  //
  //     verify(loadingScreenMockObserver.didPush(any!, any));
  //     expect(find.byType(LoginScreen), findsOneWidget);
  //   });
  // });

  // final mockObserver = LoadingScreenNavigationObserver();
  // testWidgets('Test if loading screen has on linear progress bar',
  //     (WidgetTester tester) async {
  //   await tester.pumpWidget(const MaterialApp(
  //     home: LoadingScreen(),
  //   ));
  //
  //   expect(find.byType(LinearProgressBar), findsOneWidget);
  //   await tester.pumpAndSettle(const Duration(seconds: 2, milliseconds: 500));
  //   verify(mockObserver.didPush(
  //       Route(settings: const RouteSettings(name: LoginScreen.id)), any));
  //
  //   expect(find.byType(LoginScreen), findsOneWidget);
  // });
}
