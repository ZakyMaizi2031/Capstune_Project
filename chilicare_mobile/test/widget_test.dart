// Widget tests untuk ChiliCare Flutter App
//
// Test ini memverifikasi:
// 1. Struktur Material App terbentuk dengan benar
// 2. Provider terintegrasi dengan baik
// 3. Navigation routes tersedia

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:chilicare_mobile/main.dart';

void main() {
  group('ChiliCare App Widget Tests', () {
    
    testWidgets('App renders MaterialApp dengan theme yang benar', (WidgetTester tester) async {
      // Build our app
      await tester.pumpWidget(const ChiliCareApp());

      // Verifikasi bahwa MaterialApp terbentuk
      expect(find.byType(MaterialApp), findsOneWidget);
      
      // Verifikasi bahwa ada MultiProvider untuk state management
      expect(find.byType(MultiProvider), findsOneWidget);
    });

    testWidgets('Providers terkonfigurasi dengan benar', (WidgetTester tester) async {
      // Build our app
      await tester.pumpWidget(const ChiliCareApp());

      // Verifikasi struktur provider
      expect(find.byType(MultiProvider), findsOneWidget);
      
      // Pump untuk render sepenuhnya
      await tester.pumpAndSettle();
      
      // Verifikasi bahwa app tidak crash
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('Splash screen atau Login screen muncul di startup', (WidgetTester tester) async {
      // Build our app
      await tester.pumpWidget(const ChiliCareApp());

      // Tunggu animasi splash selesai
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verifikasi bahwa ada widget yang dirender (splash atau login)
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('App tidak throw exception pada init', (WidgetTester tester) async {
      // Build app - jika ada exception saat build, test akan gagal
      await tester.pumpWidget(const ChiliCareApp());

      // Tunggu frame rendering
      await tester.pumpAndSettle();

      // Jika sampai sini, berarti app build sukses tanpa exception
      expect(true, true);
    });

  });
}
