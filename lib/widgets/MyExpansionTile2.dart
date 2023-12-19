// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const Duration _kExpand = Duration(milliseconds: 200);

/// A single-line [ListTile] with a trailing button that expands or collapses
/// the tile to reveal or hide the [children].
///
/// This widget is typically used with [ListView] to create an
/// "expand / collapse" list entry. When used with scrolling widgets like
/// [ListView], a unique [PageStorageKey] must be specified to enable the
/// [MyExpansionTile2] to save and restore its expanded state when it is scrolled
/// in and out of view.
///
/// This class overrides the [ListTileTheme.iconColor] and [ListTileTheme.textColor]
/// theme properties for its [ListTile]. These colors animate between values when
/// the tile is expanded and collapsed: between [iconColor], [collapsedIconColor] and
/// between [textColor] and [collapsedTextColor].
///
/// See also:
///
///  * [ListTile], useful for creating expansion tile [children] when the
///    expansion tile represents a sublist.
///  * The "Expand and collapse" section of
///    <https://material.io/components/lists#types>
class MyExpansionTile2 extends StatefulWidget {
  /// Creates a single-line [ListTile] with a trailing button that expands or collapses
  /// the tile to reveal or hide the [children]. The [initiallyExpanded] property must
  /// be non-null.
  const MyExpansionTile2(
      {Key? key,
      this.leading,
      required this.title,
      this.subtitle,
      this.onExpansionChanged,
      this.children = const <Widget>[],
      this.trailing,
      this.initiallyExpanded = true,
      this.maintainState = false,
      this.tilePadding,
      this.expandedCrossAxisAlignment,
      this.expandedAlignment,
      this.childrenPadding,
      this.backgroundColor,
      this.collapsedBackgroundColor,
      this.textColor,
      this.collapsedTextColor,
      this.iconColor,
      this.padding,
      this.margin,
      this.decoration,
      this.icon,
      this.collapsedIconColor,
      this.showIcon = true,
      this.showLeadingIcon = false,
      this.noTrailing = false,
      this.headerDivider})
      : assert(
          expandedCrossAxisAlignment != CrossAxisAlignment.baseline,
          'CrossAxisAlignment.baseline is not supported since the expanded children '
          'are aligned in a column, not a row. Try to use another constant.',
        ),
        super(key: key);

  final Widget? leading;
  final Widget? icon;
  final Widget title;
  final Widget? subtitle;
  final ValueChanged<bool>? onExpansionChanged;
  final List<Widget> children;
  final Color? backgroundColor;
  final Color? collapsedBackgroundColor;
  final Widget? trailing;
  final bool initiallyExpanded;
  final bool maintainState;
  final EdgeInsetsGeometry? tilePadding;
  final Alignment? expandedAlignment;
  final CrossAxisAlignment? expandedCrossAxisAlignment;
  final EdgeInsetsGeometry? childrenPadding;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BoxDecoration? decoration;
  final Color? iconColor;
  final Color? collapsedIconColor;
  final Color? textColor;
  final Color? collapsedTextColor;
  final bool showIcon;
  final bool showLeadingIcon;
  final bool noTrailing;
  final Widget? headerDivider;

  @override
  _MyExpansionTile2State createState() => _MyExpansionTile2State();
}

