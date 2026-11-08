import 'package:expense_tracker_app/models/transaction_model.dart';
import 'package:expense_tracker_app/utils/app_formatters.dart';
import 'package:flutter/material.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({super.key, required this.item, required this.onTap});
  final TransactionModel item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color =
        item.isIncome ? const Color(0xFF159B70) : const Color(0xFFE45B64);
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Row(children: [
            Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                    color: color.withValues(alpha: .10),
                    borderRadius: BorderRadius.circular(13)),
                child: Icon(
                    item.isIncome
                        ? Icons.south_west_rounded
                        : Icons.north_east_rounded,
                    color: color)),
            const SizedBox(width: 12),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF202A40))),
                  const SizedBox(height: 5),
                  Text('${item.category} • ${shortDate.format(item.date)}',
                      style: const TextStyle(
                          fontSize: 11, color: Color(0xFF8A93A5))),
                ])),
            const SizedBox(width: 8),
            Text('${item.isIncome ? '+' : '-'}৳${money(item.amount)}',
                style: TextStyle(
                    color: color, fontWeight: FontWeight.w800, fontSize: 12)),
          ]),
        ),
      ),
    );
  }
}
