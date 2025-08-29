import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback handleLogin;
  final String buttonText;
  const AppButton({
    super.key,
    required this.isLoading,
    required this.handleLogin,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 8,
            offset: const Offset(1, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: handleLogin,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Color(0xFFFFD700),
          foregroundColor: Colors.black,
          fixedSize: Size(500, 60),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(
                buttonText,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }
}
