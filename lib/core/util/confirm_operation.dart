import 'package:flutter/material.dart';
import '../../initialize.dart';
import '../../widgets/MyButton.dart';
import '../constants/ui.dart';
import '../navigation/navigation_service.dart';

class ConfirmOperation {
  static final NavigationService navigationService = getIt<NavigationService>();

  ConfirmOperation._();

  static Future<bool> getConfirm(Operation operation, {Function? retry}) async {
    final res = await navigationService.dialog(ConfirmOperationDialog(operation: operation));
    return res == true;
  }
}

class Operation {
  final OperationType type;
  final String title;
  final String message;
  final List<String> actions;
  final String trueLabel;
  final String falseLabel;

  Operation(
      {this.type = OperationType.success,
      required this.message,
      required this.title,
      required this.actions,
      this.trueLabel = "Confirm",
      this.falseLabel = "Cancel"});
}

enum OperationType { success, warning, error }

extension OperationTypeDetails on OperationType {
  Color get color {
    switch (this) {
      case OperationType.success:
        return MyColors.lightIshBlue;
      case OperationType.warning:
        return MyColors.macAndCheese;
      case OperationType.error:
        return MyColors.red;
    }
  }

  IconData get icon {
    switch (this) {
      case OperationType.success:
        return Icons.check_box;
      case OperationType.warning:
        return Icons.warning;
      case OperationType.error:
        return Icons.error;
    }
  }
}

class ConfirmOperationDialog extends StatelessWidget {
  final Operation operation;
  final NavigationService navigationService = getIt<NavigationService>();

  ConfirmOperationDialog({Key? key, required this.operation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: width * 0.35),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
                color: operation.type.color, borderRadius: const BorderRadius.vertical(top: Radius.circular(5))),
            child: Row(
              children: [
                const SizedBox(width: 18),
                Icon(operation.type.icon, color: Colors.white),
                const SizedBox(width: 8),
                Text(operation.title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
                const Spacer(),
                IconButton(
                    onPressed: () {
                      navigationService.popDialog();
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 15,
                    ))
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(18),
            child: Text(operation.message, style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 13)),
          ),
          const Divider(height: 1, thickness: 1),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 4),
            child: Row(
              children: [
                //TextButton(onPressed: () {}, child: const Text("Add")),
                const Spacer(),

                MyButton(
                  onPressed: () => navigationService.popDialog(),
                  label: operation.falseLabel,
                  color: MyColors.greyishBrown,
                  // isFlat: true,
                  fontSize: 12,
                ),
                const SizedBox(width: 12),
                MyButton(
                  onPressed: () => navigationService.popDialog(result: true),
                  label: operation.trueLabel,
                  color: theme.primaryColor,
                  // isFlat: true,
                  fontSize: 12,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
