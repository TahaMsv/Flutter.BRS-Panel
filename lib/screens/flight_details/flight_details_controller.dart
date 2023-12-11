// ignore_for_file: unused_result
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import '../../core/abstracts/success_abs.dart';
import '../../core/classes/login_user_class.dart';
import '../../core/util/confirm_operation.dart';
import '../../core/util/handlers/success_handler.dart';
import 'example/dummy_class.dart' if (dart.library.js) 'dart:html' as html;
import 'package:flutter/foundation.dart';
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
import 'usecases/delete_tag_usecase.dart';
import 'usecases/flight_get_details_usecase.dart';
import 'usecases/flight_get_tag_details_usecase.dart';
import 'usecases/get_container_pdf_usecase.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class FlightDetailsController extends MainController {
  late FlightDetailsState flightDetailsState = ref.read(flightDetailsProvider);

  /// View Helper ------------------------------------------------------------------------------------------------------

  List<TagContainer> getBinContainers(Bin bin, List<TagContainer> allCons, FlightDetails fd, bool countEmpty) {
    List<TagContainer> results = [];
    if (fd.tagList.any((e) => e.getContainerID == null && e.tagPositions.first.binID == bin.id)) {
      results = allCons.where((e) => e.getTags(fd).where((t) => t.tagPositions.first.binID == bin.id).isNotEmpty).toList() + [TagContainer.bulk(2)];
    } else {
      results = allCons.where((e) => e.getTags(fd).where((t) => t.tagPositions.first.binID == bin.id).isNotEmpty).toList();
    }
    return results;
  }

  List<FlightTag> getContainerTags(TagContainer con, List<FlightTag> allTags) {
    Position? selectedPos = ref.watch(selectedPosInDetails);
    return allTags.where((e) {
      return (selectedPos == null || selectedPos.id == e.currentPosition) && e.tagPositions.first.container?.id == con.id || (e.tagPositions.first.container?.id == null && con.isCart);
    }).toList();
  }

  /// Core -------------------------------------------------------------------------------------------------------------

  deleteTag(int flightID, FlightTag tag) async {
    bool confirm = await ConfirmOperation.getConfirm(Operation(message: "You are Deleting tags", title: "Are You Sure?", actions: ["Cancel", "Confirm"], type: OperationType.warning));
    if (!confirm) return;
    DeleteTagRequest deleteTagRequest = DeleteTagRequest(flightID: flightID, tag: tag);
    DeleteTagUseCase deleteTagUseCase = DeleteTagUseCase();
    final fOrR = await deleteTagUseCase(request: deleteTagRequest);
    fOrR.fold((l) => FailureHandler.handle(l), (r) {
      nav.pop();
      final fdP = ref.read(detailsProvider.notifier);
      FlightDetails fd = fdP.state!;
      fd.tagList.removeWhere((t) => t.tagId == tag.tagId);
      fdP.update((state) => state = fd);
      flightDetailsState.setState();
      SuccessHandler.handle(ServerSuccess(code: 1, msg: "Done Deleting!"));
    });
  }

  getContainerPDF(TagContainer container) async {
    GetContainerReportUseCase getContainerReportUseCase = GetContainerReportUseCase();
    GetContainerReportRequest getContainerReportRequest = GetContainerReportRequest(con: container, userSetting: BasicClass.userSetting);
    final fOrR = await getContainerReportUseCase(request: getContainerReportRequest);
    fOrR.fold((f) => FailureHandler.handle(f, retry: () => getContainerPDF(container)), (r) {
      final bytes = base64Decode(r.dataFile);
      nav.dialog(PDFPreviewDialog(pdfFileBytes: bytes, con: container, pdfURL: null));
    });
  }

  printPDF(Uint8List bytes) async {
    final doc = pw.Document();
    print(bytes);
    // await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => doc.save(),);
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => bytes,
    );
  }

  openPDFFile(Uint8List bytes, String name) async {
    try {
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
        Directory path = await getApplicationDocumentsDirectory();
        // print("asdas");
        final String filePath = "${path.path}\\$name.pdf".replaceAll(" ", "");
        // print("asdas2$filePath");
        final Uri uri = Uri.file(filePath);
        // print("asdas3");
        await File.fromUri(uri).writeAsBytes(bytes);
        // print("asdas4");
        // if (!File(uri.toFilePath()).existsSync()) {
        //   print("asdas");
        //   throw Exception('$uri does not exist!');
        // }else{
        //   print("not exist ${uri.toFilePath()}");
        // }
        launchUrl(uri);
        // await OpenFile.open(uri.path,type: "pdf");
      }
    } catch (e) {
      print(e);
    }
    // if (!await launchUrl(uri)) {
    // throw Exception('Could not launch $uri');
    // }
  }

  Future<FlightDetails?> flightGetDetails(int flightID) async {
    FlightDetails? flightDetails;
    FlightGetDetailsUseCase flightGetDetailsUsecase = FlightGetDetailsUseCase();
    FlightGetDetailsRequest flightGetDetailsRequest = FlightGetDetailsRequest(flightID: flightID);
    final fOrR = await flightGetDetailsUsecase(request: flightGetDetailsRequest);
    fOrR.fold((f) => FailureHandler.handle(f, retry: () => flightGetDetails(flightID)), (r) {
      flightDetails = r.details;
    });
    return flightDetails;
  }

  Future<TagMoreDetails?> flightGetTagMoreDetails(int flightID, FlightTag tag) async {
    TagMoreDetails? moreDetails;
    FlightGetTagMoreDetailsUseCase flightGetTagMoreDetailsUsecase = FlightGetTagMoreDetailsUseCase();
    FlightGetTagMoreDetailsRequest flightGetTagMoreDetailsRequest = FlightGetTagMoreDetailsRequest(flightID: flightID, tag: tag);
    final fOrR = await flightGetTagMoreDetailsUsecase(request: flightGetTagMoreDetailsRequest);
    fOrR.fold((f) => FailureHandler.handle(f, retry: () => flightGetTagMoreDetails(flightID, tag)), (r) {
      moreDetails = r.details;
      print(r.details.toJson());
      nav.dialog(TagDetailsDialog(
        tag: tag,
        moreDetails: r.details,
      ));
    });
    return moreDetails;
  }

  Future<Size> getImageSize(Uint8List imageData) async {
    final Completer<ui.Image> completer = Completer();
    final Uint8List bytes = Uint8List.fromList(imageData);
    final ui.Codec codec = await ui.instantiateImageCodec(bytes);
    final ui.Image image = (await codec.getNextFrame()).image;
    completer.complete(image);
    return Size(image.width.toDouble(), image.height.toDouble());
  }
}
