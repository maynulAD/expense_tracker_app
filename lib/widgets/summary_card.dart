import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard(
      {super.key,
      required this.title,
      required this.amount,
      required this.icon,
      required this.color});
  final String title;
  final double amount;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(17),
            border: Border.all(color: const Color(0xFFEBEEF4))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 12),
          Text(title,
              style: const TextStyle(
                  color: Color(0xFF7B8498),
                  fontSize: 12,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 5),
          FittedBox(
              alignment: Alignment.centerLeft,
              fit: BoxFit.scaleDown,
              child: Text('৳ ${amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                      color: Color(0xFF17213A),
                      fontSize: 17,
                      fontWeight: FontWeight.w800))),
        ]),
      );
}
