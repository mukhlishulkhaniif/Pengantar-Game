# Catatan Implementasi MVP

Dokumen desain asli tetap disimpan di folder ini. MVP awal sengaja dibuat sederhana agar bisa langsung diuji sebelum semua sistem arsitektur diperluas.

## Mekanik MVP

- Arena memiliki 3 jalur dan 6 kolom.
- Pemain mulai dengan 100 Math Energy dan Core Numeria 100 HP.
- Jawaban benar memberi +30 energi; setiap combo ketiga memberi bonus +10.
- Jawaban salah tetap memberi +10 energi untuk menjaga pemain pemula tetap bisa melanjutkan.
- Plusy berharga 50 dan menghasilkan +5 energi setiap 5 detik.
- Addy Cannon berharga 100 dan menyerang musuh pada jalur yang sama.
- Shield Cube berharga 75, memiliki 300 HP, dan menghalangi musuh.
- Ada 3 wave dengan 3, 4, dan 5 musuh.
- Minus Monster mulai muncul pada wave kedua.

## Batasan yang diketahui

Ini prototype pertama, bukan versi rilis. Belum tersedia animasi karakter berbasis sprite, efek suara, sistem simpan progres, peta dunia, upgrade Guardian, maupun paket ekspor mobile. Tampilan arena dibuat menggunakan fungsi gambar Godot agar tidak bergantung pada aset eksternal.
