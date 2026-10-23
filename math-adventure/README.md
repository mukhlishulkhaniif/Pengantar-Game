# Math-Adventure

Math-Adventure adalah game edukasi matematika tower defense untuk perangkat mobile, dibuat dengan Godot 4.7.2. Pemain menjawab soal, mengumpulkan Math Energy, lalu menempatkan Math Guardian untuk melindungi Core Numeria.

## Target perangkat

- Fokus utama: Android.
- Orientasi: landscape (horizontal), sesuai permainan lane-defense.
- Semua interaksi utama memakai sentuhan layar. Tidak diperlukan keyboard.
- Resolusi dasar 1280 × 720 dengan pengaturan stretch agar menyesuaikan layar.

## Menjalankan game di Godot

1. Buka Godot Project Manager.
2. Pilih **Import** dan pilih `project.godot` di folder proyek ini jika proyek belum muncul di daftar.
3. Buka proyek, tunggu Godot menyelesaikan impor, lalu tekan **F5** untuk pengujian di komputer.
4. Untuk mencoba di Android, siapkan Android export template, JDK, Android SDK, lalu atur ekspor melalui Godot Editor Settings dan Project > Export. Petunjuk tersedia di `docs/ANDROID_EXPORT_GUIDE.md`.

## Fitur MVP 0.6 Mobile UI

- Menu utama ringkas berbahasa Indonesia dengan panduan singkat dan rekor skor terbaik.
- Arena 3 jalur dan 6 kolom dengan petak sentuh untuk menempatkan Guardian.
- Highlight petak hijau saat siap ditempati dan merah untuk petak terisi.
- HUD ringkas: energi, kartu Guardian, wave, dan HP Core. Statistik lengkap ditampilkan setelah permainan.
- Soal penjumlahan dan pengurangan berada pada bilah bawah di luar arena agar tidak menutupi jalur.
- Kesulitan soal meningkat setiap wave: mudah, sedang, lalu sulit.
- Reward jawaban benar mengikuti kesulitan: +30, +50, dan +80 Math Energy.
- Jawaban salah menampilkan kembali operasi dan hasil yang benar.
- Combo tiga jawaban benar berturut-turut memberi bonus +10 energi.
- Plusy menghasilkan +5 energi setiap 5 detik.
- Addy Cannon menembakkan proyektil yang terlihat dan memberi 10 damage.
- Shield Cube memiliki 300 HP dan menahan musuh pada jalurnya.
- Tiga wave dengan 18 musuh total, termasuk Error Blob, Minus Monster, dan Calculator Bug.
- Tombol sentuh ikon jeda dan menu; ukuran kontrol ditingkatkan untuk landscape mobile.
- Rekap akhir menampilkan jumlah jawaban benar, salah, akurasi, serta pembahasan empat jawaban salah terakhir.
- Rekor skor terbaik disimpan lokal di `user://math_adventure.cfg`.
- Animasi dan efek visual prosedural tanpa aset eksternal.

## Kontrol layar sentuh

1. Seret kartu Guardian dari HUD atas ke petak kosong di arena.
2. Alternatif: ketuk kartu Guardian, lalu ketuk petak kosong.
3. Jawab soal pada bilah bawah untuk memperoleh energi.
4. Ketuk ikon jeda untuk menghentikan atau melanjutkan permainan.
5. Ketuk ikon rumah untuk kembali ke menu utama.

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

Setelah fitur penting diuji, buat commit di GitHub Desktop dan klik **Push origin** untuk mengirim checkpoint ke GitHub.

## Status pengujian

Pembaruan layout dan drag-and-drop ditinjau secara statis. Jalankan pada Godot 4.7.2, kemudian uji pada perangkat Android sebelum menganggap build siap dirilis.
