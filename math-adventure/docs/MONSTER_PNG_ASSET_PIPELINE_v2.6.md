# Math-Adventure v2.6 — Monster PNG Asset Pipeline

## Tujuan
Menyiapkan pipeline aset PNG monster sebelum ilustrasi final dibuat. Tidak ada PNG monster final yang ditambahkan pada versi ini; game menggunakan fallback prosedural sampai file aset ditempatkan.

## File yang diharapkan
- `assets/monsters/error_blob.png`
- `assets/monsters/minus_monster.png`
- `assets/monsters/calculator_bug.png`

## Perubahan kode
- Loader monster mengarah ke folder `assets/monsters/`.
- File PNG bersifat opsional; ketiadaan file tidak menghentikan game.
- Sprite otomatis mempertahankan rasio lebar/tinggi PNG.
- Ukuran maksimum per monster dikonfigurasi melalui `ENEMY_SPRITE_MAX_SIZES`.
- Animasi bob/squash dan hit flash tetap aktif pada PNG.
- HP bar tetap dirender oleh game, terpisah dari aset.

## Pengujian
1. Jalankan game tanpa PNG monster: fallback prosedural harus tampil.
2. Tambahkan PNG transparan dengan nama tepat di atas.
3. Restart project atau reimport aset.
4. Pastikan sprite tidak terdistorsi, tidak terpotong, dan menghadap kiri.
5. Pastikan HP bar serta kilatan damage masih terlihat.
