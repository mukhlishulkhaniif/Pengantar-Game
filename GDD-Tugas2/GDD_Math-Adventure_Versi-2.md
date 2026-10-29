# GAME DESIGN DOCUMENT (GDD)

## Math-Adventure --- Versi 2

**Versi dokumen:** GDD v2.1 (disesuaikan dengan HUD build v2.8)\
**Acuan proyek:** Build pengembangan v2.8\
**Engine:** Godot 4.7.2\
**Platform:** Android, orientasi landscape\
**Genre:** Educational Tower Defense / strategi kasual

------------------------------------------------------------------------

## 1. Overview

**Judul:** Math-Adventure\
**Target pemain:** Siswa SD kelas 1--6\
**Durasi permainan:** Sekitar 2--5 menit per level sebagai target awal;
durasi dapat berbeda menurut tingkat kesulitan.

**High concept:** Pemain menjelajahi dunia Numeria, menjawab soal
matematika untuk memperoleh energi, dan menyusun enam Guardian guna
melindungi Core dari gelombang monster. Pemain menyelesaikan level satu
demi satu, membuka map baru, dan mengumpulkan bintang.

**Fokus versi 2:** Memperluas battle inti menjadi permainan dengan
tutorial global, tiga map, 39 level map, progres tersimpan, tempo yang
lebih terkontrol, dan cooldown Guardian.

------------------------------------------------------------------------

## 2. Gameplay

**Core loop:** pilih map dan level → mulai pertandingan → kumpulkan
energi → tempatkan Guardian → jawab soal matematika → pertahankan semua
jalur → selesaikan wave → dapatkan bintang dan buka level berikutnya.

**Mekanik inti:** 1. Arena battle tetap menggunakan grid **5 baris × 9
kolom**. 2. Monster dapat muncul dari berbagai baris dan bergerak menuju
Core. 3. Monster berhenti untuk menyerang Guardian yang menghalangi
jalurnya. Guardian memiliki HP dan bar kesehatan. 4. Tombol soal membuka
tantangan matematika. Panel soal menjeda battle agar pemain dapat
berpikir. 5. Jawaban benar memberikan energi; jawaban salah tetap
memberi reward yang lebih kecil dan menampilkan jawaban yang benar. 6.
Plusy menghasilkan energi secara berkala. 7. Kartu Guardian memiliki
cooldown masing-masing. Kartu terlihat redup saat cooldown dan bar
pengisian menunjukkan waktu sampai siap digunakan kembali. 8. Jumlah
wave, jumlah musuh, dan tingkat kesulitan menyesuaikan level. 9. Monster
dibuat lebih tahan dibandingkan versi awal, sedangkan tempo kemunculan
dan gerakannya ditujukan agar pemain SD memiliki waktu menyusun
strategi.

**Kontrol:** ketuk kartu Guardian lalu ketuk petak kosong, atau
drag-and-drop. Tombol pause menghentikan sementara permainan.

**Enam Guardian dan biaya energi (sesuai tampilan HUD v2.8):

  Guardian (HUD v2.8)  Biaya energi Peran
  ------------------- -------------- --------------------------------------
  Plusy                            35 Menghasilkan energi.
  Addy                             70 Menyerang monster dari jarak jauh.
  Shield                           50 Menahan serangan dengan HP tinggi.
  Dragon                           95 Menyerang area sekitar target.
  Fairy                            85 Memulihkan Guardian lain.
  Knight                           85 Menyerang monster dalam jarak dekat.

------------------------------------------------------------------------

## 3. Tujuan & Menang/Kalah

**Tujuan:** selesaikan semua wave pada level sambil menjaga Core dan
menggunakan energi secara efektif.

**Menang:** semua wave pada level selesai dan HP Core masih di atas 0.

**Kalah:** HP Core mencapai 0 sebelum seluruh wave selesai.

**Bintang dan progres:** pemain dapat memperoleh hingga tiga bintang
berdasarkan penyelesaian level, sisa HP Core, dan hasil menjawab soal.
Kemenangan membuka level berikutnya; progres dan bintang terbaik
disimpan secara lokal.

