import 'dart:convert';
import 'dart:io';
import '../../core/classes/login_user_class.dart';
import 'example/dummy_class.dart' if (dart.library.js) 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../../core/abstracts/controller_abs.dart';
import '../../core/classes/flight_details_class.dart';
import '../../core/classes/tag_container_class.dart';
import '../../core/classes/tag_more_details_class.dart';
import '../../core/util/basic_class.dart';
import '../../core/util/handlers/failure_handler.dart';
import '../../widgets/TagDetailsDialog.dart';
import 'dialogs/pdf_preview_dialog.dart';
import 'flight_details_state.dart';
import 'usecases/flight_get_details_usecase.dart';
import 'usecases/flight_get_tag_details_usecase.dart';
import 'usecases/get_container_pdf_usecase.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class FlightDetailsController extends MainController {
  late FlightDetailsState flightDetailsState = ref.read(flightDetailsProvider);

  /// View Helper ------------------------------------------------------------------------------------------------------

  List<TagContainer> getBinContainers(Bin bin, List<TagContainer> allCons, FlightDetails fd, bool countEmpty) {
    List<TagContainer> results = [];
    if (fd.tagList.any((e) => e.getContainerID == null && e.tagPositions.first.binID == bin.id)) {
      results =
          allCons.where((e) => e.getTags(fd).where((t) => t.tagPositions.first.binID == bin.id).isNotEmpty).toList() +
              [TagContainer.bulk(2)];
    } else {
      results =
          allCons.where((e) => e.getTags(fd).where((t) => t.tagPositions.first.binID == bin.id).isNotEmpty).toList();
    }
    return results;
  }

  List<FlightTag> getContainerTags(TagContainer con, List<FlightTag> allTags) {
    Position? selectedPos = ref.watch(selectedPosInDetails);
    return allTags.where((e) {
      return (selectedPos == null || selectedPos.id == e.currentPosition) &&
              e.tagPositions.first.container?.id == con.id ||
          (e.tagPositions.first.container?.id == null && con.isCart);
    }).toList();
  }

  /// Core -------------------------------------------------------------------------------------------------------------
  getContainerPDF(TagContainer container) async {
    GetContainerReportUseCase getContainerReportUseCase = GetContainerReportUseCase();
    GetContainerReportRequest getContainerReportRequest =
        GetContainerReportRequest(con: container, userSetting: BasicClass.userSetting);
    final fOrR = await getContainerReportUseCase(request: getContainerReportRequest);
    fOrR.fold((f) => FailureHandler.handle(f, retry: () => getContainerPDF(container)), (r) {
      final bytes = base64Decode(r.dataFile);
      nav.dialog(PDFPreviewDialog(pdfFileBytes: bytes, con: container, pdfURL: null));
    });
  }

  printPDF(Uint8List bytes,) async {
    print("Here 83");
    final doc = pw.Document();
    print("Here 97");
    // await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => doc.save(),);
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => bytes,);
  }


  openPDFFile(Uint8List bytes, TagContainer con) async {
    if (kIsWeb) {
      final blob = html.Blob([bytes], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.document.createElement('a') as html.AnchorElement
        ..href = url
        ..style.display = 'none'
        ..download = 'report.pdf';
      html.document.body?.children.add(anchor);
      anchor.click();
    } else {
      Directory path = await getTemporaryDirectory();
      final String filePath = "${path.path}/${con.id}.pdf";
      final Uri uri = Uri.file(filePath);
      await File.fromUri(uri).writeAsBytes(bytes);
      if (!File(uri.toFilePath()).existsSync()) {
        throw Exception('$uri does not exist!');
      }
      OpenFile.open(uri.path);
    }
    // if (!await launchUrl(uri)) {
    // throw Exception('Could not launch $uri');
    // }
  }

  Future<FlightDetails?> flightGetDetails(int flightID) async {
    // final fdP = ref.read(detailsProvider.notifier);
    FlightDetails? flightDetails;
    FlightGetDetailsUseCase flightGetDetailsUsecase = FlightGetDetailsUseCase();
    FlightGetDetailsRequest flightGetDetailsRequest = FlightGetDetailsRequest(flightID: flightID);
    final fOrR = await flightGetDetailsUsecase(request: flightGetDetailsRequest);
    fOrR.fold((f) => FailureHandler.handle(f, retry: () => flightGetDetails(flightID)), (r) {
      flightDetails = r.details;
      // final fdP = ref.read(detailsProvider.notifier);
      // fdP.setFlightDetails(r.details);
    });
    return flightDetails;
  }

  Future<TagMoreDetails?> flightGetTagMoreDetails(int flightID, FlightTag tag) async {
    // final fdP = ref.read(detailsProvider.notifier);
    TagMoreDetails? moreDetails;
    FlightGetTagMoreDetailsUseCase flightGetTagMoreDetailsUsecase = FlightGetTagMoreDetailsUseCase();
    FlightGetTagMoreDetailsRequest flightGetTagMoreDetailsRequest =
        FlightGetTagMoreDetailsRequest(flightID: flightID, tag: tag);
    final fOrR = await flightGetTagMoreDetailsUsecase(request: flightGetTagMoreDetailsRequest);
    fOrR.fold((f) => FailureHandler.handle(f, retry: () => flightGetTagMoreDetails(flightID, tag)), (r) {
      moreDetails = r.details;
      print(r.details.toJson());
      nav.dialog(TagDetailsDialog(
        tag: tag,
        moreDetails: r.details,
      ));
      // final fdP = ref.read(detailsProvider.notifier);
      // fdP.setFlightDetails(r.details);
    });
    return moreDetails;
  }
}
