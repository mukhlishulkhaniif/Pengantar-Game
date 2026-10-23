# Adventure Math

# AI HANDOVER DOCUMENT

## 1. Project Overview

Adventure Math adalah game edukasi matematika berbasis mobile dengan
genre Educational Tower Defense.

Pemain berperan sebagai Math Explorer yang mempertahankan dunia Numeria
dari serangan Math Error menggunakan Math Guardian.

Project menggunakan arsitektur 4 layer agar mudah dikembangkan dan
menjaga pemisahan antara tampilan, logika aplikasi, aturan permainan,
dan sistem pendukung.

------------------------------------------------------------------------

# 2. Architecture Overview

Adventure Math menggunakan pendekatan Layered Architecture:

    Presentation Layer
            ↓
    Application Layer
            ↓
    Domain Layer
            ↓
    Infrastructure Layer

Setiap layer memiliki tanggung jawab berbeda dan tidak boleh bercampur.

------------------------------------------------------------------------

# 3. Presentation Layer

## Responsibility

Menangani semua yang berhubungan dengan tampilan dan interaksi pengguna.

Komponen:

    Presentation/

    ├── scenes/
    ├── ui/
    ├── views/
    ├── animations/
    └── input/

Tanggung jawab:

-   Menampilkan battlefield.
-   Menampilkan Guardian.
-   Menampilkan Enemy.
-   Menampilkan soal matematika.
-   Mengelola touch input mobile.
-   Mengatur animasi.

Presentation tidak boleh menangani: - Perhitungan damage. - Aturan
kemenangan. - Perhitungan energi.

------------------------------------------------------------------------

# 4. Application Layer

## Responsibility

Mengatur alur penggunaan sistem game.

Komponen:

    Application/

    ├── GameManager
    ├── BattleController
    ├── WaveManager
    ├── QuestionService
    ├── ProgressService
    └── SpawnService

Tanggung jawab:

## GameManager

Mengatur: - Perpindahan scene. - Status permainan. - Progress pemain.

## BattleController

Mengatur: - Start battle. - Victory condition. - Defeat condition.

## WaveManager

Mengatur:

    Start Wave
    ↓
    Spawn Enemy
    ↓
    Monitor Battle
    ↓
    Next Wave

## QuestionService

Menghubungkan soal matematika dengan gameplay.

Flow:

    Question Generated
    ↓
    Player Answer
    ↓
    Validation
    ↓
    Energy Reward

------------------------------------------------------------------------

# 5. Domain Layer

## Responsibility

Berisi aturan utama game.

Layer ini tidak mengetahui tampilan.

Komponen:

    Domain/

    ├── Guardian/
    ├── Enemy/
    ├── Question/
    ├── Energy/
    ├── Battle/
    └── World/

------------------------------------------------------------------------

## Guardian Domain

Menyimpan:

-   Nama Guardian.
-   Harga energi.
-   Damage.
-   Range.
-   Attack Speed.
-   Ability.

Contoh:

    GuardianData

    name
    cost
    damage
    range
    attack_speed
    ability

------------------------------------------------------------------------

## Enemy Domain

Menyimpan:

-   HP.
-   Speed.
-   Damage.
-   Ability.

------------------------------------------------------------------------

## Energy Domain

Mengatur:

-   Math Energy.
-   Penambahan energi.
-   Pengurangan energi.

Contoh:

    Correct Answer
    +
    50 Energy

    Buy Guardian
    -
    100 Energy

------------------------------------------------------------------------

## Question Domain

Mengatur:

-   Jenis soal.
-   Tingkat kesulitan.
-   Jawaban benar.

------------------------------------------------------------------------

# 6. Infrastructure Layer

## Responsibility

Sistem pendukung yang tidak berhubungan langsung dengan aturan game.

Komponen:

    Infrastructure/

    ├── SaveSystem
    ├── DataLoader
    ├── AudioManager
    ├── AssetManager
    └── Config

Tanggung jawab:

-   Penyimpanan progress.
-   Membaca data soal.
-   Loading asset.
-   Mengatur audio.

------------------------------------------------------------------------

# 7. Gameplay Flow

    Main Menu
     ↓
    World Map
     ↓
    Level Scene
     ↓
    Wave Start
     ↓
    Question System
     ↓
    Math Energy
     ↓
    Guardian Deployment
     ↓
    Battle
     ↓
    Reward

------------------------------------------------------------------------

# 8. Development Rules

Aturan pengembangan:

1.  Domain tidak boleh memanggil Presentation.
2.  Presentation hanya menampilkan data.
3.  Application menjadi penghubung antar layer.
4.  Infrastructure hanya menyediakan layanan pendukung.

------------------------------------------------------------------------

# 9. Minimum Playable Version

Target awal:

-   1 level.
-   3 Guardian.
-   2 Enemy.
-   Sistem soal penjumlahan dan pengurangan.
-   Sistem wave.
-   Sistem energi.
