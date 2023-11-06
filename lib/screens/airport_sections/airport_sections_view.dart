import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../core/classes/airport_section_class.dart';
import '../../core/constants/ui.dart';
import '../../initialize.dart';
import '../../widgets/MyAppBar.dart';
import 'airport_sections_controller.dart';
import 'airport_sections_state.dart';

class AirportSectionsView extends StatelessWidget {
  const AirportSectionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: MyAppBar(),
      body: Column(
        children: [AirportSectionBody()],
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
    final selectedSection = ref.watch(selectedSectionProvider);
    final selectedCategories = ref.watch(selectedCategoriesProvider);
    return (sectionList?.sections.isEmpty ?? true)
        ? Container()
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
                  const SectionListWidget(),
                  // const VerticalDivider(color: MyColors.brownGrey3),
                  if (selectedSection != null) SubCategoriesWidget(subCategories: selectedSection.subCategories),
                ] +
                selectedCategories.map((e) => SubCategoriesWidget(subCategories: e.subCategories)).toList(),
          );
  }
}

class SectionListWidget extends ConsumerWidget {
  static AirportSectionsController controller = getIt<AirportSectionsController>();

  const SectionListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double height = context.mediaQuery.size.height;
    final double width = context.mediaQuery.size.width;
    final sectionList = ref.watch(sectionsProvider);
    final selectedSection = ref.watch(selectedSectionProvider);
    return SizedBox(
      height: height - 80,
      width: width * 0.2,
      child: ListView.builder(
        itemCount: sectionList?.sections.length ?? 0,
        itemBuilder: (c, i) => ItemBoxWidget(
          label: sectionList?.sections[i].label ?? "",
          isSelected: selectedSection == sectionList?.sections[i],
          onTap: () => controller.onChangeSection(sectionList?.sections[i]),
        ),
      ),
    );
  }
}

class SubCategoriesWidget extends ConsumerWidget {
  final List<SubCategory> subCategories;
  static AirportSectionsController controller = getIt<AirportSectionsController>();

  const SubCategoriesWidget({super.key, required this.subCategories});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double height = context.mediaQuery.size.height;
    final double width = context.mediaQuery.size.width;
    final selectedCategories = ref.watch(selectedCategoriesProvider);
    return SizedBox(
      height: height - 80,
      width: width * 0.2,
      child: ListView.builder(
        itemCount: subCategories.length,
        itemBuilder: (c, i) => ItemBoxWidget(
          label: subCategories[i].label,
          isSelected: selectedCategories.contains(subCategories[i]),
          onTap: () => controller.onChangeSubCategory(subCategories[i]),
        ),
      ),
    );
  }
}

class ItemBoxWidget extends StatelessWidget {
  final bool isSelected;
  final String label;
  final void Function() onTap;

  const ItemBoxWidget({super.key, required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          decoration: BoxDecoration(
              color: isSelected ? MyColors.sectionSelected : MyColors.white3,
              border: Border.all(color: MyColors.brownGrey3)),
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 24, top: 31, bottom: 33),
          child: Text(label)),
    );
  }
}
