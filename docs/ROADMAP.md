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
- Diger yonetim ekranlari placeholder / hazirlaniyor mantiginda.

## Phase 4: User Management Integration

### Dogrulandi / Calisiyor

- Shell icinde calisan Isar-backed `Kullanici Tanimi` yuzeyi kuruldu ve test edildi.
- Geri donus akisi calisiyor.
- Kullanici listesi gercek `LocalUser` verisinden geliyor.
- Grup alani gercek `LocalGroup` verisini kullaniyor.
- `stagedModuleCodes` ile modul staging akisi aktif.
- Create / update / delete / reset password akislarinin kodu uygulanmis durumda.
- Yeni kullanici ekleme, gecici parola ile giris, restart sonrasi kalicilik ve silme kaliciligi dogrulandi.

### Acik Risk / Dikkat Notu

- Built-in admin delete korumasi kod duzeyinde mevcut; manuel runtime teyidi bu fazda kisa acik not olarak bekliyor.
- Farkli grup senaryolari henuz test edilmedi; mevcut durumda yalnizca `Yonetici` grup yapisi bulunuyor.

## Phase 5: Group / Module Management

### Sonraki Adim

- `Grup Tanimi` ekranina gecis
- `Modul Tanimi` ekranina gecis
- Group alanini gercek domain kaydi olarak buyutme
- Module assignment mantigini staging uzerinden kontrollu tasima

## Phase 6: Real Authorization Model

### Sonraki Adim

- Yetkili menuleri kademeli olarak gercek veri omurgasina baglama
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
