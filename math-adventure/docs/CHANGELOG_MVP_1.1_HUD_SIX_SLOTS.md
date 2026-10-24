# Math-Adventure MVP v1.1: perbaikan HUD enam slot Guardian

## Perubahan HUD

- Bar atas dirapikan untuk orientasi ponsel landscape.
- Kartu Guardian dipadatkan dan memakai ukuran responsif terhadap lebar layar.
- Energi, wave, kesehatan Core, jeda, dan menu tetap memiliki ruang tersendiri.
- HUD menampilkan enam slot kartu agar layout tidak perlu dirombak saat roster bertambah.
- Plusy, Addy Cannon, dan Shield Cube tetap aktif.
- Multiply Dragon dan Fraction Fairy ditampilkan sebagai Guardian rencana dari GDD; slot keenam menjadi tempat ekspansi. Ketiganya sengaja dinonaktifkan karena kemampuan dan logika gameplay-nya belum diimplementasikan.
- Tooltip kartu disederhanakan. Tombol yang belum tersedia tidak dapat dipilih atau diseret.

## Pemeriksaan

1. Buka proyek dengan Godot 4.7.2.
2. Pastikan bar atas menampilkan enam slot tanpa saling bertumpuk.
3. Pastikan tiga kartu aktif dapat dipilih dan diseret ke arena.
4. Pastikan tiga slot bertanda SEGERA tidak dapat dipilih.
5. Uji pada orientasi landscape di HP. Jika teks masih terasa kecil, kirim screenshot resolusi layar agar ukuran bisa disesuaikan.

Catatan: perubahan disiapkan dan diperiksa secara statis. Godot tidak tersedia di lingkungan pembuatan paket, jadi parser dan runtime tetap perlu diuji di Godot lokal sebelum APK dibuat.
