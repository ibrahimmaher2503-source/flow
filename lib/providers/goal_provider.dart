import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/savings_goal_model.dart';
import '../data/repositories/goal_repo.dart';
import '../data/services/isar_service.dart';

final goalRepoProvider = Provider<GoalRepo>((ref) {
  return GoalRepo(ref.watch(isarProvider));
});

final activeGoalsProvider = FutureProvider<List<SavingsGoal>>((ref) async {
  return ref.watch(goalRepoProvider).getActive();
});

void refreshGoals(WidgetRef ref) {
  ref.invalidate(activeGoalsProvider);
}
