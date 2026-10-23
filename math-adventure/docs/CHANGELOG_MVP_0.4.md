# Changelog Math-Adventure MVP 0.4

## Fokus versi

Versi 0.4 menambahkan umpan balik visual pada aksi utama agar pemain lebih mudah memahami hubungan antara jawaban matematika, energi, penempatan Guardian, dan pertempuran. Loop inti serta struktur proyek dipertahankan.

## Perubahan

- Menambahkan animasi idle ringan pada Guardian dan musuh.
- Menambahkan efek visual prosedural saat Guardian ditempatkan.
- Menambahkan efek muzzle pada tembakan Addy Cannon dan jejak proyektil yang lebih terang.
- Menampilkan efek benturan dan angka kerusakan saat proyektil mengenai musuh.
- Menampilkan efek saat musuh dikalahkan beserta tambahan skor.
- Menampilkan efek saat Shield Cube menerima kerusakan atau hancur.
- Menampilkan pop-up energi ketika pemain menjawab soal benar atau salah, serta saat Plusy menghasilkan energi.
- Menampilkan pengumuman wave langsung di arena.
- Menampilkan efek kerusakan Core ketika musuh berhasil menerobos.
- Memperbarui label versi dan dokumentasi.

## Struktur yang dipertahankan

- Repository tetap menggunakan `Pengantar-Game` dengan proyek di `math-adventure/`.
- Scene utama, menu, sistem pertanyaan, tiga jalur, enam kolom, tiga wave, dan tiga Guardian tetap dipertahankan.
- Seluruh efek digambar dengan GDScript dan tidak memerlukan aset eksternal.

## Pengujian manual di Godot 4.7.2

1. Jalankan game dengan F5 dan mulai petualangan.
2. Jawab satu soal dengan benar dan satu soal dengan salah. Pastikan pop-up hasil muncul.
3. Tempatkan Guardian dan pastikan efek penempatan terlihat.
4. Amati Addy Cannon saat menembak dan pastikan benturan menampilkan angka kerusakan.
5. Amati Plusy menghasilkan energi dan Shield Cube menerima serangan.
6. Periksa pengumuman wave, kerusakan Core, serta layar menang/kalah.
7. Pastikan tidak ada error merah pada tab Debugger.

Paket ini telah diperiksa secara statis. Jalankan pengujian manual di editor Godot 4.7.2 sebelum commit ke GitHub.
