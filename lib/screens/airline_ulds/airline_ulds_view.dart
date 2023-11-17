import 'package:brs_panel/widgets/DotButton.dart';
import 'package:brs_panel/widgets/MyAppBar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../core/classes/tag_container_class.dart';
import '../../core/constants/ui.dart';
import '../../initialize.dart';
import '../../widgets/MyTextField.dart';
import 'airline_ulds_controller.dart';
import 'airline_ulds_state.dart';

class AirlineUldsView extends StatelessWidget {
  const AirlineUldsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        appBar: MyAppBar(),
        body: Column(
          children: [
            AirlineUldsPanel(),
            AirlineUldListWidget(),
          ],
        ));
  }
}

class AirlineUldsPanel extends ConsumerWidget {
  static TextEditingController searchC = TextEditingController();

  const AirlineUldsPanel({Key? key}) : super(key: key);
  static AirlineUldsController myAirlineUldsController = getIt<AirlineUldsController>();

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
          DotButton(
            icon: Icons.refresh,
            onPressed: () {
              myAirlineUldsController.airlineGetUldList();
            },
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
      child: GridView.builder(
        padding: const EdgeInsets.all(12),
        itemBuilder: (c, i) => AirlineUldWidget(
          index: i,
          uld: uldList[i],
        ),
        itemCount: uldList.length,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: MediaQuery.of(context).size.width / 8,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
        ),
      ),
    );
  }
}

class AirlineUldWidget extends StatelessWidget {
  final TagContainer uld;
  final int index;
  static AirlineUldsController myAirlineUldsController = getIt<AirlineUldsController>();

  const AirlineUldWidget({Key? key, required this.uld, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: MyColors.lineColor),borderRadius: BorderRadius.circular(8)),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container(margin: const EdgeInsets.all(4), padding: const EdgeInsets.all(2), decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.tealAccent), child: Text("${uld.id}")),
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
                        myAirlineUldsController.updateUld(uld);
                      },
                    ),
                    const SizedBox(width: 8),
                    DotButton(
                      icon: Icons.delete,
                      size: 25,
                      onPressed: () {
                        myAirlineUldsController.deleteUld(uld);
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
                padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 8),
                child: Text(uld.type,style: GoogleFonts.titilliumWeb(fontWeight: FontWeight.bold),),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  // height:Get.width/12,
                  alignment: Alignment.center,
                  child: QrImageView(data: uld.barcode??''),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(uld.code,style: GoogleFonts.oxygenMono(),),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
