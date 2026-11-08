import 'package:expense_tracker_app/models/transaction_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('transaction model maps database values correctly', () {
    final item = TransactionModel(
        id: 3,
        title: 'Lunch',
        amount: 120.5,
        category: 'Food',
        type: 'Expense',
        date: DateTime(2026, 11, 8));
    final restored = TransactionModel.fromMap(item.toMap());
    expect(restored.id, 3);
    expect(restored.title, 'Lunch');
    expect(restored.amount, 120.5);
    expect(restored.category, 'Food');
    expect(restored.type, 'Expense');
    expect(restored.date, item.date);
  });
}
