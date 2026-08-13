// RecordPage —— 快速记录页（运动 / 饮食 / 情绪 3 个 tab）
//
// 设计要点：
// 1. **TabBar + TabBarView**：默认 Material 3 风格，标签页切换
// 2. **3 个独立子组件**：每个 tab 自己维护表单状态，提交后 snackbar 反馈
// 3. **统一 SnackBar 反馈**：成功/失败都通过 ScaffoldMessenger 提示

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_helper/pages/record/exercise_tab.dart';
import 'package:health_helper/pages/record/diet_tab.dart';
import 'package:health_helper/pages/record/mood_tab.dart';
import 'package:health_helper/widgets/common/common.dart';

class RecordPage extends ConsumerWidget {
  const RecordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: AppScaffold(
        title: '记录',
        appBar: AppBar(
          title: const Text('记录'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.directions_run), text: '运动'),
              Tab(icon: Icon(Icons.restaurant), text: '饮食'),
              Tab(icon: Icon(Icons.mood), text: '情绪'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ExerciseTab(),
            DietTab(),
            MoodTab(),
          ],
        ),
      ),
    );
  }
}