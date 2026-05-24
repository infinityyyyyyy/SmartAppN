// lib/screens/pomodoro/pomodoro_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/utils/notification_service.dart';

class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({super.key});

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  final NotificationService _notificationService = NotificationService();

  Timer? _pomodoroTimer;
  int _pomodoroSecondsLeft = 1500; // Varsayılan: 25 Dakika (25 * 60)
  int _customDurationMinutes = 25;
  bool _isPomodoroRunning = false;

  @override
  void dispose() {
    // ÇOK KRİTİK ÇÖZÜM: Sayfadan çıkıldığında sayacı durdurarak
    // "setState() called after dispose()" çökme hatasını tamamen engelliyoruz.
    _pomodoroTimer?.cancel();
    super.dispose();
  }

  void _showSetTimerDialog() {
    int selectedHours = _customDurationMinutes ~/ 60;
    int selectedMinutes = _customDurationMinutes % 60;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Çalışma Süresini Ayarla"),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<int>(
              value: selectedHours,
              items: List.generate(5, (index) => index).map((int val) {
                return DropdownMenuItem<int>(value: val, child: Text('$val Saat'));
              }).toList(),
              onChanged: (val) {
                if (mounted) setState(() => selectedHours = val!);
              },
            ),
            const SizedBox(width: 16),
            DropdownButton<int>(
              value: selectedMinutes,
              items: List.generate(60, (index) => index).map((int val) {
                return DropdownMenuItem<int>(value: val, child: Text('$val Dk'));
              }).toList(),
              onChanged: (val) {
                if (mounted) setState(() => selectedMinutes = val!);
              },
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("İptal")),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _customDurationMinutes = (selectedHours * 60) + selectedMinutes;
                _resetPomodoro();
              });
              Navigator.pop(context);
            },
            child: const Text("Uygula"),
          ),
        ],
      ),
    );
  }

  void _togglePomodoro() {
    if (_isPomodoroRunning) {
      _pomodoroTimer?.cancel();
      setState(() => _isPomodoroRunning = false);
    } else {
      setState(() => _isPomodoroRunning = true);
      _pomodoroTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_pomodoroSecondsLeft > 0) {
          if (mounted) setState(() => _pomodoroSecondsLeft--);
        } else {
          _pomodoroTimer?.cancel();
          if (mounted) {
            setState(() {
              _isPomodoroRunning = false;
              _pomodoroSecondsLeft = _customDurationMinutes * 60;
            });
          }
          _notificationService.showNotification("🍅 Odaklanma seansı bitti! Harika iş çıkardın.");
        }
      });
    }
  }

  void _resetPomodoro() {
    _pomodoroTimer?.cancel();
    setState(() {
      _isPomodoroRunning = false;
      _pomodoroSecondsLeft = _customDurationMinutes * 60;
    });
  }

  String _formatPomodoroTime() {
    int hours = _pomodoroSecondsLeft ~/ 3600;
    int minutes = (_pomodoroSecondsLeft % 3600) ~/ 60;
    int seconds = _pomodoroSecondsLeft % 60;
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Şık Odaklanma Başlığı
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.hourglass_top_rounded, color: colors.primary, size: 32),
                  const SizedBox(width: 12),
                  const Text(
                    "Odaklanma Odası",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "Telefonu ters çevir ve sadece hedeflerine odaklan.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
              ),
              const SizedBox(height: 48),

              // Büyük Sayaç Alanı (Özel Tasarım Kart İçinde)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: colors.primary.withOpacity(0.2), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: colors.primary.withOpacity(0.04),
                      blurRadius: 20,
                      spreadRadius: 4,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    // Dijital Font Benzeri Şık Sayaç Metni
                    Text(
                      _formatPomodoroTime(),
                      style: TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.w900,
                        color: _isPomodoroRunning ? colors.primary : Colors.grey.shade600,
                        fontFamily: 'Courier',
                      ),
                    ),
                    const SizedBox(height: 8),
                    IconButton(
                      icon: Icon(Icons.tune_rounded, color: colors.secondary, size: 28),
                      tooltip: "Süreyi Özelleştir",
                      onPressed: _showSetTimerDialog,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Kontrol Butonları (Başlat / Durdur / Sıfırla)
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: _togglePomodoro,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isPomodoroRunning ? Colors.amber.shade700 : colors.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 2,
                      ),
                      icon: Icon(_isPomodoroRunning ? Icons.pause_rounded : Icons.play_arrow_rounded),
                      label: Text(
                        _isPomodoroRunning ? "Durdur" : "Odaklanmayı Başlat",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: OutlinedButton.icon(
                      onPressed: _resetPomodoro,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.redAccent,
                        side: const BorderSide(color: Colors.redAccent, width: 1.5),
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      icon: const Icon(Icons.replay_rounded),
                      label: const Text("Sıfırla", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}