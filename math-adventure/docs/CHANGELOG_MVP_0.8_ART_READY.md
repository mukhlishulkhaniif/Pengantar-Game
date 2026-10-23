# Math-Adventure MVP v0.8

## Perubahan

- Mengubah UI ke palet vintage: krem, tinta gelap, hijau hutan, dan emas antik.
- Mengurangi tulisan di HUD pertempuran.
- Tombol energi membuka panel tantangan matematika sesuai dokumen UI.
- Battle berhenti sementara saat pemain menjawab soal, lalu berjalan kembali setelah jawaban atau tombol lanjut.
- Memindahkan informasi feedback ringkas ke HUD agar arena lebih luas.
- Menambahkan dukungan pemuatan PNG opsional untuk latar Addition Forest, Guardian, dan musuh.
- Menghapus regenerasi energi global yang tidak sesuai dokumen UI; Plusy tetap menghasilkan +5 energi setiap 5 detik.
- Menambahkan spesifikasi aset dan arah seni vintage di dokumentasi.
- Menjaga fallback prosedural supaya game tetap bisa dijalankan sebelum PNG dibuat.

## Uji manual yang diperlukan

1. Buka menu dan pastikan tombol Mulai/Cara Main bekerja.
2. Di battle, ketuk tombol energi. Panel soal harus muncul dan musuh berhenti bergerak.
3. Jawab benar, pastikan energi bertambah dan panel tertutup.
4. Buka lagi panel, jawab salah, pastikan hasil benar ditampilkan pada status dan panel tertutup.
5. Tutup panel dengan tombol Lanjut Bermain tanpa mendapat reward.
6. Tempatkan Guardian melalui drag-and-drop dan ketuk kartu lalu petak.
7. Uji tiga wave, kondisi menang/kalah, dan tombol jeda/menu.
8. Pastikan tidak ada parser error pada Godot 4.7.2.

Catatan: paket ini diperiksa secara statis. Pengujian runtime di Godot dan Android belum dilakukan dari lingkungan pembuat paket.
