/// Facade notifikasi yang aman lintas-platform.
///
/// Menggunakan **conditional import**: saat aplikasi di-compile untuk web
/// (`dart.library.js_interop` tersedia), dipakai implementasi browser
/// Notification API di `notification_web.dart`. Di platform lain dipakai
/// stub no-op agar build tetap berhasil (mobile cukup andalkan banner in-app).
library;

export 'notification_stub.dart'
    if (dart.library.js_interop) 'notification_web.dart';
