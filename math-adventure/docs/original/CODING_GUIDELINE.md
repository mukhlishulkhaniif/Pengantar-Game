# CODING GUIDELINE - MATH ADVENTURE

Version: 1.0

Purpose:

Standar coding agar proyek konsisten ketika dikerjakan oleh manusia
maupun AI developer.

------------------------------------------------------------------------

# 1. Architecture Rule

Math Adventure menggunakan 4 Layer Architecture.

## Presentation Layer

Bertugas:

-   UI
-   Input
-   Animation
-   Visual feedback

Tidak boleh:

-   Menghitung damage.
-   Mengubah HP langsung.
-   Mengatur aturan battle.

------------------------------------------------------------------------

## Application Layer

Bertugas:

-   Use case
-   Controller
-   Game flow

Contoh:

AttackUseCase

RechargeUseCase

------------------------------------------------------------------------

## Domain Layer

Bertugas:

-   Aturan inti game.
-   Entity.
-   Calculation.

Tidak boleh:

-   Memanggil UI.
-   Menjalankan animasi.
-   Bergantung pada Node Godot.

------------------------------------------------------------------------

## Infrastructure Layer

Bertugas:

-   Save data.
-   Database.
-   External service.

------------------------------------------------------------------------

# 2. Naming Convention

## Class

Gunakan PascalCase.

Contoh:

PlayerController

BattleState

## Function

Gunakan snake_case.

Contoh:

take_damage()

use_energy()

## Variable

Gunakan snake_case.

Contoh:

current_energy

max_health

------------------------------------------------------------------------

# 3. Single Responsibility

Satu class memiliki satu tanggung jawab.

Contoh buruk:

BattleManager.gd

Berisi:

-   UI
-   Damage
-   Sound
-   Save
-   Animation

Contoh baik:

BattleController.gd

hanya mengatur flow battle.

------------------------------------------------------------------------

# 4. Dependency Rule

Arah dependency:

Presentation

↓

Application

↓

Domain

↓

Infrastructure

Domain tidak boleh bergantung pada layer atas.

------------------------------------------------------------------------

# 5. Code Quality Rules

AI developer wajib:

-   Membuat kode yang mudah dibaca.
-   Menghindari duplikasi.
-   Memberikan nama yang jelas.
-   Membuat fungsi kecil.
-   Menambahkan komentar jika logic kompleks.

------------------------------------------------------------------------

# 6. Feature Development Process

Sebelum membuat fitur:

AI harus menjelaskan:

1.  Tujuan fitur.
2.  Perubahan file.
3.  Dampak sistem.
4.  Cara testing.

------------------------------------------------------------------------

# 7. Testing Rule

Setiap sistem utama harus diuji:

Player: - HP berkurang. - HP tidak negatif.

Energy: - Tidak melebihi maksimum. - Tidak kurang dari nol.

Battle: - State berpindah dengan benar.

Math: - Jawaban benar dan salah berjalan.

------------------------------------------------------------------------

# 8. Project Philosophy

Prioritas:

1.  Clean architecture.
2.  Gameplay yang menyenangkan.
3.  Kode yang mudah dikembangkan.
4.  Performa mobile.
5.  Visual polish.
