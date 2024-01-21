import 'package:flutter/material.dart';
import '../core/constants/artemis_icons_icons.dart';
import '../core/constants/ui.dart';

class ButtonPanel extends StatelessWidget {
  final Widget? centerWidget;
  final Widget? leftWidget;
  final Widget? rightWidget;
  final void Function()? centerAction;
  final void Function()? rightAction;
  final void Function()? leftAction;
  final List<int> flexList;

  const ButtonPanel({super.key, this.centerWidget, this.leftWidget, this.rightWidget, this.centerAction, this.rightAction, this.leftAction, this.flexList = const [1, 4, 1]})
      : assert(flexList.length == 3);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Row(
      children: [
        SizedBox(
            width: 40,
            height: 40,
            child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    side: const BorderSide(width: 1, color: MyColors.veryLightPink),
                    backgroundColor: MyColors.white2,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      bottomLeft: Radius.circular(5),
                    ))),
                onPressed: leftAction,
                child: leftWidget ?? const Icon(ArtemisIcons.left___arrow, size: 14, color: MyColors.brownGrey))),
        Expanded(
          flex: 4,
          child: SizedBox(
            height: 40,
            child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    side: const BorderSide(width: 1, color: MyColors.veryLightPink), backgroundColor: MyColors.white2, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
                onPressed: centerAction,
                child: centerWidget ?? Text("-", style: theme.textTheme.headline5)),
          ),
        ),
        SizedBox(
            width: 40,
            height: 40,
            child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    side: const BorderSide(width: 1, color: MyColors.veryLightPink),
                    backgroundColor: MyColors.white2,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(5),
                      topRight: Radius.circular(5),
                    ))),
                onPressed: rightAction,
                child: rightWidget ?? const Icon(ArtemisIcons.right_arrow, size: 14, color: MyColors.brownGrey))),
      ],
    );
  }
}
