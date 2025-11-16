import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/themes/app_colors.dart';
import 'features/navigation/main_navigation.dart';
import 'features/home/view_models/home_view_model.dart';
import 'core/db/database_helper.dart';

class WoTrackerApp extends StatefulWidget {
  const WoTrackerApp({Key? key}) : super(key: key);

  @override
  State<WoTrackerApp> createState() => _WoTrackerAppState();
}

class _WoTrackerAppState extends State<WoTrackerApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // When app is detached (closed), delete and prepare database for next run
    if (state == AppLifecycleState.detached) {
      _cleanupDatabase();
    }
  }

  Future<void> _cleanupDatabase() async {
    try {
      print('=== App closing - cleaning up database ===');
      final dbHelper = DatabaseHelper();
      await dbHelper.deleteDatabase();
      print('✓ Database deleted - will be fresh on next startup');
    } catch (e) {
      print('Error cleaning up database: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        // Add more providers here as needed
      ],
      child: MaterialApp(
        title: 'WoTracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            primary: AppColors.primary,
          ),
          useMaterial3: true,
          scaffoldBackgroundColor: AppColors.background,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: AppColors.textPrimary),
            titleTextStyle: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        home: const MainNavigation(),
      ),
    );
  }
}

