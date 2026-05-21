import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final IconData icon;
  final bool obscureText;
  final bool readOnly;
  final TextInputType keyboardType;
  final VoidCallback? onTap;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    required this.icon,
    this.obscureText = false,
    this.readOnly = false,
    this.keyboardType = TextInputType.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      readOnly: readOnly,
      keyboardType: keyboardType,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
