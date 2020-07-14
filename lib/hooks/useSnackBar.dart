import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SnackBarDispatcher {
  BuildContext context;

  SnackBarDispatcher(this.context);

  show(widget) {
    Scaffold.of(context).showSnackBar(SnackBar(content: widget));
  }

  showText(String text) {
    show(Text(text));
  }
}

SnackBarDispatcher useSnackBar(BuildContext context) {
  final snackBar = useMemoized(() => SnackBarDispatcher(context), [context]);
  return snackBar;
}
