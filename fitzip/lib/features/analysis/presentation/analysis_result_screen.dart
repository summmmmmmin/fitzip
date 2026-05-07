import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitzip/core/di/injection_container.dart';
import 'package:fitzip/features/analysis/domain/entity/analysis_result.dart';
import 'package:fitzip/features/analysis/domain/repository/analysis_repository.dart';

class AnalysisResultScreen extends ConsumerWidget {
  final String analysisId;
  const AnalysisResultScreen({super.key, required this.analysisId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<AnalysisResult?>(
      future: _load(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasError || snapshot.data == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('분석 결과')),
            body: const Center(child: Text('결과를 불러올 수 없습니다.')),
          );
        }
        return _ResultContent(result: snapshot.data!);
      },
    );
  }

  Future<AnalysisResult?> _load() async {
    final result = await sl<AnalysisRepository>().getResult(analysisId);
    return result.fold((_) => null, (r) => r);
  }
}

class _ResultContent extends StatelessWidget {
  final AnalysisResult result;
  const _ResultContent({required this.result});

  Color _bodyTypeColor(String? type) => switch (type) {
        'STRAIGHT' => const Color(0xFF5C6BC0),
        'NATURAL' => const Color(0xFF26A69A),
        'WAVE' => const Color(0xFFEC407A),
        _ => Colors.grey,
      };

  @override
  Widget build(BuildContext context) {
    final color = _bodyTypeColor(result.bodyType);
    final byCategory = <String, List<RecommendationItem>>{};
    for (final r in result.recommendations) {
      byCategory.putIfAbsent(r.category, () => []).add(r);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // 헤더
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: color,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: color,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Text(result.bodyTypeLabel ?? '분석 완료',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(result.bodyTypeDescription ?? '',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white70, fontSize: 14)),
                    if (result.confidenceScore != null) ...[
                      const SizedBox(height: 12),
                      Text(
                          '분석 신뢰도 ${(result.confidenceScore! * 100).toStringAsFixed(0)}%',
                          style: const TextStyle(color: Colors.white60, fontSize: 12)),
                    ],
                  ],
                ),
              ),
            ),
          ),

          // 추천 아이템
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const Text('스타일링 추천',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                ...byCategory.entries.map((entry) => _CategorySection(
                      category: entry.key,
                      items: entry.value,
                      color: color,
                    )),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategorySection extends StatelessWidget {
  final String category;
  final List<RecommendationItem> items;
  final Color color;
  const _CategorySection(
      {required this.category, required this.items, required this.color});

  String _categoryLabel(String c) => switch (c) {
        'TOP' => '상의',
        'BOTTOM' => '하의',
        'OUTER' => '아우터',
        'DRESS' => '드레스',
        'SHOES' => '신발',
        'ACCESSORY' => '액세서리',
        _ => c,
      };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(children: [
            Container(
                width: 4, height: 20,
                color: color,
                margin: const EdgeInsets.only(right: 8)),
            Text(_categoryLabel(category),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ]),
        ),
        ...items.map((item) => _RecommendationCard(item: item, color: color)),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  final RecommendationItem item;
  final Color color;
  const _RecommendationCard({required this.item, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.itemName,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(item.reason, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          if (item.avoidItems != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.block, size: 12, color: Colors.red),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text('피하세요: ${item.avoidItems}',
                        style: const TextStyle(color: Colors.red, fontSize: 12)),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
