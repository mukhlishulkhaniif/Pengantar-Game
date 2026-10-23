# Math-Adventure MVP v0.9: Mobile usability

## Perubahan

- Panel tantangan matematika menyesuaikan lebar viewport agar lebih aman pada layar sempit.
- Pilihan jawaban memakai susunan dua kolom dengan target sentuh lebih besar.
- Tombol lanjut dan tombol layar hasil memiliki tinggi minimum yang lebih nyaman untuk sentuhan.
- Panel menu dan cara bermain menggunakan lebar yang menyesuaikan viewport.
- Aset PNG sengaja tidak ditambahkan pada versi ini. Fallback prosedural tetap dipakai sampai tahap pembuatan aset.

## Uji manual di Godot 4.7.2

1. Jalankan menu utama dan buka/tutup Cara Main.
2. Masuk battle, ketuk tombol energi, pastikan soal tampil dan permainan berhenti sementara.
3. Pastikan empat pilihan jawaban tampil dalam grid dua kolom dan dapat ditekan.
4. Jawab benar dan salah; pastikan reward dan umpan balik benar.
5. Tutup panel dan pastikan permainan berlanjut.
6. Pilih Guardian dengan ketuk lalu ketuk petak, dan uji drag-and-drop dengan mouse. Uji sentuh drag setelah build Android tersedia.
7. Selesaikan battle untuk memastikan panel hasil, pembahasan, main lagi, dan menu utama tetap bekerja.
8. Periksa tab Debugger untuk parser error dan runtime error.

Catatan: perubahan ini telah diperiksa secara statis. Runtime Godot dan perangkat Android belum tersedia untuk pengujian langsung dalam lingkungan pembuatan paket.
