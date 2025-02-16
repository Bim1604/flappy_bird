import 'package:flappy_bird/util/string_utils.dart';
import 'package:flutter/material.dart';

class TextFieldComponent extends StatefulWidget {
  const TextFieldComponent({super.key,this.title,this.isPassword= false,required this.controller, this.titleColor, this.backgroundColor, this.borderColor, this.hintText, this.suffixIcon, this.radius, this.prefixIcon, this.onChanged, this.textAlign, this.contentPadding, this.height, this.isMultiLine = false, this.maxLength, this.line});
  final String? title;
  final TextEditingController controller;
  final bool? isPassword;
  final Color? titleColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final String? hintText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final double? radius;
  final Function(String)? onChanged;
  final TextAlign? textAlign;
  final EdgeInsetsGeometry? contentPadding;
  final double? height;
  final bool isMultiLine;
  final int? maxLength;
  final int? line;

  @override
  State<TextFieldComponent> createState() => _TextFieldComponentState();
}

class _TextFieldComponentState extends State<TextFieldComponent> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: !StringUtils.isNullOrWhite(widget.title),
            child: Container(
              margin: const EdgeInsets.only(bottom: 15.0),
              child: Text(widget.title??"",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold, color: widget.titleColor))
            )
          ),
          Container(
            decoration: BoxDecoration(
              color: widget.backgroundColor ?? Theme.of(context).focusColor,
              borderRadius: BorderRadius.all(Radius.circular(widget.radius ?? 10.0))
            ),
            padding: const EdgeInsets.only(left: 3.0),
            child: TextField(
              keyboardType: widget.isMultiLine ? TextInputType.multiline : null,
              maxLines: widget.line ?? (widget.isMultiLine ? 4 : 1),
              onChanged: (value) {
                if (widget.onChanged != null) {
                  widget.onChanged!(value);
                }
              },
              maxLength: widget.maxLength,
              textAlignVertical: TextAlignVertical.center,
              textAlign: widget.textAlign ?? TextAlign.start,
              obscureText: widget.isPassword??false,
              controller: widget.controller,
              cursorColor: Theme.of(context).colorScheme.onPrimary,
              style: const TextStyle(color: Color(0xFF6f5093), fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                hintFadeDuration: const Duration(milliseconds: 500),

                prefixIcon: widget.prefixIcon,
                suffixIcon: widget.suffixIcon,
                isDense: true,
                prefixIconConstraints: const BoxConstraints(maxHeight: 20, maxWidth: 40),
                suffixIconConstraints: const BoxConstraints(maxHeight: 20, maxWidth: 40),
                hintText: widget.hintText,
                border: InputBorder.none,
                hintStyle: Theme.of(context).textTheme.titleSmall?.copyWith(color: widget.titleColor),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.radius ?? 10.0),
                  borderSide: BorderSide(color: widget.borderColor ?? Theme.of(context).colorScheme.primary, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.radius ?? 10.0),
                  borderSide: BorderSide(color: widget.borderColor ?? Theme.of(context).colorScheme.primary, width: 0.6),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.radius ?? 10.0),
                  borderSide: const BorderSide(color: Colors.grey, width: 0.4),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.radius ?? 10.0),
                  borderSide: BorderSide.none,
                ),
                focusedErrorBorder: InputBorder.none,
                contentPadding: widget.contentPadding ?? const EdgeInsets.only(left: 10,right: 5,top: 7.0, bottom: 7.0)
              ),
            ),
          )
        ],
      ),
    );
  }
}