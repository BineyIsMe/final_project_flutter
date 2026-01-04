import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:myapp/data/database.dart';
import 'package:myapp/data/storage.dart';

class MockData {
  static final MockData _instance = MockData._internal();
  factory MockData() => _instance;
  MockData._internal();

  late AppDatabase _db;
  String? _dbPath;

  static get rooms => _instance._db.rooms;
  static get tenants => _instance._db.tenants;
  static get rentalServices => _instance._db.rentals;
  static get historyLogs => _instance._db.historyLogs;


  Future<void> init() async {
    final docsDir = await getApplicationDocumentsDirectory();
    _dbPath = p.join(docsDir.path, 'rental_app.json');

    _db = await loadOrCreateDatabase(_dbPath!);
  }

  Future<void> sync() async {
    if (_dbPath == null) return;
    await saveDatabaseFile(_db, _dbPath!);
  }
}