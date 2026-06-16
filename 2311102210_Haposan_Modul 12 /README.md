<div style="font-family: 'Times New Roman', Times, serif;">

<div align="center">
  <br />

  <h1>LAPORAN PRAKTIKUM <br>
  APLIKASI BERBASIS PLATFORM
  </h1>

  <br />

  <h3>MODUL 8-9<br>
    Tugas Praktikum — Notifikasi & API Perangkat Keras
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

Pada Modul 8-9 ini, tugas praktikum berfokus pada penggunaan **API Perangkat Keras** (kamera & galeri) serta **Notifikasi Lokal** pada aplikasi Flutter. Aplikasi yang dibuat memungkinkan pengguna untuk mengambil foto dari kamera atau memilih foto dari galeri perangkat, kemudian menampilkan foto tersebut di layar dan memberikan notifikasi lokal sebagai konfirmasi bahwa proses berhasil dilakukan.

### Package yang Digunakan

| Package | Versi | Fungsi |
|---|---|---|
| `image_picker` | ^1.1.2 | Mengakses kamera dan galeri perangkat untuk mengambil/memilih foto |
| `flutter_local_notifications` | ^18.0.1 | Menampilkan notifikasi lokal di perangkat Android dan iOS |

### Konsep Utama

1. **Image Picker** — Package `image_picker` menyediakan antarmuka yang mudah untuk mengakses kamera (`ImageSource.camera`) atau galeri (`ImageSource.gallery`) perangkat. Method `pickImage()` mengembalikan objek `XFile` yang berisi path file gambar yang dipilih.

2. **Flutter Local Notifications** — Package `flutter_local_notifications` memungkinkan aplikasi menampilkan notifikasi di status bar perangkat tanpa memerlukan koneksi internet atau server push notification. Notifikasi dikonfigurasi melalui `FlutterLocalNotificationsPlugin` yang diinisialisasi saat aplikasi pertama kali berjalan.

3. **Platform Permissions** — Untuk mengakses kamera dan galeri, aplikasi memerlukan permission khusus yang harus dideklarasikan di `AndroidManifest.xml` (Android) dan `Info.plist` (iOS).

---

## 2. Langkah-langkah Praktikum

### Langkah 1 — Tambah Dependencies

Buka file `pubspec.yaml` pada project Flutter, lalu tambahkan dua package baru di bagian `dependencies`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  http: ^1.6.0
  image_picker: ^1.1.2
  flutter_local_notifications: ^18.0.1
```

Kemudian jalankan:

```bash
flutter pub get
```

---

### Langkah 2 — Konfigurasi Permission Android

Buka file `android/app/src/main/AndroidManifest.xml`, lalu tambahkan permission untuk kamera dan akses storage:

```xml
<!-- Permission untuk akses internet (wajib untuk HTTP request) -->
<uses-permission android:name="android.permission.INTERNET"/>
<!-- Permission untuk akses kamera (Modul 8-9) -->
<uses-permission android:name="android.permission.CAMERA"/>
<!-- Permission untuk akses galeri / storage (Modul 8-9) -->
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
```

> **Catatan:** Permission `CAMERA` wajib agar aplikasi dapat membuka kamera perangkat. Permission `READ_EXTERNAL_STORAGE` diperlukan untuk membaca file gambar dari galeri.

---

### Langkah 3 — Konfigurasi Permission iOS

Buka file `ios/Runner/Info.plist`, lalu tambahkan deskripsi permission sebelum tag `</dict>`:

```xml
<key>NSCameraUsageDescription</key>
<string>Aplikasi memerlukan akses kamera untuk mengambil foto</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Aplikasi memerlukan akses galeri untuk memilih foto</string>
```

> Deskripsi ini akan ditampilkan kepada pengguna saat iOS meminta izin akses kamera atau galeri.

---

### Langkah 4 — Buat File `tugas_modul89.dart`

Buat file baru `lib/tugas_modul89.dart` yang berisi seluruh logika aplikasi.

**Struktur utama kode:**

1. **Inisialisasi plugin notifikasi** di fungsi `main()` sebelum `runApp()`.
2. **Widget `TugasModul89App`** — root `MaterialApp` dengan tema Material 3.
3. **Widget `HomePage`** — `StatefulWidget` yang mengelola state gambar (`_imageFile`).
4. **Method `_pickFromCamera()`** — membuka kamera, menyimpan file, dan menampilkan notifikasi.
5. **Method `_pickFromGallery()`** — membuka galeri, menyimpan file, dan menampilkan notifikasi.
6. **Method `_showNotification()`** — mengirim notifikasi lokal melalui `FlutterLocalNotificationsPlugin`.

---

### Langkah 5 — Konfigurasi Entry Point

Edit file `.vscode/launch.json` untuk mengarahkan ke file baru:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "request": "launch",
      "program": "lib/tugas_modul89.dart",
      "type": "dart"
    }
  ]
}
```

