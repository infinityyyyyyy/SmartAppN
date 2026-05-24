# SmartAppN - Gelişmiş Görev Yönetimi (Todo) Uygulaması

Bu proje, kullanıcıların günlük görevlerini düzenli bir şekilde takip etmelerini sağlarken, ruh hali (mood) takibi ve yerel bildirimler (localized push notifications) ile desteklenmiş gelişmiş bir Flutter mobil uygulamasıdır.

## 🚀 Özellikler

- **Dinamik Görev Yönetimi:** Görev ekleme, silme, tamamlama ve listeleme özellikleri.
- **Ruh Hali (Mood) Takibi:** Kullanıcıların günlük modlarını seçebileceği ve modlarına göre özelleştirilmiş arayüz deneyimi.
- **Yerel Bildirimler (Local Notifications):** Görev hatırlatıcıları ve kullanıcıyı motive eden dinamik bildirim yapısı.
- **Gelişmiş UI/UX:** Yıldız tamamlama efekti, şık animasyonlar ve modern gece/gündüz temasına uygun koyu arayüz tasarımı.
- **Temiz Kod Mimarisi:** Dart dilinin en güncel kurallarına uygun, okunabilir ve modüler klasör yapısı (`core`, `models`, `screens`).

## 🛠️ Kullanılan Teknolojiler

- **Framework:** [Flutter](https://flutter.dev) (En güncel SDK sürümü)
- **Dil:** [Dart](https://dart.dev)
- **Bildirim Yönetimi:** `flutter_local_notifications`
- **Yerel Veri Yönetimi:** Projede kullanılan local storage / state management çözümleri

## 📂 Klasör Yapısı

```text
lib/
├── core/          # Yardımcı araçlar ve servisler (Örn: notification_service.dart)
├── models/        # Veri modelleri (Örn: task_model.dart)
└── screens/       # Ekran tasarımları
    ├── dashboard/ # Ana panel ve görev listesi
    ├── login/     # Giriş ekranı
    └── mood/      # Ruh hali seçim ekranı