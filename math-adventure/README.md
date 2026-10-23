# Math-Adventure

Math-Adventure adalah game edukasi matematika bergaya lane-defense untuk Godot 4.7.2. Pemain menjawab soal, mengumpulkan Math Energy, lalu menempatkan Math Guardian untuk melindungi Core Numeria.

## Menjalankan game

1. Buka Godot Project Manager.
2. Pilih **Import** dan pilih `project.godot` di folder proyek ini jika proyek belum muncul di daftar.
3. Buka proyek, tunggu Godot menyelesaikan impor, lalu tekan **F5**.

## Fitur MVP 0.4

- Menu utama berbahasa Indonesia dengan panduan bermain dan rekor skor terbaik.
- Layar 1280 × 720, dengan pengaturan layar yang dapat diperbesar.
- Arena 3 jalur dan 6 kolom dengan highlight petak saat mouse diarahkan untuk menempatkan Guardian.
- Petak terisi diberi highlight merah saat diarahkan, petak kosong diberi highlight hijau.
- Meter visual untuk kekuatan Core dan Math Energy, serta informasi progres wave, musuh yang sudah muncul, musuh yang dikalahkan, dan akurasi jawaban.
- Soal penjumlahan dan pengurangan dengan empat pilihan jawaban.
- Kesulitan soal meningkat setiap wave: mudah, sedang, lalu sulit.
- Reward jawaban benar mengikuti kesulitan: +30, +50, dan +80 Math Energy.
- Jawaban salah menampilkan kembali operasi dan hasil yang benar sebagai umpan balik belajar.
- Combo tiga jawaban benar berturut-turut memberi bonus +10 energi.
- Plusy menghasilkan +5 energi setiap 5 detik.
- Addy Cannon menembakkan proyektil yang terlihat dan memberi 10 damage.
- Shield Cube memiliki 300 HP dan menahan musuh pada jalurnya.
- Tiga wave dengan 18 musuh total, termasuk Error Blob, Minus Monster, dan Calculator Bug.
- Minus Monster mengurangi energi jika mencapai Core; Calculator Bug bergerak lebih cepat.
- Tombol jeda, skor, statistik musuh, akurasi, layar menang/kalah, dan tombol main lagi.
- Rekor skor terbaik disimpan lokal di `user://math_adventure.cfg`.
- Animasi idle ringan untuk Guardian dan musuh agar arena terasa hidup.
- Efek visual prosedural untuk penempatan Guardian, tembakan, benturan, musuh kalah, dan kerusakan Core.
- Pop-up energi dan skor yang muncul langsung di arena sebagai umpan balik aksi pemain.
- Proyektil memiliki cahaya dan jejak yang lebih jelas.
- Visual arena dan karakter dibuat menggunakan kode. Tidak membutuhkan aset PvZ atau unduhan eksternal.

## Kontrol

1. Pilih salah satu jawaban matematika di panel kanan.
2. Pilih Guardian yang tersedia sesuai energi.
3. Arahkan mouse ke petak kosong untuk melihat highlight hijau, lalu klik untuk menempatkan Guardian.
4. Petak yang sudah ditempati ditandai merah ketika diarahkan.
5. Gunakan **Jeda/Lanjut** untuk menghentikan atau melanjutkan simulasi.
6. Lindungi Core Numeria hingga seluruh wave selesai.

## Struktur

- `scenes/`: scene Godot.
- `scripts/presentation/`: menu, arena, dan battle.
- `scripts/domain/`: pembuat soal dan aturan matematika.
- `data/`: contoh bank soal.
- `assets/`: aset orisinal tambahan bila diperlukan.
- `resources/`: resource Godot untuk data karakter/level jika ditambahkan.
- `docs/`: dokumentasi proyek dan dokumen desain asli.

## Git dan backup

Folder `.godot/` berisi cache lokal Godot dan dikecualikan oleh `.gitignore`. Jangan membuat repository Git baru di dalam folder proyek karena repository induk sudah berada di `Pengantar-Game`.

Setelah fitur penting berhasil diuji, buat commit di GitHub Desktop dan klik **Push origin** untuk mengirim checkpoint ke GitHub.

## Catatan pengujian

Paket ini telah ditinjau secara statis, tetapi tetap perlu dijalankan di Godot 4.7.2 untuk memverifikasi perubahan tampilan dan penyimpanan skor. Jika muncul error, periksa tab Debugger dan simpan teks errornya sebelum melanjutkan.
