# Catatan Implementasi

## Versi 0.2

MVP 0.2 memperbarui visual arena, alur soal matematika, wave, serangan proyektil, perilaku musuh, jeda permainan, dan statistik akhir. Semua visual utama dibuat dengan fungsi gambar Godot sehingga tidak membutuhkan aset eksternal.

### Alur permainan

1. Menu utama menyediakan tombol mulai dan panduan.
2. Battle dimulai pada wave pertama dengan soal mudah.
3. Jawaban benar memberi energi sesuai tingkat kesulitan; jawaban salah tetap memberi bantuan energi yang lebih kecil dan menunjukkan jawaban yang benar.
4. Energi digunakan untuk menempatkan Guardian di petak kosong.
5. Guardian memiliki peran berbeda: Plusy menghasilkan energi, Addy Cannon menembakkan proyektil, Shield Cube menahan musuh.
6. Wave berikutnya menaikkan kesulitan soal dan variasi musuh.
7. Hasil akhir menampilkan skor, jumlah musuh dikalahkan, dan akurasi jawaban.

### Batasan yang masih diketahui

- Progress level dan skor belum disimpan lintas sesi.
- Guardian belum memiliki sistem upgrade atau penjualan.
- Ekspor Android/iOS dan kontrol perangkat fisik belum disiapkan secara final.
- Uji akhir tetap perlu dilakukan di Godot 4.7.2 pada komputer pengguna.
