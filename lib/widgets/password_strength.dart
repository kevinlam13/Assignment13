import 'package:flutter/material.dart';

/// Utility for scoring a password's strength.
class PasswordStrength {
  static int score(String pwd) {
    int s = 0;
    if (pwd.length >= 6) s++;
    if (pwd.length >= 10) s++;
    if (RegExp(r'[0-9]').hasMatch(pwd)) s++;
    if (RegExp(r'[A-Z]').hasMatch(pwd)) s++;
    if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(pwd)) s++;
    return s.clamp(0, 4);
  }
}

/// Visual password strength bar widget.
class PasswordStrengthBar extends StatelessWidget {
  final String password;
  const PasswordStrengthBar({super.key, required this.password});

  Color _colorFor(int s) {
    if (s <= 1) return Colors.red;
    if (s == 2) return Colors.orange;
    if (s == 3) return Colors.lightGreen;
    return Colors.green;
  }

  String _label(int s) {
    if (s <= 1) return "Weak";
    if (s == 2) return "Okay";
    if (s == 3) return "Strong";
    return "Very Strong";
  }

  @override
  Widget build(BuildContext context) {
    final s = PasswordStrength.score(password);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            minHeight: 8,
            value: s / 4,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(_colorFor(s)),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Password strength: ${_label(s)}",
          style: TextStyle(
            color: _colorFor(s),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
