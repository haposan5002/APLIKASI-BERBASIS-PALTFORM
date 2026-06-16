/// Stub no-op untuk platform non-web (Android/iOS/desktop).
///
/// Menjaga agar kode tetap ter-compile di semua platform. Pada perangkat
/// mobile, padanan notifikasi lokal adalah package `flutter_local_notifications`;
/// untuk tugas ini aplikasi dijalankan di Chrome sehingga dipakai
/// implementasi web (lihat `notification_web.dart`).
class NotificationService {
  static Future<bool> requestPermission() async => false;

  static String get permission => 'default';

  static void show(String title, String body) {
    // Tidak melakukan apa-apa di platform non-web.
  }
}
