import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fitzip/core/di/injection_container.dart';
import 'package:fitzip/features/bmi/domain/repository/bmi_repository.dart';

class BmiInputScreen extends ConsumerStatefulWidget {
  const BmiInputScreen({super.key});

  @override
  ConsumerState<BmiInputScreen> createState() => _BmiInputScreenState();
}

class _BmiInputScreenState extends ConsumerState<BmiInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _heightCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _heightCtrl.dispose();
    _weightCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final result = await sl<BmiRepository>().calculate(
      heightCm: double.parse(_heightCtrl.text),
      weightKg: double.parse(_weightCtrl.text),
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    result.fold(
      (failure) => ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(failure.message))),
      (bmiResult) => context.push('/bmi/result', extra: {
        'heightCm': bmiResult.heightCm,
        'weightKg': bmiResult.weightKg,
        'bmi': bmiResult.bmi,
        'bmiCategoryLabel': bmiResult.bmiCategoryLabel,
        'age': bmiResult.age,
        'idealWeightKg': bmiResult.idealWeightKg,
        'weightAdvice': bmiResult.weightAdvice,
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BMI 측정'), backgroundColor: Colors.white, elevation: 0),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('신체 정보를 입력해주세요',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('나이대별 이상 체중을 분석해드려요',
                    style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _heightCtrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: '키 (cm)',
                    suffixText: 'cm',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (v) {
                    final n = double.tryParse(v ?? '');
                    if (n == null || n < 100 || n > 250) return '올바른 키를 입력해주세요 (100~250cm)';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _weightCtrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: '몸무게 (kg)',
                    suffixText: 'kg',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (v) {
                    final n = double.tryParse(v ?? '');
                    if (n == null || n < 20 || n > 300) return '올바른 몸무게를 입력해주세요 (20~300kg)';
                    return null;
                  },
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    onPressed: _isLoading ? null : _submit,
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _isLoading
                        ? const SizedBox.square(
                            dimension: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Text('BMI 측정하기',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
