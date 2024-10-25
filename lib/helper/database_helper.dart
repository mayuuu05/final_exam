
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/contact_model.dart';

class DatabaseHelper {
  static final DatabaseHelper databaseHelper = DatabaseHelper._();
  factory DatabaseHelper() => databaseHelper;

  DatabaseHelper._();

  static Database? db;

  Future<Database> get database async {
    if (db != null) return db!;
    db = await initDatabase();
    return db!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'contacts.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: onCreate,
    );
  }

  Future<void> onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE contacts(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, phoneNumber TEXT, email TEXT)',
    );
  }

  Future<int> insertContact(Contact contact) async {
    Database db = await database;
    return await db.insert('contacts', contact.toMap());
  }

  Future<List<Contact>> getContacts({String? query}) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps;
    if (query != null && query.isNotEmpty) {
      maps = await db.query(
        'contacts',
        where: 'name LIKE ?',
        whereArgs: ['%$query%'],
      );
    } else {
      maps = await db.query('contacts');
    }
    return List.generate(maps.length, (i) {
      return Contact(
        id: maps[i]['id'].toString(),
        name: maps[i]['name'],
        phoneNumber: maps[i]['phoneNumber'],
        email: maps[i]['email'],
      );
    });
  }

  Future<int> updateContact(Contact contact) async {
    Database db = await database;
    return await db.update(
      'contacts',
      contact.toMap(),
      where: 'id = ?',
      whereArgs: [contact.id],
    );
  }

  Future<void> deleteItem(int id) async {
    final db = await database;
    await db.delete('contacts', where: 'id = ?', whereArgs: [id]);
  }
}
