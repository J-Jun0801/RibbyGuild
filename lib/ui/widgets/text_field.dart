import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:libby_guild/res/colors.dart';
import 'package:libby_guild/res/text_themes.dart';

/// unitText : 단위 문자 (ex : 원 / km )
/// textAlign : text 정렬 위치
/// hintText : hint
/// textInputType : 키패드
/// valueChanged : valueChanged  function
/// enabled : true 활성화 / false 비활성화
/// isPassword : 패스워드 여부
class CommonTextField extends StatefulWidget {
  const CommonTextField({
    super.key,
    this.unitText,
    this.textAlign,
    this.hintText,
    this.textInputType,
    this.valueChanged,
    this.enabled,
    this.isPassword,
    this.validator,
    this.textEditingController,
    this.focusNode,
    this.maxLength,
    this.maxLines,
    this.inputFormatters,
  });

  final String? unitText;
  final TextAlign? textAlign;
  final String? hintText;
  final TextInputType? textInputType;
  final ValueChanged<String>? valueChanged;
  final String? Function(String?)? validator;
  final bool? enabled;
  final bool? isPassword;
  final TextEditingController? textEditingController;
  final FocusNode? focusNode;
  final int? maxLength;
  final int? maxLines;
  final List<TextInputFormatter>? inputFormatters;

  @override
  State<CommonTextField> createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
  bool _isFocus = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode?.addListener(() {
      setState(() {
        _isFocus = widget.focusNode?.hasFocus ?? false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    widget.focusNode?.removeListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final enabled = widget.enabled ?? true;

    return TextFormField(
        scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      validator: (value) => widget.validator?.call(value),
      textAlign: widget.textAlign ?? TextAlign.start,
      obscureText: widget.isPassword ?? false,
      obscuringCharacter: '●',
      enabled: enabled,
      focusNode: widget.focusNode,
      controller: widget.textEditingController,
      style: textTheme.bodyB1Regular.copyWith(color: enabled ? colorScheme.primaryBlack : colorScheme.grayGray4),
      maxLength: widget.maxLength,
      maxLines: widget.maxLines ?? 1,
      inputFormatters: widget.inputFormatters,
      onChanged: (text) {
        setState(() {});
        widget.valueChanged?.call(text);
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: enabled ? colorScheme.primaryWhite : colorScheme.grayGray3,
        contentPadding: const EdgeInsets.fromLTRB(12, 12.5, 12, 12.5),
        suffixText: widget.unitText,
        suffixStyle:
            textTheme.bodyB1Regular.copyWith(color: enabled ? colorScheme.primaryBlack : colorScheme.grayGray4),
        hintText: widget.hintText ?? "",
        hintStyle: textTheme.bodyB1Regular.copyWith(color: colorScheme.primaryGray4),
        labelStyle: TextStyle(color: colorScheme.primaryBlack),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          borderSide: BorderSide(width: 1, color: colorScheme.primaryBlack),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          borderSide: BorderSide(width: 1, color: colorScheme.grayGray2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          borderSide: BorderSide(width: 1, color: colorScheme.grayGray3),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          borderSide: BorderSide(width: 1, color: colorScheme.secondaryRed),
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
      keyboardType: widget.textInputType ?? TextInputType.emailAddress,
    );
  }

}
