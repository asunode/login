# LoginShell

LoginShell, shell-first Flutter desktop uygulama omurgasi uzerinde gelisen bir local auth, authorized menu ve yonetim yuzeyi projesidir.

## Proje Ozeti

Uygulama dogrudan login ekraniyla acilmaz. Acilista kalici shell gelir:

- ust bar
- orta alan
- alt bar
- varsayilan root icerik olarak InfoView

Bu yapi korunarak local auth, admin yonetimi ve ileride gercek yetkilendirme omurgasi kademeli olarak eklenmektedir.

## Dogrulandi / Calisiyor

- Shell-first masaustu akisi calisiyor.
- Uygulama acilisinda shell gorunuyor.
- Ust bar davranislari calisiyor:
  - Home
  - tema degisimi
  - kullanici slotu / logout davranisi
  - settings
  - guvenli cikis
- Sol ust baslik kapsulu root navigation davranisina bagli:
  - login yokken `Login`
  - login varken kullanicinin display name degeri
  - tiklaninca login root veya authorized menu root
- Logout ve Safe Exit ayrimi korunuyor.
- Guvenli cikista `exit(0)` nedeniyle debug konsolunda `Lost connection to device` gorulmesi normal davranistir; hata olarak degerlendirilmemelidir.
- Login artik eski mock user listesine degil, Isar-backed local auth akisina baglidir.
- `admin / admin123` ile giris calisiyor.
- Yanlis parola reddediliyor.
- Logout sonrasi login ekranina donus calisiyor.
- `LocalUser`, `LocalGroup`, `LocalModule` modelleri projede mevcut.
- Bootstrap / seed yapisi calisiyor.
- Built-in admin kullanici, built-in yonetici grubu ve temel moduller seed ediliyor.
- Sifre duz metin tutulmuyor; hash mantigi kullaniliyor.
- Session halen memory tabanlidir; persistence bu checkpointte yoktur.
- Admin authorized menu kart basliklari final hedefe yaklastirildi:
  - `Kullanici Tanimi`
  - `Grup Tanimi`
  - `Modul Tanimi`
  - `Sifre Guncelle`
- Authorized menu kartlari tiklanabilir.
- Shell icinde authorized menu alt gorunum mantigi acildi.
- `Kullanici Tanimi` karti shell icinde ayri alt ekrana geciyor.
- `Grup Tanimi` karti shell icinde gercek group yonetim ekranina geciyor.
- `Modul Tanimi` karti shell icinde gercek modul yonetim ekranina geciyor.
- Login ekranindaki eski mock kullanici dili temizlendi.
- Login paneli ve login view metinleri gercek yerel dogrulama akisina gore guncellendi.
- Admin ornek hesabinin gorunurlugu korunuyor.
- `connection_profile_form.dart` icindeki overflow problemi scroll yaklasimiyla giderildi.
- UI polish ihtiyaci olabilir; ancak bu konu bloklayici hata olarak kayitli degildir.
- `LocalUser` modeline modul tarafi icin gecici staging mantigi eklendi.
- `stagedModuleCodes` alani vardir.
- Bu alan, final modul ID yapisi gelene kadar gecici modul secim kaydi tasimak icin kullanilir.
- `dart run build_runner build --delete-conflicting-outputs` basarili calisti.
- Analyzer surum uyarisi not seviyesindedir; bloklayici degildir.
- Shell icinde calisan Isar-backed `Kullanici Tanimi` yuzeyi kuruldu ve aktif akisa baglandi.
- Kullanici listesi gercek `LocalUser` kayitlarindan geliyor.
- Grup secimi gercek `LocalGroup` verisiyle aciliyor.
- `stagedModuleCodes` alani gercekten okunup yaziliyor.
- Yeni kullanici ekleme calisiyor.
- Yeni kullanici ilk gecici parola ile giris yapabiliyor.
- Uygulama kapatilip yeniden acildiginda kullanici kayitlari kalici olarak geliyor.
- Silinen kullanici kaydi kapat-ac sonrasinda da silinmis kaliyor.
- Built-in admin delete korumasi runtime olarak teyit edildi.
- Admin disi kullanicilarin yonetim menusu gorunurlugu operator akisina dogru daraltildi.
- Shell icinde calisan Isar-backed `Grup Tanimi` yuzeyi gercek akisa baglandi.
- Group list / create / update / delete akislarinin saha testi yapildi ve calistigi teyit edildi.
- Built-in yonetici grubu korumasi aktif ve dogrulandi.
- Shell icinde calisan Isar-backed `Modul Tanimi` yuzeyi gercek akisa baglandi.
- `shell_page.dart` icinde `module-management` gercek view'a bagli.
- `LocalModule` modelindeki `iconKey` alani aktif kararin parcasi olarak kullaniliyor.
- Modul adi, aciklama, aktif/pasif, silme ve kaydetme akislarinin saha testi yapildi.
- Yeni modul ekleme ve silme calisiyor.
- Built-in temel moduller listede gorunuyor.
- Modul ikonu ilk olusturma aninda basliga gore seciliyor.
- Ikon sonraki duzenlemelerde sabit kalacak mantikla ele aliniyor.
- Kullanici, Grup ve Modul Tanimi ekranlarinin ucu de shell icinde gercek view olarak aciliyor ve temel saha testlerinden gecmis durumda.
- Authorized menu gecisi calisiyor.

## Mimari Not

- Kullanici verisinde grup ve modul alanlari bulunmalidir.
- Grup tarafi gercek domain alani olarak Isar'da tutulabilir.
- Modul atamasi ise gercek final ID yapisi netlesene kadar gecici staging mantigiyla ele alinmaktadir.
- Yonetici yetkisi yalnizca Admin icin ele alinmaktadir.
- Yonetici grubunda olmayan kullanicilar kullanici/grup/modul yonetim alanlarini ve ilgili menuleri gormez.
- Grup tanimlari ileride genisledikce yetki kararlarini admin verecektir.
- Ozet karar:
  - Group = gercek domain alani
  - Module assignment = gecici staging alani

## Acik Risk / Dikkat Notu

- Authorized menu kaynagi halen gecici / mock role-based yapi uzerinden besleniyor.
- Rol cozumu halen gecici mantikta.
- Su anda yalnizca `Yonetici` grup yapisi bulundugu icin farkli grup senaryolari henuz test edilmedi.
- Modul tarafi bilincli olarak staging alani mantiginda ilerliyor.
- Modul metadata ve daha derin baglanti yapisi PostgreSQL sonrasi faza birakildi.
- `Sifre Guncelle` ekrani halen placeholder / hazirlik asamasinda.

## Sonraki Adim

1. `Kullanici Tanimi` ekranindaki modul staging alanini sabit secim listesinden cikarip gercek `LocalModule` kayitlarindan beslemek
2. Yetkili menuleri ve ekran erisim mantigini kademeli olarak gercek veri omurgasiyla hizalamak
3. Session persistence daha sonra
4. PostgreSQL entegrasyon plani daha sonra

## Dokumantasyon

- [Project Context](docs/PROJECT_CONTEXT.md)
- [Roadmap](docs/ROADMAP.md)
- [Tasks](docs/TASKS.md)
- [Changelog](docs/CHANGELOG.md)
