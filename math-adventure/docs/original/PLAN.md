# Adventure Math

# Development Plan

## 1. Development Strategy

Adventure Math dikembangkan secara bertahap.

Prioritas utama:

1.  Gameplay berjalan.
2.  Sistem inti stabil.
3.  Visual dan konten ditambahkan.

Fokus awal adalah membuat prototype yang dapat dimainkan.

------------------------------------------------------------------------

# 2. Milestone

## Milestone 0 - Project Setup

Target:

Mempersiapkan struktur Godot.

Task:

-   Membuat project Godot 4.
-   Membuat folder 4 layer.
-   Membuat konfigurasi mobile landscape.
-   Membuat autoload dasar.

Status:

Pending.

------------------------------------------------------------------------

# Milestone 1 - Core Prototype

Target:

Membuat tower defense sederhana.

Fitur:

-   Battle Scene.
-   3 lane.
-   Enemy movement.
-   Guardian placement.
-   Guardian attack.
-   Core health.

Output:

Pemain dapat melihat pertempuran berjalan.

------------------------------------------------------------------------

# Milestone 2 - Math System

Target:

Menghubungkan matematika dengan gameplay.

Fitur:

-   Question System.
-   Math Challenge popup.
-   Energy reward.
-   Energy spending.

Output:

Pemain mendapatkan energi melalui soal.

------------------------------------------------------------------------

# Milestone 3 - Game Loop

Target:

Membuat permainan lengkap.

Fitur:

-   Wave system.
-   Victory condition.
-   Defeat condition.
-   Level data.

------------------------------------------------------------------------

# Milestone 4 - Content

Target:

Menambahkan isi game.

Fitur:

-   Guardian baru.
-   Enemy baru.
-   World baru.
-   Reward system.

------------------------------------------------------------------------

# Milestone 5 - Polish

Target:

Meningkatkan kualitas.

Fitur:

-   Animation.
-   Sound effect.
-   UI improvement.
-   Mobile optimization.

------------------------------------------------------------------------

# 3. Coding Order

Urutan implementasi:

    1. Domain Energy
    2. Domain Question
    3. Domain Guardian
    4. Domain Enemy
    5. Battle Controller
    6. Wave Manager
    7. Presentation UI
    8. Visual Asset

------------------------------------------------------------------------

# 4. Prototype Target v0.1

Prototype pertama harus memiliki:

-   Landscape mode.
-   Satu Battle Scene.
-   Tiga lane.
-   Satu enemy.
-   Satu guardian.
-   Energy system.
-   Question system.

------------------------------------------------------------------------

# 5. Development Rule

Jangan membuat:

-   Banyak karakter sebelum sistem stabil.
-   Asset final sebelum gameplay terbukti.
-   Level banyak sebelum balancing.

Prioritas:

Gameplay \> Architecture \> Content \> Visual Polish.

------------------------------------------------------------------------

# 6. First Implementation Task

Task pertama:

Membuat project Godot dengan:

    res://

    presentation/
    application/
    domain/
    infrastructure/
    resources/
    assets/
    scenes/

Kemudian membuat Domain Layer pertama:

    domain/energy/Energy.gd
