# Project Context

## Purpose

LoginShell, shell-first Flutter Windows desktop omurgasi uzerinde gelisen bir local auth, authorized menu, connection profile ve kademeli yonetim ekranlari projesidir.

## Dogrulandi / Calisiyor

### Shell Omurgasi

- Proje shell-first Windows desktop akisiyla calisiyor.
- Uygulama acilisinda shell gorunur; ust bar, orta alan ve alt bar birlikte yuklenir.
- Varsayilan root orta alan mantigi olarak `InfoView` korunur.
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
- Guvenli cikista `exit(0)` nedeniyle debug konsolunda `Lost connection to device` gorulmesi normal davranis notudur.

### Auth / Isar / Session

- Login Isar-backed local auth akisi uzerinden calisir.
- `admin / admin123` ile giris dogrulanmistir.
- Yanlis parola reddedilmektedir.
- Logout sonrasi login ekranina donus calismaktadir.
- `LocalUser`, `LocalGroup`, `LocalModule` modelleri aktif akista kullanilmaktadir.
- Bootstrap / seed yapisi calismaktadir.
- Built-in admin kullanici seed edilir.
- Built-in yonetici grubu seed edilir.
- Temel moduller seed edilir.
- Sifreler duz metin tutulmaz; hash mantigi kullanilir.
- Session halen memory tabanlidir; persistence bu checkpointte henuz eklenmemistir.

### Yonetim Ekranlari

- `Kullanici Tanimi`, `Grup Tanimi` ve `Modul Tanimi` ekranlarinin ucu de shell icinde gercek view olarak acilir.
- `Kullanici Tanimi` ekrani gercek `LocalUser` kayitlariyla calisir.
- `Grup Tanimi` ekrani gercek `LocalGroup` kayitlariyla calisir.
- `Modul Tanimi` ekrani gercek `LocalModule` kayitlariyla calisir.
- Bu uc ekran placeholder degildir; shell akisi icine bagli gercek yonetim yuzeyleridir.

### Modul / Grup / Kullanici Zinciri

- `LocalGroup` modeline `moduleCodes` alani eklenmistir.
- Boylesiyle grup uzerinde gercek modul paketi tasinabilir hale gelmistir.
- `Grup Tanimi` ekrani artik grup uzerine gercek modul paketi kaydedebilmektedir.
- `Kullanici Tanimi` ekranindaki modul listesi artik sabit / hardcoded secimlerden degil, gercek `LocalModule` kayitlarindan beslenir.
- `Modul Tanimi` ekrani mevcutta gercek modul kayitlariyla calismaya devam eder.
- Sonuc olarak `Modul -> Grup -> Kullanici` zinciri uygulama icinde fiilen acilmistir.

### Yetkili Menu Gecisi

- Yetkili menu cozumu bir gecis adimi daha ilerlemistir.
- `mock_authorized_menu_repository.dart` dosya adi mock kalmis olsa da, cozum artik kullanicinin grubunu okuyup grup uzerindeki `moduleCodes` degerlerine gore gorunur menu uretebilir.
- Admin disi kullanicilar icin admin-only moduller gorunmez.
- Demo kullanicisinda bos menu davranisi kontrollu bicimde dogrulanmistir.
- Login kullanicisinda grup uzerinden gelen `TeknikServis` modulu goruntulenmistir.
- Muhasebe kullanicisinda grup uzerinden gelen coklu modul paketi goruntulenmistir.
- Bu saha dogrulamalariyla grup bazli modul yetkilendirme yolu pratikte test edilmistir.

## Mimari Karar

- Final hedef yon artik daha nettir:
  - Modul = calisma alani
  - Grup = modul paketi
  - Kullanici = gruba bagli yetkili kisi
- Gercek menu cozumu artik grup bazli calisir.
- Ancak sistem halen hibrit gecis asamasindadir.
- Kullanici ustundeki `stagedModuleCodes` alani tamamen kaldirilmamis durumdadir.
- Bu alan artik ana yetki kaynagi olarak anlatilmamali; gecis / migrasyon / legacy override alani rolune yaklasmaktadir.
- Final authorization modeli tam oturdugunda bu alan:
  - kaldirilmali
  - veya yalnizca ikincil override / gecis notu rolune indirilmeli

## Acik Risk / Dikkat Notu

- Yetkili menu cozumunun grup bazli yola gecmis olmasi, final authorization modelinin tamamen tamamlandigi anlamina gelmez.
- `mock_authorized_menu_repository.dart` halen gecis katmanidir.
- Session persistence henuz devreye alinmamistir.
- `Sifre Guncelle` ekrani halen placeholder / hazirlik asamasindadir.
- `Modul Staging Alani` teknik borc olarak izlenmelidir; final modelde unutulmamasi gereken temizlik kalemidir.

## Sonraki Adim

1. `Kullanici Tanimi` ekranini grup bazli gercek yetki modeline daha acik sekilde hizalamak
2. `Modul Staging Alani`nin nihai rolunu netlestirmek
3. Uygunsa kullanici ekranindaki modul bolumunu sadeleştirmek
4. Hibrit authorization katmanlarini kontrollu bicimde final modele yaklastirmak
