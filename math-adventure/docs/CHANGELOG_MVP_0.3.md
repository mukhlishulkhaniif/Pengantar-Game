# Changelog MVP 0.3

## Perubahan

- Menambahkan meter visual kekuatan Core dan Math Energy.
- Menambahkan ringkasan progres wave, jumlah musuh yang sudah muncul, musuh yang dikalahkan, dan akurasi jawaban.
- Menambahkan highlight hover hijau untuk petak kosong dan merah untuk petak yang sudah ditempati saat memilih Guardian.
- Menambahkan garis arah gerak yang halus dan cahaya lembut di sekitar Core.
- Jawaban salah kini menampilkan ulang operasi lengkap beserta hasil yang benar sebagai umpan balik pembelajaran.
- Menyimpan rekor skor terbaik secara lokal menggunakan `ConfigFile` di `user://math_adventure.cfg`.
- Menampilkan rekor skor terbaik di menu utama.
- Memperbarui label versi menjadi 0.3.

## Yang dipertahankan

- Scene utama, alur menu dan battle, 3 jalur, 6 kolom, 3 wave, serta ketiga tipe Guardian.
- Struktur repository dan dokumen rancangan asli.
- Seluruh visual tetap orisinal dan digambar melalui GDScript.

## Pengujian yang diperlukan

Jalankan di Godot 4.7.2, periksa highlight petak, progress meter, jawaban salah, hasil akhir, dan apakah rekor skor tetap muncul setelah game ditutup lalu dibuka kembali.
