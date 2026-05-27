// lib/main.dart

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/utils/notification_service.dart';
import 'screens/login/login_screen.dart'; // Bu ekranı bir sonraki adımda oluşturacağız

// lib/main.dart içindeki main fonksiyonunu bu şekilde değiştirin:

void main() async {
  // Binding işlemlerini garantiye alıyoruz
  WidgetsFlutterBinding.ensureInitialized();

  // Web'de kilitlenmeyi önlemek için async işlemleri try-catch içine alıyoruz
  try {
    await initializeDateFormatting('tr_TR', null);
  } catch (e) {
    debugPrint("Zaman formatı yüklenirken es geçildi: $e");
  }

  try {
    final notificationService = NotificationService();
    await notificationService.initNotification();
  } catch (e) {
    debugPrint("Bildirim servisi es geçildi: $e");
  }

  // Ne olursa olsun uygulamayı ayağa kaldırıyoruz!
  runApp(const SmartTaskApp());
}

class SmartTaskApp extends StatefulWidget {
  const SmartTaskApp({super.key});

  @override
  State<SmartTaskApp> createState() => _SmartTaskAppState();
}

class _SmartTaskAppState extends State<SmartTaskApp> {
  bool _isDarkMode = true; // Global tema yönetimi

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartTask Pro',
      debugShowCheckedModeBanner: false,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,

      // Aydınlık Tema Ayarları
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF4F46E5),
          secondary: Color(0xFF06B6D4),
          surface: Colors.white,
        ),
        useMaterial3: true,
      ),

      // Karanlık Tema Ayarları
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF090A0F),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6366F1),
          secondary: Color(0xFFA855F7),
          surface: Color(0xFF14151F),
        ),
        useMaterial3: true,
      ),

      // Uygulama ilk açıldığında doğrudan LoginScreen'i tetikliyoruz
      home: LoginScreen(
        isDarkMode: _isDarkMode,
        onThemeChanged: (value) => setState(() => _isDarkMode = value),
      ),
    );
  }
}
