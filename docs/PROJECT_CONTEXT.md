# Project Context

## Purpose

LoginShell, shell-first Flutter desktop omurgasi uzerinde gelisen bir local auth, authorized menu, connection profile ve ileride genisleyecek yonetim ekranlari projesidir.

## Dogrulandi / Calisiyor

### Shell Omurgasi

- Proje shell-first masaustu akisiyla calisiyor.
- Uygulama acilisinda shell gorunur; ust bar, orta alan ve alt bar birlikte yuklenir.
- Varsayilan root orta alan mantigi olarak InfoView korunur.
- Ust bar davranislari aktif durumdadir:
  - Home
  - tema degisimi
  - kullanici slotu / logout davranisi
  - settings
  - guvenli cikis
- Sol ust baslik kapsulu root navigation davranisina baglidir:
  - login yokken `Login`
  - login varken kullanicinin display name degeri
  - tiklandiginda login root veya authorized menu root
- Logout ve Safe Exit ayrimi korunmustur.
- Guvenli cikista `exit(0)` nedeniyle debug konsolunda `Lost connection to device` gorulmesi normal davranistir; hata gibi ele alinmamaktadir.

### Auth / Isar / Session

- Login artik eski mock user listesi uzerinden degil, Isar-backed local auth akisi uzerinden calisir.
- `admin / admin123` ile giris dogrulanmistir.
- Yanlis parola reddedilmektedir.
- Logout sonrasi login ekranina donus calismaktadir.
- `LocalUser`, `LocalGroup`, `LocalModule` modelleri projede mevcuttur.
- Bootstrap / seed yapisi calismaktadir.
- Built-in admin kullanici seed edilir.
- Built-in yonetici grubu seed edilir.
- Temel moduller seed edilir.
- Sifreler duz metin tutulmaz; hash mantigi kullanilir.
- Session halen memory tabanlidir; persistence bu checkpointte henuz eklenmemistir.
- Authorized menu icerigi final veri modeli seviyesinde degildir; gecis asamasindadir.

### Menu / Yetkili Alan

- Admin yetkili menu kart basliklari final hedefe yaklastirilmistir:
  - `Kullanici Tanimi`
  - `Grup Tanimi`
  - `Modul Tanimi`
  - `Sifre Guncelle`
- Authorized menu kartlari tiklanabilirdir.
- Shell icinde authorized menu alt gorunum mantigi acilmistir.
- `Kullanici Tanimi` karti shell icinde ayri alt ekrana gecer.
- `Grup Tanimi` karti shell icinde gercek group yonetim ekranina gecer.
- `Modul Tanimi` karti shell icinde gercek modul yonetim ekranina gecer.
- Admin disi kullanicilarin gorunurlugu operator akisina dogru daraltilmistir.
- Yonetici yetkisi yalnizca Admin icin ele alinmaktadir.
- Yonetici grubunda olmayan kullanicilar kullanici/grup/modul yonetim alanlarini ve ilgili menuleri gormez.
- Grup tanimlari ileride genisledikce yetki kararlarini admin verecektir.

### Login / UI Metinleri

- Login ekranindaki eski mock kullanici dili temizlenmistir.
- Login paneli ve login view metinleri gercek yerel dogrulama akisina gore guncellenmistir.
- Admin ornek hesabinin gorunurlugu korunmustur.
- Eski mock anlatimi bu checkpointte aktif gercek durum olarak kullanilmamaktadir.

### Settings

- `connection_profile_form.dart` icindeki overflow problemi scroll yaklasimiyla giderilmistir.
- Bu konu kapanmis kabul edilir.
- Gerekirse ileride UI polish yapilabilir; ancak bloklayici hata notu yoktur.

### Local User Model

- `LocalUser` modeline modul tarafi icin gecici staging mantigi eklenmistir.
- `stagedModuleCodes` alani mevcuttur.
- Bu alanin amaci:
  - final modul ID yapisi gelene kadar gecici kayit tutmak
  - kullanici ustunde staging mantigiyla modul secimini tasimak
