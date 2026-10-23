# Arah Seni Math-Adventure v0.8

## Arah utama

Math-Adventure memakai estetika kartun tinta klasik era 1930-an. Ciri visual meliputi outline hitam yang tegas, siluet ekspresif, anggota tubuh lentur, tekstur kertas tua, dan warna yang terasa dicetak atau dilukis tangan. Inspirasi dibatasi pada teknik visual umum. Jangan menyalin karakter, logo, komposisi khas, atau aset dari Cuphead maupun Plants vs. Zombies.

## Dunia

World 1 tetap bernama **Addition Forest**. Hutan memiliki rumput bergelombang, pepohonan berliku, akar, jamur, bunga kecil, dan gerbang Core Numeria. Area permainan harus terbaca jelas dari ukuran layar ponsel landscape. Hindari detail ramai di tengah jalur. Detail dekoratif ditempatkan di pinggir.

## Palet

- Kertas krem: `#EEE2C4`
- Tinta gelap: `#171A13`
- Hijau hutan: `#31482F`
- Hijau sage: `#637E7A`
- Emas antik: `#D3AD5B`
- Merah bata untuk damage: `#B95C49`

## UI

HUD dibuat sederhana seperti seed bank tower-defense: energi, tiga kartu Guardian, wave, HP Core, jeda, dan menu. Gunakan panel beroutline tinta dan sudut sedikit membulat. Hindari paragraf instruksi selama battle. Soal matematika muncul sebagai panel kecil setelah pemain mengetuk tombol energi. Saat panel terbuka, battle berhenti sementara agar soal tidak terasa mengganggu aksi.

## Aset yang akan dibuat

| Aset | Lokasi | Ukuran yang disarankan |
|---|---|---|
| Latar Addition Forest | `assets/backgrounds/addition_forest_bg.png` | 1920 × 800, landscape |
| Plusy | `assets/characters/plusy.png` | 512 × 512, transparan |
| Addy Cannon | `assets/characters/addy_cannon.png` | 512 × 512, transparan |
| Shield Cube | `assets/characters/shield_cube.png` | 512 × 512, transparan |
| Error Blob | `assets/characters/error_blob.png` | 512 × 512, transparan |
| Minus Monster | `assets/characters/minus_monster.png` | 512 × 512, transparan |
| Calculator Bug | `assets/characters/calculator_bug.png` | 512 × 512, transparan |

## Aturan PNG

1. Gunakan PNG RGBA untuk karakter agar latar transparan.
2. Tampilkan seluruh siluet dan jangan memotong tangan, kaki, atau aksesori.
3. Semua karakter memakai ketebalan outline dan pencahayaan yang konsisten.
4. Desain karakter orisinal, tidak meniru desain berhak cipta.
5. Hindari teks yang menyatu dengan gambar kecuali logo yang memang dirancang sebagai aset tersendiri.
6. Pastikan karakter tetap jelas saat ditampilkan sekitar 60 sampai 80 piksel di layar.

## Implementasi saat ini

Kode arena memeriksa file PNG pada path yang tercantum di atas. Jika file tersedia, arena memakainya. Jika tidak, game memakai gambar fallback prosedural agar proyek tetap bisa dijalankan selama aset sedang disiapkan.
