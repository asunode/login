# Changelog

## 2026-04-02

### Grup Bazli Modul Yetkilendirme Gecisi

#### Dogrulandi / Calisiyor

- `LocalGroup` modeline `moduleCodes` alani eklendi.
- Grup uzerinde gercek modul paketi tasima yolu acildi.
- `Kullanici Tanimi` ekranindaki modul listesi sabit / hardcoded secimlerden cikarilip gercek `LocalModule` kayitlarindan beslenir hale getirildi.
- `Grup Tanimi` ekrani grup uzerine gercek modul paketi kaydedebilir hale geldi.
- Yetkili menu cozumu, kullanicinin grubunu okuyup grup uzerindeki modul paketinden gorunur menu uretme yonunde guncellendi.
- Admin disi kullanicilar icin admin-only moduller gorunmez hale geldi.
- Demo kullanicisinda bos menu davranisi kontrollu bicimde dogrulandi.
- Login kullanicisinda grup uzerinden gelen `TeknikServis` modulu goruntulendi.
- Muhasebe kullanicisinda grup uzerinden gelen coklu modul paketi goruntulendi.
- Boylece `Modul -> Grup -> Kullanici` zincirinin Yetkili Menu uretiminde fiilen calistigi checkpoint seviyesinde dogrulandi.

#### Mimari Not

- Sistem, kullanici ustundeki `stagedModuleCodes` alanina dayanan onceki hibrit yapidan daha grup-merkezli bir authorization yonune ilerledi.
- Gercek menu cozumu artik grup bazli calisir.
- `stagedModuleCodes` tamamen kaldirilmis degildir; gecis guvenligi icin fallback / legacy override alanina donusmektedir.

#### Acik Risk / Dikkat Notu

- Bu checkpoint final sade authorization modeli degildir.
- `mock_authorized_menu_repository.dart` dosya adi mock kalmaya devam etmektedir ve gecis katmani mantigi surmektedir.
- `Modul Staging Alani`, final model tam oturdugunda kaldirilmali veya yalnizca ikincil role indirilmeli; bu teknik borc unutulmamalidir.
- Session persistence sonraki fazda duruyor.
- `Sifre Guncelle` ekrani halen placeholder / hazirlik asamasindadir.

### Management Screens Checkpoint

#### Dogrulandi / Calisiyor

- `Modul Tanimi` gercek view'a baglandi.
- `LocalModule.iconKey` karari uygulandi.
- Modul ekleme ve silme saha testi gecti.
- Kullanici / Grup / Modul yonetim ekranlari shell icinde gercek akisa tasinmis oldu.
- Admin disi kullanici gorunurlugu operator akisina dogru daraltildi.
- `Grup Tanimi` placeholder olmaktan cikti; gercek Isar-backed akisla calisiyor.
- Built-in yonetici grubu korumasinin calistigi saha testleriyle teyit edildi.
- Built-in admin delete korumasi runtime olarak teyit edildi.

#### Acik Risk / Dikkat Notu

- Authorized menu / role modeli halen gecis asamasinda.
- Module assignment halen staging mantiginda.
- Modul metadata detaylari ve daha derin baglanti yapisi PostgreSQL sonrasi faza birakildi.
- Session persistence sonraki fazda duruyor.

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

- Authorized menu kaynaginin halen gecici / mock role-based yapi oldugu notu korundu.
- Rol cozumunun halen gecici mantikta oldugu notu korundu.
- Farkli grup senaryolarinin henuz test edilmedigi kayda gecirildi.
- `Sifre Guncelle` ekraninin placeholder / hazirlik asamasinda oldugu notu korundu.

#### Sonraki Adim

- `Kullanici Tanimi` ekranindaki modul staging alanini gercek `LocalModule` kayitlarindan besleme isi sonraki yakin adim olarak not edildi.
- Yetkili menuleri ve ekran erisim mantigini gercek veri omurgasiyla hizalama isi sonraki faza tasindi.

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
