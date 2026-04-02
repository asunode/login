# Tasks

## Done

- Shell-first application frame kuruldu.
- Uygulama shell ile aciliyor; ust bar, orta alan ve alt bar birlikte gorunuyor.
- Varsayilan root orta alan mantigi olarak InfoView korunuyor.
- Ust bar davranislari aktif: Home, tema degisimi, kullanici slotu / logout davranisi, settings ve guvenli cikis.
- Sol ust baslik kapsulu root navigation davranisina baglandi.
- Login yokken `Login`, login varken display name mantigi calisiyor.
- Logout ve Safe Exit ayrimi korundu.
- Guvenli cikista `exit(0)` sonrasi `Lost connection to device` notu normal davranis olarak kabul edildi.
- Login Isar-backed local auth akisina tasindi.
- `admin / admin123` ile giris calisiyor.
- Yanlis parola reddediliyor.
- Logout sonrasi login ekranina donus calisiyor.
- `LocalUser`, `LocalGroup`, `LocalModule` modelleri eklendi.
- Bootstrap / seed yapisi aktif hale getirildi.
- Built-in admin kullanici, built-in yonetici grubu ve temel moduller seed ediliyor.
- Sifreler hash mantigiyla tutuluyor.
- Admin authorized menu kart basliklari final hedefe yaklastirildi: `Kullanici Tanimi`, `Grup Tanimi`, `Modul Tanimi`, `Sifre Guncelle`.
- Authorized menu kartlari tiklanabilir hale geldi.
- Shell icinde authorized menu alt gorunum mantigi acildi.
- `Kullanici Tanimi` karti shell icinde ayri alt ekrana geciyor.
- Login ekranindaki eski mock kullanici dili temizlendi.
- Login paneli ve login view metinleri yerel dogrulama akisina gore guncellendi.
- Admin ornek hesabinin gorunurlugu korundu.
- `connection_profile_form.dart` overflow problemi scroll yaklasimiyla giderildi.
- `LocalUser` modeline modul tarafi icin gecici staging mantigi eklendi.
- `stagedModuleCodes` alani kayda gecirildi.
- `dart run build_runner build --delete-conflicting-outputs` basarili calisti.
- Shell icinde calisan Isar-backed `Kullanici Tanimi` yuzeyi kuruldu ve test edildi.
- Geri donus akisi calisiyor.
- Kullanici listesi gercek `LocalUser` verisinden geliyor.
- Grup alani gercek `LocalGroup` verisiyle aciliyor.
- `stagedModuleCodes` alani okunup yaziliyor.
- Yeni kullanici ekleme calisiyor.
- Yeni kullanici ilk gecici parola ile giris yapabiliyor.
- Uygulama kapat-ac sonrasinda kullanici kayitlari kalici olarak geliyor.
- Silinen kullanici kapat-ac sonrasinda da silinmis kaliyor.
- Kullanici guncelleme, kullanici silme ve sifre sifirlama akislarinin kodu uygulanmis durumda.
- Built-in admin delete korumasi kod duzeyinde mevcut.

## Current

- Calisan shell-first yapinin korunmasi
- Isar-backed local auth temelinin korunmasi
- Session'in memory tabanli kalmaya devam etmesi
- Authorized menu tarafinin gecis asamasinda kontrollu tutulmasi
- Group = gercek domain alani
- Module assignment = gecici staging alani

## Next

1. Built-in admin delete korumasi icin kisa runtime teyidi
2. Grup Tanimi ekranini gercek Isar-backed group yonetimine cevirme
3. Modul Tanimi ekranina gecis
4. Yetkili menuleri kademeli olarak gercek veri omurgasina baglama

## Later

- Session persistence daha sonra
- PostgreSQL entegrasyon plani daha sonra
- Analyzer surum uyari notlarini izlemeye devam etme
- Settings tarafinda gerekirse UI polish gecisi
- Final authorization modelini gercek veri omurgasiyla tam hizalama
