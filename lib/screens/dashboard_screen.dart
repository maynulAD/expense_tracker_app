import 'package:expense_tracker_app/database/database_helper.dart';
import 'package:expense_tracker_app/models/transaction_model.dart';
import 'package:expense_tracker_app/screens/add_edit_transaction_screen.dart';
import 'package:expense_tracker_app/screens/transaction_details_screen.dart';
import 'package:expense_tracker_app/utils/app_formatters.dart';
import 'package:expense_tracker_app/widgets/summary_card.dart';
import 'package:expense_tracker_app/widgets/transaction_tile.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<TransactionModel> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await DatabaseHelper.instance.getAll();
    if (!mounted) return;
    setState(() {
      _items = data;
      _loading = false;
    });
  }

  double get _income =>
      _items.where((e) => e.isIncome).fold(0, (s, e) => s + e.amount);
  double get _expense =>
      _items.where((e) => !e.isIncome).fold(0, (s, e) => s + e.amount);

  Future<void> _add() async {
    final changed = await Navigator.push<bool>(context,
        MaterialPageRoute(builder: (_) => const AddEditTransactionScreen()));
    if (changed == true) _load();
  }

  Future<void> _details(TransactionModel item) async {
    final changed = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
            builder: (_) => TransactionDetailsScreen(transaction: item)));
    if (changed == true) _load();
  }

  @override
  Widget build(BuildContext context) {
    final balance = _income - _expense;
    return Scaffold(
      appBar: AppBar(title: const Text('Expense Tracker'), actions: [
        IconButton(
            onPressed: _load,
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh')
      ]),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: _add,
          backgroundColor: const Color(0xFF3157D5),
          foregroundColor: Colors.white,
          icon: const Icon(Icons.add_rounded),
          label: const Text('Add Transaction')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                  padding: const EdgeInsets.fromLTRB(18, 10, 18, 100),
                  children: [
                    const Text('Your money, clearly tracked.',
                        style:
                            TextStyle(color: Color(0xFF7D879B), fontSize: 13)),
                    const SizedBox(height: 16),
                    Container(
                        padding: const EdgeInsets.all(19),
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [Color(0xFF244CC2), Color(0xFF4776E8)]),
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(children: [
                                Icon(Icons.account_balance_wallet_rounded,
                                    color: Colors.white70),
                                SizedBox(width: 9),
                                Text('CURRENT BALANCE',
                                    style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 1.2))
                              ]),
                              const SizedBox(height: 12),
                              Text('৳ ${money(balance)}',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 29,
                                      fontWeight: FontWeight.w800)),
                            ])),
                    const SizedBox(height: 12),
                    Row(children: [
                      Expanded(
                          child: SummaryCard(
                              title: 'Total Income',
                              amount: _income,
                              icon: Icons.trending_up_rounded,
                              color: const Color(0xFF159B70))),
                      const SizedBox(width: 10),
                      Expanded(
                          child: SummaryCard(
                              title: 'Total Expense',
                              amount: _expense,
                              icon: Icons.trending_down_rounded,
                              color: const Color(0xFFE45B64)))
                    ]),
                    const SizedBox(height: 25),
                    Row(children: [
                      const Expanded(
                          child: Text('Recent Transactions',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF202A40)))),
                      Text('${_items.length} total',
                          style: const TextStyle(
                              color: Color(0xFF8992A5), fontSize: 12))
                    ]),
                    const SizedBox(height: 12),
                    if (_items.isEmpty)
                      Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 34, horizontal: 18),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(17)),
                          child: const Column(children: [
                            Icon(Icons.receipt_long_rounded,
                                size: 42, color: Color(0xFFADB6C7)),
                            SizedBox(height: 10),
                            Text('No transactions yet',
                                style: TextStyle(fontWeight: FontWeight.w700)),
                            SizedBox(height: 5),
                            Text(
                                'Tap Add Transaction to record your first entry.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color(0xFF8A93A5), fontSize: 12))
                          ]))
                    else
                      ..._items.map((item) => Padding(
                          padding: const EdgeInsets.only(bottom: 9),
                          child: TransactionTile(
                              item: item, onTap: () => _details(item)))),
                  ]),
            ),
    );
  }
}
