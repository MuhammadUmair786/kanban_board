import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormFieldWithSuffixAction extends StatelessWidget {
  const CustomTextFormFieldWithSuffixAction({
    super.key,
    this.hintText,
    required this.labelText,
    required this.controller,
    this.validator,
    this.inputFormatterList,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
    this.marginBottom,
    this.onActionComplete,
    this.suffixIconPath = '',
    this.suffixIcon,
  });
  final String? hintText;
  final String labelText;
  final TextEditingController controller;

  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatterList;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String suffixIconPath;
  final IconData? suffixIcon;

  final double? marginBottom;
  final void Function(String)? onActionComplete;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: textInputAction,
      onFieldSubmitted: onActionComplete,
      controller: controller,
      inputFormatters: inputFormatterList,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        label: Padding(
          padding: const EdgeInsets.only(left: 7),
          child: Text(
            labelText,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintText: hintText ?? labelText,
        isDense: true,
        suffixIconColor: Colors.black54,
        suffixIcon: IconButton(
          icon: suffixIconPath.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(10),
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: ImageIcon(
                      AssetImage(suffixIconPath),
                      size: 5,
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(0),
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: Icon(
                      suffixIcon,
                    ),
                  ),
                ),
          onPressed: () => onActionComplete!(controller.text),
          splashRadius: 20,
          padding: EdgeInsets.zero,
        ),
      ),
      validator: validator ??
          (String? value) {
            if (value!.trim().isEmpty) {
              return 'Please fill in this feild';
            }
            return null;
          },
    );
  }
}

class CustomTextFormFieldWithLabel extends StatelessWidget {
  const CustomTextFormFieldWithLabel({
    super.key,
    this.hintText,
    required this.labelText,
    required this.controller,
    this.validator,
    this.isReadOnly = false,
    this.inputFormatterList,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
    this.minLines,
    this.maxlines,
    this.suffixIconPath = '',
    this.suffixIcon,
    this.maxLength,
    this.marginBottom = 20,
    this.onActionComplete,
    this.textCapitalization,
    this.onChanged,
    this.autofillHintsList,
  });
  final String? hintText;
  final String labelText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool? isReadOnly;
  final List<TextInputFormatter>? inputFormatterList;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int? minLines;
  final int? maxlines;
  final String suffixIconPath;
  final IconData? suffixIcon;
  final int? maxLength;
  final double marginBottom;
  final void Function(String)? onActionComplete;
  final TextCapitalization? textCapitalization;
  final void Function(String)? onChanged;
  final List<String>? autofillHintsList;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: textInputAction,
      onFieldSubmitted: onActionComplete,
      autofillHints: autofillHintsList?.map((e) => e.toString()),
      controller: controller,
      readOnly: isReadOnly!,
      minLines: minLines,
      maxLines: maxlines ?? 1,
      maxLength: maxLength,
      inputFormatters: inputFormatterList,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization ?? TextCapitalization.none,
      onChanged: onChanged,
      decoration: InputDecoration(
        counter: maxLength == null ? const Offstage() : null,
        label: Padding(
          padding: const EdgeInsets.only(left: 7),
          child: Text(
            labelText,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintText: hintText ?? labelText,

        isDense: true,
        // suffixIconColor: Colors.black54,
        suffixIcon: suffixIconPath.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.all(10),
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: ImageIcon(
                    AssetImage(suffixIconPath),
                    size: 5,
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(8),
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Icon(
                    suffixIcon,
                    // color: Colors.black45,
                  ),
                ),
              ),
      ),
      validator: validator ??
          (String? value) {
            if (value!.trim().isEmpty) {
              return 'Please fill in this feild';
            }
            return null;
          },
    );
  }
}
