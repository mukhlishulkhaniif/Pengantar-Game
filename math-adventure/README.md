# Math-Adventure

Math-Adventure adalah game edukasi matematika bergaya lane-defense untuk Godot 4.7.2. Pemain menjawab soal, mengumpulkan Math Energy, lalu menempatkan Math Guardian untuk melindungi Core Numeria.

## Menjalankan game

1. Buka Godot Project Manager.
2. Pilih **Import** dan pilih `project.godot` di folder proyek ini jika proyek belum muncul di daftar.
3. Buka proyek, tunggu Godot menyelesaikan impor, lalu tekan **F5**.

## Fitur MVP 0.2

- Menu utama bahasa Indonesia dengan panduan cara bermain.
- Layar 1280 × 720 dan jendela yang terbuka maksimal.
- Arena 3 jalur dan 6 kolom untuk menempatkan Guardian.
- Soal penjumlahan dan pengurangan dengan empat pilihan jawaban.
- Kesulitan soal meningkat setiap wave: mudah, sedang, lalu sulit.
- Reward jawaban benar mengikuti kesulitan: +30, +50, dan +80 Math Energy.
- Jawaban salah tetap memberi +10 energi dan menampilkan jawaban yang benar.
- Combo tiga jawaban benar berturut-turut memberi bonus +10 energi.
- Plusy menghasilkan +5 energi setiap 5 detik.
- Addy Cannon menembakkan proyektil yang terlihat dan memberi 10 damage.
- Shield Cube memiliki 300 HP dan menahan musuh pada jalurnya.
- Tiga wave dengan 18 musuh total, termasuk Error Blob, Minus Monster, dan Calculator Bug.
- Minus Monster mengurangi energi jika mencapai Core; Calculator Bug bergerak lebih cepat.
- Tombol jeda, skor, jumlah musuh yang dikalahkan, akurasi jawaban, layar menang/kalah, dan tombol main lagi.
- Seluruh visual karakter dan arena digambar menggunakan kode. Tidak membutuhkan aset PvZ atau unduhan eksternal.

## Kontrol

1. Pilih salah satu jawaban matematika di panel kanan.
2. Pilih Guardian yang tersedia sesuai energi.
3. Klik petak kosong pada arena untuk menempatkan Guardian.
4. Gunakan **Jeda/Lanjut** untuk menghentikan atau melanjutkan simulasi.
5. Lindungi Core Numeria hingga seluruh wave selesai.

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

## Catatan

Ini adalah MVP yang ditingkatkan, bukan rilis final. Uji gameplay di Godot 4.7.2 sebelum melanjutkan ke ekspor Android/iOS. Dokumen desain asli tetap berada di `docs/original/` sebagai referensi.
