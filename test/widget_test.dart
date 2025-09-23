import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_crm/main.dart';
import 'package:notes_crm/screens/login_screen.dart';

void main() {
  testWidgets('App starts and shows LoginScreen', (WidgetTester tester) async {
    
    await tester.pumpWidget(const MyApp());

    
    await tester.pumpAndSettle();

    
    expect(find.byType(LoginScreen), findsOneWidget);

    expect(find.text('Login'), findsOneWidget);
  });
}
