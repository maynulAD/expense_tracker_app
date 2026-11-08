import 'package:expense_tracker_app/database/database_helper.dart';
import 'package:expense_tracker_app/models/transaction_model.dart';
import 'package:expense_tracker_app/screens/add_edit_transaction_screen.dart';
import 'package:expense_tracker_app/utils/app_formatters.dart';
import 'package:flutter/material.dart';

class TransactionDetailsScreen extends StatefulWidget {
  const TransactionDetailsScreen({super.key, required this.transaction});
  final TransactionModel transaction;
  @override
  State<TransactionDetailsScreen> createState() =>
      _TransactionDetailsScreenState();
}

class _TransactionDetailsScreenState extends State<TransactionDetailsScreen> {
  late TransactionModel _item;
  @override
  void initState() {
    super.initState();
    _item = widget.transaction;
  }

  Future<void> _edit() async {
    final changed = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
            builder: (_) => AddEditTransactionScreen(transaction: _item)));
    if (changed == true && mounted) Navigator.pop(context, true);
  }

  Future<void> _delete() async {
    final confirm = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text('Delete transaction?'),
              content: Text(
                  'Are you sure you want to delete "${_item.title}"? This action cannot be undone.'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: const Text('Cancel')),
                FilledButton(
                    style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFE05260)),
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text('Delete'))
              ],
            ));
    if (confirm == true) {
      await DatabaseHelper.instance.delete(_item.id!);
      if (mounted) Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color =
        _item.isIncome ? const Color(0xFF159B70) : const Color(0xFFE45B64);
    return Scaffold(
      appBar: AppBar(title: const Text('Transaction Details'), actions: [
        IconButton(
            onPressed: _edit,
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit'),
        IconButton(
            onPressed: _delete,
            icon: const Icon(Icons.delete_outline_rounded),
            tooltip: 'Delete')
      ]),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
                color: color.withValues(alpha: .09),
                borderRadius: BorderRadius.circular(22)),
            child: Column(children: [
              Icon(
                  _item.isIncome
                      ? Icons.south_west_rounded
                      : Icons.north_east_rounded,
                  color: color,
                  size: 34),
              const SizedBox(height: 10),
              Text(_item.type.toUpperCase(),
                  style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.3)),
              const SizedBox(height: 8),
              Text('${_item.isIncome ? '+' : '-'}৳ ${money(_item.amount)}',
                  style: TextStyle(
                      color: color, fontSize: 29, fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              Text(_item.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF29344B))),
            ])),
        const SizedBox(height: 20),
        Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE9EDF5))),
            child: Column(children: [
              _row('Category', _item.category),
              const Divider(height: 24),
              _row('Transaction type', _item.type),
              const Divider(height: 24),
              _row('Date', fullDate.format(_item.date)),
              const Divider(height: 24),
              _row('Transaction ID', '#${_item.id}'),
            ])),
        const SizedBox(height: 20),
        OutlinedButton.icon(
            onPressed: _edit,
            icon: const Icon(Icons.edit_outlined),
            label: const Text('Edit Transaction'),
            style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(51),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)))),
        TextButton.icon(
            onPressed: _delete,
            icon: const Icon(Icons.delete_outline_rounded),
            label: const Text('Delete Transaction'),
            style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFE05260),
                minimumSize: const Size.fromHeight(48))),
      ]),
    );
  }

  Widget _row(String label, String value) => Row(children: [
        Expanded(
            child: Text(label,
                style:
                    const TextStyle(color: Color(0xFF8791A4), fontSize: 13))),
        const SizedBox(width: 10),
        Flexible(
            child: Text(value,
                textAlign: TextAlign.end,
                style: const TextStyle(
                    color: Color(0xFF273149),
                    fontSize: 13,
                    fontWeight: FontWeight.w700)))
      ]);
}
