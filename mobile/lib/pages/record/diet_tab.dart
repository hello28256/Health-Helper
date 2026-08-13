// DietTab —— 饮食记录表单

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_helper/api/api_error.dart';
import 'package:health_helper/providers/diet_provider.dart';
import 'package:health_helper/theme/dimens.dart';

class DietTab extends ConsumerStatefulWidget {
  const DietTab({super.key});

  @override
  ConsumerState<DietTab> createState() => _DietTabState();
}

class _DietTabState extends ConsumerState<DietTab> {
  final _formKey = GlobalKey<FormState>();
  final _foodCtrl = TextEditingController();
  final _kcalCtrl = TextEditingController();
  String _mealType = 'breakfast';
  bool _submitting = false;

  @override
  void dispose() {
    _foodCtrl.dispose();
    _kcalCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    try {
      await ref.read(dietProvider.notifier).addDietRecord(
            foodName: _foodCtrl.text.trim(),
            kcal: int.parse(_kcalCtrl.text),
            consumedAt: DateTime.now(),
            mealType: _mealType,
          );
      if (!mounted) return;
      _foodCtrl.clear();
      _kcalCtrl.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('已记录饮食')),
      );
    } on ApiError catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('提交失败：${e.message}')),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimens.space16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _foodCtrl,
              enabled: !_submitting,
              decoration: const InputDecoration(
                labelText: '食物名称',
                prefixIcon: Icon(Icons.restaurant_menu),
              ),
              validator: (v) =>
                  (v == null || v.isEmpty) ? '请输入食物名称' : null,
            ),
            const SizedBox(height: AppDimens.space16),
            TextFormField(
              controller: _kcalCtrl,
              enabled: !_submitting,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: '热量（千卡）',
                prefixIcon: Icon(Icons.local_fire_department),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return '请输入热量';
                if (int.tryParse(v) == null) return '请输入整数';
                if (int.parse(v) < 0) return '热量不能为负';
                return null;
              },
            ),
            const SizedBox(height: AppDimens.space16),
            DropdownButtonFormField<String>(
              initialValue: _mealType,
              decoration: const InputDecoration(
                labelText: '餐别',
                prefixIcon: Icon(Icons.schedule),
              ),
              items: const [
                DropdownMenuItem(value: 'breakfast', child: Text('早餐')),
                DropdownMenuItem(value: 'lunch', child: Text('午餐')),
                DropdownMenuItem(value: 'dinner', child: Text('晚餐')),
                DropdownMenuItem(value: 'snack', child: Text('零食')),
              ],
              onChanged: (v) {
                if (v != null) setState(() => _mealType = v);
              },
            ),
            const SizedBox(height: AppDimens.space24),
            FilledButton(
              onPressed: _submitting ? null : _submit,
              child: _submitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('提交'),
            ),
          ],
        ),
      ),
    );
  }
}