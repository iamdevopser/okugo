# okugo
Türkçe hikaye kitabı okuma uygulaması (Flutter MVP).

## Çalıştırma

Proje Flutter uygulaması olarak `okugo_app/` klasörü altında yer alır.

```bash
cd okugo_app
flutter pub get
flutter run
```

## Uygulama Akışı (MVP)

- **Rol seçimi**: Admin veya Öğrenci.
- **Admin**: Kitap adı / sayfa sayısı / seviye ile kitap ekler. Eklenen kitapların **20 soruluk sınavını** düzenleyebilir.
- **Öğrenci**:
  - Kitap seçer, **“Sayfa Okundu”** ile okuma simülasyonu yapar.
  - Okunan her yeni sayfa için **+5 puan**.
  - Kitap bittiğinde sınava girer.
  - Sınavdan geçince **+100 puan** (her kitap için bir kez).
  - Bir sınava **en fazla 3 hak**: 3. hakta da kalırsa kitap ilerlemesi sıfırlanır, sınav kilitlenir; kitabı yeniden bitirince sınav tekrar açılır.
- **Puan Tablosu**: toplam puan, puan kazandıran okunan sayfa sayısı, geçilen sınav sayısı, mevcut seviye ve kitap bazlı durumlar.

## Veri Saklama

Uygulama verileri (kitaplar, ilerleme, puan) **local** olarak `shared_preferences` içinde JSON şeklinde saklanır.
