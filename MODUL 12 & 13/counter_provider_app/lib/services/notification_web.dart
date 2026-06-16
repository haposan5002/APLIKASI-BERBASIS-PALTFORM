import 'dart:js_interop';
import 'package:web/web.dart' as web;

/// Implementasi notifikasi untuk platform **web (Chrome)** menggunakan
/// browser Notification API. Inilah padanan "Local Notification" di web —
/// notifikasi tampil di tingkat sistem operasi, di luar jendela aplikasi.
class NotificationService {
  /// Meminta izin notifikasi ke browser. Idempotent: jika izin sudah
  /// diberikan/ditolak, browser langsung mengembalikan status tersebut.
  /// Mengembalikan `true` bila izin diberikan (`granted`).
  static Future<bool> requestPermission() async {
    final result = await web.Notification.requestPermission().toDart;
    return result.toDart == 'granted';
  }

  /// Status izin saat ini: 'default', 'granted', atau 'denied'.
  static String get permission => web.Notification.permission;

  /// Menampilkan notifikasi browser dengan [title] dan [body].
  /// Hanya tampil bila izin sudah `granted`.
  static void show(String title, String body) {
    if (web.Notification.permission == 'granted') {
      web.Notification(
        title,
        web.NotificationOptions(
          body: body,
          icon: 'icons/Icon-192.png',
        ),
      );
    }
  }
}
