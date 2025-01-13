import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/student.dart';
import '../models/group.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'scolarite.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE groups(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        libelle TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE students(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nom TEXT,
        prenom TEXT,
        dateNaiss TEXT,
        tel TEXT,
        photo TEXT,
        groupeld INTEGER
      )
    ''');
  }

  // Insert a student
  Future<int> insertStudent(Student student) async {
    final db = await database;
    final studentMap = student.toMap();
    studentMap.remove('id'); // Ensure 'id' is not included
    return await db.insert('students', studentMap);
  }

  // Update a student
  Future<int> updateStudent(Student student) async {
    final db = await database;
    return await db.update(
      'students',
      student.toMap(),
      where: 'id = ?',
      whereArgs: [student.id],
    );
  }

  // Get all students
  Future<List<Map<String, dynamic>>> getStudents() async {
    final db = await database;
    return await db.query('students');
  }

  // Delete a student
  Future<int> deleteStudent(int id) async {
    final db = await database;
    return await db.delete(
      'students',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Insert a group
  Future<int> insertGroup(Group group) async {
    final db = await database;
    return await db.insert('groups', group.toMap());
  }

  // Get all groups
  Future<List<Map<String, dynamic>>> getGroups() async {
    final db = await database;
    return await db.query('groups');
  }

  // Update a group
  Future<int> updateGroup(Group group) async {
    final db = await database;
    return await db.update(
      'groups',
      group.toMap(),
      where: 'id = ?',
      whereArgs: [group.id],
    );
  }

  // Delete a group
  Future<int> deleteGroup(int id) async {
    final db = await database;
    return await db.delete(
      'groups',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}