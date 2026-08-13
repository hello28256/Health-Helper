// MoodTab —— 情绪记录表单（1-10 分 + 备注）

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_helper/api/api_error.dart';
import 'package:health_helper/providers/mood_provider.dart';
import 'package:health_helper/theme/dimens.dart';

class MoodTab extends ConsumerStatefulWidget {
  const MoodTab({super.key});

  @override
  ConsumerState<MoodTab> createState() => _MoodTabState();
}

class _MoodTabState extends ConsumerState<MoodTab> {
  final _formKey = GlobalKey<FormState>();
  final _noteCtrl = TextEditingController();
  int _score = 5;
  bool _submitting = false;

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    try {
      await ref.read(moodProvider.notifier).addMoodRecord(
            score: _score,
            note: _noteCtrl.text.trim().isEmpty
                ? null
                : _noteCtrl.text.trim(),
            recordedAt: DateTime.now(),
          );
      if (!mounted) return;
      _noteCtrl.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('已记录情绪')),
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
            Text(
              '情绪评分：$_score / 10',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Slider(
              value: _score.toDouble(),
              min: 1,
              max: 10,
              divisions: 9,
              label: '$_score',
              onChanged: _submitting
                  ? null
                  : (v) => setState(() => _score = v.round()),
            ),
            const SizedBox(height: AppDimens.space8),
            TextFormField(
              controller: _noteCtrl,
              enabled: !_submitting,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: '备注（可选）',
                hintText: '今天感觉怎么样？',
                prefixIcon: Icon(Icons.edit_note),
              ),
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