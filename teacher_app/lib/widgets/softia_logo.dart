import 'package:flutter/material.dart';

class SoftiaLogo extends StatelessWidget {
  const SoftiaLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.school, color: AppColors.primary),
        const SizedBox(width: 8),
        Text("Softia",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
            fontFamily: 'Poppins',
          ),
        )
      ],
    );
  }
}