# Math-Adventure

Prototype MVP game edukasi matematika berbasis lane defense, dibuat untuk Godot 4.7.2.

## Menjalankan game

1. Buka Godot Project Manager.
2. Klik **Import**.
3. Pilih file `project.godot` di folder proyek ini.
4. Buka proyek, tunggu Godot menyelesaikan impor, lalu tekan **F6** atau **F5**. Gunakan F5 untuk menjalankan scene utama.

## Fitur yang sudah ada

- Menu utama berbahasa Indonesia.
- Arena 3 jalur dan 6 kolom penempatan Guardian.
- Soal acak penjumlahan dan pengurangan dengan empat pilihan jawaban.
- Jawaban benar memberi 30 Math Energy, jawaban salah memberi 10 Math Energy.
- Guardian: Plusy (generator energi), Addy Cannon (penyerang jarak jauh), Shield Cube (penghalang).
- Tiga wave dengan Error Blob dan Minus Monster.
- Core Numeria, kondisi menang/kalah, dan tombol main ulang.
- Seluruh grafis MVP digambar menggunakan kode. Tidak membutuhkan aset PvZ.

## Kontrol

1. Jawab soal di panel kanan untuk mendapatkan energi.
2. Pilih Guardian di panel kanan.
3. Klik petak di arena untuk menempatkannya.
4. Pertahankan Core Numeria sampai semua wave selesai.

## Struktur

- `scenes/`: scene Godot.
- `scripts/presentation/`: menu, arena, dan tampilan battle MVP.
- `scripts/domain/`: pembuat soal matematika.
- `data/`: contoh bank soal untuk pengembangan berikutnya.
- `docs/`: dokumen desain awal.

## Catatan

Ini adalah MVP awal yang dapat dikembangkan. Mekanik dan tampilan dapat disesuaikan dengan GDD. Belum ada ekspor Android/iOS yang disiapkan.
