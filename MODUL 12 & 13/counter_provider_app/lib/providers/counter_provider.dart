import 'package:flutter/foundation.dart';

/// CounterProvider — kelas state management menggunakan [ChangeNotifier].
///
/// Bertugas **menyimpan dan mengelola** nilai counter (Modul 13). Setiap kali
/// nilai berubah, [notifyListeners] dipanggil sehingga seluruh widget yang
/// "mendengarkan" provider ini (lewat `context.watch` / `Consumer`) otomatis
/// di-rebuild dengan nilai terbaru.
class CounterProvider extends ChangeNotifier {
  /// Nilai counter — disimpan privat agar hanya bisa diubah lewat method.
  int _count = 0;

  /// Getter publik untuk dibaca oleh UI.
  int get count => _count;

  /// Menambah nilai counter sebanyak 1, lalu memberi tahu para listener.
  void increment() {
    _count++;
    notifyListeners();
  }

  /// Mengembalikan nilai counter ke 0 (fitur tambahan untuk kemudahan demo).
  void reset() {
    _count = 0;
    notifyListeners();
  }
}
