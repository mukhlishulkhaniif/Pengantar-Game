# Adventure Math

# Architecture Document (Revised)

## 1. Architecture Goal

Adventure Math menggunakan arsitektur 4 layer agar project mudah
dikembangkan dan tidak bergantung pada satu sistem tertentu.

Fokus arsitektur:

-   Memisahkan gameplay logic dan tampilan.
-   Memudahkan penambahan Guardian, Enemy, dan Level.
-   Menghindari ketergantungan kode lama RPG.

------------------------------------------------------------------------

# 2. Layer Architecture

    Presentation Layer
            ↓
    Application Layer
            ↓
    Domain Layer
            ↓
    Infrastructure Layer

Aturan:

-   Layer atas boleh menggunakan layer bawah.
-   Layer bawah tidak boleh mengetahui layer atas.

------------------------------------------------------------------------

# 3. Final Project Structure

    res://

    ├── presentation/
    │   ├── battle/
    │   ├── ui/
    │   ├── views/
    │   └── input/
    │
    ├── application/
    │   ├── battle/
    │   ├── services/
    │   ├── managers/
    │   └── controllers/
    │
    ├── domain/
    │   ├── guardian/
    │   ├── enemy/
    │   ├── energy/
    │   ├── question/
    │   ├── battle/
    │   └── player/
    │
    ├── infrastructure/
    │   ├── data/
    │   ├── save/
    │   ├── audio/
    │   └── loader/
    │
    ├── resources/
    │   ├── guardian/
    │   ├── enemy/
    │   ├── question/
    │   └── level/
    │
    ├── scenes/
    │   ├── main/
    │   ├── battle/
    │   └── ui/
    │
    ├── assets/
    │
    └── docs/

------------------------------------------------------------------------

# 4. Domain Layer

Domain berisi aturan utama game.

## Guardian

    Guardian.gd
    GuardianStats.gd

Mengatur:

-   Cost.
-   Damage.
-   Range.
-   Attack speed.
-   Ability.

------------------------------------------------------------------------

## Enemy

    Enemy.gd
    EnemyStats.gd

Mengatur:

-   HP.
-   Speed.
-   Damage.
-   Ability.

------------------------------------------------------------------------

## Energy

    Energy.gd

Mengatur:

-   Penambahan energi.
-   Pengurangan energi.
-   Validasi pembelian Guardian.

------------------------------------------------------------------------

## Question

    Question.gd
    QuestionGenerator.gd
    AnswerValidator.gd

Mengatur:

-   Pembuatan soal.
-   Jawaban benar.
-   Reward.

------------------------------------------------------------------------

# 5. Application Layer

Mengatur alur game.

## BattleController

Mengatur:

-   Start battle.
-   Victory.
-   Defeat.

## WaveManager

Mengatur:

-   Spawn wave.
-   Jumlah enemy.
-   Progress wave.

## EnergyService

Menghubungkan:

    Question
       ↓
    Energy Reward
       ↓
    Guardian Purchase

## GuardianService

Mengatur:

-   Spawn Guardian.
-   Placement request.

------------------------------------------------------------------------

# 6. Presentation Layer

Hanya mengatur visual.

Contoh:

    BattleUI
    GuardianView
    EnemyView
    QuestionPopup

Tidak boleh:

-   Menghitung damage.
-   Mengubah HP.
-   Mengatur aturan battle.

------------------------------------------------------------------------

# 7. Infrastructure Layer

Mengatur sistem pendukung.

Contoh:

    SaveManager
    DataLoader
    AudioManager

------------------------------------------------------------------------

# 8. Removed Old RPG Components

Komponen berikut tidak digunakan:

-   Player attack system.
-   Turn based battle.
-   Recharge use case.
-   Monster battle controller lama.

Adventure Math sekarang menggunakan:

    Question
     ↓
    Energy
     ↓
    Guardian
     ↓
    Tower Defense Battle

------------------------------------------------------------------------

# 9. Development Order

1.  Setup folder dan scene.
2.  Membuat Domain Energy.
3.  Membuat Question System.
4.  Membuat Guardian System.
5.  Membuat Enemy System.
6.  Membuat Wave System.
7.  Menghubungkan UI.
