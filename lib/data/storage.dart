import 'dart:io';
import 'dart:convert';
import 'package:myapp/data/database.dart';


Future<void> saveDatabaseFile(AppDatabase db, String filePath) async {
  final file = File(filePath);

  const encoder = JsonEncoder.withIndent('  ');
  final jsonString = encoder.convert(db.toJson());
  
  await file.writeAsString(jsonString);
  print(' Database saved to: $filePath');
}


Future<AppDatabase> loadOrCreateDatabase(String filePath) async {
  final file = File(filePath);

  if (await file.exists()) {
    try {
      final content = await file.readAsString();

      if (content.trim().isEmpty) {
        print(' Database file empty. Creating defaults.');
        final defaultDB = AppDatabase.empty();
        await saveDatabaseFile(defaultDB, filePath);
        return defaultDB;
      }

      final jsonData = jsonDecode(content);
      print(' Database loaded successfully from: $filePath');
      return AppDatabase.fromJson(jsonData);

    } catch (e) {
      print(' Error parsing database: $e');
      print('Creating new empty database (Backup logic suggested in production).');
      final defaultDB = AppDatabase.empty();
      await saveDatabaseFile(defaultDB, filePath);
      return defaultDB;
    }
  } else {

    await file.create(recursive: true);
    final defaultDB = AppDatabase.empty();
    await saveDatabaseFile(defaultDB, filePath);
    print(' Created new database file at: $filePath');
    return defaultDB;
  }
}