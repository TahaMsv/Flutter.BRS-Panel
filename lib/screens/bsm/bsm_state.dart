import 'package:brs_panel/core/classes/bsm_result_class.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final bsmProvider = ChangeNotifierProvider<BsmState>((_) => BsmState());

class BsmState extends ChangeNotifier {
  void setState() => notifyListeners();

  TextEditingController newBsmC = TextEditingController();
  bool loadingBSM = false;

}

final bsmListProvider = StateNotifierProvider<BsmListNotifier, List<BsmResult>>((ref) => BsmListNotifier(ref));

final bsmSearchProvider = StateProvider<String>((ref) => '');
final bsmDateProvider = StateProvider<DateTime>((ref) => DateTime.now());
final bsmsShowFiltersProvider = StateProvider<bool>((ref) => true);

final filteredBsmListProvider = Provider<List<BsmResult>>((ref) {
  final bsms = ref.watch(bsmListProvider);
  final searchFilter = ref.watch(bsmSearchProvider);
  return bsms
      .where(
        (f) => true
  )
      .toList();
});

class BsmListNotifier extends StateNotifier<List<BsmResult>> {
  final StateNotifierProviderRef ref;

  BsmListNotifier(this.ref) : super([]);

  void addBsm(BsmResult bsm) {
    state = [...state, bsm];
  }
  void insertBsm(int index,BsmResult bsm) {
    state = [bsm,...state];
  }

  void removeBsm(int id) {
    state = state.where((element) => element.messageId != id).toList();
  }

  void setBsms(List<BsmResult> fl) {
    state = fl;
  }
}



///final userProvider = StateProvider<User?>((ref) => null);
