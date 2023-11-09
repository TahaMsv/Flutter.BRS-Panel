import 'dart:typed_data';
import 'package:brs_panel/initialize.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../../core/classes/tag_container_class.dart';
import '../../../core/constants/ui.dart';
import '../../../core/navigation/navigation_service.dart';
import '../flight_details_controller.dart';

class PDFPreviewDialog extends StatefulWidget {
  final String? pdfURL;
  final Uint8List pdfFileBytes;
  final TagContainer? con;

  const PDFPreviewDialog({Key? key, required this.pdfFileBytes, required this.con, required this.pdfURL})
      : super(key: key);

  @override
  State<PDFPreviewDialog> createState() => _PDFPreviewDialogState();
}

class _PDFPreviewDialogState extends State<PDFPreviewDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final NavigationService ns = getIt<NavigationService>();
    final FlightDetailsController controller = getIt<FlightDetailsController>();
    return Dialog(
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(0),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
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
                  onDocumentLoadFailed: (f) {
                    print("failed");
                    print(f.error);
                    print(f.description);
                  },
                  pageLayoutMode: PdfPageLayoutMode.single,
                ),
              ),
            ),
            const Divider(),
            Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => controller.openPDFFile(widget.pdfFileBytes, widget.con!),
                    label: const Text(kIsWeb ? "Download" : "Open"),
                    icon: const Icon(Icons.picture_as_pdf),
                  ),
                ),
                Expanded(child: TextButton(onPressed: () => ns.pop(), child: const Text("OK"))),
              ],
            )
          ],
        ),
      ),
    );
  }
}
