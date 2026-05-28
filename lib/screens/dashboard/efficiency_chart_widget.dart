import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class EfficiencyChartWidget extends StatelessWidget {
  final int completedTasksCount;
  final int pendingTasksCount;

  const EfficiencyChartWidget({
    super.key,
    required this.completedTasksCount,
    required this.pendingTasksCount,
  });

  @override
  Widget build(BuildContext context) {
    int total = completedTasksCount + pendingTasksCount;
    // Eğer hiç görev yoksa grafiğin patlamaması için boş bir durum gösterelim
    bool hasData = total > 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900], // Koyu tema arka planı
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text(
            "Günün Verimlilik Analizi",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 150,
            child: hasData
                ? PieChart(
              PieChartData(
                sectionsSpace: 5,
                centerSpaceRadius: 40,
                sections: [
                  // Tamamlanan Görevler Bölümü (Yeşil)
                  PieChartSectionData(
                    color: Colors.greenAccent[400],
                    value: completedTasksCount.toDouble(),
                    title: '${((completedTasksCount / total) * 100).toStringAsFixed(0)}%',
                    radius: 25,
                    titleStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  // Bekleyen Görevler Bölümü (Kırmızı/Turuncu)
                  PieChartSectionData(
                    color: Colors.orangeAccent,
                    value: pendingTasksCount.toDouble(),
                    title: '${((pendingTasksCount / total) * 100).toStringAsFixed(0)}%',
                    radius: 25,
                    titleStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            )
                : const Center(
              child: Text(
                "Henüz analiz edilecek görev yok",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Renklerin ne anlama geldiğini gösteren küçük açıklamalar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildIndicator(Colors.greenAccent[400]!, "Tamamlandı"),
              _buildIndicator(Colors.orangeAccent, "Bekliyor"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}