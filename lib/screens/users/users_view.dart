import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../core/constants/ui.dart';
import '../../initialize.dart';
import '../../widgets/DotButton.dart';
import '../../widgets/LoadingListView.dart';
import '../../widgets/MyAppBar.dart';
import '../../widgets/MyTextField.dart';
import 'data_tables/aircraft_data_table.dart';
import 'users_controller.dart';
import 'users_state.dart';

class UsersView extends StatelessWidget {
  const UsersView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: MyAppBar(),
      body: Column(children: [UsersPanel(), UserListWidget()]),
    );
  }
}

class UsersPanel extends ConsumerStatefulWidget {
  const UsersPanel({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UsersPanelState();
}

class _UsersPanelState extends ConsumerState<UsersPanel> {
  static TextEditingController searchC = TextEditingController();
  static UsersController controller = getIt<UsersController>();
  bool showClearButton = false;

  @override
  void initState() {
    showClearButton = searchC.text.isNotEmpty;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyColors.white1,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          DotButton(size: 35, onPressed: () => controller.addUpdateUser(null), icon: Icons.add, color: Colors.blueAccent),
          const SizedBox(width: 12),
          Expanded(
              flex: 2,
              child: MyTextField(
                height: 35,
                prefixIcon: const Icon(Icons.search),
                placeholder: "Search Here ...",
                controller: searchC,
                showClearButton: showClearButton,
                onChanged: (v) {
                  final s = ref.read(userSearchProvider.notifier);
                  s.state = v;
                  setState(() {
                    showClearButton = searchC.text.isNotEmpty;
                  });
                },
              )),
          const SizedBox(width: 12),
          Expanded(
            flex: 5,
            child: Row(
              children: [
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UserListWidget extends ConsumerWidget {
  const UserListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double width = MediaQuery.of(context).size.width;
    final UsersState state = ref.watch(usersProvider);
    final userList = ref.watch(filteredUserListProvider);
    return Expanded(
      child: LoadingListView(
        loading: state.loading,
        child: SfDataGrid(
          headerGridLinesVisibility: GridLinesVisibility.both,
          selectionMode: SelectionMode.none,
          sortingGestureType: SortingGestureType.tap,
          allowSorting: true,
          headerRowHeight: 35,
          source: UserDataSource(users: userList),
          columns: UserDataTableColumn.values
              .map((e) => GridColumn(
                    columnName: e.name,
                    label: Center(child: Text(e.name.capitalizeFirst!)),
                    width: e.width * width,
                  ))
              .toList(),
        ),
      ),
    );
  }
}
