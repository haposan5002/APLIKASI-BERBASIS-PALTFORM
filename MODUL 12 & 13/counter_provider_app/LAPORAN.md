<div style="font-family: 'Times New Roman', Times, serif;">

<div align="center">
  <br />

  <h1>LAPORAN PRAKTIKUM <br>
  APLIKASI BERBASIS PLATFORM
  </h1>

  <br />

  <h3>TUGAS PERTEMUAN - 13<br>
    Praktikum Flutter — Implementasi Provider dan Notifikasi pada Flutter
  </h3>

  <br />

  <img width="182" height="182" alt="Logo Telkom University Purwokerto" src="https://github.com/user-attachments/assets/8937914f-d19f-4e65-b983-c927c8559522" />

  <br />
  <br />
  <br />

  <h3>Disusun Oleh :</h3>

  <p>
    <strong>Haposan Felix Marcel Siregar</strong><br>
    <strong>2311102210</strong><br>
    <strong>S1 IF-11-04</strong>
  </p>

  <br />

  <h3>Dosen Pengampu :</h3>

  <p>
    <strong>Cahyo Prihantoro, S.Kom., M.Eng.</strong>
  </p>

  <br />

  <h3>LABORATORIUM HIGH PERFORMANCE
  <br>FAKULTAS INFORMATIKA <br>UNIVERSITAS TELKOM PURWOKERTO <br>2026</h3>
</div>

<hr>

## 1. Penjelasan Singkat

Pada tugas **Pertemuan 13** ini, praktikum berfokus pada penerapan **State Management Provider** dan **Notifikasi** pada framework Flutter. Aplikasi yang dibangun adalah sebuah aplikasi sederhana berupa _counter_ (penghitung) satu halaman yang menampilkan nilai angka, di mana setiap kali angka tersebut bertambah akan muncul notifikasi berisi nilai counter terbaru.

Konsep utama yang diterapkan:

1. **State Management (Provider)** : Menggunakan package `provider` dengan kelas `ChangeNotifier` untuk memisahkan logika bisnis (state) dari tampilan (UI). Kelas `CounterProvider` menyimpan dan mengelola nilai counter secara reaktif melalui pemanggilan `notifyListeners()`.
2. **Notifikasi** : Aplikasi dijalankan pada **Chrome (Web)**, sehingga notifikasi tingkat sistem menggunakan **browser Notification API** (package `web`) sebagai padanan _Local Notification_ — notifikasi muncul di luar jendela aplikasi pada tingkat OS. Sebagai cadangan yang selalu terlihat, ditambahkan pula notifikasi _in-app_ berupa **SnackBar**. Notifikasi muncul dengan judul **"Counter Update"** dan pesan **"Nilai counter saat ini: X"** setiap kali tombol tambah ditekan.
3. **Desain Sederhana & Fungsional** : Antarmuka dibangun dengan Material 3 (tema gelap), menampilkan kartu identitas mahasiswa (Nama dan NIM), nilai counter besar di tengah layar, serta tombol **Tambah (+)** dan **Reset**.

---

## 2. Penjelasan Singkat Tiap Widget / Kelas

Berikut adalah penjelasan komponen utama yang digunakan dalam proyek ini:

1. **`MyApp`** (`StatelessWidget`):
   - Root widget aplikasi (`MaterialApp` dengan tema Material 3). Di dalam fungsi `main()`, aplikasi dibungkus `ChangeNotifierProvider` agar satu instance `CounterProvider` dapat diakses oleh seluruh _widget tree_.

2. **`CounterProvider`** (`ChangeNotifier`):
   - Kelas yang bertanggung jawab mengelola state angka (`_count`) yang bersifat privat dan hanya dibaca lewat getter `count`. Method `increment()` menaikkan nilai lalu memanggil `notifyListeners()` untuk memperbarui UI secara otomatis. Tersedia pula `reset()` untuk mengembalikan nilai ke 0.

3. **`NotificationService`** (facade lintas-platform):
   - Menggunakan **conditional import** (`notification_service.dart`). Saat di-_compile_ untuk web dipakai implementasi browser Notification API (`notification_web.dart`); di platform lain dipakai _stub no-op_ (`notification_stub.dart`) agar build tetap berhasil. Menyediakan `requestPermission()` dan `show(title, body)`.

