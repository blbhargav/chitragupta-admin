import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;
// see https://pub.dev/packages/universal_html

//class HandCursor extends MouseRegion {
//
//  // get a reference to the body element that we previously altered
//  static final appContainer = html.window.document.getElementById('app-container');
//
//  HandCursor({Widget child}) : super(
//      onHover: (PointerHoverEvent evt) {
//        appContainer.style.cursor='pointer';
//        // you can use any of these:
//        // 'help', 'wait', 'move', 'crosshair', 'text' or 'pointer'
//        // more options/details here: http://www.javascripter.net/faq/stylesc.htm
//      },
//      onExit: (PointerExitEvent evt) {
//        // set cursor's style 'default' to return it to the original state
//        appContainer.style.cursor='default';
//      },
//      child: child
//  );
//
//}

class HandCursor extends MouseRegion {
  static final appContainer = html.window.document.querySelectorAll('flt-glass-pane')[0];
  HandCursor({Widget child}) : super(
      onHover: (PointerHoverEvent evt) {
        appContainer.style.cursor='pointer';
      },
      onExit: (PointerExitEvent evt) {
        appContainer.style.cursor='default';
      },
      child: child
  );
}

class InkWellMouseRegion extends InkWell {
  InkWellMouseRegion({
    Key key,
    @required Widget child,
    @required GestureTapCallback onTap,
    double borderRadius = 0,
  }) : super(
    key: key,
    child: !kIsWeb ? child : HoverAware(child: child),
    onTap: onTap,
    borderRadius: BorderRadius.circular(borderRadius),
  );
}

class HoverAware extends MouseRegion {

  // get a reference to the body element that we previously altered
  static final appContainer = html.window.document.getElementById('app-container');

  HoverAware({Widget child}) : super(
      onHover: (PointerHoverEvent evt) {
        appContainer.style.cursor='pointer';
        // you can use any of these:
        // 'help', 'wait', 'move', 'crosshair', 'text' or 'pointer'
        // more options/details here: http://www.javascripter.net/faq/stylesc.htm
      },
      onExit: (PointerExitEvent evt) {
        // set cursor's style 'default' to return it to the original state
        appContainer.style.cursor='default';
      },
      child: child
  );

}