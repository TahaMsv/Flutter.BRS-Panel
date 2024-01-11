import 'dart:typed_data';
import 'package:brs_panel/initialize.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../../core/classes/tag_container_class.dart';
import '../../../core/constants/ui.dart';
import '../../../core/navigation/navigation_service.dart';
import '../flight_details_controller.dart';
import '../flight_details_state.dart';

class PDFPreviewDialog extends ConsumerStatefulWidget {
  final String? pdfURL;
  final Uint8List pdfFileBytes;
  final TagContainer? con;
  final String? name;

  const PDFPreviewDialog({Key? key, required this.pdfFileBytes, required this.con, required this.pdfURL, this.name = 'pdf'}) : super(key: key);

  @override
  ConsumerState<PDFPreviewDialog> createState() => _PDFPreviewDialogState();
}

class _PDFPreviewDialogState extends ConsumerState<PDFPreviewDialog> {
  GlobalKey _key = GlobalKey();
  static const int VK_KEY_P = 0x50; // Virtual-key code for the 'P' key

  void _handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent && event.data is RawKeyEventDataWindows) {
      RawKeyEventDataWindows data = event.data as RawKeyEventDataWindows;
      final isControlPressed = data.modifiers & RawKeyEventDataWindows.modifierLeftControl != 0;
      if (isControlPressed && data.keyCode == VK_KEY_P) {
        print('Ctrl + P was pressed');
        // Call your print function here
        final FlightDetailsController controller = getIt<FlightDetailsController>();
        controller.printPDF(widget.pdfFileBytes);
      }
    }
  }

  @override
  void initState() {
    // localPDFFormat = ref.watch(pdfFormat) ?? PdfPageFormat.a4;
    super.initState();
    RawKeyboard.instance.addListener(_handleKeyEvent);
  }

  @override
  void dispose() {
    RawKeyboard.instance.removeListener(_handleKeyEvent);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final NavigationService ns = getIt<NavigationService>();
    final FlightDetailsController controller = getIt<FlightDetailsController>();
    return RawKeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKey: (x) async {
        // detect if ctrl + v or cmd + v is pressed
        if (x.isControlPressed && x.character == "p" || x.isMetaPressed && x.character == "p") {
          controller.printPDF(widget.pdfFileBytes);
        }
      },
      child: Dialog(
        child: Container(
          width: 600,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(0),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              widget.con == null
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.only(left: 12, top: 0),
                      child: Row(
                        children: [
                          Text("PDF Preview ${widget.con?.title ?? ''}", style: theme.textTheme.headlineMedium),
                          const SizedBox(width: 12),
                          Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: widget.con!.getImgMini),
                          Text(widget.con!.code, style: const TextStyle(fontSize: 16)),
                          const Spacer(),
                          IconButton(onPressed: () => ns.pop(), icon: const Icon(Icons.close, color: MyColors.brownGrey)),
                        ],
                      ),
                    ),
              const Divider(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
                  child: SfPdfViewer.memory(
                    widget.pdfFileBytes,
                    onDocumentLoadFailed: (f) {},
                    pageLayoutMode: PdfPageLayoutMode.single,
                  ),
                ),
              ),
              const Divider(),
              if (ref.watch(isPrintSettingEnable))
                SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: <Widget>[
                            const Text("PDF Format: ", style: TextStyles.styleBold13Black),
                            const SizedBox(width: 10),
                            SizedBox(
                              width: 70,
                              child: ListTile(
                                horizontalTitleGap: 5,
                                contentPadding: const EdgeInsets.all(0),
                                title: const Text('A4', style: TextStyles.style13Black),
                                leading: Radio<PdfPageFormat>(
                                  activeColor: Colors.green,
                                  value: PdfPageFormat.a4,
                                  onChanged: (PdfPageFormat? value) {
                                    setState(() {
                                      ref.read(pdfFormat.notifier).state = value!;
                                    });
                                  },
                                  groupValue: ref.read(pdfFormat.notifier).state,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 100,
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(0),
                                horizontalTitleGap: 5,
                                title: const Text('A5', style: TextStyles.style13Black),
                                leading: Radio<PdfPageFormat>(
                                  activeColor: Colors.green,
                                  value: PdfPageFormat.a5,
                                  onChanged: (PdfPageFormat? value) {
                                    setState(() {
                                      ref.read(pdfFormat.notifier).state = value!;
                                    });
                                  },
                                  groupValue: ref.read(pdfFormat.notifier).state,
                                ),
                              ),
                            ),
                          ],
                        ),
                        TextButton.icon(
                          onPressed: () {
                            ref.read(isPrintSettingEnable.notifier).state = !ref.read(isPrintSettingEnable.notifier).state;
                          },
                          label: const Text(''),
                          icon: const Icon(Icons.check, color: Colors.green),
                        ),
                      ],
                    )),
              const Divider(),
              Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () => controller.openPDFFile(widget.pdfFileBytes, widget.con?.code ?? widget.name ?? 'pdf'),
                      label: const Text(kIsWeb ? "Download" : "Open"),
                      icon: const Icon(Icons.picture_as_pdf),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () => controller.printPDF(widget.pdfFileBytes),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(),
                          const Row(
                            children: [Icon(Icons.print_rounded), SizedBox(width: 5), Text("Print")],
                          ),
                          TextButton.icon(
                            onPressed: () {
                              ref.read(isPrintSettingEnable.notifier).state = !ref.read(isPrintSettingEnable.notifier).state;
                            },
                            label: const Text(''),
                            icon: const Icon(Icons.settings),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(child: TextButton(onPressed: () => ns.pop(), child: const Text("OK"))),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
