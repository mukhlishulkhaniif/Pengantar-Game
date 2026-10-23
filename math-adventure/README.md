# Math-Adventure

Math-Adventure adalah game edukasi matematika tower defense untuk Android, dibuat dengan Godot 4.7.2. Pemain menggunakan Math Energy untuk memanggil Guardian dan menjawab tantangan matematika saat membutuhkan energi.

## Target perangkat

- Fokus utama: Android.
- Orientasi: landscape (horizontal).
- Interaksi utama menggunakan layar sentuh.
- Resolusi dasar: 1280 × 720 dengan stretch agar menyesuaikan layar.

## Menjalankan proyek

1. Buka Godot Project Manager.
2. Pilih **Import** dan pilih `project.godot` di folder ini jika proyek belum terdaftar.
3. Buka proyek, tunggu proses impor selesai, lalu tekan **F5**.
4. Petunjuk ekspor Android ada di `docs/ANDROID_EXPORT_GUIDE.md`.

## Fitur versi 0.8

- Menu ringkas dengan palet vintage: krem, tinta gelap, hijau hutan, dan emas antik.
- HUD seed-bank sederhana dengan tombol energi, tiga kartu Guardian, wave, HP Inti, jeda, dan menu.
- Tantangan matematika hanya muncul ketika pemain mengetuk tombol energi. Permainan berhenti sementara agar pemain bisa menjawab tanpa tekanan.
- Empat pilihan jawaban. Jawaban benar memberi energi sesuai kesulitan, jawaban salah tetap memberi +10 energi dan menampilkan hasil benar pada status.
- Arena tiga jalur dan enam kolom.
- Guardian dapat ditempatkan dengan drag-and-drop atau mengetuk kartu lalu petak.
- Plusy menghasilkan +5 energi setiap 5 detik. Addy Cannon menembakkan proyektil. Shield Cube menahan musuh.
- Tiga wave dengan total 18 musuh, termasuk Error Blob, Minus Monster, dan Calculator Bug.
- Jeda, kembali ke menu, rekap akhir, pembahasan soal salah, dan rekor skor lokal.
- Loader aset PNG opsional. Jika file PNG belum tersedia, game menggunakan ilustrasi prosedural sebagai fallback.

## Arah visual

Arah seni versi berikutnya adalah kartun tinta klasik era 1930-an dengan desain karakter orisinal. Nuansanya mengambil inspirasi dari teknik animasi vintage, bukan menyalin karakter, logo, atau aset dari game lain. Dunia tetap bertema Addition Forest.

Lihat `docs/ART_DIRECTION_V0.8.md` untuk palet warna, daftar nama file aset, ukuran yang disarankan, dan panduan penempatan.

## Lokasi aset PNG

- Latar arena: `assets/backgrounds/addition_forest_bg.png`
- Guardian: `assets/characters/plusy.png`, `addy_cannon.png`, `shield_cube.png`
- Musuh: `assets/characters/error_blob.png`, `minus_monster.png`, `calculator_bug.png`

Loader akan memakai file PNG jika sudah tersedia. File tersebut belum disertakan dalam paket v0.8. Sampai aset dibuat, ilustrasi prosedural tetap digunakan sebagai fallback.

## Struktur proyek

- `scenes/`: scene Godot.
- `scripts/presentation/`: menu, arena, dan battle.
- `scripts/domain/`: generator soal dan aturan matematika.
- `data/`: bank soal.
- `assets/`: gambar, font, dan audio.
- `resources/`: resource Godot.
- `docs/`: dokumentasi dan dokumen desain asli.

## GitHub backup

Repository Git tetap berada di folder induk `Pengantar-Game`. Jangan membuat repository baru di dalam folder proyek. Folder `.godot/` dikecualikan oleh `.gitignore`.

Setelah versi diuji, buat commit di GitHub Desktop dan klik **Push origin**.

## Status pengujian

Struktur arsip, file konfigurasi, referensi scene, dan perubahan script sudah diperiksa secara statis. Proyek belum dijalankan langsung di editor Godot 4.7.2 pada lingkungan pembuatan paket ini. Uji menu, tantangan energi, penempatan Guardian, wave, dan kondisi menang/kalah sebelum menyimpan checkpoint.
