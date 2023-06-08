import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
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
          DotButton(
            icon: Icons.refresh,
            onPressed: () {
              myAirportCartsController.airportGetCarts();
            },
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
        child: GridView.builder(
      padding: const EdgeInsets.all(12),
      itemBuilder: (c, i) => AirportCartWidget(
        index: i,
        cart: cartList[i],
      ),
      itemCount: cartList.length,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: Get.width / 8,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
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
    return Container(
      decoration: BoxDecoration(border: Border.all(color: MyColors.lineColor), borderRadius: BorderRadius.circular(8)),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container(margin: const EdgeInsets.all(4), padding: const EdgeInsets.all(2), decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.tealAccent), child: Text("${cart.id}")),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
                margin: const EdgeInsets.all(4),
                padding: const EdgeInsets.all(2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    DotButton(
                      icon: Icons.edit,
                      size: 25,
                      onPressed: () {
                        myAirportCartsController.updateCart(cart);
                      },
                    ),
                    const SizedBox(width: 8),
                    DotButton(
                      icon: Icons.delete,
                      size: 25,
                      onPressed: () {
                        myAirportCartsController.deleteCart(cart);
                      },
                      color: Colors.red,
                    ),
                  ],
                )),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  // color: Colors.orange
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Text(
                  cart.type,
                  style: GoogleFonts.titilliumWeb(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  // height:Get.width/12,
                  alignment: Alignment.center,
                  child: QrImageView(data: cart.barcode),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  cart.code,
                  style: GoogleFonts.oxygenMono(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
