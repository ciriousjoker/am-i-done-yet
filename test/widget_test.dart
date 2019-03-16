// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_firebase_ui/flutter_firebase_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:am_i_done_yet/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(App(), Duration(seconds: 5));
    await tester.pumpAndSettle(Duration(seconds: 10));

    expect(find.text("Login"), findsOneWidget);
    // expect(find.byWidget(SignInScreen()), findsOneWidget);
    // expect(find.byType(Scaffold), findsOneWidget);
  });
}
