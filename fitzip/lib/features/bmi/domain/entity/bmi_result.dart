class BmiResult {
  final double heightCm;
  final double weightKg;
  final double bmi;
  final String bmiCategory;
  final String bmiCategoryLabel;
  final int age;
  final double idealWeightKg;
  final double weightDiffKg;
  final String weightAdvice;

  const BmiResult({
    required this.heightCm,
    required this.weightKg,
    required this.bmi,
    required this.bmiCategory,
    required this.bmiCategoryLabel,
    required this.age,
    required this.idealWeightKg,
    required this.weightDiffKg,
    required this.weightAdvice,
  });
}
