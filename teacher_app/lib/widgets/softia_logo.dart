import 'package:flutter/material.dart';
import '../utils/theme.dart'; // Import the file containing AppTheme

class SoftiaLogo extends StatelessWidget {
  const SoftiaLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.school, color: AppTheme.primary), // Changed to AppTheme.primary
        const SizedBox(width: 8),
        Text(
          "Softia",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.primary, // Changed to AppTheme.primary
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }
}