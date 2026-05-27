// lib/screens/login/mood_screen.dart
import 'dart:math';

import 'package:flutter/material.dart';

import '../dashboard/dashboard_screen.dart';

class MoodScreen extends StatefulWidget {
  final String userName;
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const MoodScreen({
    super.key,
    required this.userName,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<MoodScreen> createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> {
  bool _showWelcome = true;
  String _selectedQuote = "";
  String _selectedMoodTitle = "";

  // Her emoji için tam 10 adet özel motivasyon sözü havuzu
  final Map<String, List<String>> _motivationQuotes = {
    "Şahane!": [
      "Harika! Bu enerjiyi bugün tamamlamak istediğin işlere yansıt! ✨",
      "Süpersin! Bugün seni durdurabilecek hiçbir şey yok!",
      "Bu şahane modunu iş listeni eritmek için mükemmel bir yakıt olarak kullan!",
      "Enerjin harika! Çevrene de bu harika motivasyonu yaymaya ne dersin?",
      "Günün şahane başladıysa, bitişi efsane olacaktır! Başlayalım!",
      "İçindeki bu pozitif güç bugün harika projeler üretecek!",
      "Modun zirvedeyken en zorlu görevleri aradan çıkarmanın tam sırası!",
      "Harika bir gün, harika kararlarla taçlanır. Adım at!",
      "Bugün senin günün! Potansiyelini sonuna kadar yansıt!",
      "Bu harika enerjinle bugün harikalar yaratacaksın, inanıyorum!",
    ],
    "İyiyim.": [
      "Harika bir denge! Dingin ve odaklanmış bir gün seni bekliyor. 🎯",
      "İyi olmak, harika işler başarmak için en güvenli zeminidir.",
      "Net bir zihin ve istikrarlı bir enerji bugün seni başarıya taşır.",
      "Güzel bir gün geçirmek için ihtiyacın olan her şey zaten içinde mevcut.",
      "Adım adım, sakin ve kararlı bir şekilde bugünün planlarını tamamlayabilirsin.",
      "İçindeki sakin güç, en karmaşık kodları bile çözmene yeter!",
      "Bugün her şey yolunda. Odaklan ve hedeflerine doğru ilerle.",
      "Dengeli bir enerji, uzun soluklu başarıların en büyük sırrıdır.",
      "Kendinden emin ve hazırsın. Bugün güzel adımlar atacaksın.",
      "Planlarını gerçekleştirmek için bugünkü modun tam aradığın şey!",
    ],
    "Eh...": [
      "Bazen sadece başlamak bile modu yükseltir. Küçük bir adımla başla! 🚶‍♂️",
      "Her gün zirvede olamayız, önemli olan ritmi tamamen kaybetmemek.",
      "Bugün kendine yüklenme. Küçük görevleri bitirerek enerjini topla.",
      "Bir fincan kahve al ve en kolay işinden başlayarak motoru ısıt!",
      "Eh işte dediğin günler, büyük sıçrayışların öncesindeki dinlenme evresidir.",
      "Unutma; büyük başarılar sadece çok enerjik günlerde inşa edilmez.",
      "Bugün planın %50'sini yapsan bile bu bir zaferdir. Kendine şans ver.",
      "Zihnini rahat bırak. Sadece önündeki ilk küçük adıma odaklan.",
      "Modun yavaş yavaş yükselecektir, acele etme ve sadece başla.",
      "Bugün büyük kararlar almak yerine, rutin işlerini tamamlamayı dene.",
    ],
    "Keyifsiz.": [
      "Keyifsiz anlar kalıcı değildir. Bugün kendine karşı nazik ol. ☕",
      "Unutma, bulutlar ne kadar koyu olursa olsun arkasında hep güneş var.",
      "Zorlama, derin bir nefes al. Bugün sadece yapabildiğin kadarını yap.",
      "Küçük bir mola ver, sevdiğin bir müziği aç ve zihnini rahatlat.",
      "Keyifsiz olmak da insani bir duygu. Kendine biraz zaman tanı.",
      "Bugün büyük hedefler yerine seni yormayacak küçük adımlarla ilerle.",
      "Her gün harika geçmek zorunda değil. Bugünü sakin atlatmak da bir başarı.",
      "İçindeki enerjiyi toplamak için acele etme, yavaşlamak bazen en iyisidir.",
      "Biraz temiz hava al veya bir bardak su iç. Küçük şeyler modu değiştirir.",
      "Bu modu üretkenliğe dönüştürmek zorunda değilsin, bugün sakin kalmak yeterli.",
    ],
    "Zor bir gün.": [
      "Fırtınalar ağaçları daha güçlü kılar. Bu zor günün de geçeceğini bil! 🛡️",
      "Çok güçlü birisin, bu zorlu günün de üstesinden geleceksin.",
      "Bugün sadece hayatta kalmak ve günü bitirmek bile senin için bir başarı.",
      "Zor günlerin en güzel yanı, bittiklerinde bizi çok daha dirençli yapmalarıdır.",
      "Kendini baskı altında hissetme. İşler bekleyebilir, sağlığın ve zihnin daha önemli.",
      "Bugün derin bir nefes al ve her şeyi aynı anda çözmeye çalışmayı bırak.",
      "Yalnız değilsin, bu zorlu anı sadece parça parça yönetmeye odaklan.",
      "Şu an zor görünebilir ama arkandaki tüm engelleri nasıl aştığını hatırla.",
      "Bugün en düşük viteste ilerle. Kendini hırpalamadan günü tamamla.",
      "Bu zorlu günün akşamında kendine güzel bir ödül vermeyi unutma.",
    ],
  };

  @override
  void initState() {
    super.initState();
    // 2.5 saniye sonra Hoş Geldiniz yazısını kapatıp duygu ekranını açar
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        setState(() => _showWelcome = false);
      }
    });
  }

