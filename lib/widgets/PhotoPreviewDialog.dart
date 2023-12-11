import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../core/classes/login_user_class.dart';
import '../core/navigation/navigation_service.dart';
import '../initialize.dart';

class PhotoPreviewDialog extends StatefulWidget {
  final String? photoUrl;
  final Uint8List imageFileBytes;
  final Position? pos;
  final Size imageSize;

  const PhotoPreviewDialog({Key? key, required this.imageFileBytes, required this.pos, required this.photoUrl, required this.imageSize}) : super(key: key);

  @override
  _PhotoPreviewDialogState createState() => _PhotoPreviewDialogState();
}

class _PhotoPreviewDialogState extends State<PhotoPreviewDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double imageWidth = widget.imageSize.width;
    double imageHeight = widget.imageSize.height;
    double width = MediaQuery.of(context).size.width;

    double horozintalPad = (width - imageWidth + 200) / 2;

    return Material(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horozintalPad!, vertical: 100),
        child: Container(
          // constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width/2, maxHeight: MediaQuery.of(context).size.height/2 * 0.7),
          // width: MediaQuery.of(context).size.width/2,
          // height: MediaQuery.of(context).size.height/2,
          // padding: EdgeInsets.all(24),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Text("PhotoPreview ${widget.pos?.title ?? ''}"),
              ),
              Divider(),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Center(
                  child: SizedBox(
                    // width: MediaQuery.of(context).size.width/2,
                    child: widget.photoUrl == null
                        ? Image.memory(
                            widget.imageFileBytes,
                            fit: BoxFit.contain,
                          )
                        : Image.network(
                            widget.photoUrl!,
                            fit: BoxFit.contain,
                          ),
                  ),
                ),
              )),
              const Divider(),
              Center(
                child: TextButton(
                    onPressed: () {
                      final NavigationService nav = getIt<NavigationService>();
                      nav.popDialog();
                    },
                    child: const Text("OK")),
              )
            ],
          ),
        ),
      ),
    );
  }
}
