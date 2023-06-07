import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../core/classes/airport_cart_class.dart';
import '../../core/constants/ui.dart';
import '../../core/util/basic_class.dart';
import '../../initialize.dart';
import '../../widgets/DotButton.dart';
import '../../widgets/MyAppBar.dart';
import '../../widgets/MyTextField.dart';
import 'airport_carts_controller.dart';
import 'airport_carts_state.dart';

class AirportCartsView extends StatelessWidget {
  const AirportCartsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        appBar: MyAppBar(),
        body: Column(
          children: [
            AirportCartsPanel(),
            AirportCartListWidget(),
          ],
        ));
  }
}

class AirportCartsPanel extends ConsumerWidget {
  static TextEditingController searchC = TextEditingController();

  const AirportCartsPanel({Key? key}) : super(key: key);
  static AirportCartsController myAirportCartsController = getIt<AirportCartsController>();

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
              myAirportCartsController.addCart();
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
                  final s = ref.read(cartSearchProvider.notifier);
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

class AirportCartListWidget extends ConsumerWidget {
  const AirportCartListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double width = MediaQuery.of(context).size.width;
    final AirportCartsState state = ref.watch(airportCartsProvider);
    final cartList = ref.watch(filteredCartListProvider);
    return Expanded(
        child: ListView.builder(
      itemBuilder: (c, i) => AirportCartWidget(
        index: i,
        cart: cartList[i],
      ),
      itemCount: cartList.length,
    ));
  }
}

class AirportCartWidget extends StatelessWidget {
  final AirportCart cart;
  final int index;
  static AirportCartsController myAirportCartsController = getIt<AirportCartsController>();

  const AirportCartWidget({Key? key, required this.cart, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: index.isEven ? MyColors.pinkishGrey : Colors.white,
      title: Text(cart.code),
      leading: Text(cart.type),
    );
  }
}
