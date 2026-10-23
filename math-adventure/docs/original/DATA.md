# Adventure Math

# Data Design Document

## 1. Overview

Dokumen ini menentukan struktur data utama Adventure Math.

Data dirancang agar sesuai dengan 4 Layer Architecture.

------------------------------------------------------------------------

# 2. Guardian Data

Digunakan untuk menyimpan informasi Math Guardian.

Contoh:

``` json
{
"name":"Addy Cannon",
"type":"attacker",
"cost":100,
"damage":10,
"range":5,
"attack_speed":2
}
```

------------------------------------------------------------------------

# 3. Enemy Data

Contoh:

``` json
{
"name":"Error Blob",
"hp":50,
"speed":20,
"damage":10
}
```

------------------------------------------------------------------------

# 4. Energy Data

Menyimpan sistem Math Energy.

``` json
{
"current_energy":150,
"max_energy":999
}
```

------------------------------------------------------------------------

# 5. Math Challenge Data

Data soal matematika.

``` json
{
"type":"addition",
"difficulty":1,
"question":"12+8",
"answer":20,
"reward":50
}
```

------------------------------------------------------------------------

# 6. Level Data

Menyimpan konfigurasi level.

``` json
{
"world":"Addition Forest",
"lane_count":3,
"wave_count":5,
"question_type":"addition"
}
```

------------------------------------------------------------------------

# 7. Player Progress Data

Menyimpan:

-   Level terbuka.
-   Guardian terbuka.
-   Reward.

------------------------------------------------------------------------

# 8. Architecture Mapping

Domain Layer: - Guardian rules. - Enemy rules. - Energy rules. -
Question rules.

Application Layer: - Mengatur flow data.

Infrastructure Layer: - Menyimpan JSON/save data.

Presentation Layer: - Menampilkan data.
