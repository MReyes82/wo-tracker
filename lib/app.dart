import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/themes/app_colors.dart';
import 'features/navigation/main_navigation.dart';
import 'features/home/view_models/home_view_model.dart';

class WoTrackerApp extends StatelessWidget {
  const WoTrackerApp({Key? key}) : super(key: key);

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

