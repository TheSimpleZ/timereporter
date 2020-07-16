// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customTextFormField.dart';

// **************************************************************************
// FunctionalWidgetGenerator
// **************************************************************************

class CustomTextFormField extends HookWidget {
  const CustomTextFormField(
      {Key key,
      this.textController,
      this.errorMessage,
      this.icon,
      this.hintText,
      this.labelText,
      this.keyBoardType,
      this.obscureText = false,
      this.autocorrect = true})
      : super(key: key);

  final dynamic textController;

  final dynamic errorMessage;

  final dynamic icon;

  final dynamic hintText;

  final dynamic labelText;

  final dynamic keyBoardType;

  final dynamic obscureText;

  final dynamic autocorrect;

  @override
  Widget build(BuildContext _context) => customTextFormField(
      textController: textController,
      errorMessage: errorMessage,
      icon: icon,
      hintText: hintText,
      labelText: labelText,
      keyBoardType: keyBoardType,
      obscureText: obscureText,
      autocorrect: autocorrect);
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<dynamic>('textController', textController));
    properties.add(DiagnosticsProperty<dynamic>('errorMessage', errorMessage));
    properties.add(DiagnosticsProperty<dynamic>('icon', icon));
    properties.add(DiagnosticsProperty<dynamic>('hintText', hintText));
    properties.add(DiagnosticsProperty<dynamic>('labelText', labelText));
    properties.add(DiagnosticsProperty<dynamic>('keyBoardType', keyBoardType));
    properties.add(DiagnosticsProperty<dynamic>('obscureText', obscureText));
    properties.add(DiagnosticsProperty<dynamic>('autocorrect', autocorrect));
  }
}
