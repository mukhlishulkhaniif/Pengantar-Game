# Catatan Implementasi Math-Adventure 0.4

## Sasaran

Memperjelas aksi di arena tanpa mengganti fondasi gameplay yang sudah diuji pada versi sebelumnya.

## File yang diperbarui

- `scripts/presentation/arena_view.gd`: animasi idle, efek visual prosedural, jejak proyektil, efek benturan, dan teks mengambang.
- `scripts/presentation/battle.gd`: memicu efek untuk jawaban matematika, energi, penempatan Guardian, tembakan, kerusakan, wave, dan Core.
- `scripts/presentation/main_menu.gd`: label versi 0.4.
- `README.md`, `project.godot`, dan dokumen changelog: dokumentasi versi 0.4.

## Prinsip teknis

- Tidak menambah ketergantungan aset eksternal.
- Efek dibatasi hingga 36 elemen aktif untuk mencegah penumpukan yang tidak perlu.
- Animasi hanya menggunakan `CanvasItem` drawing dan waktu proses.
- File cache `.godot/` tetap dikecualikan dari Git.

## Pengujian manual

Lihat `CHANGELOG_MVP_0.4.md` untuk daftar pemeriksaan. Jangan anggap versi stabil sebelum diuji pada Godot 4.7.2.


## Revisi HUD v1.1

HUD battle kini menyediakan enam slot Guardian responsif untuk orientasi mobile landscape. Tiga kartu yang telah memiliki mekanik tetap aktif, sementara dua Guardian yang direncanakan di GDD dan satu slot ekspansi ditandai SEGERA hingga implementasi gameplay-nya selesai. Lihat `CHANGELOG_MVP_1.1_HUD_SIX_SLOTS.md`.
