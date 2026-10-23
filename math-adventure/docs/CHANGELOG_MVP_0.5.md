# Changelog Math-Adventure MVP 0.5

## Fokus versi

Versi 0.5 menambahkan kemudahan kontrol dan umpan balik belajar setelah permainan selesai. Mekanik utama versi 0.4 dipertahankan.

## Perubahan

- Pintasan keyboard 1, 2, dan 3 untuk memilih Plusy, Addy Cannon, dan Shield Cube.
- Tombol Escape untuk menjeda atau melanjutkan permainan.
- Pemilihan Guardian lewat keyboard memberi umpan balik saat energi belum mencukupi.
- Riwayat jawaban disimpan selama satu sesi permainan.
- Layar hasil menampilkan jumlah jawaban benar, salah, skor, musuh yang dikalahkan, dan akurasi.
- Tombol pembahasan menampilkan hingga empat jawaban salah terakhir beserta jawaban yang benar.
- Panduan kontrol dan nomor versi diperbarui.

## Struktur yang dipertahankan

- Repository tetap menggunakan `Pengantar-Game`, dengan proyek di `math-adventure/`.
- Scene, skrip generator soal, tiga jalur, enam kolom, tiga Guardian, dan tiga wave tetap dipertahankan.
- Tidak ada aset eksternal yang diperlukan.

## Pengujian manual yang disarankan

1. Jalankan dengan F5 dan mulai permainan.
2. Tekan 1, 2, atau 3 untuk memilih Guardian.
3. Tekan Esc untuk menjeda dan melanjutkan permainan.
4. Jawab beberapa soal dengan benar dan salah.
5. Selesaikan permainan, buka pembahasan soal, lalu pastikan rekap benar/salah tampil.
6. Periksa tab Debugger dan pastikan tidak ada error merah.

Paket telah diperiksa secara statis. Jalankan di Godot 4.7.2 sebelum melakukan commit ke GitHub.
