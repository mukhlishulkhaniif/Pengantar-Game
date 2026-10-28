# Adventure Math

## Game Design Document (GDD)

# 1. Informasi Game

**Nama Game:** Adventure Math\
**Genre:** Educational Tower Defense\
**Engine:** Godot 4\
**Platform Target:** Mobile (Android/iOS)\
**Target Pemain:** Anak Sekolah Dasar (SD)\
**Tema:** Fantasy Adventure + Mathematics

Adventure Math adalah game edukasi matematika berbasis tower defense
yang dirancang untuk perangkat mobile. Pemain mempertahankan dunia
Numeria dari serangan Math Error dengan menggunakan kekuatan matematika
sebagai sumber energi untuk memanggil Math Guardian.

------------------------------------------------------------------------

# 2. High Concept

Adventure Math menggabungkan pembelajaran matematika dengan strategi
pertahanan.

Pemain berperan sebagai Math Explorer yang bertugas menjaga dunia
Numeria. Untuk melawan musuh, pemain harus menyelesaikan soal matematika
agar mendapatkan Math Energy. Energi tersebut digunakan untuk memanggil
berbagai Math Guardian yang memiliki kemampuan berbeda.

Matematika bukan hanya menjadi aktivitas belajar, tetapi menjadi
kekuatan utama dalam petualangan pemain.

------------------------------------------------------------------------

# 3. Cerita

Dunia Numeria adalah dunia fantasi yang memiliki keseimbangan berkat
kekuatan matematika.

Suatu hari, muncul makhluk bernama Math Error yang berasal dari
kesalahan perhitungan. Makhluk tersebut menyebabkan kekacauan dan
mengganggu keseimbangan dunia dengan merusak energi matematika.

Pemain sebagai Math Explorer harus melakukan perjalanan melewati
berbagai wilayah Numeria dan menggunakan pengetahuan matematika untuk
mengembalikan keseimbangan dunia.

------------------------------------------------------------------------

# 4. Gameplay Utama

Adventure Math menggunakan mekanisme tower defense dengan sistem
pertahanan berbasis lane.

Pemain harus:

-   Menjawab soal matematika.
-   Mengumpulkan Math Energy.
-   Memanggil Math Guardian.
-   Mengatur strategi pertahanan.
-   Mengalahkan gelombang Math Error.

## Core Gameplay Loop

	Musuh menyerang
			↓
	Soal matematika muncul
			↓
	Pemain menjawab soal
			↓
	Mendapat Math Energy
			↓
	Memanggil Math Guardian
			↓
	Guardian menyerang musuh
			↓
	Menyelesaikan wave
			↓
	Membuka level baru

------------------------------------------------------------------------

# 5. Sistem Math Energy

Math Energy merupakan sumber daya utama dalam permainan.

Pemain memperoleh Math Energy dengan menjawab soal matematika.

Contoh:

	12 + 8 = ?

	A. 18
	B. 20
	C. 22
	D. 24

Jawaban benar: - Mendapat energi. - Meningkatkan combo. - Membantu
membeli Guardian.

Jawaban salah: - Mendapat energi lebih sedikit. - Kesempatan strategi
menjadi terbatas.

------------------------------------------------------------------------

# 6. Sistem Battle

Pertarungan berlangsung dalam beberapa jalur pertahanan.

Komponen permainan:

-   Area pertahanan pemain.
-   Jalur pergerakan musuh.
-   Slot penempatan Guardian.
-   Gelombang serangan musuh.

Tujuan utama:

-   Mengalahkan seluruh musuh.
-   Melindungi Core Numeria.

------------------------------------------------------------------------

# 7. Math Guardian

Math Guardian adalah makhluk penjaga yang dipanggil menggunakan Math
Energy.

## Plusy

**Role:** Energy Generator

Makhluk kecil berbentuk simbol tambah yang menghasilkan energi tambahan
secara berkala.

------------------------------------------------------------------------

## Addy Cannon

**Role:** Ranged Attacker

