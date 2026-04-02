# Changelog

## 2026-04-02

### Checkpoint Alignment Update

#### Dogrulandi / Calisiyor

- Shell-first masaustu omurgasinin aktif checkpoint kaydi gercek durumla hizalandi.
- Uygulamanin shell ile acildigi; ust bar, orta alan ve alt barin birlikte calistigi netlestirildi.
- Varsayilan root orta alan olarak InfoView mantiginin korundugu kayda gecirildi.
- Ust bar davranislarinin calistigi dogrulandi:
  - Home
  - tema degisimi
  - kullanici slotu / logout davranisi
  - settings
  - guvenli cikis
- Sol ust baslik kapsulu root navigation davranisinin aktif oldugu kayda gecirildi.
- Logout ve Safe Exit ayriminin korundugu belgelendi.
- `exit(0)` sonrasi debug konsolunda `Lost connection to device` gorulmesinin normal davranis oldugu not dusuldu.
- Login akisinin eski mock user listesine degil, Isar-backed local auth akisina bagli oldugu kayda gecirildi.
- `admin / admin123` girisinin, yanlis parola reddinin ve logout sonrasi login ekranina donusun dogrulanmis durum olarak islendigi kaydedildi.
- `LocalUser`, `LocalGroup`, `LocalModule`, bootstrap / seed, built-in admin, built-in yonetici grubu ve temel modul seed durumlari checkpoint kaydina guncel olarak yazildi.
- Sifrelerin duz metin degil hash mantigiyla tutuldugu kayda gecirildi.
- Session'in halen memory tabanli oldugu acikca not edildi.
- Admin authorized menu kartlarinin hedef basliklara yaklastigi ve shell icinde alt gorunum mantiginin acildigi belgelerde guncellendi.
- `connection_profile_form.dart` overflow konusunun scroll yaklasimiyla kapandigi not edildi.
- `LocalUser` icindeki `stagedModuleCodes` staging karari checkpoint dokumantasyonuna islendi.
- `user_management_view.dart` tarafinin pending degil, projede uygulanmis Isar-backed surum oldugu netlestirildi.
- `Kullanici Tanimi` ekraninin gercek `LocalUser` ve `LocalGroup` verisiyle calistigi kayda gecirildi.
- `stagedModuleCodes` alaninin ekranda gercekten okunup yazildigi not edildi.
- Kullanici ekleme davranisinin calistigi kaydedildi.
- Yeni kullanicinin gecici parola ile giris yapabildigi kaydedildi.
- Uygulama yeniden acildiginda kullanici kayitlarinin kalici olarak geri geldigi kaydedildi.
- Silinen kullanicinin kapat-ac sonrasinda da silinmis kaldigi kaydedildi.
- Kullanici Tanimi ekraninin shell icine oturmus ve authorized menu gecisiyle calisan yuzey oldugu belgelerde netlestirildi.
- Dokumantasyon ile gercek kod arasindaki sapmanin bu checkpointte kapatildigi kayda gecirildi.

#### Acik Risk / Dikkat Notu

- Built-in admin delete korumasi kodda mevcut; manuel runtime teyidi henuz acik not olarak birakildi.
- Authorized menu kaynaginin halen gecici / mock role-based yapi oldugu notu korundu.
- Rol cozumunun halen gecici mantikta oldugu notu korundu.
- Farkli grup senaryolarinin henuz test edilmedigi kayda gecirildi.
- `Grup Tanimi`, `Modul Tanimi` ve `Sifre Guncelle` ekranlarinin placeholder / hazirlik asamasinda oldugu notu korundu.

#### Sonraki Adim

- Built-in admin delete korumasi icin kisa runtime teyidi
- Siradaki gelistirme isinin `Grup Tanimi` ekrani oldugu kaydedildi.
- Sonrasinda `Modul Tanimi` ekranina gecis planlandigi not edildi.

## 2026-04-01

- Root title capsule behavior was finalized for login and authenticated states.
- User icon slot now transforms into logout action after authentication.
- Logout confirmation and session cleanup flow were added.
- Safe exit was kept separate from logout.
- Initial Isar local auth backbone was added.
- `LocalUser`, `LocalGroup`, and `LocalModule` were introduced.
- Application startup now initializes Isar.
- Bootstrap now seeds built-in admin, group, and module data.
- `admin / admin123` login now works on the new local auth path.
- Authorized menu content is still role-based mock data for now.
- `SWorld` to `Login` title migration is completed.
- Settings-side overflow still remains deferred.
- Generated Isar `.g.dart` files currently show non-blocking `experimental_member_use` warnings during analyze output.

## 2026-03-31

- Shell-first application structure is active and opens with the persistent shell layout.
- Mock login and authorized menu flow has been established.
- Settings profile management flow has been established.
- Repository and contract abstraction has been added.
- Session and app settings models have been added.
- Direct mock access from views has been removed.
- Settings-side overflow is known and intentionally deferred in this checkpoint.
