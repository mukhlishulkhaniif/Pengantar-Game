# Adventure Math

# UI/UX Design Document (Revised - Hybrid Math Energy System)

## 1. Energy Interaction Concept

Adventure Math menggunakan sistem Math Energy hybrid.

Pemain mendapatkan energi melalui dua cara:

1.  Passive Energy
2.  Math Challenge

Tujuan sistem: - Menjaga gameplay tetap seperti tower defense. -
Menjadikan matematika sebagai bagian utama permainan. - Menghindari
pemain merasa sedang mengerjakan ujian.

------------------------------------------------------------------------

# 2. Math Energy System

## Passive Energy

Passive Energy berasal dari Guardian tertentu seperti Plusy.

Contoh:

Plusy:

    +5 Energy / 5 detik

Fungsi: - Membantu pemain tetap bermain. - Mencegah pemain kehabisan
energi total.

------------------------------------------------------------------------

## Math Challenge

Math Challenge adalah sumber energi utama.

Pemain menekan tombol Energy di pojok kiri atas.

Flow:

    Tap Energy Button
            ↓
    Question Popup muncul
            ↓
    Pemain menjawab soal
            ↓
    Validasi jawaban
            ↓
    Energy Reward

------------------------------------------------------------------------

# 3. Energy Button

Tampilan:

    💎 150

Tidak menggunakan teks panjang.

Saat ditekan:

    +----------------+
    |  25 + 15 = ?   |
    |                |
    | [30] [40] [45] |
    +----------------+

------------------------------------------------------------------------

# 4. Reward Jawaban

Jawaban benar:

    +50 Energy

Jawaban salah:

    +10 Energy

Tambahan:

-   Combo benar memberikan bonus.
-   Soal sulit memberikan reward lebih besar.

------------------------------------------------------------------------

# 5. Battle UI Update

Layout:

    --------------------------------

    💎250          Wave 3/5       ⏸

    --------------------------------

    Lane 1 =================>

    Lane 2 =================>

    Lane 3 =================>

    Lane 4 =================>

    Lane 5 =================>


    --------------------------------

    🌱50   🔫100   🛡75

    --------------------------------

Soal tidak selalu tampil. Soal hanya muncul saat pemain meminta Energy
Challenge.

------------------------------------------------------------------------

# 6. UX Principle

Matematika harus terasa sebagai kekuatan pemain.

Bukan:

"Berhenti bermain untuk mengerjakan soal"

Tetapi:

"Gunakan kemampuan matematika untuk mendapatkan kekuatan."

------------------------------------------------------------------------

# 7. Presentation Layer

UI bertugas:

-   Menampilkan Energy.
-   Membuka Question Popup.
-   Menampilkan reward.

UI tidak menangani:

-   Perhitungan reward.
-   Validasi jawaban.
-   Perubahan energi.

Alur:

    Player Input
    ↓
    Presentation
    ↓
    Application
    ↓
    Domain
    ↓
    Update UI
