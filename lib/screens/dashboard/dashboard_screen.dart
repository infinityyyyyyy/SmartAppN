// lib/screens/dashboard/dashboard_screen.dart

import 'package:flutter/material.dart';

// Görev Modelimiz
class TodoTask {
  String id;
  String title;
  String category;
  String priority; // Düşük, Orta, Yüksek
  bool isCompleted;

  TodoTask({
    required this.id,
    required this.title,
    required this.category,
    required this.priority,
    this.isCompleted = false,
  });
}

class DashboardScreen extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;
  final String userEmail; // Aslında login'den gelen ismi tutuyor

  const DashboardScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.userEmail,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<TodoTask> _tasks = [];

  // Önem derecelerine göre renk tanımları
  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'Yüksek':
        return Colors.redAccent;
      case 'Orta':
        return Colors.orangeAccent;
      case 'Düşük':
      default:
        return Colors.greenAccent;
    }
  }

  // İlerleme Oranı Hesaplama
  double _calculateProgress() {
    if (_tasks.isEmpty) return 0.0;
    int completedCount = _tasks.where((task) => task.isCompleted).length;
    return completedCount / _tasks.length;
  }

  // GÖREV EKLEME / DÜZENLEME MODAL PENCERESİ
  void _showTaskDialog({TodoTask? task}) {
    final nameController = TextEditingController(text: task?.title ?? '');
    final categoryController = TextEditingController(text: task?.category ?? '');
    String selectedPriority = task?.priority ?? 'Düşük';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E294B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                top: 24,
                left: 24,
                right: 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      task == null ? "Yeni Görev Ekle" : "Görevi Düzenle",
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: nameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Görev Adı",
                        labelStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: const Color(0xFF0D111E),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: categoryController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Kategori (Örn: Ders, Proje, Kod)",
                        labelStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: const Color(0xFF0D111E),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text("Önem Derecesi:", style: TextStyle(color: Colors.white, fontSize: 14)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: ['Düşük', 'Orta', 'Yüksek'].map((p) {
                        bool isSel = selectedPriority == p;
                        return ChoiceChip(
                          label: Text(p),
                          selected: isSel,
                          selectedColor: const Color(0xFF6C63FF),
                          backgroundColor: const Color(0xFF0D111E),
                          labelStyle: TextStyle(color: isSel ? Colors.white : Colors.grey),
                          onSelected: (val) {
                            if (val) setModalState(() => selectedPriority = p);
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        if (nameController.text.trim().isEmpty) return;

                        setState(() {
                          if (task == null) {
                            // Yeni ekleme
                            _tasks.add(TodoTask(
                              id: DateTime.now().toString(),
                              title: nameController.text.trim(),
                              category: categoryController.text.trim().isEmpty ? 'Genel' : categoryController.text.trim(),
                              priority: selectedPriority,
                            ));
                          } else {
                            // Düzenleme
                            task.title = nameController.text.trim();
                            task.category = categoryController.text.trim().isEmpty ? 'Genel' : categoryController.text.trim();
                            task.priority = selectedPriority;
                          }
                        });
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C63FF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(task == null ? "Ekle" : "Güncelle"),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double progress = _calculateProgress();

    return Scaffold(
      // Sol altta Yıldız şeklinde Ekleme Butonu
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTaskDialog(),
        backgroundColor: const Color(0xFF6C63FF),
        child: const Icon(Icons.star_rounded, color: Colors.amber, size: 32), // Yıldız butonu
      ),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ÜST PANEL: Karşılama ve İlerleme Göstergesi
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Merhaba, ${widget.userEmail} 👋",
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _tasks.isEmpty ? "Bugün için henüz görev yok." : "İşte bugünün hedefleri:",
                      style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                    // İlerleme Durumu Metni
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Günlük İlerleme", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                        Text("${(progress * 100).toInt()}%", style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Çizgisel İlerleme Çubuğu (Progress Bar)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 10,
                        backgroundColor: Colors.white.withOpacity(0.1),
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6C63FF)),
                      ),
                    ),
                  ],
                ),
              ),

              // GÖREV LİSTESİ ALANI
              Expanded(
                child: _tasks.isEmpty
                    ? _buildEmptyStateWidget()
                    : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: _tasks.length,
                  itemBuilder: (context, index) {
                    final task = _tasks[index];
                    return _buildTaskCard(task);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Eğer hiç görev yoksa gösterilecek şık boş ekran tasarımı
  Widget _buildEmptyStateWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.auto_awesome_motion_rounded, size: 64, color: Colors.white.withOpacity(0.2)),
          const SizedBox(height: 16),
          Text(
            "Liste bomboş duruyor...\nSol alttaki yıldızdan yeni görev ekle!",
            style: TextStyle(color: Colors.grey.shade500, fontSize: 15, height: 1.4),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Listelenen Her Bir Görev Kartı Tasarımı
  Widget _buildTaskCard(TodoTask task) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: task.isCompleted ? const Color(0xFF161E38) : const Color(0xFF1E294B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: task.isCompleted ? Colors.transparent : Colors.white.withOpacity(0.05),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        // Basıldığında tamamlama efekti (Yıldız çakması)
        leading: GestureDetector(
          onTap: () {
            setState(() {
              task.isCompleted = !task.isCompleted;
            });
          },
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: task.isCompleted
                ? const Icon(Icons.star_rounded, color: Colors.amber, size: 30, key: ValueKey("checked"))
                : Icon(Icons.star_border_rounded, color: Colors.grey.shade400, size: 30, key: const ValueKey("unchecked")),
          ),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            color: task.isCompleted ? Colors.grey : Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Row(
            children: [
              // Kategori Rozeti
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(6)),
                child: Text(task.category, style: const TextStyle(color: Colors.grey, fontSize: 11)),
              ),
              const SizedBox(width: 8),
              // Önem Derecesi Göstergesi
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _getPriorityColor(task.priority).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  task.priority,
                  style: TextStyle(color: _getPriorityColor(task.priority), fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        // Sağ taraftaki işlem butonları (Düzenle ve Sil)
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_rounded, color: Colors.blueAccent, size: 20),
              onPressed: () => _showTaskDialog(task: task),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
              onPressed: () {
                setState(() {
                  _tasks.removeWhere((t) => t.id == task.id);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}