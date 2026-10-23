# Adventure Math

# Balance Document

## 1. Overview

Dokumen ini mengatur keseimbangan ekonomi dan tingkat kesulitan
Adventure Math.

Tujuan:

-   Gameplay terasa menantang tetapi tidak membuat anak SD frustrasi.
-   Pemain selalu memiliki kesempatan membuat strategi.
-   Matematika tetap menjadi sumber kekuatan utama.

------------------------------------------------------------------------

# 2. Core Economy

Resource utama:

## Math Energy

Digunakan untuk:

-   Membeli Guardian.
-   Mengaktifkan kemampuan tertentu.

Sumber Energy:

1.  Passive Energy.
2.  Math Challenge.

------------------------------------------------------------------------

# 3. Energy Balance

## Passive Energy

Passive Energy digunakan sebagai bantuan.

Contoh:

Plusy:

    +5 Energy / 5 detik

Tujuan:

-   Menjaga pemain tetap dapat bermain.
-   Tidak menggantikan fungsi soal matematika.

------------------------------------------------------------------------

## Math Challenge Reward

Reward berdasarkan kesulitan:

  Difficulty         Reward
  ------------ ------------
  Easy           +30 Energy
  Medium         +50 Energy
  Hard           +80 Energy

------------------------------------------------------------------------

# 4. Guardian Balance

## Plusy

Role: Energy Generator

Cost:

    50 Energy

Output:

    +5 Energy / 5 detik

------------------------------------------------------------------------

## Addy Cannon

Role: Damage Dealer

Cost:

    100 Energy

Stat awal:

    Damage: 10
    Range: Medium
    Attack Speed: Normal

------------------------------------------------------------------------

## Shield Cube

Role: Tank

Cost:

    75 Energy

Stat awal:

    HP: 300
    Damage: None

------------------------------------------------------------------------

# 5. Enemy Balance

## Error Blob

Role: Basic Enemy

Stat:

    HP: 50
    Speed: Normal
    Damage: Low

------------------------------------------------------------------------

## Minus Monster

Role: Disruptor

Stat:

    HP: 100
    Speed: Slow
    Ability:
    Reduce Energy

------------------------------------------------------------------------

## Calculator Bug

Role: Fast Enemy

Stat:

    HP: 70
    Speed: Fast
    Damage: Medium

------------------------------------------------------------------------

# 6. Level Difficulty

Kesulitan meningkat melalui:

## Mathematics

Awal:

-   Penjumlahan.
-   Pengurangan.

Menengah:

-   Perkalian.
-   Pembagian.

Lanjut:

-   Pecahan.
-   Persentase.

------------------------------------------------------------------------

## Battle

Awal:

-   3 lane.
-   Enemy sedikit.

Lanjut:

-   4-5 lane.
-   Kombinasi enemy.
-   Wave lebih panjang.

------------------------------------------------------------------------

# 7. Wave Balance

Contoh level awal:

## Wave 1

    5 Error Blob

## Wave 2

    10 Error Blob

## Wave 3

    Error Blob + Calculator Bug

## Wave 4

    Mixed Enemy

## Wave 5

    Final Challenge

------------------------------------------------------------------------

# 8. Difficulty Rule

Jika pemain gagal:

Game dapat menyesuaikan:

-   Mengurangi jumlah enemy.
-   Memberikan bonus Energy.
-   Memberikan soal lebih mudah.

Tujuan:

Membantu proses belajar.

------------------------------------------------------------------------

# 9. Future Upgrade

Sistem upgrade dapat ditambahkan:

Guardian Upgrade:

-   Damage.
-   HP.
-   Cooldown.
-   Energy efficiency.

Enemy Upgrade:

-   HP scaling.
-   Speed scaling.
-   Ability baru.

------------------------------------------------------------------------

# 10. Technical Implementation

Balance disimpan sebagai data.

Contoh:

    BalanceData

    Guardian Cost
    Enemy HP
    Question Reward
    Wave Configuration

Data berada di Infrastructure Layer.

Aturan perhitungan berada di Domain Layer.
