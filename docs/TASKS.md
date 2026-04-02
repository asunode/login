# Tasks

## Done

- Shell-first application frame kuruldu.
- Uygulama shell ile aciliyor; ust bar, orta alan ve alt bar birlikte gorunuyor.
- Varsayilan root orta alan mantigi olarak `InfoView` korunuyor.
- Ust bar davranislari aktif: Home, tema degisimi, kullanici slotu / logout davranisi, settings ve guvenli cikis.
- Sol ust baslik kapsulu root navigation davranisina baglandi.
- Login yokken `Login`, login varken display name mantigi calisiyor.
- Logout ve Safe Exit ayrimi korundu.
- Guvenli cikista `exit(0)` sonrasi `Lost connection to device` notu normal davranis olarak kabul edildi.
- Login Isar-backed local auth akisina tasindi.
- `admin / admin123` ile giris calisiyor.
- Yanlis parola reddediliyor.
- Logout sonrasi login ekranina donus calisiyor.
- `LocalUser`, `LocalGroup`, `LocalModule` modelleri eklendi ve aktif akisa baglandi.
- Bootstrap / seed yapisi aktif hale getirildi.
- Built-in admin kullanici, built-in yonetici grubu ve temel moduller seed ediliyor.
- Sifreler hash mantigiyla tutuluyor.
- `Kullanici Tanimi`, `Grup Tanimi` ve `Modul Tanimi` ekranlari shell icinde gercek view olarak aciliyor.
- `Modul Tanimi` gercek `LocalModule` kayitlariyla calisiyor.
- `Kullanici Tanimi` ekranindaki modul listesi gercek `LocalModule` kayitlarindan besleniyor.
- `LocalGroup.moduleCodes` alani eklendi.
- Grup ekraninda grup uzerine gercek modul paketi kaydi acildi.
- Yetkili menu cozumu grup bazli modul okuma yoluna gecti.
- `mock_authorized_menu_repository.dart`, kullanicinin grubunu okuyup grup uzerindeki modul paketinden menu uretebiliyor.
- Admin disi kullanicilar icin admin-only moduller gorunmuyor.
- Demo kullanicisinda bos menu davranisi kontrollu bicimde dogrulandi.
- Login kullanicisinda grup uzerinden gelen `TeknikServis` modulu goruntulendi.
- Muhasebe kullanicisinda grup uzerinden gelen coklu modul paketi goruntulendi.
- Boylece `Modul -> Grup -> Kullanici` zincirinin Yetkili Menu uretiminde calistigi saha olarak dogrulandi.

## Current

- Calisan shell-first yapinin korunmasi
- Isar-backed local auth temelinin korunmasi
- Grup bazli modul yetkilendirme yolunun hibrit gecis mantigiyla korunmasi
- Gercek menu cozumunun grup bazli calismasi
- Session'in memory tabanli kalmaya devam etmesi
- `Modul Staging Alani`nin artik ana yetki kaynagi olmayip gecis / legacy override alanina donusuyor olmasi

## Next

1. `Kullanici Tanimi` ekranini grup bazli gercek yetki modeline daha net hizalamak
2. `Modul Staging Alani`nin final rolunu netlestirmek
3. Uygunsa kullanici ekranindaki modul bolumunu sadeleştirmek
4. Hibrit authorization katmanlarindan kontrollu bicimde cikmak

## Later

- Session persistence daha sonra
- PostgreSQL entegrasyon plani daha sonra
- `Sifre Guncelle` ekranini gercek akisa baglama
- Final authorization modelini gercek veri omurgasiyla tam hizalama
- Final model oturdugunda `Modul Staging Alani`ni kaldirma veya ikincil role indirme
