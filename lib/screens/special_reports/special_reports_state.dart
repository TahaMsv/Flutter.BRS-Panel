import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../core/classes/user_class.dart';

final specialReportsProvider = ChangeNotifierProvider<SpecialReportsState>((_) => SpecialReportsState());

class SpecialReportsState extends ChangeNotifier {
  void setState() => notifyListeners();

  bool loading = false;
}

final userSearchProvider = StateProvider<String>((ref) => '');
final filteredUserListProvider = Provider<List<User>>((ref) {
  final searchFilter = ref.watch(userSearchProvider);
  final specialReports = ref.watch(userListProvider);
  return specialReports?.where((f) => f.validateSearch(searchFilter)).toList() ?? [];
});

final userListProvider = StateProvider<List<User>?>((ref) => null);