Atau jalankan langsung via terminal:

```bash
flutter run -t lib/tugas_modul89.dart
```

---

### Langkah 6 — Jalankan Aplikasi

1. Sambungkan device atau jalankan emulator.
2. Jalankan:
   ```bash
   flutter run -t lib/tugas_modul89.dart
   ```
3. Tampilan awal menunjukkan placeholder "Belum ada foto" dengan dua tombol: **Buka Kamera** dan **Pilih Galeri**.
4. Tekan tombol **Buka Kamera** → kamera terbuka → ambil foto → foto tampil di layar → notifikasi muncul: *"Foto berhasil diambil dari Kamera!"*.
5. Tekan tombol **Pilih Galeri** → galeri terbuka → pilih foto → foto tampil di layar → notifikasi muncul: *"Foto berhasil dipilih dari Galeri!"*.

---

## 3. Struktur Project

```
tutorial_12/
├── lib/
│   ├── main.dart                     # Entry point default Flutter (counter template)
│   ├── tutorial_12.dart              # Halaman networking Modul 12 (fetch API Laravel)
│   ├── Product.dart                  # Model Product (fromJson) untuk Modul 12
│   └── tugas_modul89.dart            # [NEW] Aplikasi kamera + notifikasi (Modul 8-9)
├── android/app/src/main/
│   └── AndroidManifest.xml           # Permission: INTERNET, CAMERA, READ_EXTERNAL_STORAGE
├── ios/Runner/
│   └── Info.plist                    # Permission: NSCameraUsageDescription, NSPhotoLibraryUsageDescription
├── .vscode/
│   └── launch.json                   # Entry point: lib/tugas_modul89.dart
├── pubspec.yaml                      # Dependencies: http, image_picker, flutter_local_notifications
└── ...
```

---

## 4. Source Code Lengkap

### 4.1 `lib/tugas_modul89.dart`

```dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// ──────────────────────────────────────────────
// Plugin notifikasi lokal (top-level agar bisa
// diakses dari mana saja di file ini)
// ──────────────────────────────────────────────
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi notifikasi lokal
  const AndroidInitializationSettings androidInit =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const DarwinInitializationSettings iosInit = DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  const InitializationSettings initSettings = InitializationSettings(
    android: androidInit,
    iOS: iosInit,
  );

  await flutterLocalNotificationsPlugin.initialize(initSettings);

  runApp(const TugasModul89App());
}

// ═══════════════════════════════════════════════
//  ROOT WIDGET
// ═══════════════════════════════════════════════
class TugasModul89App extends StatelessWidget {
  const TugasModul89App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Modul 8-9 — Kamera & Notifikasi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

// ═══════════════════════════════════════════════
//  HALAMAN UTAMA
// ═══════════════════════════════════════════════
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _imageFile; // menyimpan file gambar yang dipilih / diambil
  final ImagePicker _picker = ImagePicker();

  // ─── Ambil foto dari kamera ────────────────
  Future<void> _pickFromCamera() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );
    if (photo != null) {
      setState(() => _imageFile = File(photo.path));
      _showNotification(
        title: 'Foto Berhasil Diambil 📸',
        body: 'Foto berhasil diambil dari Kamera!',
      );
    }
  }

  // ─── Pilih foto dari galeri ────────────────
  Future<void> _pickFromGallery() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (image != null) {
      setState(() => _imageFile = File(image.path));
      _showNotification(
        title: 'Foto Berhasil Dipilih 🖼️',
        body: 'Foto berhasil dipilih dari Galeri!',
      );
    }
  }

  // ─── Tampilkan notifikasi lokal ────────────
  Future<void> _showNotification({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'modul89_channel', // channel id
      'Modul 8-9 Notifications', // channel name
      channelDescription: 'Notifikasi setelah mengambil / memilih foto',
      importance: Importance.high,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      0, // notification id
      title,
      body,
      details,
    );
  }

  // ─── BUILD ─────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Modul 8-9 — Kamera & Notifikasi'),
        centerTitle: true,
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              // ── Info card ─────────────────────
              Card(
                elevation: 0,
                color: colorScheme.secondaryContainer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline,
                          color: colorScheme.onSecondaryContainer),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Ambil foto dari kamera atau pilih dari galeri. '
                          'Notifikasi akan muncul setelah foto berhasil diambil.',
                          style: TextStyle(
                            color: colorScheme.onSecondaryContainer,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ── Tombol aksi ───────────────────
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _pickFromCamera,
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Buka Kamera'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _pickFromGallery,
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Pilih Galeri'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: colorScheme.tertiary,
                        foregroundColor: colorScheme.onTertiary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ── Preview gambar ────────────────
              if (_imageFile != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.file(
                    _imageFile!,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Path: ${_imageFile!.path.split('/').last}',
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.outline,
                  ),
                  textAlign: TextAlign.center,
                ),
              ] else ...[
                // Placeholder saat belum ada gambar
                Container(
                  height: 280,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: colorScheme.outlineVariant,
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image_outlined,
                        size: 64,
                        color: colorScheme.outlineVariant,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Belum ada foto',
                        style: TextStyle(
                          fontSize: 16,
                          color: colorScheme.outline,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tekan tombol di atas untuk mengambil foto',
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.outlineVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
```

