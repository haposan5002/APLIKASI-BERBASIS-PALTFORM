# Laporan Praktikum — Modul 12 & 13

**Nama:** Haposan Felix Marcel Siregar
**NIM:** 2311102210
**Judul:** Implementasi *State Management* Provider dan Notifikasi pada Flutter

---

## 1. Deskripsi Singkat

Aplikasi `counter_provider_app` adalah aplikasi Flutter satu halaman yang menampilkan
nilai *counter* beserta tombol **Tambah (+)**. Setiap kali tombol ditekan, nilai
counter bertambah 1 dan sebuah notifikasi muncul dengan judul **"Counter Update"** dan
pesan **"Nilai counter saat ini: X"** (X = nilai terbaru). Tersedia pula tombol **Reset**
untuk demo.

## 2. Cara Kerja Provider (Modul 13)

State counter dikelola oleh kelas `CounterProvider` yang meng-*extends* `ChangeNotifier`
(`lib/providers/counter_provider.dart`):

- Nilai disimpan pada variabel privat `int _count = 0` dan hanya bisa dibaca lewat
  getter `count`, sehingga perubahan terkontrol melalui method.
- Method `increment()` menjalankan `_count++` lalu memanggil **`notifyListeners()`**.
  Pemanggilan inilah yang memberi tahu semua widget pendengar bahwa state berubah.
- `reset()` mengembalikan nilai ke 0 dengan pola yang sama.

Provider didaftarkan di `main.dart` menggunakan **`ChangeNotifierProvider`** yang
membungkus `MyApp`, sehingga satu instance `CounterProvider` tersedia untuk seluruh
*widget tree*:

```dart
ChangeNotifierProvider(
  create: (_) => CounterProvider(),
  child: const MyApp(),
);
```

Pada UI:
- **Membaca + mendengarkan:** kartu nilai counter dibungkus `Consumer<CounterProvider>`,
  jadi **hanya bagian itu** yang di-*rebuild* saat nilai berubah (efisien).
- **Aksi tanpa rebuild:** tombol memakai `context.read<CounterProvider>().increment()`
  / `.reset()` untuk memanggil method tanpa ikut mendengarkan perubahan.

Alur: tekan tombol → `increment()` → `notifyListeners()` → `Consumer` rebuild →
angka di layar otomatis ter-update.

## 3. Cara Kerja Notifikasi (Modul 12)

Aplikasi dijalankan di **Chrome (web)**, sehingga notifikasi tingkat sistem
menggunakan **browser Notification API** sebagai padanan *Local Notification*
(`lib/services/notification_web.dart`):

- `requestPermission()` memanggil `web.Notification.requestPermission()` untuk meminta
  izin notifikasi ke browser (dipanggil saat halaman pertama tampil via
  `initState` + `addPostFrameCallback`).
- `show(title, body)` membuat `web.Notification(...)` — notifikasi muncul di tingkat
  OS, di luar jendela aplikasi — hanya bila izin sudah `granted`.

Agar aman lintas-platform dipakai **conditional import** pada
`notification_service.dart`: implementasi web dipakai saat tersedia
`dart.library.js_interop`, selain itu memakai *stub no-op* (`notification_stub.dart`)
supaya build di Android/iOS/desktop tetap berhasil.

Saat tombol **Tambah** ditekan (`_handleIncrement` di `main.dart`), berurutan terjadi:
1. `counter.increment()` — nilai bertambah lewat Provider.
2. `NotificationService.show("Counter Update", "Nilai counter saat ini: X")` —
   notifikasi browser.
3. **SnackBar** in-app (`ScaffoldMessenger`) sebagai notifikasi cadangan yang selalu
   terlihat, berisi judul dan pesan yang sama.

## 4. Kesimpulan

Provider (`ChangeNotifier` + `notifyListeners`) memisahkan logika state dari tampilan
dan membuat UI bereaksi otomatis terhadap perubahan, sedangkan mekanisme notifikasi
memberi umpan balik ke pengguna setiap counter bertambah — sesuai seluruh ketentuan
tugas Modul 12 & 13.
