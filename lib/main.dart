import 'package:flutter/material.dart';
import 'app.dart';
import 'core/utils/test_data_helper.dart';
import 'core/db/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('=== Initializing app ===');

  // For testing: Delete database on startup to ensure fresh data
  try {
    print('Deleting database for fresh start...');
    final dbHelper = DatabaseHelper();
    await dbHelper.deleteDatabase();
    print('✓ Database deleted');
  } catch (e) {
    print('Note: Could not delete database (may not exist yet): $e');
  }

  // Seed database with test data
  try {
    print('Seeding database...');
    await TestDataHelper.seedDatabase();
    print('Database ready');
  } catch (e) {
    print('Failed to seed database: $e');
  }

  print('Starting app...');
  runApp(const WoTrackerApp());
}

