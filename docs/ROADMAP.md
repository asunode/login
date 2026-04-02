# Roadmap

## Phase 1: Shell Foundation

### Dogrulandi / Calisiyor

- Shell-first masaustu acilis omurgasi aktif.
- Ust bar, orta alan ve alt bar birlikte calisiyor.
- Varsayilan root orta alan mantigi olarak InfoView korunuyor.
- Home, tema degisimi, kullanici slotu / logout, settings ve guvenli cikis davranislari aktif.
- Sol ust baslik kapsulu root navigation davranisina bagli.
- Logout ve Safe Exit ayrimi korunuyor.
- `exit(0)` sonrasi debug konsolunda `Lost connection to device` gorulmesi normal davranis notudur.

## Phase 2: Local Auth Foundation

### Dogrulandi / Calisiyor

- Login Isar-backed local auth akisina baglandi.
- `admin / admin123` ile giris dogrulandi.
- Yanlis parola reddediliyor.
- Logout sonrasi login ekranina donus calisiyor.
- `LocalUser`, `LocalGroup`, `LocalModule` modelleri mevcut.
- Bootstrap / seed yapisi aktif.
- Built-in admin kullanici, built-in yonetici grubu ve temel moduller seed ediliyor.
- Sifreler hash ile tutuluyor.
- Session halen memory tabanli.

### Acik Risk / Dikkat Notu

- Session persistence bu fazda tamamlanmadi.
- Authorized menu kaynagi henuz final gercek veri modeli degil.

## Phase 3: Admin Menu Transition

### Dogrulandi / Calisiyor

- Admin yetkili menu kart basliklari final hedefe yaklastirildi:
  - `Kullanici Tanimi`
  - `Grup Tanimi`
  - `Modul Tanimi`
  - `Sifre Guncelle`
- Authorized menu kartlari tiklanabilir.
- Shell icinde authorized menu alt gorunum mantigi acildi.
- `Kullanici Tanimi` karti shell icinde ayri alt ekrana geciyor.
- Yonetim ekranlari kademeli olarak gercek shell view'larina tasiniyor.

## Phase 4: User Management Integration

### Dogrulandi / Calisiyor

- Shell icinde calisan Isar-backed `Kullanici Tanimi` yuzeyi kuruldu ve test edildi.
- Geri donus akisi calisiyor.
- Kullanici listesi gercek `LocalUser` verisinden geliyor.
- Grup alani gercek `LocalGroup` verisini kullaniyor.
- `stagedModuleCodes` ile modul staging akisi aktif.
- Create / update / delete / reset password akislarinin kodu uygulanmis durumda.
- Yeni kullanici ekleme, gecici parola ile giris, restart sonrasi kalicilik ve silme kaliciligi dogrulandi.
- Built-in admin delete korumasi runtime olarak teyit edildi.
- Admin disi kullanicilarin yonetim menusu gorunurlugu operator akisina dogru daraltildi.

### Acik Risk / Dikkat Notu

- Farkli grup senaryolari henuz test edilmedi; mevcut durumda yalnizca `Yonetici` grup yapisi bulunuyor.

## Phase 5: Group / Module Management

### Dogrulandi / Calisiyor

- `Grup Tanimi` shell icinde gercek view olarak aciliyor; placeholder degil.
- Isar-backed group list / create / update / delete akisi acik.
- Built-in yonetici grubu korunuyor.
- Saha testi yapildi ve calistigi teyit edildi.
- `Modul Tanimi` shell icinde gercek view olarak aciliyor; placeholder degil.
- `shell_page.dart` icinde `module-management` gercek view'a baglandi.
- `LocalModule` modelinde `iconKey` alani mevcut ve aktif kararin parcasi.
- Modul adi, aciklama, aktif/pasif, silme ve kaydetme akislarinin saha testi yapildi.
- Yeni modul ekleme ve silme calisiyor.
- Built-in temel moduller listede gorunuyor.
- Modul ikonu ilk olusturma aninda basliga gore seciliyor.
- Ikon sonrasinda sabit kalacak mantikla ele aliniyor.

### Acik Risk / Dikkat Notu

- Module assignment mantigi henuz kullanici ustunde staging olarak tutuluyor.
- Modul metadata ve daha derin baglanti yapisi PostgreSQL sonrasi faza birakildi.

## Phase 6: Real Authorization Model

### Sonraki Adim

- `Kullanici Tanimi` ekranindaki modul staging alanini gercek `LocalModule` verisine baglama
- Yetkili menuleri ve ekran erisim mantigini kademeli olarak gercek veri omurgasiyla hizalama
- Mock role-based menu mantigindan kontrollu cikis
- Gercek authorization modelini local control verisiyle hizalama

## Phase 7: Persistence / PostgreSQL

### Sonraki Adim

- Session persistence daha sonra
- PostgreSQL entegrasyon plani daha sonra

## Mimari Not

- Kullanici verisinde grup ve modul alanlari olmalidir.
- Group = gercek domain alani
- Module assignment = gecici staging alani
- Bu ayrim, final modul ID yapisi netlesene kadar korunacaktir.
