---

🚀 TÜRKÇE KİTAP OKUMA UYGULAMASI – MVP PROMPTU

Sen deneyimli bir Flutter mobil uygulama geliştiricisisin. Amacın, Türkçe öğrenen kullanıcılar için en hızlı şekilde çalışan, mantıksal olarak hatasız ve temel özellikleri içeren bir kitap okuma uygulaması (MVP) geliştirmektir.

Bu sürüm minimum ama çalışan olmalıdır. Gereksiz detaylardan kaçın, ancak temel işlevler eksiksiz çalışsın.

---

🛠️ Teknoloji

Flutter (Dart) kullan

State management: setState veya Provider

Veri saklama: Local storage (in-memory / SharedPreferences / basit local JSON)

Backend zorunlu değil

---

📱 MVP Kapsamı

👤 Kullanıcı Tipleri

Admin

Öğrenci

Basit bir rol seçimi ekranı yeterlidir (gerçek auth zorunlu değil).

---

📚 Kitap Sistemi

Uygulama aşağıdaki seviyelerde Türkçe hikâye kitaplarını içermelidir:

A1–A2

A2–B1

B1–B2

B2–C1

C1–C2


Her kitap şu alanlara sahip olmalıdır:

Kitap adı

Sayfa sayısı

Dil seviyesi

---

🔐 Admin – Kitap Ekleme

Admin ekranında:

Kitap adı (TextField)

Sayfa sayısı (Number input)

Dil seviyesi (Dropdown veya TextField)

Kitap Ekle butonu

Eklenen kitaplar uygulama içinde listelenmelidir.

---

📖 Öğrenci – Okuma & Puan

Öğrenci bir kitap seçebilir

“Sayfa Okundu” butonu ile okuma simüle edilir

Okunan her sayfa için +5 puan

Okuma ilerlemesi kitap bazlı tutulur

---

📝 Sınav Sistemi (Basitleştirilmiş)

Her kitap için 20 soruluk bir sınav vardır (sorular sabit olabilir)

Sınav:

Geçti / Kaldı mantığıyla çalışır

Geçilen her sınav için +100 puan

Her sınava en fazla 3 giriş hakkı

3 hak da başarısız olursa:

Sınav kilitlenir

Kitap ilerlemesi sıfırlanır

Kitap yeniden okunmadan sınav açılmaz

---

🏆 Puan & İlerleme Ekranı

Öğrenci şu bilgileri görebilmelidir:

Toplam puan

Okunan sayfa sayısı

Geçilen sınavlar

Mevcut dil seviyesi (kitaplara göre)

Basit bir tablo veya kart görünümü yeterlidir.

---

🧠 Mantıksal Kurallar (ÇOK ÖNEMLİ)

Puanlar doğru hesaplanmalı

Sınav hakları doğru takip edilmeli

3 başarısız denemede kitap resetlenmeli

Reset sonrası sınav kilidi kalkmalı

Hatalı durumlara izin verilmemeli

---

📦 Çıktı Beklentisi

Tamamen çalışan bir Flutter MVP

Basit ama anlaşılır UI

Temiz ve okunabilir kod

main.dart + birkaç screen yeterlidir

Kısa açıklama:

Uygulama akışı

Veri nasıl tutuluyor

Neden bu yapı seçildi

---

🎯 Hedef

Bu MVP:

Çalışır

Test edilebilir

Genişletilebilir

Mantıksal olarak hatasız

olmalıdır.

Detaydan çok doğru çalışan çekirdek sistem önceliklidir.

---
