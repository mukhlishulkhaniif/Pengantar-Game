# Adventure Math

# Level Design Document (LDD) - Revised

## 1. Overview

Level Design Document ini menjelaskan struktur dunia, level progression,
lane system, wave design, dan balancing awal Adventure Math sebagai game
Educational Tower Defense mobile.

Tujuan desain level:

-   Membuat pemain anak SD memahami mekanik secara bertahap.
-   Memberikan pengalaman strategi yang berkembang.
-   Menggabungkan pembelajaran matematika dengan pertahanan dunia
    Numeria.

------------------------------------------------------------------------

# 2. World Design

Adventure Math berlangsung di dunia Numeria.

Setiap wilayah memiliki tema matematika dan tingkat tantangan yang
berbeda.

------------------------------------------------------------------------

# World 1 - Addition Forest

## Tema

Hutan fantasi yang menjadi wilayah awal pemain.

## Materi Matematika

-   Penjumlahan.
-   Pengurangan.

## Tujuan Edukasi

Mengenalkan:

-   Sistem Math Energy.
-   Cara menjawab soal.
-   Cara menggunakan Guardian.

## Lane System

3 Lane

Alasan:

-   Cocok sebagai tahap pengenalan.
-   Mudah dipahami anak SD.
-   Memberikan ruang belajar strategi dasar.

## Guardian

-   Plusy.
-   Addy Cannon.
-   Shield Cube.

## Enemy

-   Error Blob.

------------------------------------------------------------------------

# World 2 - Multiplication Desert

## Tema

Gurun matematika dengan teknologi angka dan mesin kalkulator.

## Materi Matematika

-   Perkalian.
-   Pembagian.

## Tujuan Edukasi

Melatih:

-   Kecepatan berhitung.
-   Pengambilan keputusan.

## Lane System

4 Lane

Alasan:

-   Meningkatkan kompleksitas strategi.
-   Pemain mulai mengatur beberapa area pertahanan.

## Guardian Baru

-   Multiply Dragon.

## Enemy

-   Error Blob.
-   Calculator Bug.

------------------------------------------------------------------------

# World 3 - Fraction Castle

## Tema

Kastil matematika yang menyimpan energi pecahan.

## Materi Matematika

-   Pecahan.
-   Persentase.

## Tujuan Edukasi

Menghadapkan pemain pada tantangan matematika lebih tinggi.

## Lane System

5 Lane

Alasan:

-   Menjadi mode lanjutan.
-   Membutuhkan strategi kombinasi Guardian.

## Guardian Baru

-   Fraction Fairy.

## Enemy

-   Minus Monster.
-   Calculator Bug.

------------------------------------------------------------------------

# 3. Dynamic Lane System

Jumlah lane tidak dibuat tetap.

Setiap level memiliki konfigurasi sendiri.

Data level menyimpan:

    LevelData

    - World ID
    - Level ID
    - Lane Count
    - Wave Data
    - Enemy Configuration
    - Reward

Contoh:

Level awal:

    Addition Forest Level 1

    Lane Count:
    3

Level akhir:

    Fraction Castle Level 5

    Lane Count:
    5

------------------------------------------------------------------------

# 4. Battle Field Design

Sistem battlefield menggunakan lane defense.

Contoh:

3 Lane:

    Enemy Spawn

    Lane 1 =================>

    Lane 2 =================>

    Lane 3 =================>

                 Core Player

5 Lane:

    Enemy Spawn

    Lane 1 =================>
    Lane 2 =================>
    Lane 3 =================>
    Lane 4 =================>
    Lane 5 =================>

                 Core Player

------------------------------------------------------------------------

# 5. Level Structure

Setiap world memiliki:

    World

    ├── Tutorial Level
    ├── Introduction Level
    ├── Challenge Level
    ├── Advanced Level
    └── Boss Level

------------------------------------------------------------------------

# 6. Wave Design

## Tutorial

Fokus:

-   Mengenalkan Energy.
-   Mengenalkan Guardian.
-   Mengenalkan musuh.

Contoh:

Wave 1: 5 Error Blob.

Wave 2: 10 Error Blob.

Wave 3: Guardian challenge.

------------------------------------------------------------------------

## Normal Level

Struktur:

Wave 1: Enemy dasar.

Wave 2: Kombinasi enemy.

Wave 3: Enemy cepat.

Wave 4: Serangan besar.

Wave 5: Boss/Final challenge.

------------------------------------------------------------------------

# 7. Difficulty Progression

Kesulitan meningkat melalui:

## Mathematics

Awal:

    5 + 3 = ?

Lanjut:

    25 x 4 = ?

------------------------------------------------------------------------

## Enemy

Awal:

-   HP rendah.
-   Gerakan lambat.

Lanjut:

-   HP tinggi.
-   Ability khusus.
-   Multi lane attack.

------------------------------------------------------------------------

## Strategy

Awal:

Pemain dapat menggunakan satu Guardian.

Lanjut:

Pemain harus:

-   Mengatur beberapa lane.
-   Mengkombinasikan Guardian.
-   Mengelola energi.

------------------------------------------------------------------------

# 8. Reward System

Setelah menyelesaikan level:

Pemain mendapatkan:

-   Bintang.
-   Guardian baru.
-   Area baru.
-   Upgrade material.

------------------------------------------------------------------------

# 9. Tutorial Flow

Tutorial mengajarkan:

1.  Mendapatkan Math Energy.
2.  Menjawab soal.
3.  Memanggil Guardian.
4.  Menempatkan Guardian.
5.  Bertahan dari wave.

------------------------------------------------------------------------

# 10. Initial Balancing

## Math Energy

Jawaban benar:

+50 Energy

Combo:

Bonus tambahan.

------------------------------------------------------------------------

## Guardian Cost

Plusy:

50 Energy

Addy Cannon:

100 Energy

Shield Cube:

75 Energy

------------------------------------------------------------------------

## Enemy Basic

Error Blob:

HP: 50

Speed: Normal

Damage: Rendah

------------------------------------------------------------------------

# 11. Technical Notes

Lane system dibuat berbasis data.

Application Layer:

Mengatur flow level.

Domain Layer:

Menyimpan aturan lane dan battle.

Presentation Layer:

Menampilkan jumlah lane sesuai LevelData.

Contoh:

    LevelData.lane_count = 5

    ↓

    Battle Scene generate 5 lane

Dengan sistem ini, penambahan lane baru tidak membutuhkan perubahan core
gameplay.