**Tutorial:** pemain harus menyelesaikan penjelasan tutorial sebelum
monster mulai muncul. Tutorial mengajarkan tujuan melindungi Core,
pemilihan Guardian, penempatan pada grid, cara memperoleh energi melalui
soal, pengawasan semua jalur, dan cara memulai wave.

------------------------------------------------------------------------

## 4. Level & World

**Struktur:** **40 level keseluruhan**, terdiri dari 1 tutorial global
dan 39 level map.

  Map                     Materi matematika                Jumlah level
  ----------------------- ------------------------------ --------------
  Addition Forest         Penjumlahan dan pengurangan                13
  Multiplication Desert   Perkalian dan pembagian                    13
  Fraction Castle         Pecahan dan persentase dasar               13
  Tutorial global         Pengenalan mekanik game                     1
  **Total**                                                      **40**

Setiap map memiliki 13 level: 3 Introduction, 4 Challenge, 4 Advanced,
dan 2 Boss.

**Tampilan pilih level:** pemain cukup melihat nama map, tombol
Tutorial, nomor level, dan tombol kembali/tutup. Tombol level berbentuk
persegi dengan ukuran seragam. Level terkunci dibedakan secara visual
dari level yang sudah terbuka.

**Sketsa halaman pilih level:**

``` text
[ ADDITION FOREST ] [ MULTIPLICATION DESERT ] [ FRACTION CASTLE ]

[ TUTORIAL ]

[ 01 ] [ 02 ] [ 03 ] [ 04 ] [ 05 ]
[ 06 ] [ 07 ] [ 08 ] [ 09 ] [ 10 ]
[ 11 ] [ 12 ] [ 13 ]
```

**Progres kesulitan:** level awal memperkenalkan mekanik dan soal yang
mudah. Level selanjutnya meningkatkan komposisi serta jumlah monster,
tingkat kesulitan soal, dan kebutuhan strategi. Level Boss dirancang
sebagai tantangan puncak pada setiap map.

------------------------------------------------------------------------

## 5. Arah Seni & Audio

**Visual:** mempertahankan gaya kartun 2D vintage dengan warna hangat,
karakter Guardian yang mudah dibedakan, dan monster yang ekspresif.

**Map:** - **Addition Forest:** arena hutan hijau. - **Multiplication
Desert:** lingkungan gurun. - **Fraction Castle:** lingkungan kastil
fantasi.

**Antarmuka:** HUD menampilkan energi, enam kartu Guardian, wave, HP
Core, cooldown, serta tombol pause dan home. Halaman pilih level dibuat
sederhana agar fokus pemain hanya pada map dan nomor level.

**Animasi:** gerakan karakter, efek serangan dan damage, bar HP,
cooldown yang terisi, serta banner pergantian wave.

**Audio:** efek suara jawaban benar, serangan, monster terkena damage,
pergantian wave, dan kemenangan menjadi bagian penyempurnaan pengalaman
bermain.

------------------------------------------------------------------------

## 6. Teknis & Lingkup

**Engine:** Godot 4.7.2\
**Bahasa:** GDScript\
**Platform target:** Android landscape\
**Repository:** GitHub `Pengantar-Game`

**Fitur yang menjadi bagian build versi 2:** - Battle grid 5 × 9 dan
enam Guardian. - Energi, soal matematika, HP Guardian/Core, dan wave. -
Cooldown kartu Guardian dan tombol soal. - Monster dari berbagai baris
dengan tempo yang lebih terkontrol. - Tiga map dengan materi matematika
berbeda. - Tutorial global. - 40 entri level: satu tutorial dan 39 level
map. - Pembukaan level berikutnya dan penyimpanan progres/bintang. - UI
pilih level dengan nomor tombol persegi.

**Pengembangan lanjutan:** - Menguji tutorial, perpindahan map, dan
progres dari awal sampai akhir di Godot 4.7.2. - Menyelaraskan materi
dan tingkat kesulitan dengan kurikulum kelas 1--6. - Menyempurnakan
desain boss, variasi objektif level, animasi, audio, dan keseimbangan
Guardian. - Menguji ukuran teks serta kontrol pada beberapa perangkat
Android.

**Catatan:** dokumen ini membedakan fitur yang tercantum pada build v2.8
dengan pekerjaan lanjutan. Validasi akhir tetap perlu dilakukan dengan
menjalankan proyek dan menguji game secara langsung.
