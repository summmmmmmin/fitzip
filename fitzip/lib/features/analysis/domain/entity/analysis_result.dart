class AnalysisResult {
  final String id;
  final String status;
  final String? bodyType;
  final String? bodyTypeLabel;
  final String? bodyTypeDescription;
  final double? confidenceScore;
  final List<RecommendationItem> recommendations;

  const AnalysisResult({
    required this.id,
    required this.status,
    this.bodyType,
    this.bodyTypeLabel,
    this.bodyTypeDescription,
    this.confidenceScore,
    required this.recommendations,
  });
}

class RecommendationItem {
  final String category;
  final String itemName;
  final String reason;
  final String? avoidItems;
  final String? imageUrl;

  const RecommendationItem({
    required this.category,
    required this.itemName,
    required this.reason,
    this.avoidItems,
    this.imageUrl,
  });
}
