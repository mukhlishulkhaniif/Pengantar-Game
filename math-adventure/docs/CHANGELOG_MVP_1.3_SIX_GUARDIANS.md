# Math-Adventure MVP v1.3 — Enam Guardian Aktif

## Tujuan
Mengubah keenam kartu Guardian dari tiga kartu aktif dan tiga placeholder menjadi enam unit yang benar-benar dapat dipilih, di-drag ke grid 5×9, dibeli menggunakan Math Energy, dan memengaruhi pertarungan.

## Daftar Guardian

| Guardian | Harga | HP | Peran | Kemampuan |
|---|---:|---:|---|---|
| Plusy | 50 | 180 | Penghasil energi | Menghasilkan +5 energi setiap 5 detik. |
| Addy Cannon | 100 | 170 | Penyerang jarak jauh | Menembakkan orb ke satu musuh dalam jalur yang sama; 18 damage, jeda 0,9 detik. |
| Shield Cube | 75 | 480 | Tank | Menerima 8 damage dari serangan monster dan memantulkan 6 damage. |
| Multiply Dragon | 140 | 190 | Penyerang area | Menembakkan bola api yang memberi 24 damage ke musuh dekat pada jalur target dan jalur di sebelahnya. |
| Fraction Fairy | 125 | 160 | Pendukung/penyembuh | Memulihkan hingga 28 HP Guardian terdekat dalam jangkauan 2 kolom dan 1 jalur setiap 3,5 detik. |
| Number Knight | 125 | 250 | Petarung jarak dekat | Membalas musuh yang sedang menyerangnya dengan 26 damage setiap 0,82 detik. |

## Aturan umum
- Semua Guardian menempati satu petak dan memiliki bar HP.
- Monster berhenti di depan Guardian, menyerangnya, lalu melanjutkan perjalanan setelah Guardian hancur.
- Guardian penyerang memilih musuh terdekat di jalur yang sama.
- Guardian dapat dipilih dengan mengetuk kartu atau ditempatkan melalui drag-and-drop.
- Visual orisinal prosedural menjadi fallback; PNG karakter dapat ditambahkan kemudian tanpa mengubah sistem battle.

## Pengujian lokal
1. Buka `project.godot` dengan Godot 4.7.2.
2. Jalankan scene battle dalam orientasi landscape.
3. Pastikan keenam kartu dapat dipilih ketika energi cukup dan ditempatkan di petak kosong.
4. Uji kemampuan Plusy, Addy Cannon, Shield Cube, Multiply Dragon, Fraction Fairy, dan Number Knight.
5. Periksa tab Debugger untuk error sebelum ekspor APK Android.

Catatan: kode paket diperiksa secara statis di lingkungan pembuat paket, tetapi belum dieksekusi melalui Godot. Pengujian lokal tetap diperlukan sebelum mengganti APK yang sudah berfungsi.
