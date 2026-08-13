// ExerciseTab —— 运动记录表单
//
// 字段：类型 / 时长 / 卡路里
// 提交后调 exercisesProvider.addExercise，成功 snackbar

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_helper/api/api_error.dart';
import 'package:health_helper/providers/exercises_provider.dart';
import 'package:health_helper/theme/dimens.dart';

class ExerciseTab extends ConsumerStatefulWidget {
  const ExerciseTab({super.key});

  @override
  ConsumerState<ExerciseTab> createState() => _ExerciseTabState();
}

class _ExerciseTabState extends ConsumerState<ExerciseTab> {
  final _formKey = GlobalKey<FormState>();
  final _typeCtrl = TextEditingController();
  final _durationCtrl = TextEditingController();
  final _kcalCtrl = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _typeCtrl.dispose();
    _durationCtrl.dispose();
    _kcalCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    try {
      await ref.read(exercisesProvider.notifier).addExercise(
            type: _typeCtrl.text.trim(),
            durationMin: int.parse(_durationCtrl.text),
            kcal: int.parse(_kcalCtrl.text),
            startedAt: DateTime.now(),
          );
      if (!mounted) return;
      _typeCtrl.clear();
      _durationCtrl.clear();
      _kcalCtrl.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('已记录运动')),
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
              controller: _typeCtrl,
              enabled: !_submitting,
              decoration: const InputDecoration(
                labelText: '类型（跑步 / 游泳 / 骑车 …）',
                prefixIcon: Icon(Icons.directions_run),
              ),
              validator: (v) =>
                  (v == null || v.isEmpty) ? '请输入运动类型' : null,
            ),
            const SizedBox(height: AppDimens.space16),
            TextFormField(
              controller: _durationCtrl,
              enabled: !_submitting,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: '时长（分钟）',
                prefixIcon: Icon(Icons.timer_outlined),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return '请输入时长';
                if (int.tryParse(v) == null) return '请输入整数';
                if (int.parse(v) <= 0) return '时长必须大于 0';
                return null;
              },
            ),
            const SizedBox(height: AppDimens.space16),
            TextFormField(
              controller: _kcalCtrl,
              enabled: !_submitting,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: '消耗（千卡）',
                prefixIcon: Icon(Icons.local_fire_department),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return '请输入消耗';
                if (int.tryParse(v) == null) return '请输入整数';
                if (int.parse(v) < 0) return '消耗不能为负';
                return null;
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