---

### 4.2 `android/app/src/main/AndroidManifest.xml`

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <application
        android:label="tutorial_12"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher">
        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:launchMode="singleTop"
            android:taskAffinity=""
            android:theme="@style/LaunchTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize">
            <meta-data
              android:name="io.flutter.embedding.android.NormalTheme"
              android:resource="@style/NormalTheme"
              />
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>
        <meta-data
            android:name="flutterEmbedding"
            android:value="2" />
    </application>
    <!-- Permission untuk akses internet (wajib untuk HTTP request) -->
    <uses-permission android:name="android.permission.INTERNET"/>
    <!-- Permission untuk akses kamera (Modul 8-9) -->
    <uses-permission android:name="android.permission.CAMERA"/>
    <!-- Permission untuk akses galeri / storage (Modul 8-9) -->
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
</manifest>
```

---

### 4.3 `ios/Runner/Info.plist` (Bagian yang Ditambahkan)

```xml
<key>NSCameraUsageDescription</key>
<string>Aplikasi memerlukan akses kamera untuk mengambil foto</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Aplikasi memerlukan akses galeri untuk memilih foto</string>
```

---

### 4.4 `pubspec.yaml` (Bagian Dependencies)

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  http: ^1.6.0
  image_picker: ^1.1.2
  flutter_local_notifications: ^18.0.1
```

---

### 4.5 `.vscode/launch.json`

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "request": "launch",
      "program": "lib/tugas_modul89.dart",
      "type": "dart"
    }
  ]
}
```

---

## 5. Penjelasan Widget & Komponen

| Widget / Komponen | File | Fungsi |
|---|---|---|
| `FlutterLocalNotificationsPlugin` | `tugas_modul89.dart` | Plugin top-level untuk mengelola notifikasi lokal Android & iOS |
| `WidgetsFlutterBinding.ensureInitialized()` | `main()` | Memastikan binding Flutter siap sebelum inisialisasi plugin |
| `AndroidInitializationSettings` | `main()` | Konfigurasi ikon notifikasi Android (`@mipmap/ic_launcher`) |
| `DarwinInitializationSettings` | `main()` | Konfigurasi permission notifikasi iOS (alert, badge, sound) |
| `MaterialApp` | `TugasModul89App` | Root widget dengan tema Material 3 dan seed color `Colors.indigo` |
| `Scaffold` | `HomePage` | Struktur halaman (AppBar + Body) |
| `AppBar` | `HomePage` | Bar atas dengan judul "Modul 8-9 — Kamera & Notifikasi" |
| `Card` | `HomePage` | Info card menjelaskan fungsi aplikasi |
| `ElevatedButton.icon` (Kamera) | `HomePage` | Tombol "Buka Kamera" → memanggil `_pickFromCamera()` |
| `ElevatedButton.icon` (Galeri) | `HomePage` | Tombol "Pilih Galeri" → memanggil `_pickFromGallery()` |
| `Image.file` | `HomePage` | Menampilkan foto hasil kamera/galeri |
| `ImagePicker.pickImage()` | `_pickFromCamera/Gallery` | Membuka kamera atau galeri untuk mengambil foto |
| `AndroidNotificationDetails` | `_showNotification()` | Detail notifikasi Android (channel, importance, priority) |
| `DarwinNotificationDetails` | `_showNotification()` | Detail notifikasi iOS |

---

## 6. Alur Kerja Aplikasi

```
┌─────────────────────────────┐
│   User membuka aplikasi     │
│   (Tampil placeholder)      │
└──────────┬──────────────────┘
           │
     ┌─────┴─────┐
     ▼           ▼
