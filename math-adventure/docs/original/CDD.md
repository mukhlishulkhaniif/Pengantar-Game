# Adventure Math

# Character Design Document (CDD)

## 1. Overview

Dokumen ini mendefinisikan desain karakter Adventure Math berdasarkan
konsep Educational Tower Defense.

Karakter dibagi menjadi:

-   Player Character
-   Math Guardian
-   Math Error

Setiap karakter memiliki pemisahan antara:

-   Domain Layer: data, statistik, dan aturan gameplay.
-   Presentation Layer: visual, animasi, efek, dan suara.

------------------------------------------------------------------------

# 2. Player Character

# Math Explorer

## Deskripsi

Math Explorer adalah karakter utama pemain yang bertugas menjaga dunia
Numeria.

Math Explorer bukan karakter tempur langsung, tetapi berperan sebagai
strategist yang menggunakan kemampuan matematika untuk memanggil Math
Guardian.

## Peran Gameplay

-   Menjawab soal matematika.
-   Menghasilkan Math Energy.
-   Memilih strategi pertahanan.
-   Membuka wilayah baru.

## Item Utama

### Math Compass

Fungsi:

-   Membaca energi matematika.
-   Membantu perjalanan pemain.
-   Menjadi simbol kekuatan pemain.

## Implementasi MVP

Math Explorer hanya muncul pada:

-   Main Menu.
-   World Map.
-   Story Scene.

Tidak muncul dalam battlefield untuk mengurangi kompleksitas
pengembangan.

------------------------------------------------------------------------

# 3. Math Guardian

Math Guardian adalah unit pertahanan yang dipanggil menggunakan Math
Energy.

------------------------------------------------------------------------

# Guardian 01

# Plusy

## Role

Energy Generator

## Deskripsi

Makhluk kecil berbentuk simbol tambah yang menjadi sumber energi bagi
pemain.

## Gameplay Function

Menghasilkan Math Energy secara berkala.

## Domain Data

    Name:
    Plusy

    Type:
    Generator

    Cost:
    50 Energy

    Energy Rate:
    10

    Cooldown:
    5 seconds

## Visual Direction

-   Bentuk kecil dan lucu.
-   Simbol "+" sebagai identitas utama.
-   Warna dominan kuning.
-   Ekspresi ceria.

------------------------------------------------------------------------

# Guardian 02

# Addy Cannon

## Role

Ranged Attacker

## Deskripsi

Robot kecil yang menggunakan energi matematika sebagai proyektil.

## Gameplay Function

Menyerang musuh dari jarak jauh.

## Domain Data

    Name:
    Addy Cannon

    Type:
    Attacker

    Cost:
    100 Energy

    Damage:
    10

    Range:
    5

    Attack Speed:
    2 seconds

## Visual Direction

-   Robot kecil.
-   Memiliki meriam angka.
-   Proyektil berbentuk energi matematika.

------------------------------------------------------------------------

# Guardian 03

# Shield Cube

## Role

Defender

## Deskripsi

Kubus matematika hidup yang memiliki pertahanan tinggi.

## Gameplay Function

Menahan musuh agar Guardian lain dapat menyerang.

## Domain Data

    Name:
    Shield Cube

    Type:
    Tank

    Cost:
    75 Energy

    HP:
    300

## Visual Direction

-   Bentuk kubus.
-   Ekspresi kuat tetapi ramah.
-   Memiliki simbol matematika pada permukaan.

------------------------------------------------------------------------

# 4. Math Error

Math Error adalah musuh yang berasal dari kesalahan perhitungan.

------------------------------------------------------------------------

# Enemy 01

# Error Blob

## Role

Basic Enemy

## Deskripsi

Makhluk sederhana yang terbentuk dari angka rusak.

## Domain Data

    HP:
    50

    Speed:
    20

    Damage:
    10

## Visual Direction

-   Bentuk blob.
-   Warna gelap tetapi tetap lucu.
-   Memiliki simbol angka yang glitch.

------------------------------------------------------------------------

# Enemy 02

# Minus Monster

## Role

Disruptor Enemy

## Deskripsi

Monster yang memiliki kemampuan mengurangi energi matematika pemain.

## Ability

Saat menyerang:

    Player Energy -20

## Visual Direction

-   Memiliki simbol minus.
-   Aura negatif.
-   Gerakan lebih lambat.

------------------------------------------------------------------------

# Enemy 03

# Calculator Bug

## Role

Fast Enemy

## Deskripsi

Makhluk kecil cepat yang menyerang dengan kecepatan tinggi.

## Ability

-   Movement speed tinggi.
-   HP lebih rendah.

## Visual Direction

-   Bentuk seperti mesin kalkulator rusak.
-   Efek glitch.

------------------------------------------------------------------------

# 5. Visual Style Guide

## Style

Cute Fantasy Cartoon 2D

## Target Audience

Anak Sekolah Dasar.

## Karakteristik Visual

-   Bentuk sederhana.
-   Silhouette mudah dikenali.
-   Warna cerah.
-   Ekspresi jelas.
-   Tidak menggunakan desain menyeramkan.

## Referensi

-   Plants vs Zombies.
-   Pokemon.
-   Fantasy animation style.

------------------------------------------------------------------------

# 6. Technical Implementation

## Domain Layer

Menyimpan:

    Character Data

    - Name
    - Type
    - Cost
    - HP
    - Damage
    - Ability
    - Behavior

## Presentation Layer

Menyimpan:

    Character Scene

    - Sprite
    - Animation
    - Particle Effect
    - Sound

------------------------------------------------------------------------

# 7. Expansion Plan

Karakter baru dapat ditambahkan dengan:

1.  Membuat data karakter baru.
2.  Membuat scene visual baru.
3.  Menghubungkan dengan Guardian/Enemy system.

Tidak perlu mengubah core system.