4. **`HomePage`** (`StatefulWidget`):
   - Halaman utama aplikasi. Pada `initState` meminta izin notifikasi ke browser. Menampilkan identitas mahasiswa, nilai counter (dibungkus `Consumer<CounterProvider>` agar hanya bagian itu yang di-_rebuild_), dan tombol aksi.
   - Tombol **Tambah** memanggil `context.read<CounterProvider>().increment()`, lalu memunculkan notifikasi browser sekaligus SnackBar berisi judul "Counter Update" dan nilai terbaru.

---

## 3. Langkah-langkah Pembuatan Aplikasi

### Langkah 1 — Inisialisasi Project Flutter

Buat project Flutter baru di dalam direktori proyek:

```bash
flutter create counter_provider_app
```

---

### Langkah 2 — Tambahkan Dependencies di `pubspec.yaml`

Tambahkan library `provider` (state management) dan `web` (akses browser Notification API):

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  provider: ^6.1.2
  web: ^1.1.0
```

Setelah itu, jalankan perintah untuk mengunduh package:

```bash
flutter pub get
```

---

### Langkah 3 — Strukturkan Layanan Notifikasi Lintas-Platform (Conditional Import)

Agar aplikasi tetap dapat di-_build_ di semua platform, layanan notifikasi dipisah
menjadi tiga berkas pada folder `lib/services/`:

**`notification_service.dart`** — facade yang memilih implementasi berdasarkan platform:

```dart
/// Conditional import: pakai Notification API browser saat di web,
/// selain itu pakai stub no-op agar build tetap berhasil.
library;

export 'notification_stub.dart'
    if (dart.library.js_interop) 'notification_web.dart';
```

**`notification_web.dart`** — implementasi notifikasi browser (Chrome):

```dart
import 'dart:js_interop';
import 'package:web/web.dart' as web;

class NotificationService {
  static Future<bool> requestPermission() async {
    final result = await web.Notification.requestPermission().toDart;
    return result.toDart == 'granted';
  }

  static String get permission => web.Notification.permission;

  static void show(String title, String body) {
    if (web.Notification.permission == 'granted') {
      web.Notification(
        title,
        web.NotificationOptions(body: body, icon: 'icons/Icon-192.png'),
      );
    }
  }
}
```

**`notification_stub.dart`** — stub no-op untuk platform non-web (Android/iOS/desktop):

```dart
class NotificationService {
  static Future<bool> requestPermission() async => false;
  static String get permission => 'default';
  static void show(String title, String body) {
    // Tidak melakukan apa-apa di platform non-web.
  }
}
```

---

### Langkah 4 — Implementasi Provider (`lib/providers/counter_provider.dart`)

`CounterProvider` mengelola state counter menggunakan `ChangeNotifier`:

```dart
import 'package:flutter/foundation.dart';

class CounterProvider extends ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners(); // beri tahu semua listener agar UI ter-update
  }

  void reset() {
    _count = 0;
    notifyListeners();
  }
}
```

---

### Langkah 5 — Implementasi Antarmuka & Logika (`lib/main.dart`)

Berikut _source code_ utama yang memuat setup Provider, permintaan izin notifikasi,
dan handler tombol Tambah:

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/counter_provider.dart';
import 'services/notification_service.dart';

void main() {
  // ChangeNotifierProvider menyediakan satu instance CounterProvider
  // untuk seluruh widget tree.
  runApp(
    ChangeNotifierProvider(
      create: (_) => CounterProvider(),
      child: const MyApp(),
    ),
  );
}

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
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Minta izin notifikasi sedini mungkin.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationService.requestPermission();
    });
  }

  Future<void> _handleIncrement() async {
    final counter = context.read<CounterProvider>();
    counter.increment();

    const title = 'Counter Update';
    final body = 'Nilai counter saat ini: ${counter.count}';

    // 1) Notifikasi tingkat sistem (browser Notification API).
    await NotificationService.requestPermission();
    NotificationService.show(title, body);

    // 2) Notifikasi in-app (SnackBar) sebagai feedback yang selalu terlihat.
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$title — $body')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter Provider'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Identitas mahasiswa
            const Text(
              'Haposan Felix Marcel Siregar — 2311102210',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            const Text('NILAI COUNTER'),
            // Consumer — hanya bagian ini yang di-rebuild saat counter berubah.
            Consumer<CounterProvider>(
              builder: (context, counter, child) => Text(
                '${counter.count}',
                style: const TextStyle(fontSize: 96, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _handleIncrement,
              icon: const Icon(Icons.add),
              label: const Text('Tambah'),
            ),
            OutlinedButton.icon(
              onPressed: () => context.read<CounterProvider>().reset(),
              icon: const Icon(Icons.refresh),
              label: const Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }
}
```

