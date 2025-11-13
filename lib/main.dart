import 'package:flutter/material.dart';
import 'app.dart';
import 'core/utils/test_data_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('=== Initializing app ===');

  // Seed test data for testing purposes
  try {
    print('Calling TestDataHelper.seedDatabase()...');
    await TestDataHelper.seedDatabase();
    print('TestDataHelper.seedDatabase() completed');
  } catch (e) {
    print('Failed to seed database: $e');
  }

  print('Starting app...');
  runApp(const WoTrackerApp());
}

