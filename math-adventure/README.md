# Math-Adventure MVP v0.9

Prototipe game edukasi tower defense mobile untuk Godot 4.7.2. Aset visual PNG sengaja ditunda; ilustrasi prosedural tetap menjadi fallback.

## Fokus v0.9

- UI mobile yang lebih responsif untuk panel menu dan soal.
- Jawaban matematika dalam grid dua kolom dengan target sentuh lebih besar.
- Mekanik energi, soal on-demand, Guardian, drag-and-drop, wave, serta menang/kalah dipertahankan.
- Orientasi game dirancang untuk landscape.

## Cara menjalankan

1. Buka `project.godot` melalui Godot 4.7.2.
2. Tekan `F5`.
3. Uji menu, panel soal, penempatan Guardian, tiga wave, dan hasil permainan.

## Struktur

- `scenes/`: scene menu dan battle.
- `scripts/domain/`: generator soal.
- `scripts/presentation/`: UI, arena, input dan alur battle.
- `data/`: data soal.
- `assets/`: lokasi aset orisinal saat dibuat nanti.
- `docs/original/`: dokumen desain awal.

Lihat `docs/CHANGELOG_MVP_0.9_MOBILE_USABILITY.md` dan `docs/ANDROID_EXPORT_GUIDE.md` untuk langkah pengujian.


## Guardian Aktif v1.3

Build ini mengaktifkan keenam Guardian: Plusy, Addy Cannon, Shield Cube, Multiply Dragon, Fraction Fairy, dan Number Knight. Ringkasan harga, HP, dan kemampuan ada di `docs/CHANGELOG_MVP_1.3_SIX_GUARDIANS.md`.