  // Rastgele söz seçen fonksiyon
  void _selectMood(String moodTitle) {
    final quotes = _motivationQuotes[moodTitle]!;
    final random = Random();

    setState(() {
      _selectedMoodTitle = moodTitle;
      _selectedQuote = quotes[random.nextInt(quotes.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A2344), Color(0xFF0D111E)],
          ),
        ),
        child: SafeArea(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 600),
            child: _showWelcome
                ? _buildWelcomeWidget()
                : (_selectedQuote.isEmpty
                      ? _buildMoodSelectionWidget()
                      : _buildQuoteWidget()),
          ),
        ),
      ),
    );
  }

  // 1. AŞAMA: Hoş Geldiniz Ekranı (3. görsel esintili)
  Widget _buildWelcomeWidget() {
    return Center(
      key: const ValueKey("welcome"),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                color: Colors.amber,
                size: 80,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              "Hoş Geldiniz",
              style: TextStyle(
                fontFamily: 'Serif',
                fontSize: 44,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.userName,
              style: const TextStyle(
                fontSize: 26,
                color: Color(0xFF6C63FF),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 2. AŞAMA: Bugün Nasıl Hissediyorsun Ekranı (4. görsel tasarımı)
  Widget _buildMoodSelectionWidget() {
    return Center(
      key: const ValueKey("mood_select"),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Bugün kendini\nnasıl hissediyorsun?",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.3,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            // Emojilerin Yatay Dizilimi
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildEmojiButton("🥳", "Şahane!"),
                _buildEmojiButton("👍", "İyiyim."),
                _buildEmojiButton("😐", "Eh..."),
                _buildEmojiButton("👎", "Keyifsiz."),
                _buildEmojiButton("😰", "Zor bir gün."),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Emojilerin altındaki eğik metinli özel buton yapısı
  Widget _buildEmojiButton(String emoji, String title) {
    return GestureDetector(
      onTap: () => _selectMood(title),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 40)),
          const SizedBox(height: 12),
          Transform.rotate(
            angle: -0.2, // Görseldeki gibi hafif sola eğik yazı efekti
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 3. AŞAMA: Seçilen Emojiye Göre Söz Gösteren Ekran
  Widget _buildQuoteWidget() {
    return Padding(
      key: const ValueKey("quote"),
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _selectedMoodTitle,
            style: const TextStyle(
              fontSize: 22,
              color: Color(0xFF6C63FF),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Icon(
            Icons.format_quote_rounded,
            size: 48,
            color: Colors.white.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            _selectedQuote,
            style: const TextStyle(
              fontSize: 22,
              color: Colors.white,
              height: 1.5,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          ElevatedButton.icon(
            onPressed: () {
              // Dashboard ekranına geçiş yapıyoruz
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => DashboardScreen(
                    isDarkMode: widget.isDarkMode,
                    onThemeChanged: widget.onThemeChanged,
                    userEmail: widget.userName,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C63FF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            icon: const Icon(Icons.arrow_forward_rounded),
            label: const Text(
              "Uygulamaya Geç",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
