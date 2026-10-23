# Math-Adventure MVP 0.5.1 Mobile

## Tujuan

Mengoreksi arah pengembangan agar Math-Adventure diprioritaskan untuk perangkat mobile, dengan Android sebagai target pertama.

## Perubahan

- Menghapus ketergantungan panduan pada pintasan keyboard 1/2/3 dan Escape.
- Memperbarui panduan agar seluruh alur menggunakan ketukan layar.
- Memperbesar target sentuh pilihan jawaban, tombol Guardian, jeda, dan menu.
- Memperbarui instruksi arena menjadi instruksi ketuk petak kosong.
- Memperbarui dokumentasi target perangkat: landscape dan Android-first.
- Mempertahankan mekanik permainan, nama scene, struktur folder, dan format repository.
- Orientasi handheld tetap landscape (`window/handheld/orientation=0`).

## Uji manual

1. Jalankan proyek di Godot 4.7.2 dan pastikan menu tampil.
2. Buka panduan bermain dan pastikan tidak ada instruksi keyboard.
3. Mulai permainan, jawab soal dengan mengetuk pilihan.
4. Pilih Guardian dan ketuk petak kosong.
5. Uji JEDA/LANJUT, MENU, menang/kalah, dan pembahasan.
6. Ekspor dan uji APK pada perangkat Android setelah Android SDK/JDK dan export templates dikonfigurasi.

Paket ini telah diperiksa secara statis, tetapi belum dijalankan pada perangkat Android fisik.
