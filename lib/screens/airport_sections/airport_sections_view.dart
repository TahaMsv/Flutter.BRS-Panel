import 'package:brs_panel/widgets/MyButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../core/classes/airport_section_class.dart';
import '../../core/constants/ui.dart';
import '../../initialize.dart';
import '../../widgets/MyAppBar.dart';
import 'airport_sections_controller.dart';
import 'airport_sections_state.dart';

class AirportSectionsView extends ConsumerWidget {
  const AirportSectionsView({super.key});

  static AirportSectionsController controller = getIt<AirportSectionsController>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(airportSectionsProvider);
    return Scaffold(
      appBar: const MyAppBar(),
      body: const AirportSectionBody(),
      floatingActionButton: state.areSectionsUpdated
          ? Container()
          : SizedBox(
              height: 30,
              width: 120,
              child: MyButton(
                style: ElevatedButton.styleFrom(foregroundColor: MyColors.white3, backgroundColor: MyColors.mainColor),
                onPressed: () async => await controller.updateSectionsRequest(),
                label: "Save Changes",
              ),
            ),
    );
  }
}

class AirportSectionBody extends ConsumerWidget {
  const AirportSectionBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AirportSectionsState state = ref.watch(airportSectionsProvider);
    final sectionList = ref.watch(sectionsProvider);
    final selectedCategories = ref.watch(selectedSectionsProvider);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[SectionsWidget(sections: sectionList?.sections ?? [])] +
            selectedCategories.map((e) => SectionsWidget(sections: e.sections)).toList(),
      ),
    );
  }
}

class SectionsWidget extends ConsumerWidget {
  final List<Section> sections;
  static AirportSectionsController controller = getIt<AirportSectionsController>();

  const SectionsWidget({super.key, required this.sections});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double height = context.mediaQuery.size.height;
    final double width = context.mediaQuery.size.width;
    final selectedCategories = ref.watch(selectedSectionsProvider);
    return SizedBox(
      height: height - 80,
      width: width * 0.2,
      child: ListView.builder(
        itemCount: sections.length + 1,
        itemBuilder: (c, i) => i == sections.length
            ? AddItemWidget(label: "Add Section", onTap: () => controller.addSection(subs: sections))
            : ItemBoxWidget(
                label: sections[i].label,
                isSelected: selectedCategories.contains(sections[i]),
                onTap: () => controller.onTapSection(sections[i]),
                onDelete: () => controller.onDeleteSection(sections[i]),
              ),
      ),
    );
  }
}

class ItemBoxWidget extends StatelessWidget {
  final bool isSelected;
  final String label;
  final void Function() onTap;
  final void Function() onDelete;

  const ItemBoxWidget(
      {super.key, required this.label, required this.isSelected, required this.onTap, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          decoration: BoxDecoration(
              color: isSelected ? MyColors.sectionSelected : MyColors.white3,
              border: Border.all(color: MyColors.lineColor2)),
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 19, top: 26, bottom: 28),
          child: Row(
            children: [
              Expanded(child: Text(label, style: const TextStyle(color: MyColors.indexColor))),
              IconButton(color: MyColors.red2, onPressed: onDelete, icon: const Icon(Icons.delete_forever_outlined)),
              const SizedBox(width: 8),
            ],
          )),
    );
  }
}

class AddItemWidget extends StatelessWidget {
  const AddItemWidget({super.key, required this.label, required this.onTap});

  final String label;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.only(left: 19, top: 19, bottom: 19),
          alignment: Alignment.centerLeft,
        ),
        icon: Container(
            height: 28,
            width: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: MyColors.fadedBlue2, borderRadius: BorderRadius.circular(4)),
            child: const Icon(Icons.add, size: 18)),
        label: Text(label),
        onPressed: onTap);
  }
}
