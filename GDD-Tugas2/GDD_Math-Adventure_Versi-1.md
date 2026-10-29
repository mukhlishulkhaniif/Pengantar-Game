# GAME DESIGN DOCUMENT (GDD)

## Math-Adventure --- Versi 1

**Versi dokumen:** GDD v1.0\
**Acuan proyek:** Core gameplay Math-Adventure v1.x\
**Engine:** Godot 4.7.2\
**Platform:** Android, orientasi landscape\
**Genre:** Educational Tower Defense / strategi kasual

------------------------------------------------------------------------

## 1. Overview

**Judul:** Math-Adventure\
**Target pemain:** Siswa SD kelas 1--6\
**Durasi permainan:** Sekitar 2--5 menit per pertandingan, sebagai
target awal.

**High concept:** Pemain menyusun Guardian bertema matematika untuk
melindungi Core Numeria dari serangan monster. Pemain menggunakan energi
untuk menempatkan Guardian dan menjawab soal matematika agar memperoleh
tambahan energi.

**Fokus versi 1:** Membuat satu pertandingan tower defense yang bisa
dimainkan, dengan arena grid, Guardian, monster, energi, soal
matematika, serta kondisi menang dan kalah.

------------------------------------------------------------------------

## 2. Gameplay

**Core loop:** kumpulkan energi → pilih Guardian → tempatkan Guardian di
arena → hadapi monster → jawab soal untuk memperoleh energi →
pertahankan Core sampai semua wave selesai.

**Mekanik inti:** 1. Arena berbentuk grid **5 baris × 9 kolom**. 2.
Monster bergerak dari sisi kanan menuju Core di sisi kiri. 3. Guardian
ditempatkan pada petak arena untuk menyerang atau menahan monster. 4.
Setiap Guardian memiliki biaya energi dan HP. Monster yang bertemu
Guardian akan menyerangnya; monster melanjutkan perjalanan jika Guardian
hancur. 5. Tombol energi membuka soal matematika. Jawaban benar memberi
energi tambahan. 6. Plusy membantu menghasilkan energi secara berkala.
7. Pertandingan dasar terdiri dari **3 wave**.

**Kontrol:** pemain mengetuk kartu Guardian lalu mengetuk petak kosong,
atau menggunakan drag-and-drop untuk menempatkannya. Pada PC, kontrol
dilakukan dengan mouse; pada Android, dengan sentuhan layar.

**Enam Guardian utama:**

  Guardian            Biaya energi Peran
  ----------------- -------------- ---------------------------------------------
  Plusy                         50 Menghasilkan energi.
  Addy Cannon                  100 Menyerang monster dari jarak jauh.
  Shield Cube                   75 Menahan serangan dengan HP tinggi.
  Multiply Dragon              140 Menyerang beberapa monster di area sekitar.
  Fraction Fairy               125 Memulihkan HP Guardian lain.
  Number Knight                125 Melawan monster dalam jarak dekat.

------------------------------------------------------------------------

## 3. Tujuan & Menang/Kalah

**Tujuan:** pertahankan Core Numeria sambil mengelola energi dan memilih
Guardian yang sesuai.

**Menang:** semua wave berhasil diselesaikan dan HP Core masih di atas
0.

**Kalah:** HP Core mencapai 0 sebelum seluruh wave selesai.

**Energi:** pemain menggunakan energi untuk menempatkan Guardian. Soal
matematika menjadi salah satu cara mendapatkan energi tambahan; Plusy
juga mendukung pasokan energi.

**Fokus hasil pertandingan:** versi ini berfokus pada mekanik inti
battle dan hasil menang/kalah. Sistem peta dengan banyak level, tutorial
global, dan penyimpanan progres ant level belum menjadi fokus utama.

------------------------------------------------------------------------

## 4. Level & World

**Map utama:** satu arena bertema hutan, yaitu **Addition Forest**.

**Materi matematika:** terutama penjumlahan dan pengurangan dasar.

**Arena (sketsa sederhana):**

``` text
Core  | [ ][ ][ ][ ][ ][ ][ ][ ][ ] | Monster
      | [ ][ ][ ][ ][ ][ ][ ][ ][ ] |
      | [ ][ ][ ][ ][ ][ ][ ][ ][ ] |
      | [ ][ ][ ][ ][ ][ ][ ][ ][ ] |
      | [ ][ ][ ][ ][ ][ ][ ][ ][ ] |
              5 baris × 9 kolom
```

**Progres kesulitan:** pertandingan menggunakan tiga wave. Pada versi
awal, fokusnya adalah mengenalkan pertahanan, penempatan Guardian,
penggunaan energi, dan soal matematika dalam satu arena.

------------------------------------------------------------------------

## 5. Arah Seni & Audio

**Visual:** kartun 2D dengan nuansa animasi vintage tahun 1930-an,
bentuk karakter ekspresif, garis tegas, dan warna hangat. Palet utama
menggunakan hijau hutan, krem, cokelat gelap, serta aksen emas.

**Arena:** lapangan grid harus mudah dibaca agar pemain dapat melihat
posisi Guardian dan monster.

**Animasi:** gerakan monster, serangan Guardian, bar HP, serta efek saat
monster terkena serangan.

**Audio:** efek suara untuk serangan, jawaban benar, monster terkena
damage, dan kemenangan direncanakan untuk memperkuat umpan balik.
Kelengkapan audio bukan fokus utama versi inti.

------------------------------------------------------------------------

## 6. Teknis & Lingkup

**Engine:** Godot 4.7.2\
**Bahasa:** GDScript\
**Platform target:** Android landscape\
**Repository:** GitHub `Pengantar-Game`

**Fitur inti versi 1:** - Arena grid 5 × 9. - Enam Guardian dengan peran
berbeda. - Monster, HP Guardian, dan HP Core. - Sistem energi dan soal
matematika. - Tiga wave pada pertandingan dasar. - Kondisi menang dan
kalah. - Kontrol sentuh dan drag-and-drop.

**Pengembangan berikutnya:** menyeimbangkan tingkat kesulitan untuk anak
SD, memperbaiki tempo monster, menambahkan cooldown, memperkaya animasi
dan aset monster, serta membangun sistem tutorial dan progres banyak
level.

**Catatan:** GDD versi 1 menggambarkan fondasi gameplay. Detail balance
dapat berubah mengikuti hasil pengujian di Godot dan Android.
