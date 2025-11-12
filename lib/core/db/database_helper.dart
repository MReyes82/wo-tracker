import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Initialize FFI for desktop platforms
    if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    String path = join(await getDatabasesPath(), 'wo_tracker.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Basic catalogs for exercises types, equipment types, and muscle groups
    await db.execute('''
      CREATE TABLE IF NOT EXISTS exercise_type (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS equipment_type (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS muscle_group (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      )
    ''');

    // Catalog of available (registered) exercises added by the user
    await db.execute('''
      CREATE TABLE IF NOT EXISTS exercise (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        exercise_type_id INTEGER NOT NULL,
        equipment_type_id INTEGER NOT NULL,
        muscle_group_id INTEGER NOT NULL,
        default_working_weight REAL,
        is_using_metric INTEGER NOT NULL DEFAULT 1,
        created_at TEXT,
        updated_at TEXT,
        FOREIGN KEY (exercise_type_id) REFERENCES exercise_type(id),
        FOREIGN KEY (equipment_type_id) REFERENCES equipment_type(id),
        FOREIGN KEY (muscle_group_id) REFERENCES muscle_group(id)
      )
    ''');

    // Catalog of workout types
    await db.execute('''
      CREATE TABLE IF NOT EXISTS workout_type (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      )
    ''');

    // WORKOUT TEMPLATES
    await db.execute('''
      CREATE TABLE IF NOT EXISTS workout_template (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        type_id INTEGER NOT NULL,
        created_at TEXT,
        updated_at TEXT,
        FOREIGN KEY (type_id) REFERENCES workout_type(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS template_exercise (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        template_id INTEGER NOT NULL,
        exercise_id INTEGER NOT NULL,
        position INTEGER DEFAULT 0,
        planned_sets INTEGER DEFAULT 0,
        FOREIGN KEY (template_id) REFERENCES workout_template(id) ON DELETE CASCADE,
        FOREIGN KEY (exercise_id) REFERENCES exercise(id)
      )
    ''');

    // Workout sessions
    await db.execute('''
      CREATE TABLE IF NOT EXISTS workout_session (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        template_id INTEGER,
        title TEXT,
        start_time TEXT NOT NULL,
        end_time TEXT,
        notes TEXT,
        created_at TEXT,
        FOREIGN KEY (template_id) REFERENCES workout_template(id) ON DELETE SET NULL
      )
    ''');

    // SNAPSHOT TABLE: exercise within a workout session
    await db.execute('''
      CREATE TABLE IF NOT EXISTS workout_exercise (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        session_id INTEGER NOT NULL,
        template_exercise_id INTEGER,
        exercise_id INTEGER,
        exercise_name TEXT NOT NULL,
        exercise_description TEXT,
        planned_sets INTEGER,
        position INTEGER,
        notes TEXT,
        FOREIGN KEY (session_id) REFERENCES workout_session(id) ON DELETE CASCADE,
        FOREIGN KEY (template_exercise_id) REFERENCES template_exercise(id) ON DELETE SET NULL,
        FOREIGN KEY (exercise_id) REFERENCES exercise(id)
      )
    ''');

    // Sets performed
    await db.execute('''
      CREATE TABLE IF NOT EXISTS workout_set (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        workout_exercise_id INTEGER NOT NULL,
        set_number INTEGER NOT NULL,
        reps INTEGER,
        weight REAL,
        effort_level INTEGER,
        effort_level_specifier TEXT,
        completed INTEGER DEFAULT 0,
        completed_at TEXT,
        notes TEXT,
        FOREIGN KEY (workout_exercise_id) REFERENCES workout_exercise(id) ON DELETE CASCADE,
        UNIQUE (workout_exercise_id, set_number)
      )
    ''');

    // Indexes
    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_template_exercise_template 
      ON template_exercise(template_id)
    ''');

    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_session_exercise_session 
      ON workout_exercise(session_id)
    ''');

    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_set_wex 
      ON workout_set(workout_exercise_id)
    ''');
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }

  /// Get the full path to the database file
  Future<String> getDatabasePath() async {
    return join(await getDatabasesPath(), 'wo_tracker.db');
  }

  /// Drop all tables in the database (for testing purposes)
  Future<void> dropAllTables() async {
    final db = await database;

    // Disable foreign keys temporarily to avoid constraint issues
    await db.execute('PRAGMA foreign_keys = OFF');

    // Drop all tables in reverse order of dependencies
    await db.execute('DROP TABLE IF EXISTS workout_set');
    await db.execute('DROP TABLE IF EXISTS workout_exercise');
    await db.execute('DROP TABLE IF EXISTS workout_session');
    await db.execute('DROP TABLE IF EXISTS template_exercise');
    await db.execute('DROP TABLE IF EXISTS workout_template');
    await db.execute('DROP TABLE IF EXISTS exercise');
    await db.execute('DROP TABLE IF EXISTS workout_type');
    await db.execute('DROP TABLE IF EXISTS muscle_group');
    await db.execute('DROP TABLE IF EXISTS equipment_type');
    await db.execute('DROP TABLE IF EXISTS exercise_type');

    // Drop indexes
    await db.execute('DROP INDEX IF EXISTS idx_template_exercise_template');
    await db.execute('DROP INDEX IF EXISTS idx_session_exercise_session');
    await db.execute('DROP INDEX IF EXISTS idx_set_wex');

    // Re-enable foreign keys
    await db.execute('PRAGMA foreign_keys = ON');

    print('✓ All tables dropped successfully');
  }

  /// Delete the entire database file and reset the instance
  /// Use this for complete cleanup between tests
  Future<void> deleteDatabase() async {
    await close();
    String path = await getDatabasePath();
    await databaseFactory.deleteDatabase(path);
    _database = null;
    print('✓ Database file deleted: $path');
  }

  /// Reset the database by dropping all tables and recreating them
  Future<void> resetDatabase() async {
    await dropAllTables();

    // Recreate all tables
    await _onCreate(await database, 1);

    print('✓ Database reset successfully');
  }
}

