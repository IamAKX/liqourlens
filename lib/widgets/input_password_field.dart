import 'package:flutter/material.dart';

class InputPasswordField extends StatefulWidget {
  const InputPasswordField(
      {Key? key,
      required this.hint,
      required this.controller,
      required this.keyboardType,
      required this.icon,
      this.enabled})
      : super(key: key);

  final String hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final IconData icon;

  final bool? enabled;

  @override
  State<InputPasswordField> createState() =>
      _InputPasswordFieldState();
}

class _InputPasswordFieldState extends State<InputPasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: widget.enabled ?? true,
      keyboardType: widget.keyboardType,
      autocorrect: true,
      obscureText: _obscureText,
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: widget.hint,
        prefixIcon: Icon(
          widget.icon,
        ),
        suffixIcon: InkWell(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: Icon(
            _obscureText
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
        ),
        alignLabelWithHint: true,
        filled: true,
      ),
    );
  }
}
