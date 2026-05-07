import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BmiResultScreen extends StatelessWidget {
  final Map<String, dynamic> extra;

  const BmiResultScreen({super.key, required this.extra});

  Color _categoryColor(String label) => switch (label) {
        '저체중' => Colors.blue,
        '정상' => Colors.green,
        '과체중' => Colors.orange,
        _ => Colors.red,
      };

  @override
  Widget build(BuildContext context) {
    final bmi = extra['bmi'] as double;
    final label = extra['bmiCategoryLabel'] as String;
    final advice = extra['weightAdvice'] as String;
    final age = extra['age'] as int;
    final idealWeight = extra['idealWeightKg'] as double;
    final color = _categoryColor(label);

    return Scaffold(
      appBar: AppBar(title: const Text('BMI 결과'), backgroundColor: Colors.white, elevation: 0),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 4),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(bmi.toStringAsFixed(1),
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold, color: color)),
                    Text('BMI', style: TextStyle(color: color)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(label,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 32),

              // 상세 정보
              _InfoCard(children: [
                _InfoRow(label: '현재 키', value: '${extra['heightCm']}cm'),
                _InfoRow(label: '현재 몸무게', value: '${extra['weightKg']}kg'),
                _InfoRow(label: '나이', value: '$age세'),
                _InfoRow(label: '이상 체중 (BMI 22 기준)', value: '${idealWeight.toStringAsFixed(1)}kg'),
              ]),
              const SizedBox(height: 16),

              // 조언
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: color.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Icon(Icons.tips_and_updates, color: color),
                      const SizedBox(width: 8),
                      Text('맞춤 조언', style: TextStyle(fontWeight: FontWeight.bold, color: color)),
                    ]),
                    const SizedBox(height: 8),
                    Text(advice, style: const TextStyle(fontSize: 15)),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // BMI 기준표
              const _BmiReferenceTable(),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () => context.pop(),
                  child: const Text('다시 측정하기'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final List<Widget> children;
  const _InfoCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(children: children),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _BmiReferenceTable extends StatelessWidget {
  const _BmiReferenceTable();

  @override
  Widget build(BuildContext context) {
    final rows = [
      ('저체중', '18.5 미만', Colors.blue),
      ('정상', '18.5 ~ 22.9', Colors.green),
      ('과체중', '23.0 ~ 24.9', Colors.orange),
      ('비만', '25.0 이상', Colors.red),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('아시아 BMI 기준표',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        ...rows.map((r) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(children: [
                Container(
                    width: 12, height: 12,
                    decoration: BoxDecoration(color: r.$3, shape: BoxShape.circle)),
                const SizedBox(width: 8),
                Text(r.$1, style: const TextStyle(fontWeight: FontWeight.w500)),
                const Spacer(),
                Text(r.$2, style: const TextStyle(color: Colors.grey)),
              ]),
            )),
      ],
    );
  }
}
