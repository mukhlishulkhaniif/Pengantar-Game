# Adventure Math

# Technical Design Document (Energy System Revision)

## 1. Energy Architecture

Math Energy berada pada Domain Layer.

Terdapat dua sumber:

1.  Passive Energy
2.  Math Challenge Reward

------------------------------------------------------------------------

# 2. Energy Flow

    Guardian Generator
            |
            v
     Passive Energy


    Question Service
            |
            v
     Correct Answer
            |
            v
     Energy Reward

------------------------------------------------------------------------

# 3. Question Flow

    Player Tap Energy Button

    ↓

    Presentation Layer

    ↓

    Question Service

    ↓

    Question Domain Validation

    ↓

    Energy Domain Update

    ↓

    UI Refresh

------------------------------------------------------------------------

# 4. Domain Responsibility

Energy Domain:

-   Menambah energi.
-   Mengurangi energi.
-   Validasi transaksi Guardian.

Tidak mengetahui UI.

------------------------------------------------------------------------

# 5. Application Responsibility

Energy Service:

-   Menghubungkan soal dengan reward.
-   Mengatur request dari pemain.
-   Mengirim update ke UI.

------------------------------------------------------------------------

# 6. Presentation Responsibility

Menampilkan:

-   Energy counter.
-   Question popup.
-   Reward animation.

Tidak menghitung nilai.
