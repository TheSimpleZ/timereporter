import 'package:flutter/material.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

part 'customTextFormField.g.dart';

@hwidget
Widget customTextFormField(
        {textController,
        errorMessage,
        icon,
        hintText,
        labelText,
        keyBoardType,
        obscureText = false}) =>
    TextFormField(
      autovalidate: false,
      controller: textController,
      // The validator receives the text that the user has entered.
      validator: (value) => value.isEmpty ? errorMessage : null,
      decoration: InputDecoration(
        icon: Icon(icon),
        hintText: hintText,
        labelText: labelText,
      ),
      keyboardType: keyBoardType,
      obscureText: obscureText,
    );
