# Perubahan Math-Adventure v0.6: layout ringkas dan drag-and-drop mobile

## Perubahan utama
- HUD pertempuran disederhanakan menjadi energi, tiga kartu Guardian, wave, HP Core, jeda, dan menu.
- Arena mendapat ruang utama; label dan instruksi berulang di dalam arena dihilangkan.
- Bilah soal ditempatkan di bawah arena dengan empat tombol jawaban besar, sehingga tidak menutupi jalur.
- Kartu Guardian dapat diseret ke petak kosong menggunakan mouse saat pengembangan dan sentuhan di Android.
- Ketuk kartu lalu ketuk petak tetap didukung sebagai cara alternatif.
- Pratinjau Guardian mengikuti jari dan petak target memberi tanda hijau atau merah.
- Menu utama dan panduan bermain dipersingkat.
- Struktur folder, nama scene, sistem soal, gelombang, dan mekanik pertempuran dipertahankan.

## Pengujian
- Arsip, referensi file, dan perubahan kode diperiksa secara statis.
- Wajib diuji di Godot 4.7.2: drag kartu ke arena, tap-to-place, jawaban soal, jeda, kemenangan/kekalahan, serta orientasi landscape di perangkat Android.


## Perbaikan v0.6.1

- Mengganti nama fungsi preview drag agar tidak bertabrakan dengan method bawaan `Control.set_drag_preview(Control)` pada Godot 4.7.2.
- Mengganti fungsi pembersihan preview dengan nama khusus proyek.