> Catatan: cuplikan `main.dart` di atas disederhanakan pada bagian _styling_ agar
> ringkas. Versi lengkap (dengan kartu identitas, gradient, dan SnackBar berdesain)
> tersedia pada berkas `lib/main.dart` di repository.

---

## 4. Struktur File Proyek

Struktur folder inti dari project aplikasi ini adalah sebagai berikut:

```text
counter_provider_app/
├── lib/
│   ├── main.dart                       ← Entrypoint, MyApp, HomePage, handler tombol
│   ├── providers/
│   │   └── counter_provider.dart       ← CounterProvider (ChangeNotifier) — state counter
│   └── services/
│       ├── notification_service.dart   ← Facade: conditional export (web / stub)
│       ├── notification_web.dart       ← Implementasi browser Notification API (Chrome)
│       └── notification_stub.dart      ← Stub no-op untuk platform non-web
├── web/                                ← target build (aplikasi dijalankan di Chrome)
├── LAPORAN.md                          ← laporan praktikum
└── pubspec.yaml                        ← dependencies: provider, web
```

---

## 5. Cara Menjalankan Aplikasi

1. Pastikan Google Chrome terpasang dan terdeteksi sebagai perangkat:
   ```bash
   flutter devices
   ```
2. Unduh dependencies:
   ```bash
   flutter pub get
   ```
3. Jalankan aplikasi pada Chrome:
   ```bash
   flutter run -d chrome
   ```
4. Saat aplikasi pertama kali terbuka, **izinkan** notifikasi ketika muncul pop-up permintaan izin dari browser.
5. Tekan tombol **Tambah (+)** — nilai counter bertambah dan notifikasi "Counter Update" muncul.

---

## 6. Screenshot Hasil Tampilan

_(Tangkapan layar (screenshot) hasil pengujian diletakkan pada folder `SS`)_

<br>

<div align="center">

| No  | Deskripsi Tampilan                       | File Gambar                                              |
| :-: | :--------------------------------------- | :------------------------------------------------------ |
|  1  | Izin Aktifkan Notifikasi (Awal Dibuka)   | <img src="SS/izin notifikasi.png" width="320" />        |
|  2  | Tampilan Awal Aplikasi                   | <img src="SS/tampilan awal.png" width="320" />          |
|  3  | Klik Counter Pertama (Notifikasi Muncul) | <img src="SS/klik counter pertama.png" width="320" />   |
|  4  | Klik Counter Kedua (Notifikasi Update)   | <img src="SS/klik counter kedua.png" width="320" />     |

</div>

<br>

---

## 7. Kesimpulan

Pada praktikum Pertemuan 13 ini, telah berhasil diimplementasikan:

1. **Penggunaan State Management Provider** melalui kelas `ChangeNotifier` (`CounterProvider`) untuk memisahkan logika nilai counter dari UI. Dengan `notifyListeners()` dan `Consumer`, pembaruan UI menjadi reaktif dan efisien karena hanya widget yang relevan yang di-_rebuild_.
2. **Penyajian Notifikasi** menggunakan **browser Notification API** (package `web`) sebagai padanan Local Notification di platform web, dipicu langsung dari aksi tombol tanpa memerlukan server eksternal seperti Firebase, serta diperkuat dengan SnackBar in-app sebagai cadangan.
3. **Penerapan Pola Lintas-Platform** melalui _conditional import_ pada `notification_service.dart`, sehingga proyek tetap dapat di-_build_ di platform non-web menggunakan implementasi _stub_.

</div>
