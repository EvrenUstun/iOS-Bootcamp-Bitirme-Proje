# Evren Üstün - Arçelik iOS Swift Bootcamp Bitirme Projesi

# Proje Hakkında

* Bu proje Arçelik & Patika.dev iOS Swift Bootcamp kapsamında hazırlanmıştır.

* Projede elektirikli araçlar için şarj istasyon noktalarından randevu almak hedeflenmiştir.

* Uygulama Arçelik tarafından sunulan REST API'lar ile geliştirilmiştir.

* Proje MVVM pattern'nine uygun şekilde yazılmıştır.

* API istekleri URLSession ile yapılmıştır.

* Bildirim gönderme işlemleri için local notification kullanılmıştır.

---

* Uygulama ilk açıldığında kullanıcıdan konum ve bildirim izni istenmektedir.

* Kullanıcı uygulamaya giriş yaptığında ana sayfasında güncel ve geçmiş randevularını görüntüleyebilmektedir. Bu sayfadan randevu oluşturma sayfasına geçebilmektedir.

* Ana sayfada bulunan profil ikonuna tıklanarak kullanıcının email adresini ve cihaz ID'sini görüntüleyebileceği profil sayfasına geçebilmektedir. Bu sayfada kullanıcı uygulamadan çıkış yapabilmektedir.

* Randevu oluştur butonuna basılarak randevu oluşturma adımlarına başlanabilmektedir. İlk aşama olarak kullanıcıdan randevu almak istediği şehri seçmesi istenmektedir. Bu sayfada şehirler API'dan gelen sıra ile gösterilmektedir. Kullanıcı burada şehir adına göre arama yapabilmektedir. Aranan kelimeye uygun bir sonuç varsa arama kutucuğunun çevresi yeşile dönmektedir. Eğer aranan kelime ile ilgili bir sonuç bulunmadıysa arama kutucuğu kırmızıya dönerek kullanıcıya bilgi mesajı gösterilmektedir.

* Şehir seçtikten sonra kullanıcı seçtiği şehirde bulunan şarj istasyonlarını görebilmektedir. Eğer konum izni verildiyse istasyonlar kullanıcının bulunduğu konuma olan uzaklığına göre sıralanmaktadır. Aksi halde istasyonlar API'dan gelen sıra ile yazdırılmaktadır.

* Kullanıcı istasyon seçme ekranında isterse cihaz tipine, soket tipine, uzaklığa ve hizmetlere göre filtreleme yapabilmektedir. Temizle butonu ile seçtiği filtreleri kaldırabilmektedir. Filtreleme yapıldıktan sonra kullanıcı istasyon seçme ekranında seçtiği filterele göre istasyonları görüntüleyebilmektedir. Seçtiği filtre bilgileri şarj istasyonlarının üzerinde kullanıcıyı bilgilendirilmektedir. Bu alandan 'X' ikonuna basılarak silmek istediği filtreleme özelliğini kaldırabilmektedir.

* Kullanıcı şarj istasyonunu seçtikten sonra şarj istasyonunun kullanıcının seçtiği tarihe göre istasyonda bulunan soketlerin o gün içerisindeki uygunluğunu görebilmektedir. Kullanıcı bu ekranda bulunduğu tarihten eski bir tarihi seçerse popup ile uyarılmaktadır. Bu popup'ta bulunan düzenle butonu ile randevu tarihini ve saatini tekrar düzenleyebilmektedir. Ya da bugünü seç butonu ile otomatik olarak kulanıcının bulunduğu tarihte bulunan uygunluklar gösterilmektedir.

* Kullanıcı uygun bir tarihi ve saati seçtikten sonra randevu detay sayfasına yönlendirilmektedir. Kullanıcı bu sayfada randevu bilgilerini gözden geçirebilmektedir. Bildirim al butonunu aktif hale getirerek randevu saatinden önce bildirim alabilmektedir. Ancak randevuya kalan süre seçilen bildirim zamanından daha kısa ise popup ile uyarılmaktadır. Popup'ta bulunan düzenle butonu ile bildirim zamanı düzenlenebilmektedir. Bildirimsiz devam et butonu ile de bildirim özelliği kapatılabilmektedir.

* Randevu detay sayfasında randevu onayla butonuna basıldığında oluşan randevu ana sayfada gösterilmektedir.

* Ana sayfa güncel randevular çöp kutusu ikonuna tıklanarak silinebilmektedir. Silme işlemi gerçekleşmeden önce kullanıcıya popup gösterilerek silme işlemi onaylatılmakta veya vazgeçirilmektedir.

# Kullanılan Teknolojiler

* Swift 5.6.1
* SwiftGen 6.5.1
* Xcode 13.4.1

# Uygulamada Bulunan Bug'lar

* Saat seçme ekranında bir saat seçildiğinde bazı saatler rastgele bir şekilde dolu gözükmektedir.

* Popup görünümünde auto layout hataları bulunmaktadır. Küçük telefon ekranlarında hatalı görünebilmektedir.

* Kullanıcıların randevularının listelendiği ekranda iki kere silme işlemi yapıldığında ikinci silme işleminde randevunun silinmesine rağmen ekran yenilenmemektedir. Uygulama tekrar açıldığında silinen randevu ekranda gözükmeyecektir.

* Kullanıcı iki kere arka arkaya randevu aldığında ikinci aldığı randevu alınmış olmasına rağmen randevularının listelendiği ekranda yeni randevu olarak gözükmemektedir. Uygulama tekrar açıldığında yeni randevu ekrana gelecektir.

* Uygulama ikonu verilen assetler içerisinde bulunmadığından dolayı gönderilen bildirimde uygulama ikonu gözükmemektedir.

<br>

# Uygulama Ekran Görüntüleri

## Giriş Yapma
<br>

![](/Screenshot/login.gif)

<br>

## Randevu Alma
<br>

![](/Screenshot/Randevu_Alma.gif)

<br>

![](/Screenshot/Home_Page_Ge%C3%A7mi%C5%9F_Randevu.png)



<br>

## Randevu İptal 
<br>

![](/Screenshot/Randevu_%C4%B0ptal_Etme.gif)

<br>

## Hesaptan Çıkış
<br>

![](/Screenshot/Hesaptan_%C3%87%C4%B1kma.gif)

<br>

## 2 Soketli İstasyonlar
<br>

![](/Screenshot/2soket.png)

<br>

## 3 Soketli İstasyonlar
<br>

![](/Screenshot/3soket.png)

<br>