class _MyExpansionTile2State extends State<MyExpansionTile2> with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeOutTween = CurveTween(curve: Curves.easeOut);
  static final Animatable<double> _easeInTween = CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _halfTween = Tween<double>(begin: 0.0, end: 0.5);

  final ColorTween _borderColorTween = ColorTween();
  final ColorTween _headerColorTween = ColorTween();
  final ColorTween _iconColorTween = ColorTween();
  final ColorTween _backgroundColorTween = ColorTween();

  late AnimationController _controller;
  late Animation<double> _iconTurns;
  late Animation<double> _heightFactor;
  late Animation<Color?> _borderColor;
  late Animation<Color?> _headerColor;
  late Animation<Color?> _iconColor;
  late Animation<Color?> _backgroundColor;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _kExpand, vsync: this);
    _heightFactor = _controller.drive(_easeInTween);
    _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));
    _borderColor = _controller.drive(_borderColorTween.chain(_easeOutTween));
    _headerColor = _controller.drive(_headerColorTween.chain(_easeInTween));
    _iconColor = _controller.drive(_iconColorTween.chain(_easeInTween));
    _backgroundColor = _controller.drive(_backgroundColorTween.chain(_easeOutTween));

    _isExpanded = PageStorage.of(context).readState(context) as bool? ?? widget.initiallyExpanded;
    if (_isExpanded) _controller.value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse().then<void>((void value) {
          if (!mounted) return;
          setState(() {
            // Rebuild without widget.children.
          });
        });
      }
      PageStorage.of(context).writeState(context, _isExpanded);
    });
    widget.onExpansionChanged?.call(_isExpanded);
  }

  Widget _buildChildren(BuildContext context, Widget? child) {
    final Color borderSideColor = _borderColor.value ?? Colors.transparent;
    return Container(
      decoration: widget.decoration,
      padding: widget.padding,
      margin: widget.margin,
      color: widget.backgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          widget.noTrailing
              ? InkWell(onTap: _handleTap, child: widget.title)
              : Container(
                  padding: widget.tilePadding,
                  child: InkWell(
                    onTap: _handleTap,
                    child: Row(
                      children: [
                        widget.showLeadingIcon
                            ? RotationTransition(
                                turns: _iconTurns,
                                child: widget.icon ??
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Icon(Icons.expand_more, color: _iconColor.value),
                                    ),
                              )
                            : Container(),
                        Expanded(child: widget.title),
                        widget.trailing ?? Container(),
                        widget.showIcon
                            ? RotationTransition(
                                turns: _iconTurns,
                                child: widget.icon ??
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Icon(Icons.expand_more, color: _iconColor.value),
                                    ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
          widget.headerDivider ?? Container(),
          //
          // ListTileTheme.merge(
          //   iconColor: _iconColor.value,
          //   textColor: _headerColor.value,
          //   child: ListTile(
          //     onTap: _handleTap,
          //     contentPadding: widget.tilePadding,
          //     leading: widget.leading,
          //     title: widget.title,
          //     subtitle: widget.subtitle,
          //     trailing: widget.trailing ?? RotationTransition(
          //       turns: _iconTurns,
          //       child: const Icon(Icons.expand_more),
          //     ),
          //   ),
          // ),
          ClipRect(
            child: Padding(
              padding: widget.childrenPadding ?? const EdgeInsets.symmetric(horizontal: 12),
              child: Align(
                alignment: widget.expandedAlignment ?? Alignment.center,
                heightFactor: _heightFactor.value,
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    _borderColorTween.end = theme.dividerColor;
    _headerColorTween
      ..begin = widget.collapsedTextColor ?? theme.textTheme.subtitle1!.color
      ..end = widget.textColor ?? colorScheme.secondary;
    _iconColorTween
      ..begin = widget.collapsedIconColor ?? theme.unselectedWidgetColor
      ..end = widget.iconColor ?? colorScheme.secondary;
    _backgroundColorTween
      ..begin = widget.collapsedBackgroundColor
      ..end = widget.backgroundColor;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final bool closed = !_isExpanded && _controller.isDismissed;
    final bool shouldRemoveChildren = closed && !widget.maintainState;

    final Widget result = Offstage(
      offstage: closed,
      child: TickerMode(
        enabled: !closed,
        child: Container(
          padding: widget.childrenPadding ?? EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: widget.expandedCrossAxisAlignment ?? CrossAxisAlignment.center,
            children: widget.children,
          ),
        ),
      ),
    );

    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChildren,
      child: shouldRemoveChildren ? null : result,
    );
  }
}
