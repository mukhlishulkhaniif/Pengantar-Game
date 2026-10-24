# Math-Adventure MVP v1.0: gameplay dan arena mobile

## Perubahan

- Arena diubah dari 3 x 6 menjadi 5 baris x 9 kolom.
- Ukuran teks HUD, kartu Guardian, energi, wave, dan Core diperbesar untuk layar ponsel.
- Semua Guardian sekarang memiliki HP dan bar kesehatan.
- Monster berhenti ketika menyentuh Guardian di jalurnya dan menyerangnya sampai HP Guardian habis.
- Shield Cube memiliki HP paling tinggi, sedangkan Guardian biasa tetap dapat menahan monster.
- Jangkauan Addy Cannon ditingkatkan menjadi sekitar lima petak.
- Kecepatan monster diturunkan untuk memberi waktu kepada pemain menyusun pertahanan.
- Jumlah musuh dan interval kemunculan wave disederhanakan untuk tingkat kesulitan yang lebih ramah anak SD.
- Energi awal ditingkatkan menjadi 150 agar pemain dapat memasang beberapa Guardian sejak awal.
- Dua wave pertama menggunakan soal mudah dan wave terakhir menggunakan soal sedang.

## Pemeriksaan manual yang perlu dilakukan di Godot 4.7.2 dan HP Android

1. Buka proyek dan pastikan tidak ada parser error di tab Debugger.
2. Jalankan battle, pastikan grid terdiri dari 5 baris dan 9 kolom.
3. Coba ketuk kartu Guardian lalu petak kosong.
4. Coba drag-and-drop Guardian pada HP.
5. Periksa bahwa semua Guardian menampilkan bar HP.
6. Biarkan monster mendekati Guardian dan pastikan monster berhenti, menyerang, lalu bergerak lagi hanya setelah Guardian hancur.
7. Periksa jangkauan tembakan Addy Cannon dan pastikan proyektil hanya menyerang monster di jalur yang sama.
8. Uji seluruh tiga wave dan panel hasil.

Catatan: perubahan kode sudah disiapkan secara statis. Godot 4.7.2 dan perangkat Android tidak tersedia untuk menjalankan pengujian runtime di lingkungan pembuatan paket. Jalankan uji manual di perangkat sebelum mengganti APK yang sedang dipakai.
