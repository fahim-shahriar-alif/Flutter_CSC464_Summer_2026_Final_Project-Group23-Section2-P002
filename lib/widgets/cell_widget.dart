import 'package:flutter/material.dart';

class CellWidget extends StatelessWidget {
  final String value;
  final VoidCallback onTap;
  final bool isEnabled;

  const CellWidget({
    super.key,
    required this.value,
    required this.onTap,
    required this.isEnabled,
  });

  Color _getTextColor() {
    if (value == 'X') return Colors.blue.shade700;
    if (value == 'O') return Colors.red.shade700;
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (isEnabled && value.isEmpty) ? onTap : null,
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.deepPurple, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 52,
              fontWeight: FontWeight.bold,
              color: _getTextColor(),
            ),
          ),
        ),
      ),
    );
  }
}
