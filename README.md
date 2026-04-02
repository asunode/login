# LoginShell

LoginShell, shell-first Flutter Windows desktop omurgasi uzerinde gelisen bir local auth, authorized menu ve yonetim yuzeyi projesidir.

## Proje Ozeti

Uygulama dogrudan login ekraniyla acilmaz. Acilista kalici shell gelir:

- ust bar
- orta alan
- alt bar
- varsayilan root icerik olarak InfoView

Bu yapi korunarak local auth, admin yonetimi ve kademeli authorization omurgasi ilerletilmektedir.

## Checkpoint Ozeti

- Shell-first Windows desktop akisi calisiyor.
- Local auth Isar-backed yapida calisiyor.
- `admin / admin123` girisi dogrulandi.
- `LocalUser`, `LocalGroup`, `LocalModule` modelleri aktif akista kullaniliyor.
- `Kullanici Tanimi`, `Grup Tanimi` ve `Modul Tanimi` ekranlarinin ucu de shell icinde gercek view olarak calisiyor.
- `Kullanici Tanimi` ekranindaki modul listesi artik sabit secimlerden degil, gercek `LocalModule` kayitlarindan besleniyor.
- `LocalGroup` uzerinde `moduleCodes` alaniyla grup-modul paketi iliskisi acildi.
- `Grup Tanimi` ekrani artik grup uzerine gercek modul paketi kaydedebiliyor.
- Yetkili menu cozumu artik yalnizca role-based mock basliklardan ibaret degil; kullanicinin grubunu okuyup grup uzerindeki modul paketine gore menu uretebiliyor.
- Admin disi kullanicilar icin admin-only moduller gorunmuyor.
- Demo kullanicisinda bos menu davranisi kontrollu bicimde dogrulandi.
- Login kullanicisinda grup uzerinden gelen `TeknikServis` modulu goruntulendi.
- Muhasebe kullanicisinda grup uzerinden gelen coklu modul paketi goruntulendi.
- Boylece `Modul -> Grup -> Kullanici` zinciri, Yetkili Menu uretiminde fiilen calisir hale geldi.

## Mimari Not

- Final hedef yon netlesiyor:
  - Modul = calisma alani
  - Grup = modul paketi
  - Kullanici = gruba bagli yetkili kisi
- Sistem halen hibrit gecis asamasindadir.
- Gercek menu cozumu artik grup bazli calisir.
- Kullanici uzerindeki `stagedModuleCodes` alani tamamen kaldirilmis degildir.
- Bu alan artik ana yetki kaynagi gibi yorumlanmamali; gecis / migrasyon / legacy override alani yonune kaymaktadir.

## Acik Risk / Dikkat Notu

- `mock_authorized_menu_repository.dart` dosya adi mock kalmis olsa da davranis artik grup bazli gercek menu cozumune yaklasmistir; final authorization modeli olarak yine de tamamlanmis sayilmamalidir.
- Session halen memory tabanlidir; persistence bu checkpointte yoktur.
- `Sifre Guncelle` ekrani halen placeholder / hazirlik asamasindadir.
- `Modul Staging Alani`, final model tam oturdugunda kaldirilmali veya yalnizca ikincil legacy override rolune indirilmeli; bu teknik borc unutulmamalidir.

## Sonraki Adim

1. `Kullanici Tanimi` ekranini grup bazli gercek yetki modeline daha net hizalamak
2. `Modul Staging Alani`nin final rolunu netlestirmek
3. Uygunsa kullanici ekranindaki modul bolumunu sadeleştirmek
4. Hibrit gecisten final authorization modeline kontrollu yaklasmak

## Dokumantasyon

- [Project Context](docs/PROJECT_CONTEXT.md)
- [Roadmap](docs/ROADMAP.md)
- [Tasks](docs/TASKS.md)
- [Changelog](docs/CHANGELOG.md)
