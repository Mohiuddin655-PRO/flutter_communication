import 'package:flutter/material.dart';

class EditText extends StatefulWidget {
  final String hint;
  final String? initialValue, level, errorText;
  final EdgeInsetsGeometry? padding, margin;
  final TextInputType? inputType;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final BorderRadius? borderRadius;
  final bool Function(String)? validator;

  const EditText({
    Key? key,
    required this.hint,
    this.initialValue,
    this.level,
    this.errorText,
    this.padding,
    this.margin,
    this.inputType,
    this.onChanged,
    this.enabled = true,
    this.borderRadius,
    this.validator,
  }) : super(key: key);

  @override
  State<EditText> createState() => _EditTextState();
}

class _EditTextState extends State<EditText> {
  final _textController = TextEditingController();

  @override
  void initState() {
    _textController.text = widget.initialValue ?? '';
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool a = _textController.text.isEmpty;
    bool b = widget.validator == null ||
        (widget.validator != null &&
            widget.validator!.call(_textController.text));
    bool isValid = a || b;
    return Container(
      margin: widget.margin ?? const EdgeInsets.symmetric(vertical: 12),
      child: TextField(
        enabled: widget.enabled,
        controller: _textController,
        keyboardType: widget.inputType,
        onChanged: (value) => setState(() => widget.onChanged?.call(value)),
        decoration: InputDecoration(
          hintText: widget.hint,
          border: OutlineInputBorder(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          labelText: widget.level ?? widget.hint,
          contentPadding: widget.padding ??
              const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          errorText: isValid ? null : widget.errorText,
        ),
      ),
    );
  }
}
