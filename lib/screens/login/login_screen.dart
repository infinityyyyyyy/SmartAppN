// lib/screens/login/login_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'mood_screen.dart';

class LoginScreen extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const LoginScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkSavedUser();
  }

  Future<void> _checkSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final savedName = prefs.getString('user_name');

    if (savedName != null && savedName.isNotEmpty && mounted) {
      _navigateToMoodScreen(savedName);
    }
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      final cleanName = _nameController.text.trim();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', cleanName);

      if (!mounted) return;
      setState(() => _isLoading = false);
      _navigateToMoodScreen(cleanName);
    }
  }

  Future<void> _handleGuestLogin() async {
    setState(() => _isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', 'Misafir');

    if (!mounted) return;
    setState(() => _isLoading = false);
    _navigateToMoodScreen('Misafir');
  }

  void _navigateToMoodScreen(String name) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            MoodScreen(
              userName: name,
              isDarkMode: widget.isDarkMode,
              onThemeChanged: widget.onThemeChanged,
            ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A2344), Color(0xFF0D111E)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Column(
                      children: [
                        const Icon(
                            Icons.waving_hand_rounded, size: 72, color: Color(
                            0xFF6C63FF)),
                        const SizedBox(height: 24),
                        const Text(
                          "Merhaba!",
                          style: TextStyle(fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "SmartTask Pro'ya başlamak için adınızı girin",
                          style: TextStyle(color: Colors.grey.shade400,
                              fontSize: 16),
                          textAlign: TextAlign
                              .center, // 🎯 DÜZELTİLDİ: TextAlign.center yapıldı
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: _nameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Adınız",
                        labelStyle: const TextStyle(color: Colors.grey),
                        prefixIcon: const Icon(
                            Icons.person_outline_rounded, color: Colors.grey),
                        filled: true,
                        fillColor: const Color(0xFF1E294B),
                        border: OutlineInputBorder(borderRadius: BorderRadius
                            .circular(16), borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                                color: Color(0xFF6C63FF), width: 2)),
                      ),
                      validator: (value) {
                        if (value == null || value
                            .trim()
                            .isEmpty) return 'Lütfen adınızı girin';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C63FF),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    child: _isLoading
                        ? const SizedBox(height: 24,
                        width: 24,
                        child: CircularProgressIndicator(color: Colors.white))
                        : const Text("Devam Et", style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 32),
                  TextButton(
                    onPressed: _isLoading ? null : _handleGuestLogin,
                    child: const Text(
                      "Misafir olarak devam et",
                      style: TextStyle(color: Color(0xFF6C63FF),
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}