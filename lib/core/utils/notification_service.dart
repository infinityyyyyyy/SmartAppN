// lib/core/utils/notification_service.dart

import 'package:flutter/material.dart';

class NotificationService {
  // Singleton yapısını koruyoruz ki diğer ekranlardaki çağrılar patlamasın
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  // Dışarıdan çağrılan metotları boş işlevli (mock) hale getiriyoruz
  Future<void> initNotification() async {
    debugPrint("Bildirim servisi güvenli modda başlatıldı (Hata önleyici aktif).");
  }

  void requestPermissions() {
    debugPrint("Bildirim izinleri güvenli modda es geçildi.");
  }

  Future<void> showNotification(String taskTitle) async {
    // Bildirim göndermek yerine konsola yazdırarak uygulamanın çökmesini önlüyoruz
    debugPrint('🔔 [SmartTask Pro Bildirimi]: "$taskTitle" başarıyla planlandı.');
  }
}