import 'package:expense_tracker_app/models/transaction_model.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();
  static const tableName = 'transactions';
  Database? _db;

  Future<Database> get database async => _db ??= await _open();

  Future<Database> _open() async {
    final dbPath = p.join(await getDatabasesPath(), 'expense_tracker.db');
    return openDatabase(dbPath, version: 1, onCreate: (db, version) async {
      await db.execute('''CREATE TABLE $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        amount REAL NOT NULL,
        category TEXT NOT NULL,
        type TEXT NOT NULL,
        date TEXT NOT NULL
      )''');
    });
  }

  Future<int> insert(TransactionModel item) async =>
      (await database).insert(tableName, item.toMap());

  Future<List<TransactionModel>> getAll() async {
    final rows =
        await (await database).query(tableName, orderBy: 'date DESC, id DESC');
    return rows.map(TransactionModel.fromMap).toList();
  }

  Future<int> update(TransactionModel item) async {
    final values = item.toMap()..remove('id');
    return (await database)
        .update(tableName, values, where: 'id = ?', whereArgs: [item.id]);
  }

  Future<int> delete(int id) async =>
      (await database).delete(tableName, where: 'id = ?', whereArgs: [id]);
}
