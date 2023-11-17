// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:webview_windows/webview_windows.dart';
// import 'package:window_manager/window_manager.dart';
// import '../../../widgets/MyButton.dart';
//
// import '../../../core/constants/ui.dart';
// import '../../../core/navigation/navigation_service.dart';
// import '../initialize.dart';
//
// class StimulPreviewDialog extends StatefulWidget {
//   final String url;
//
//   StimulPreviewDialog({Key? key,required this.url}) : super(key: key);
//
//   @override
//   State<StimulPreviewDialog> createState() => _StimulPreviewDialogState();
// }
//
// class _StimulPreviewDialogState extends State<StimulPreviewDialog> {
//   final NavigationService navigationService = getIt<NavigationService>();
//   final WebviewController _controller = WebviewController();
//   final _textController = TextEditingController();
//   final List<StreamSubscription> _subscriptions = [];
//   bool _isWebviewSuspended = false;
//
//   @override
//   void initState() {
//     super.initState();
//     initPlatformState();
//   }
//
//   Future<void> initPlatformState() async {
//     // Optionally initialize the webview environment using
//     // a custom user data directory
//     // and/or a custom browser executable directory
//     // and/or custom chromium command line flags
//     //await WebviewController.initializeEnvironment(
//     //    additionalArguments: '--show-fps-counter');
//
//     try {
//       await _controller.initialize();
//       _subscriptions.add(_controller.url.listen((url) {
//         _textController.text = url;
//       }));
//
//       _subscriptions
//           .add(_controller.containsFullScreenElementChanged.listen((flag) {
//         debugPrint('Contains fullscreen element: $flag');
//         windowManager.setFullScreen(flag);
//       }));
//
//       await _controller.setBackgroundColor(Colors.transparent);
//       await _controller.setPopupWindowPolicy(WebviewPopupWindowPolicy.deny);
//       await _controller.loadUrl('https://flutter.dev');
//
//       if (!mounted) return;
//       setState(() {});
//     } on PlatformException catch (e) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         showDialog(
//             context: context,
//             builder: (_) => AlertDialog(
//               title: Text('Error'),
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Code: ${e.code}'),
//                   Text('Message: ${e.message}'),
//                 ],
//               ),
//               actions: [
//                 TextButton(
//                   child: Text('Continue'),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                 )
//               ],
//             ));
//       });
//     }
//   }
//
//   Widget compositeView() {
//     if (!_controller.value.isInitialized) {
//       return const Text(
//         'Not Initialized',
//         style: TextStyle(
//           fontSize: 24.0,
//           fontWeight: FontWeight.w900,
//         ),
//       );
//     } else {
//       return Padding(
//         padding: EdgeInsets.all(20),
//         child: Column(
//           children: [
//             Card(
//               elevation: 0,
//               child: Row(children: [
//                 Expanded(
//                   child: TextField(
//                     decoration: InputDecoration(
//                       hintText: 'URL',
//                       contentPadding: EdgeInsets.all(10.0),
//                     ),
//                     textAlignVertical: TextAlignVertical.center,
//                     controller: _textController,
//                     onSubmitted: (val) {
//                       _controller.loadUrl(val);
//                     },
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.refresh),
//                   splashRadius: 20,
//                   onPressed: () {
//                     _controller.reload();
//                   },
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.developer_mode),
//                   tooltip: 'Open DevTools',
//                   splashRadius: 20,
//                   onPressed: () {
//                     _controller.openDevTools();
//                   },
//                 )
//               ]),
//             ),
//             Expanded(
//                 child: Card(
//                     color: Colors.transparent,
//                     elevation: 0,
//                     clipBehavior: Clip.antiAliasWithSaveLayer,
//                     child: Stack(
//                       children: [
//                         Webview(
//                           _controller,
//                           permissionRequested: _onPermissionRequested,
//                         ),
//                         StreamBuilder<LoadingState>(
//                             stream: _controller.loadingState,
//                             builder: (context, snapshot) {
//                               if (snapshot.hasData &&
//                                   snapshot.data == LoadingState.loading) {
//                                 return LinearProgressIndicator();
//                               } else {
//                                 return SizedBox();
//                               }
//                             }),
//                       ],
//                     ))),
//           ],
//         ),
//       );
//     }
//   }
//
//   Future<WebviewPermissionDecision> _onPermissionRequested(
//       String url, WebviewPermissionKind kind, bool isUserInitiated) async {
//     final decision = await showDialog<WebviewPermissionDecision>(
//       context: navigationService.context!,
//       builder: (BuildContext context) => AlertDialog(
//         title: const Text('WebView permission requested'),
//         content: Text('WebView has requested permission \'$kind\''),
//         actions: <Widget>[
//           TextButton(
//             onPressed: () =>
//                 Navigator.pop(context, WebviewPermissionDecision.deny),
//             child: const Text('Deny'),
//           ),
//           TextButton(
//             onPressed: () =>
//                 Navigator.pop(context, WebviewPermissionDecision.allow),
//             child: const Text('Allow'),
//           ),
//         ],
//       ),
//     );
//
//     return decision ?? WebviewPermissionDecision.none;
//   }
//
//   @override
//   void dispose() {
//     _subscriptions.forEach((s) => s.cancel());
//     _controller.dispose();
//     super.dispose();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     ThemeData theme = Theme.of(context);
//     double width = MediaQuery.of(context).sizewidth;
//     double height = MediaQuery.of(context).sizeheight;
//
//     return Dialog(
//       insetPadding: EdgeInsets.symmetric(horizontal: width * 0.15),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Row(
//             children: [
//               const SizedBox(width: 18),
//               const Text("Stimul Preview", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
//               const Spacer(),
//               IconButton(
//                   onPressed: () {
//                     navigationService.popDialog();
//                   },
//                   icon: const Icon(Icons.close))
//             ],
//           ),
//           const Divider(height: 1),
//           Container(
//             padding: const EdgeInsets.all(18),
//             child:  Column(
//               children: [
//                 // Expanded(child: Webview(url: "https://brsdev-api.abomis.com/mrt"))
//                 SizedBox(
//                   height:300,
//                   width:300,
//                   child: Webview(
//                     _controller,
//                     permissionRequested: _onPermissionRequested,
//                   ),
//                 )
//
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 18, right: 18, bottom: 18),
//             child: Row(
//               children: [
//                 //TextButton(onPressed: () {}, child: const Text("Add")),
//                 const Spacer(),
//
//                  MyButton(
//                   onPressed: ()=>navigationService.popDialog(),
//                   label: "Done",
//                   color: MyColors.lightIshBlue,
//                 ),
//
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
