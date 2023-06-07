import 'package:brs_panel/core/classes/airline_uld_class.dart';
import 'package:brs_panel/widgets/DotButton.dart';
import 'package:brs_panel/widgets/MyAppBar.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../core/constants/ui.dart';
import '../../core/util/basic_class.dart';
import '../../initialize.dart';
import '../../widgets/MyTextField.dart';
import 'airline_ulds_controller.dart';
import 'airline_ulds_state.dart';

class AirlineUldsView extends StatelessWidget {
  const AirlineUldsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const MyAppBar(),
        body: Column(
          children: [AirlineUldsPanel(), const AirlineUldListWidget()],
        ));
  }
}

class AirlineUldsPanel extends ConsumerWidget {
  static TextEditingController searchC = TextEditingController();

  AirlineUldsPanel({Key? key}) : super(key: key);
  final AirlineUldsController myAirlineUldsController = getIt<AirlineUldsController>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ThemeData theme = Theme.of(context);
    return Container(
      color: MyColors.white1,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          DotButton(
            size: 35,
            onPressed: () {
              myAirlineUldsController.addUld();
            },
            icon: Icons.add,
            color: Colors.blueAccent,
          ),
          const SizedBox(width: 12),
          Expanded(
              flex: 2,
              child: MyTextField(
                height: 35,
                prefixIcon: const Icon(Icons.search),
                placeholder: "Search Here...",
                controller: searchC,
                showClearButton: true,
                onChanged: (v) {
                  final s = ref.read(uldSearchProvider.notifier);
                  s.state = v;
                },
              )),
          const SizedBox(width: 12),
          const Expanded(
            flex: 5,
            child: SizedBox(),
          ),
        ],
      ),
    );
  }
}

class AirlineUldListWidget extends ConsumerWidget {
  const AirlineUldListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double width = MediaQuery.of(context).size.width;
    final AirlineUldsState state = ref.watch(airlineUldsProvider);
    final uldList = ref.watch(filteredUldListProvider);
    return Expanded(
        child: ListView.builder(
      itemBuilder: (c, i) => AirlineUldWidget(
        index: i,
        uld: uldList[i],
      ),
      itemCount: uldList.length,
    ));
  }
}

class AirlineUldWidget extends StatelessWidget {
  final AirlineUld uld;
  final int index;
  static AirlineUldsController myAirlineUldsController = getIt<AirlineUldsController>();

  const AirlineUldWidget({Key? key, required this.uld, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: index.isEven?MyColors.pinkishGrey:Colors.white,
      title: Text(uld.code),
      leading: Text(uld.type),
    );
  }
}
