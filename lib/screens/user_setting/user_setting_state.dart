import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/classes/user_class.dart';

final userSettingProvider = ChangeNotifierProvider<UserSettingState>((_) => UserSettingState());

class UserSettingState extends ChangeNotifier {
  void setState() => notifyListeners();

  bool loading = false;
  bool updateProfile = false;
  int editProfileDrawerIndex = 0;
}

final userSearchProvider = StateProvider<String>((ref) => '');
final filteredUserListProvider = Provider<List<User>>((ref) {
  final searchFilter = ref.watch(userSearchProvider);
  final userSetting = ref.watch(userListProvider);
  return userSetting?.where((f) => f.validateSearch(searchFilter)).toList() ?? [];
});

final userListProvider = StateProvider<List<User>?>((ref) => null);
