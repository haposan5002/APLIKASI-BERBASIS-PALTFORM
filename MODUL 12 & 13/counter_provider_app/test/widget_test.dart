// Widget test untuk aplikasi Counter + Provider (Modul 12 & 13).
//
// Memverifikasi nilai counter mulai dari 0 dan bertambah menjadi 1 setelah
// tombol "Tambah" ditekan (state dikelola oleh CounterProvider).

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:counter_provider_app/main.dart';
import 'package:counter_provider_app/providers/counter_provider.dart';

void main() {
  testWidgets('Counter bertambah saat tombol Tambah ditekan',
      (WidgetTester tester) async {
    // Bangun aplikasi dengan Provider, lalu trigger satu frame.
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => CounterProvider(),
        child: const MyApp(),
      ),
    );

    // Counter dimulai dari 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tekan tombol Tambah lalu trigger frame.
    await tester.tap(find.text('Tambah'));
    await tester.pump();

    // Nilai counter telah bertambah menjadi 1.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