Robot kecil dengan meriam angka yang menembakkan energi matematika
kepada musuh.

------------------------------------------------------------------------

## Shield Cube

**Role:** Defender

Kubus matematika hidup dengan pertahanan tinggi yang bertugas
memperlambat musuh.

------------------------------------------------------------------------

## Multiply Dragon

**Role:** Area Attacker

Naga kecil dengan kekuatan perkalian yang mampu menyerang banyak musuh
sekaligus.

------------------------------------------------------------------------

## Fraction Fairy

**Role:** Support

Peri matematika yang menggunakan energi pecahan untuk memberikan efek
khusus.

------------------------------------------------------------------------

# 8. Enemy Design

Musuh disebut Math Error.

## Error Blob

Musuh dasar dengan kemampuan sederhana.

------------------------------------------------------------------------

## Minus Monster

Monster yang dapat mengurangi jumlah Math Energy pemain.

------------------------------------------------------------------------

## Calculator Bug

Musuh cepat dengan kemampuan bergerak lebih agresif.

------------------------------------------------------------------------

## Zero King

Boss utama yang ingin menghapus seluruh angka dari dunia Numeria.

------------------------------------------------------------------------

# 9. Dunia dan Level

## World 1: Addition Forest

Materi: - Penjumlahan - Pengurangan

Tema: Hutan fantasi dengan energi angka dasar.

------------------------------------------------------------------------

## World 2: Multiplication Desert

Materi: - Perkalian - Pembagian

Tema: Gurun matematika dengan teknologi angka.

------------------------------------------------------------------------

## World 3: Fraction Castle

Materi: - Pecahan - Persentase

Tema: Kastil penuh simbol matematika.

------------------------------------------------------------------------

# 10. Visual Direction

Gaya visual:

**Cute Fantasy Cartoon**

Karakter dibuat:

-   Lucu dan mudah dikenali anak-anak.
-   Bentuk sederhana.
-   Warna cerah.
-   Ekspresi yang menarik.

Referensi visual: - Plants vs Zombies - Pokemon - Ghibli-inspired
fantasy environment

Dunia matematika dibuat sebagai dunia fantasi, bukan seperti ruang
kelas.

------------------------------------------------------------------------

# 11. Sistem Progression

Pemain dapat:

-   Membuka Guardian baru.
-   Membuka wilayah baru.
-   Menghadapi musuh yang lebih kuat.
-   Mempelajari materi matematika lebih tinggi.

Sistem upgrade:

Level 1: Kemampuan dasar.

Level 2: Peningkatan kekuatan.

Level 3: Kemampuan khusus terbuka.

------------------------------------------------------------------------

# 12. Educational Design

Tujuan pembelajaran:

-   Melatih kemampuan berhitung.
-   Meningkatkan kecepatan berpikir.
-   Membantu memahami konsep matematika dasar.

Materi matematika:

Level awal: - Penjumlahan. - Pengurangan.

Level lanjut: - Perkalian. - Pembagian. - Pecahan. - Persentase.

------------------------------------------------------------------------

# 13. Scope Pengembangan

Versi awal untuk tugas:

## Guardian

-   Plusy
-   Addy Cannon
-   Shield Cube

## Enemy

-   Error Blob
-   Minus Monster

## Materi

-   Penjumlahan
-   Pengurangan

## Level

-   1 dunia dengan beberapa wave.

------------------------------------------------------------------------

# 14. Struktur Project Godot

	AdventureMath/

	├── scenes/
	├── scripts/
	├── assets/
	├── data/
	└── resources/

Sistem utama:

-   Question System
-   Energy System
-   Wave Manager
-   Guardian System
-   Enemy System

------------------------------------------------------------------------

# 15. Tujuan Akhir

Adventure Math menjadi game edukasi mobile yang membuat anak belajar
matematika melalui pengalaman bermain strategi.

Pemain tidak hanya mengerjakan soal, tetapi menggunakan kemampuan
matematika sebagai kekuatan untuk menyelesaikan petualangan.
