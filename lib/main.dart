import 'package:flutter/material.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('=== Initializing app ===');
  print('Starting app...');

  runApp(const WoTrackerApp());
}