- `dart run build_runner build --delete-conflicting-outputs` basarili calismistir.
- Analyzer surum uyari notu bloklayici degildir.

### Kullanici Tanimi Ekrani

- Shell icinde calisan ilk gercek `Kullanici Tanimi` yuzeyi kurulmus ve test edilmistir.
- Ekran shell icine oturur.
- Geri donus akisi calisir.
- Kullanici listesi ve sag panel form mantigi acilmistir.
- Grup alani ve modul staging alani UI seviyesinde gosterilir.
- Built-in admin korumasi UI seviyesinde dusunulmustur.
- Kullanici listesi gercek `LocalUser` kayitlarindan gelir.
- Grup secimi gercek `LocalGroup` verisiyle acilir.
- `stagedModuleCodes` alani okunup yazilir.
- Yeni kullanici ekleme calisir.
- Gecici parola ile giris calisir.
- Kapat-ac sonrasi kalicilik calisir.
- Silme kaliciligi calisir.
- Built-in admin delete korumasi runtime olarak teyit edilmistir.

### Grup Tanimi Ekrani

- `Grup Tanimi` placeholder degildir; shell icinde gercek view olarak acilir.
- Isar-backed group list / create / update / delete akisi aciktir.
- Built-in yonetici grubu korunur.
- Saha testi yapilmis ve calistigi teyit edilmistir.

### Modul Tanimi Ekrani

- `Modul Tanimi` placeholder degildir; shell icinde gercek view olarak acilir.
- `shell_page.dart` icinde `module-management` gercek view'a baglidir.
- `LocalModule` modelinde `iconKey` alani mevcuttur.
- Modul adi, aciklama, aktif/pasif, silme ve kaydetme akislarinin gercek akista oldugu teyit edilmistir.
- Ikon ilk olusturma aninda basliga gore secilir.
- Ikon sonrasinda sabit kalacak mantikla ele alinir.
- Yeni modul ekleme ve silme saha testlerinde calismistir.
- Built-in temel moduller listede gorunur.
- Modul metadata ve daha derin baglanti yapisi PostgreSQL sonrasi faza birakilan teknik borc olarak tutulur.

## Mimari Karar

- Kullanici verisinde grup ve modul alanlari bulunmalidir.
- Grup tarafi gercekci kayit olarak Isar'da tutulabilir.
- Modul tarafi ise ileride netlesecek gercek ID yapisina kadar gecici kayit / staging mantigiyla ele alinmaktadir.
- Yonetici yetkisi yalnizca Admin icin ele alinmaktadir.
- Yonetici grubunda olmayan kullanicilar kullanici/grup/modul yonetim alanlarini ve ilgili menuleri gormez.
- Grup tanimlari ileride genisledikce yetki kararlarini admin verecektir.
- Ozet:
  - Group = gercek domain alani
  - Module assignment = gecici staging alani

## Acik Risk / Dikkat Notu

- Yetkili menu icerigi halen kademeli gecis asamasindadir; final authorization modeli olarak yorumlanmamalidir.
- Session persistence henuz devreye alinmamistir.
- Module assignment henuz staging mantigindadir.
- Modul metadata ve daha derin baglanti yapisi PostgreSQL sonrasi faza birakilmistir.
- Analyzer surum uyari notu bloklayici degildir; ancak gelistirme ortamlarinda izlenmeye devam edilmelidir.

## Sonraki Adim

1. `Kullanici Tanimi` ekranindaki modul staging alanini sabit secim listesinden cikarip gercek `LocalModule` kayitlarindan beslemek
2. Yetkili menuleri ve ekran erisim mantigini kademeli olarak gercek veri omurgasiyla hizalamak
3. Session persistence daha sonra
4. PostgreSQL entegrasyon plani daha sonra
