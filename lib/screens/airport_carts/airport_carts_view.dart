import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../core/classes/tag_container_class.dart';
import '../../core/constants/ui.dart';
import '../../initialize.dart';
import '../../widgets/DotButton.dart';
import '../../widgets/LoadingListView.dart';
import '../../widgets/MyAppBar.dart';
import '../../widgets/MyTextField.dart';
import 'airport_carts_controller.dart';
import 'airport_carts_state.dart';
import 'data_tables/airport_cart_data_table.dart';

class AirportCartsView extends ConsumerWidget {
  const AirportCartsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double width = MediaQuery.of(context).size.width;
    final AirportCartsState state = ref.watch(airportCartsProvider);
    final cartList = ref.watch(filteredCartListProvider);

    return Scaffold(
        appBar: const MyAppBar(),
        body: Column(
          children: [
            AirportCartsPanel(),
            // AirportCartListWidget(),
            Expanded(
              child: LoadingListView(
                loading: state.loading,
                child: SfDataGrid(
                    headerGridLinesVisibility: GridLinesVisibility.both,
                    selectionMode: SelectionMode.none,
                    sortingGestureType: SortingGestureType.doubleTap,
                    // allowSorting: true,
                    headerRowHeight: 35,
                    source: AirportCartDataSource(carts: cartList),
                    columns: AirportCartDataTableColumn.values
                        .map(
                          (e) => GridColumn(
                            columnName: e.name,
                            label: Center(child: Text(e.appropriateName)),
                            width: e.width * width,
                            allowSorting: false,
                          ),
                        )
                        .toList()),
              ),
            ),
          ],
        ));
  }
}

class AirportCartsPanel extends ConsumerStatefulWidget {
  const AirportCartsPanel({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AirportCartsPanelState();
}

class _AirportCartsPanelState extends ConsumerState<AirportCartsPanel> {
  static TextEditingController searchC = TextEditingController();
  static AirportCartsController myAirportCartsController = getIt<AirportCartsController>();
  bool showClearButton = false;

  @override
  void initState() {
    showClearButton = searchC.text.isNotEmpty;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              placeholder: "Search Here ...",
              controller: searchC,
              showClearButton: showClearButton,
              onChanged: (v) {
                final s = ref.read(cartSearchProvider.notifier);
                s.state = v;
                setState(() {
                  showClearButton = searchC.text.isNotEmpty;
                });
              },
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(flex: 5, child: SizedBox()),
          DotButton(
            icon: Icons.refresh,
            onPressed: () async => await myAirportCartsController.airportGetCarts(),
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
        maxCrossAxisExtent: MediaQuery.of(context).size.width / 8,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
    ));
  }
}

class AirportCartWidget extends StatelessWidget {
  final TagContainer cart;
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
            child: Container(
                margin: const EdgeInsets.all(4),
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.tealAccent),
                child: Text("${cart.id}")),
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
                      onPressed: () => myAirportCartsController.updateCart(cart),
                    ),
                    const SizedBox(width: 8),
                    DotButton(
                      icon: Icons.delete,
                      size: 25,
                      onPressed: () async => await myAirportCartsController.deleteCart(cart),
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
                child: cart.allowedTagTypesWidgetMini,
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
