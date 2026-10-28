# Math-Adventure v1.9 — Easy Mode & Game Balance

## Tujuan
Mengurangi beban strategi untuk pemain anak SD dengan tempo lebih lambat, energi lebih ramah, dan pola jalur yang bisa dipelajari.

## Perubahan
- Energi awal: 220 (sebelumnya 150).
- Harga Guardian diturunkan: Plusy 35, Addy 70, Shield 50, Dragon 95, Fairy 85, Knight 85.
- Wave berisi 3, 4, dan 5 musuh.
- Jarak spawn diperlebar menjadi sekitar 4.2 / 3.9 / 3.6 detik.
- Jalur wave 1 hanya baris tengah; wave 2 memakai baris tengah dan dua baris di sebelahnya; wave 3 menggunakan pola tetap yang mencakup semua baris.
- Kecepatan musuh diturunkan; musuh khusus hanya muncul di wave terakhir.
- Damage musuh ke Guardian diturunkan menjadi 6 (Shield menerima 4); damage ke Core diturunkan menjadi 5–6.
- Minus Monster tidak lagi mengurangi energi saat berhasil mencapai Core.
- Plusy menghasilkan 8 energi setiap 4.5 detik.
- Regenerasi pasif 5 energi setiap 7 detik selama permainan aktif.
- Jawaban salah tetap memberi 15 energi dan menampilkan feedback yang mendukung belajar.
- Damage Guardian sedikit diseimbangkan ulang: Addy 15, Dragon 20, Knight 20.

## Catatan
Dibuat dari proyek Math-Adventure v1.8. Jalankan di Godot 4.7.2 untuk validasi parser dan runtime sebelum ekspor APK.

- Soal wave terakhir memakai rentang operand 5–15 (bukan 10–30) agar transisi kesulitan lebih lembut.
