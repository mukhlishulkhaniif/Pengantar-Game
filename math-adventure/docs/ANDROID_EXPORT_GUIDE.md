# Panduan menyiapkan ekspor Android

Game dirancang untuk Android dalam orientasi landscape. Pengaturan Android SDK/JDK dan export template perlu dilakukan satu kali pada komputer pengembang.

1. Buka Godot 4.7.2.
2. Pasang export templates yang sesuai dari menu **Editor > Manage Export Templates** jika belum tersedia.
3. Siapkan JDK dan Android SDK sesuai panduan resmi Godot 4.7.2.
4. Buka **Editor > Editor Settings > Export > Android**, lalu isi lokasi JDK dan Android SDK.
5. Buka **Project > Export**, tambahkan preset **Android**, dan isi package name unik, misalnya `com.numeria.mathadventure` jika belum digunakan.
6. Ekspor APK debug untuk pengujian. Pasang APK pada HP Android dan uji ukuran teks, target sentuh, orientasi landscape, suara, performa, dan alur menang/kalah.
7. Jangan membagikan APK sebelum pengujian perangkat selesai.

Nama menu dan kebutuhan SDK dapat berbeda menurut sistem yang telah terpasang. Rujuk dokumentasi resmi Godot untuk versi yang sedang digunakan.
