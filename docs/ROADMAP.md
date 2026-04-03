# Roadmap

## Phase 1: Shell Foundation

### Dogrulandi / Calisiyor

- Shell-first Windows desktop acilis omurgasi aktif.
- Ust bar, orta alan ve alt bar birlikte calisiyor.
- Varsayilan root orta alan mantigi olarak `InfoView` korunuyor.
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
- `LocalUser`, `LocalGroup`, `LocalModule` modelleri mevcut ve aktif akista.
- Bootstrap / seed yapisi aktif.
- Built-in admin kullanici, built-in yonetici grubu ve temel moduller seed ediliyor.
- Sifreler hash ile tutuluyor.
- Session halen memory tabanli.

### Acik Risk / Dikkat Notu

- Session persistence bu fazda tamamlanmadi.

## Phase 3: Management Screens Transition

### Dogrulandi / Calisiyor

- `Kullanici Tanimi`, `Grup Tanimi` ve `Modul Tanimi` ekranlari shell icinde gercek view olarak aciliyor.
- `Modul Tanimi` gercek `LocalModule` kayitlariyla calisiyor.
- `Kullanici Tanimi` ekrani gercek `LocalUser` kayitlariyla calisiyor.
- `Grup Tanimi` ekrani gercek `LocalGroup` kayitlariyla calisiyor.
- `Kullanici Tanimi` ekranindaki modul secim bolumu artik sabit listeden degil, gercek `LocalModule` kayitlarindan besleniyor.
- `Grup Tanimi` ekrani grup uzerine gercek modul paketi kaydedebiliyor.

## Phase 4: Group-Based Module Authorization Transition

### Dogrulandi / Calisiyor

- `LocalGroup.moduleCodes` alaniyla grup-modul paketi iliskisi acildi.
- Yetkili menu cozumu grup bazli modul okuma yonune gecti.
- `mock_authorized_menu_repository.dart`, kullanicinin grubunu okuyup grup uzerindeki `moduleCodes` degerlerinden gorunur menu uretebiliyor.
- Admin disi kullanicilar icin admin-only moduller gorunmuyor.
- Demo kullanicisinda bos menu davranisi kontrollu bicimde dogrulandi.
- Login kullanicisinda grup bazli tek modul akisi goruntulendi.
- Muhasebe kullanicisinda grup bazli coklu modul akisi goruntulendi.
- Boylece `Modul -> Grup -> Kullanici` yonu, Yetkili Menu uretiminde fiilen calisir hale geldi.

### Acik Risk / Dikkat Notu

- Bu checkpoint final sade authorization modeli degildir; hibrit gecis asamasi devam etmektedir.
- Kullanici ustundeki `stagedModuleCodes` alani tamamen kaldirilmamis durumdadir.
- Bu alan artik ana yetki kaynagi gibi ele alinmamalidir; legacy / migrasyon / override yonune dusmektedir.

## Phase 5: Final Authorization Simplification

### Son Checkpoint Hizalamasi

- Grup bazli menu cozumunden sonra `Kullanici Tanimi` ekrani da ayni gerceklige yaklastirildi.
- UI, yetkili calisma alanlarinin birincil kaynaginin grup oldugunu daha net ifade eder hale geldi.
- `Grup Uzerinden Gelen Yetkili Moduller` alani eklenerek secili grubun gercek modul paketi kullanici ekraninda gorunur kilindi.
- `Modul Staging / Legacy Override` alani ana yetki kaynagi gibi degil, gecis amacli ikincil alan gibi konumlandirildi.
- Kullanici listesi etiketleri de grup bazli gerceklige gore guncellendi.

### Sonraki Adim

- `Modul Staging Alani`nin final rolunu netlestirmek
- Kullanici ekranindaki hibrit parcalari daha da sadeletmek
- Final modelde staging alaninin kaldirilip kaldirilmayacagini netlestirmek
- Hibrit gecis katmanlarindan kontrollu cikmak

### Acik Risk / Dikkat Notu

- Bu checkpoint final sade authorization modeli degildir.
- Kullanici ekrani yeni modele yaklastirilmistir; ancak hibrit gecis mantigi halen surmektedir.
- `stagedModuleCodes` halen sistemde bulunur ve gecis / legacy override rolu tamamen kapanmis degildir.

## Phase 6: Persistence / PostgreSQL

### Sonraki Adim

- Session persistence daha sonra
- PostgreSQL entegrasyon plani daha sonra

## Mimari Not

- Modul = calisma alani
- Grup = modul paketi
- Kullanici = gruba bagli yetkili kisi
- Gercek menu cozumu artik grup bazli yonde ilerlemektedir.
- `stagedModuleCodes` final modelde kalici ana kaynak olarak dusunulmemelidir.
