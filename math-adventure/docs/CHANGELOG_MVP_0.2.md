# Math-Adventure MVP 0.2

## Perubahan utama

### Visual dan UI
- Memperjelas panel arena, jalur, petak, Core Numeria, dan label Guardian.
- Menambahkan bentuk visual berbeda untuk Plusy, Addy Cannon, Shield Cube, Error Blob, Minus Monster, dan Calculator Bug.
- Menampilkan proyektil Addy Cannon dan bar HP musuh serta Shield Cube.
- Menambahkan tombol Cara Bermain pada menu.
- Menambahkan tombol jeda, skor, dan statistik hasil akhir.

### Gameplay
- Menyesuaikan wave menjadi 4, 6, dan 8 musuh.
- Memperkenalkan Calculator Bug pada wave ketiga.
- Minus Monster mengurangi 15 Math Energy saat mencapai Core.
- Addy Cannon menembakkan proyektil dengan damage 10.
- Shield Cube memiliki 300 HP dan menahan musuh.
- Skor bertambah saat menjawab benar, mengalahkan musuh, dan menyelesaikan wave.

### Matematika
- Wave 1: soal mudah dengan angka 0–20, reward +30.
- Wave 2: soal sedang dengan angka 10–50, reward +50.
- Wave 3: soal sulit dengan angka 20–100, reward +80.
- Jawaban salah memberi +10 energi dan menampilkan jawaban benar.
- Setiap tiga jawaban benar berturut-turut memberi bonus +10 energi.

## Berkas yang diperbarui

- `project.godot`
- `scripts/domain/question_generator.gd`
- `scripts/presentation/main_menu.gd`
- `scripts/presentation/arena_view.gd`
- `scripts/presentation/battle.gd`
- `README.md`
- `.gitignore`

Dokumen desain awal di `docs/original/` dipertahankan tanpa perubahan.
