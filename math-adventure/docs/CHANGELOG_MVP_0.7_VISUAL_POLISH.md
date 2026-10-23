# Math-Adventure v0.7: Poles Visual dan Animasi Mobile

## Tujuan
Membuat arena terasa lebih hidup tanpa menambah panel teks atau mengubah loop permainan inti.

## Perubahan
- Latar kebun berlapis dengan variasi rumput, bunga, garis jalur, bingkai tanah, dan gerbang Core Numeria.
- Desain karakter prosedural ditingkatkan dengan detail daun, kelopak, wajah, laras meriam, sisi kubus, kaki, dan antena.
- Animasi ringan untuk goyangan karakter, langkah musuh, kelopak bunga, dan denyut proyektil.
- Efek penempatan, tembakan, benturan, musuh kalah, bonus energi, dan awal wave diperjelas.
- Penanda petak tetap hijau/merah untuk membantu drag-and-drop di layar sentuh.
- Tidak menambahkan ketergantungan aset eksternal; gambar karakter dibuat dengan drawing API Godot.
- Tidak mengubah sistem energi, generator soal, wave, atau struktur scene.

## Checklist pengujian manual
- [ ] Proyek terbuka di Godot 4.7.2 tanpa parser error.
- [ ] Menu utama dapat memulai battle.
- [ ] Drag kartu Guardian dan tap-to-place berfungsi.
- [ ] Petak terisi diberi penanda merah dan petak kosong hijau.
- [ ] Proyektil mengenai musuh dan efek benturan terlihat.
- [ ] Plusy, Addy Cannon, Shield Cube, dan ketiga jenis musuh tergambar dengan benar.
- [ ] Jawaban soal tetap menambah energi dan menghasilkan umpan balik.
- [ ] Jeda, kemenangan, kekalahan, dan kembali ke menu tetap berfungsi.
- [ ] Game diuji dalam orientasi landscape di Android.

## Catatan
Kode dan arsip diperiksa secara statis. Versi ini belum dijalankan di editor Godot dari lingkungan pembuatan paket. Uji manual diperlukan sebelum commit sebagai versi stabil.
