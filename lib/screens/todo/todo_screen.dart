// lib/screens/todo/todo_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/task_model.dart';
import '../../core/utils/notification_service.dart';

class TodoScreen extends StatefulWidget {
  final bool isDarkMode;

  const TodoScreen({
    super.key,
    required this.isDarkMode,
  });

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final List<TodoTask> _tasks = [];
  final TextEditingController _taskController = TextEditingController();
  final NotificationService _notificationService = NotificationService();

  String _selectedCategory = 'Okul';
  String _selectedPriority = 'Orta';
  String _currentFilter = 'Hepsi';

  DateTime _selectedDate = DateTime.now(); // Aktif olarak seçili olan gün

  // Sadece seçili güne ait olan görevleri getiren filtre metodu
  List<TodoTask> get _filteredTasks {
    List<TodoTask> dayTasks = _tasks.where((task) {
      return task.date.year == _selectedDate.year &&
          task.date.month == _selectedDate.month &&
          task.date.day == _selectedDate.day;
    }).toList();

    if (_currentFilter == 'Tamamlananlar') {
      return dayTasks.where((task) => task.isCompleted).toList();
    } else if (_currentFilter == 'Bekleyenler') {
      return dayTasks.where((task) => !task.isCompleted).toList();
    }
    return dayTasks;
  }

  // Seçili günün ilerleme yüzdesi
  double get _completionPercentage {
    List<TodoTask> dayTasks = _tasks.where((task) {
      return task.date.year == _selectedDate.year &&
          task.date.month == _selectedDate.month &&
          task.date.day == _selectedDate.day;
    }).toList();

    if (dayTasks.isEmpty) return 0.0;
    int completedCount = dayTasks.where((task) => task.isCompleted).length;
    return completedCount / dayTasks.length;
  }

  void _addTask() {
    if (_taskController.text.isNotEmpty) {
      String enteredTitle = _taskController.text.trim();
      setState(() {
        _tasks.add(TodoTask(
          title: enteredTitle,
          category: _selectedCategory,
          priority: _selectedPriority,
          date: _selectedDate, // Görev seçili olan tarihe eklenir, eski günler korunur
        ));
        _taskController.clear();
      });
      Navigator.pop(context);
      _notificationService.showNotification(enteredTitle);
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'Yüksek': return Colors.redAccent;
      case 'Orta': return Colors.orangeAccent;
      default: return Colors.greenAccent;
    }
  }

  // Yatay Takvim Şeridi (Responsive & Çakışma Korumalı)
  Widget _buildHorizontalCalendar(ColorScheme colors) {
    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        itemBuilder: (context, index) {
          final date = DateTime.now().subtract(const Duration(days: 3)).add(Duration(days: index));
          final isSelected = date.year == _selectedDate.year &&
              date.month == _selectedDate.month &&
              date.day == _selectedDate.day;

          final isToday = date.year == DateTime.now().year &&
              date.month == DateTime.now().month &&
              date.day == DateTime.now().day;

          return GestureDetector(
            onTap: () => setState(() => _selectedDate = date),
            child: Container(
              width: 60,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? colors.primary
                    : (isToday ? colors.primary.withOpacity(0.15) : colors.surface),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? colors.primary : colors.primary.withOpacity(0.1),
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('E', 'tr_TR').format(date).toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.grey.shade500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    date.day.toString(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : (isToday ? colors.primary : null),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showAddDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24, right: 24, top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  "${DateFormat('dd MMMM', 'tr_TR').format(_selectedDate)} Gününe Görev Ekle",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _taskController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "Ne planlıyorsunuz?",
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1E1F2C) : Colors.grey.shade100,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text("Kategori: ", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  DropdownButton<String>(
                    value: _selectedCategory,
                    items: ['Okul', 'İş', 'Kişisel', 'Genel'].map((String val) {
                      return DropdownMenuItem<String>(value: val, child: Text(val));
                    }).toList(),
                    onChanged: (val) {
                      setModalState(() => _selectedCategory = val!);
                      setState(() => _selectedCategory = val!);
                    },
                  ),
                  const Spacer(),
                  const Text("Öncelik: ", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  DropdownButton<String>(
                    value: _selectedPriority,
                    items: ['Düşük', 'Orta', 'Yüksek'].map((String val) {
                      return DropdownMenuItem<String>(value: val, child: Text(val));
                    }).toList(),
                    onChanged: (val) {
                      setModalState(() => _selectedPriority = val!);
                      setState(() => _selectedPriority = val!);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _addTask,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text("Görevi Planla", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tarih ve Başlık Alanı
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(DateFormat('dd MMMM yyyy, EEEE', 'tr_TR').format(_selectedDate),
                      style: TextStyle(color: colors.secondary, fontSize: 13, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text("Görev Paneli", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
                ],
              ),
            ),

            // Yatay Takvim Şeridi
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: _buildHorizontalCalendar(colors),
            ),

            // Seçilen Güne Ait Verimlilik Analizi (Progress Bar)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [colors.primary, colors.secondary]),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Günün Verimlilik Analizi", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(
                      _filteredTasks.isEmpty
                          ? "Bu tarihte planlanmış görev yok."
                          : "%${(_completionPercentage * 100).toInt()} Tamamlandı",
                      style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12),
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: _completionPercentage,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Alt Filtre Çipleri
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
              child: Row(
                children: ['Hepsi', 'Bekleyenler', 'Tamamlananlar'].map((filter) {
                  final isSelected = _currentFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(filter),
                      selected: isSelected,
                      onSelected: (val) => setState(() => _currentFilter = filter),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Dinamik Görev Listesi (Boşluk Kontrollü & Taşma Korumalı)
            Expanded(
              child: _filteredTasks.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_today_rounded, size: 48, color: Colors.grey.shade600),
                    const SizedBox(height: 12),
                    Text(
                      "Bu tarihte planlanmış bir görev yok.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                    ),
                  ],
                ),
              )
                  : ListView.builder(
                itemCount: _filteredTasks.length,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                itemBuilder: (context, index) {
                  final task = _filteredTasks[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
                    ),
                    child: ListTile(
                      leading: Checkbox(
                        value: task.isCompleted,
                        activeColor: colors.primary,
                        onChanged: (val) => setState(() => task.isCompleted = val!),
                      ),
                      title: Text(
                        task.title,
                        style: TextStyle(
                          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                          color: task.isCompleted ? Colors.grey : null,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(color: colors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                              child: Text(task.category, style: TextStyle(fontSize: 11, color: colors.primary, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 8),
                            Icon(Icons.circle, size: 10, color: _getPriorityColor(task.priority)),
                            const SizedBox(width: 4),
                            Text(task.priority, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                          ],
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                        onPressed: () => setState(() => _tasks.remove(task)),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        backgroundColor: colors.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}