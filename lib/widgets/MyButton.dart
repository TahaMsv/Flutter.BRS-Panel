import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

class MyButton extends StatefulWidget {
  final double height;
  final double? width;
  final double? fontSize;
  final Callback? onPressed;
  final VoidCallback? onLongPress;
  final ValueChanged<bool>? onHover;
  final ValueChanged<bool>? onFocusChange;
  final ButtonStyle? style;
  final FocusNode? focusNode;
  final bool autofocus;
  final MaterialStatesController? statesController;
  final Widget? child;
  final String label;
  final bool showLoading;
  final bool fade;
  final Color? color;

  const MyButton({super.key,
    this.height = 35,
    this.fontSize = 13,
    this.width,
    this.onPressed,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.style,
    this.focusNode,
    this.autofocus = false,
    this.statesController,
    this.showLoading = true,
    this.child,
    required this.label,
    // this.loading = false,
    this.fade = false,
    this.color});

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  bool _loading = false;

  _onTap() {
    if (widget.onPressed is AsyncCallback) {
      if (_loading) return;
      _loading = true;
      setState(() {});
      (widget.onPressed as AsyncCallback).call().whenComplete(() {
        _loading = false;
        setState(() {});
      });
    } else {
      widget.onPressed?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Color c = widget.onPressed == null ? Colors.grey : widget.color ?? theme.primaryColor;
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: ElevatedButton(
        onPressed: _onTap,
        onLongPress: widget.onLongPress,
        onFocusChange: widget.onFocusChange,
        autofocus: widget.autofocus,
        focusNode: widget.focusNode,
        statesController: widget.statesController,
        onHover: widget.onHover,
        style: widget.style ??
            ButtonStyle(
              fixedSize: MaterialStatePropertyAll(Size.fromHeight(widget.height)),
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
              padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 8)),
              shadowColor: const MaterialStatePropertyAll(Colors.transparent),
              backgroundColor: MaterialStatePropertyAll(c.withOpacity(widget.fade ? 0.3 : 1)),
              foregroundColor: MaterialStatePropertyAll(widget.fade ? c : Colors.white),
            ),
        child: IndexedStack(
          alignment: Alignment.center,
          index: _loading && widget.showLoading ? ((widget.width ?? 44) < 43 ? 2 : 1) : 0,
          children: [
            widget.child ?? Text(widget.label, style: TextStyle(fontSize: widget.fontSize)),
            SpinKitThreeBounce(color: widget.fade ? c : Colors.white, size: 18),
            SpinKitCircle(color: widget.fade ? c : Colors.white, size: 18),
          ],
        ),
      ),
    );
  }
}
