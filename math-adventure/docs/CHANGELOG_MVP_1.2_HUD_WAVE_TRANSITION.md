# Math-Adventure MVP v1.2: HUD ringkas dan transisi wave

## Perubahan
- Mengurangi tulisan HUD: wave, jumlah musuh singkat, dan HP Core menggunakan label ringkas.
- Mengganti ruang kosong di tengah HUD dengan panel status wave yang mengisi lebar secara responsif.
- Menampilkan progres tiga wave melalui tiga segmen visual.
- Memperbesar tombol jeda dan menu, memperjelas border, serta menambahkan tooltip.
- Ikon jeda berubah menjadi ikon lanjut saat permainan dijeda.
- Menambahkan banner transisi di tengah layar saat wave dimulai, dengan subtitle pendek dan efek fade-out.
- Menghilangkan teks wave yang berulang di HUD dan efek wave di bagian atas arena.

## Pengujian yang disarankan
1. Buka `project.godot` dengan Godot 4.7.2.
2. Jalankan battle pada orientasi landscape.
3. Periksa enam slot kartu, tracker wave, HP Core, dan tombol jeda/menu.
4. Pastikan banner `WAVE 1`, `WAVE 2`, dan `WAVE 3` tampil di tengah ketika wave dimulai.
5. Periksa tab Debugger sebelum ekspor APK.

Catatan: perubahan kode telah diperiksa secara statis, tetapi belum dijalankan melalui Godot pada lingkungan pembuat paket. Lakukan pengujian lokal sebelum mengganti APK yang sudah berfungsi.
