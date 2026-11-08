import 'package:expense_tracker_app/database/database_helper.dart';
import 'package:expense_tracker_app/models/transaction_model.dart';
import 'package:expense_tracker_app/utils/app_formatters.dart';
import 'package:flutter/material.dart';

class AddEditTransactionScreen extends StatefulWidget {
  const AddEditTransactionScreen({super.key, this.transaction});
  final TransactionModel? transaction;
  @override
  State<AddEditTransactionScreen> createState() =>
      _AddEditTransactionScreenState();
}

class _AddEditTransactionScreenState extends State<AddEditTransactionScreen> {
  static const categories = [
    'Food',
    'Transport',
    'Shopping',
    'Bills',
    'Health',
    'Education',
    'Salary',
    'Business',
    'Entertainment',
    'Other'
  ];
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _amount = TextEditingController();
  String? _category;
  String? _type;
  DateTime _date = DateTime.now();
  bool _saving = false;
  bool get _editing => widget.transaction != null;

  @override
  void initState() {
    super.initState();
    final item = widget.transaction;
    if (item != null) {
      _title.text = item.title;
      _amount.text = item.amount.toString();
      _category = item.category;
      _type = item.type;
      _date = item.date;
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _amount.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (date != null) setState(() => _date = date);
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final item = TransactionModel(
        id: widget.transaction?.id,
        title: _title.text.trim(),
        amount: double.parse(_amount.text.trim()),
        category: _category!,
        type: _type!,
        date: _date);
    try {
      if (_editing) {
        await DatabaseHelper.instance.update(item);
      } else {
        await DatabaseHelper.instance.insert(item);
      }
      if (mounted) Navigator.pop(context, true);
    } catch (error) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unable to save transaction: $error')));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
            title: Text(_editing ? 'Edit Transaction' : 'Add Transaction')),
        body: Form(
            key: _formKey,
            child: ListView(padding: const EdgeInsets.all(20), children: [
              const Text('Transaction information',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF202A40))),
              const SizedBox(height: 7),
              const Text('Enter the details for this transaction.',
                  style: TextStyle(color: Color(0xFF8791A4))),
              const SizedBox(height: 23),
              TextFormField(
                  controller: _title,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                      labelText: 'Title',
                      hintText: 'e.g. Monthly salary',
                      prefixIcon: Icon(Icons.edit_note_rounded)),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Title cannot be empty.'
                      : null),
              const SizedBox(height: 15),
              TextFormField(
                  controller: _amount,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                      labelText: 'Amount',
                      hintText: '0.00',
                      prefixIcon: Icon(Icons.payments_outlined),
                      prefixText: '৳ '),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty)
                      return 'Please enter an amount.';
                    final n = double.tryParse(v.trim());
                    if (n == null || !n.isFinite)
                      return 'Enter a valid number.';
                    if (n <= 0) return 'Amount must be greater than zero.';
                    return null;
                  }),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                  value: _category,
                  isExpanded: true,
                  decoration: const InputDecoration(
                      labelText: 'Category',
                      prefixIcon: Icon(Icons.category_outlined)),
                  hint: const Text('Select a category'),
                  items: categories
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) => setState(() => _category = v),
                  validator: (v) =>
                      v == null ? 'Please select a category.' : null),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                  value: _type,
                  decoration: const InputDecoration(
                      labelText: 'Transaction Type',
                      prefixIcon: Icon(Icons.swap_vert_rounded)),
                  hint: const Text('Select income or expense'),
                  items: const [
                    DropdownMenuItem(value: 'Income', child: Text('Income')),
                    DropdownMenuItem(value: 'Expense', child: Text('Expense'))
                  ],
                  onChanged: (v) => setState(() => _type = v),
                  validator: (v) =>
                      v == null ? 'Please select a transaction type.' : null),
              const SizedBox(height: 15),
              InkWell(
                  onTap: _pickDate,
                  borderRadius: BorderRadius.circular(14),
                  child: InputDecorator(
                      decoration: const InputDecoration(
                          labelText: 'Date',
                          prefixIcon: Icon(Icons.calendar_month_rounded),
                          suffixIcon: Icon(Icons.keyboard_arrow_down_rounded)),
                      child: Text(shortDate.format(_date)))),
              const SizedBox(height: 27),
              SizedBox(
                  height: 53,
                  child: FilledButton(
                      onPressed: _saving ? null : _save,
                      style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF3157D5),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14))),
                      child: _saving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white))
                          : Text(
                              _editing
                                  ? 'Update Transaction'
                                  : 'Save Transaction',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700)))),
            ])),
      );
}
