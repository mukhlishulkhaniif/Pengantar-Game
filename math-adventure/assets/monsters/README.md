# Aset Monster Math-Adventure

Letakkan tiga PNG transparan di folder ini. Nama file harus persis:

- `error_blob.png`
- `minus_monster.png`
- `calculator_bug.png`

## Spesifikasi gambar
- PNG RGBA dengan background transparan.
- Kanvas persegi 512 × 512 px (boleh 1024 × 1024 px jika detail diperlukan).
- Karakter penuh terlihat, termasuk kaki, tanduk, antena, atau aksesori.
- Sisakan margin transparan sekitar 8–12% dari tepi kanvas agar tidak terpotong saat animasi.
- Menghadap ke kiri (arah berjalan menuju Core di sisi kiri arena).
- Gaya kartun vintage 1930-an, outline tinta gelap yang tegas, bentuk sederhana, ekspresi ekspresif.
- Hindari bayangan/background berbentuk kotak yang menyatu dengan gambar; hanya karakter yang transparan.
- Jangan memasukkan HP bar, angka damage, atau lingkaran bayangan ke dalam PNG; semua itu digambar oleh game.

## Peran desain
- **Error Blob:** monster dasar, bentuk bulat/lentur, ekspresi nakal.
- **Minus Monster:** monster tank lebih besar, bentuk bersudut/berduri, tampak kokoh.
- **Calculator Bug:** monster kecil mirip serangga kalkulator, antena dan detail tombol sederhana.

## Cara kerja di game
`arena_view.gd` memuat file-file ini secara opsional. Jika PNG belum ada, game tetap berjalan memakai gambar prosedural bawaan. Rasio gambar dijaga otomatis supaya sprite tidak terdistorsi. Animasi berjalan, pantulan, dan kilatan ketika terkena damage tetap diterapkan pada PNG.
