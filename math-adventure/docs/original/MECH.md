# Adventure Math

# Game Mechanics Document

## 1. Overview

Dokumen ini menjelaskan aturan utama gameplay Adventure Math.

Adventure Math adalah game Educational Tower Defense mobile dengan
sistem pertahanan lane, Math Guardian, dan Math Energy berbasis soal
matematika.

------------------------------------------------------------------------

# 2. Gameplay Loop

    Musuh datang
          ↓
    Pemain mengatur Guardian
          ↓
    Pemain membutuhkan Energy
          ↓
    Math Challenge
          ↓
    Mendapat Math Energy
          ↓
    Membeli Guardian
          ↓
    Bertahan dari Wave

------------------------------------------------------------------------

# 3. Battle System

Battle menggunakan sistem tower defense.

Komponen:

-   Lane.
-   Guardian.
-   Enemy.
-   Core Player.
-   Wave.

Tujuan:

Melindungi Core Numeria sampai seluruh wave selesai.

------------------------------------------------------------------------

# 4. Lane System

Jumlah lane mengikuti Level Data.

Contoh:

World 1: - 3 lane.

World 2: - 4 lane.

World 3: - 5 lane.

Setiap lane memiliki:

-   Jalur musuh.
-   Slot Guardian.
-   Area pertahanan.

------------------------------------------------------------------------

# 5. Guardian System

Guardian adalah unit pertahanan pemain.

Setiap Guardian memiliki:

    Guardian Data

    - Name
    - Cost
    - HP
    - Damage
    - Range
    - Attack Speed
    - Ability

------------------------------------------------------------------------

## Guardian Placement

Flow:

    Pilih Guardian
          ↓
    Pilih Slot
          ↓
    Guardian Spawn

Aturan:

-   Satu slot hanya memiliki satu Guardian.
-   Guardian dapat menyerang sesuai role.
-   Guardian tidak dapat bergerak.

------------------------------------------------------------------------

# 6. Enemy System

Enemy bergerak menuju Core Numeria.

Setiap Enemy memiliki:

    Enemy Data

    - HP
    - Speed
    - Damage
    - Ability

------------------------------------------------------------------------

## Enemy Behavior

Normal Enemy:

Berjalan menuju Core.

Special Enemy:

Memiliki kemampuan tambahan.

Contoh:

Minus Monster:

Mengurangi Energy pemain.

------------------------------------------------------------------------

# 7. Wave System

Setiap level terdiri dari beberapa wave.

Contoh:

    Wave 1
    Basic Enemy

    Wave 2
    More Enemy

    Wave 3
    Special Enemy

    Wave 4
    Combination

    Wave 5
    Final Challenge

------------------------------------------------------------------------

# 8. Math Energy System

Math Energy adalah resource utama.

Sumber:

## Passive Energy

Dihasilkan oleh Guardian tertentu.

Contoh:

Plusy:

+5 Energy setiap beberapa detik.

------------------------------------------------------------------------

## Math Challenge

Pemain menekan tombol Energy untuk membuka soal.

Flow:

    Tap Energy
          ↓
    Question Popup
          ↓
    Answer
          ↓
    Reward Energy

------------------------------------------------------------------------

# 9. Question Rules

Soal memiliki:

-   Type.
-   Difficulty.
-   Reward.

Contoh:

Mudah:

    5 + 3 = ?

Sulit:

    25 x 4 = ?

Reward dipengaruhi oleh tingkat kesulitan.

------------------------------------------------------------------------

# 10. Victory Condition

Pemain menang jika:

-   Semua wave selesai.
-   Core Numeria masih memiliki HP.

------------------------------------------------------------------------

# 11. Defeat Condition

Pemain kalah jika:

-   Core Numeria hancur.
-   Musuh berhasil melewati pertahanan.

------------------------------------------------------------------------

# 12. Upgrade System

Versi awal:

Guardian belum memiliki upgrade kompleks.

Future development:

-   Damage upgrade.
-   Energy efficiency.
-   Ability upgrade.

------------------------------------------------------------------------

# 13. Technical Rule

Implementasi mengikuti 4 Layer Architecture.

Domain: - Aturan battle. - Statistik Guardian. - Statistik Enemy.

Application: - Mengatur flow gameplay.

Presentation: - Menampilkan battle.

Infrastructure: - Data dan penyimpanan.