┌─────────┐ ┌──────────┐
│ Tombol  │ │ Tombol   │
│ Kamera  │ │ Galeri   │
└────┬────┘ └────┬─────┘
     │           │
     ▼           ▼
┌─────────┐ ┌──────────┐
│ Buka    │ │ Buka     │
│ Kamera  │ │ Galeri   │
│ Device  │ │ Device   │
└────┬────┘ └────┬─────┘
     │           │
     ▼           ▼
┌─────────────────────────────┐
│  User ambil / pilih foto    │
└──────────┬──────────────────┘
           │
     ┌─────┴─────┐
     ▼           ▼
┌─────────┐ ┌──────────────┐
│ Foto    │ │ Notifikasi   │
│ tampil  │ │ lokal muncul │
│ di UI   │ │ di status bar│
└─────────┘ └──────────────┘
```

---

## 7. Cara Menjalankan

1. Pastikan Flutter SDK sudah terinstal dan device/emulator tersedia.
2. Buka terminal di folder `tutorial_12/`.
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Jalankan aplikasi:
   ```bash
   flutter run -t lib/tugas_modul89.dart
   ```
5. Tekan tombol **Buka Kamera** → ambil foto → foto tampil + notifikasi muncul.
6. Tekan tombol **Pilih Galeri** → pilih foto → foto tampil + notifikasi muncul.
7. Ambil screenshot untuk dilampirkan di folder `SS/`.

---

## 8. Screenshot Hasil Tampilan

<br>

<div align="center">

| No | Deskripsi | Screenshot |
|:---:|:---|:---:|
| 1 | Tampilan awal aplikasi (placeholder) | <img width="519" height="787" alt="image" src="https://github.com/user-attachments/assets/b5d94937-9096-45f4-8b0e-e9162c91f020" alt="Tampilan Awal" width="250" /> |
| 2 | Membuka kamera perangkat | <img width="514" height="873" alt="image" src="https://github.com/user-attachments/assets/ad21b84a-01c4-4da5-95c5-8bfb6e1d67ba" alt="Kamera" width="250" /> |
| 3 | Foto berhasil diambil dari kamera | <img width="512" height="825" alt="image" src="https://github.com/user-attachments/assets/eecfae1c-87f6-4f5f-bdf1-66748aee082a" />|
| 4 | Notifikasi setelah ambil foto kamera | <img width="540" height="796" alt="image" src="https://github.com/user-attachments/assets/129f768f-abc9-4094-9d9a-acd389c1515a" />|
| 5 | Foto berhasil dipilih dari galeri | <img width="520" height="830" alt="image" src="https://github.com/user-attachments/assets/225f6ac1-9513-4c64-9d63-e3d89894d5ad" />|
| 6 | Notifikasi setelah pilih foto galeri | <img width="564" height="836" alt="image" src="https://github.com/user-attachments/assets/2d641577-c287-4cb8-be2f-6c21ec9365ec" />|

</div>

<br>



---

## 9. Kesimpulan

Pada tugas praktikum Modul 8-9 ini, berhasil diimplementasikan aplikasi Flutter sederhana yang menggabungkan **API Perangkat Keras** dan **Notifikasi Lokal**. Beberapa hal yang dicapai:

1. **Image Picker** berhasil diimplementasikan menggunakan package `image_picker` untuk mengakses kamera (`ImageSource.camera`) dan galeri (`ImageSource.gallery`) perangkat. Foto yang diambil/dipilih ditampilkan di UI menggunakan `Image.file`.

2. **Flutter Local Notifications** berhasil diimplementasikan menggunakan package `flutter_local_notifications`. Notifikasi lokal ditampilkan secara otomatis setelah pengguna berhasil mengambil foto dari kamera atau memilih foto dari galeri, tanpa memerlukan koneksi internet atau server push notification.

3. **Platform Permissions** dikonfigurasi dengan benar pada `AndroidManifest.xml` (permission `CAMERA` dan `READ_EXTERNAL_STORAGE`) serta `Info.plist` (deskripsi `NSCameraUsageDescription` dan `NSPhotoLibraryUsageDescription`) agar aplikasi dapat mengakses perangkat keras tanpa error.

4. Aplikasi menggunakan **Material Design 3** dengan tema yang konsisten dan UI yang responsif, termasuk info card, tombol dengan ikon, dan preview gambar dengan rounded corners.

</div>
