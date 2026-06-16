import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/counter_provider.dart';
import 'services/notification_service.dart';

void main() {
  runApp(
    // ChangeNotifierProvider menyediakan satu instance CounterProvider untuk
    // seluruh widget tree, sehingga state counter dapat diakses dari mana saja.
    ChangeNotifierProvider(
      create: (_) => CounterProvider(),
      child: const MyApp(),
    ),
  );
}

/// MyApp — root aplikasi (MaterialApp) dengan tema Material 3 mode gelap.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Counter Provider App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF6C63FF),
        brightness: Brightness.dark,
        fontFamily: 'Segoe UI',
      ),
      home: const HomePage(),
    );
  }
}

/// HomePage — halaman utama. Menampilkan nilai counter dan tombol Tambah (+).
/// Setiap penekanan tombol: counter bertambah (lewat Provider) lalu memunculkan
/// notifikasi browser + banner in-app.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Minta izin notifikasi sedini mungkin agar prompt browser muncul.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationService.requestPermission();
    });
  }

  /// Handler tombol Tambah (+): increment via Provider lalu tampilkan notifikasi.
  Future<void> _handleIncrement() async {
    final counter = context.read<CounterProvider>();
    counter.increment();

    // Judul & pesan sesuai ketentuan tugas.
    const title = 'Counter Update';
    final body = 'Nilai counter saat ini: ${counter.count}';

    // 1) Notifikasi tingkat sistem (browser Notification API di Chrome).
    await NotificationService.requestPermission();
    NotificationService.show(title, body);

    // 2) Notifikasi in-app (SnackBar) sebagai feedback yang selalu terlihat.
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.notifications_active, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(body, style: const TextStyle(fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF6C63FF),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 3),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.exposure_plus_1_rounded, size: 26),
            SizedBox(width: 10),
            Text(
              'Counter Provider',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [colorScheme.primary, colorScheme.tertiary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorScheme.surface,
              colorScheme.surface.withValues(alpha: 0.95),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildIdentityCard(colorScheme),
                  const SizedBox(height: 28),
                  _buildCounterCard(colorScheme),
                  const SizedBox(height: 28),
                  _buildButtons(colorScheme),
                  const SizedBox(height: 20),
                  _buildHint(colorScheme),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Kartu identitas praktikan.
  Widget _buildIdentityCard(ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primaryContainer.withValues(alpha: 0.5),
            colorScheme.tertiaryContainer.withValues(alpha: 0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(Icons.bolt_rounded, size: 40, color: colorScheme.primary),
          const SizedBox(height: 8),
          Text(
            'Modul 12 & 13 — Provider & Notifikasi',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Haposan Felix Marcel Siregar — 2311102210',
            style: TextStyle(
              fontSize: 13,
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// Kartu utama yang menampilkan nilai counter (di-rebuild via Consumer).
  Widget _buildCounterCard(ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.15),
            blurRadius: 24,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'NILAI COUNTER',
            style: TextStyle(
              fontSize: 14,
              letterSpacing: 2,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 12),
          // Consumer — hanya bagian ini yang di-rebuild saat counter berubah.
          Consumer<CounterProvider>(
            builder: (context, counter, child) {
              return Text(
                '${counter.count}',
                style: TextStyle(
                  fontSize: 96,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                  height: 1.0,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Tombol Tambah (+) dan tombol Reset.
  Widget _buildButtons(ColorScheme colorScheme) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: FilledButton.icon(
            onPressed: _handleIncrement,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            icon: const Icon(Icons.add_rounded, size: 26),
            label: const Text(
              'Tambah',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: OutlinedButton.icon(
            onPressed: () => context.read<CounterProvider>().reset(),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              side: BorderSide(
                color: colorScheme.primary.withValues(alpha: 0.5),
              ),
            ),
            icon: const Icon(Icons.refresh_rounded, size: 22),
            label: const Text(
              'Reset',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  /// Teks bantuan kecil di bawah tombol.
  Widget _buildHint(ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.info_outline_rounded,
          size: 16,
          color: colorScheme.onSurface.withValues(alpha: 0.5),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            'Tekan "Tambah" → notifikasi "Counter Update" muncul',
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ),
      ],
    );
  }
}
