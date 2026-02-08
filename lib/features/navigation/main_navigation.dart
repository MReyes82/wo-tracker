import 'package:flutter/material.dart';
import 'package:wo_tracker/generated/l10n/app_localizations.dart';
import '../../core/themes/app_colors.dart';
import '../home/views/home_screen.dart';
import '../settings/views/settings_screen.dart';
import '../register/views/register_new_screen.dart';
import '../history/views/records_screen.dart';

// Global key to access MainNavigation state from anywhere
final GlobalKey<_MainNavigationState> mainNavigationKey = GlobalKey<_MainNavigationState>();

class MainNavigation extends StatefulWidget {
  const MainNavigation({Key? key}) : super(key: key);

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  // Method to switch tabs from external widgets
  void switchTab(int index) {
    if (index >= 0 && index < 4) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  Widget _getScreen(int index) {
    switch (index) {
      case 0:
        return const HomeScreen();
      case 1:
        return const RegisterNewScreen();
      case 2:
        return RecordsScreen(key: ValueKey('records-$index'));
      case 3:
        return const SettingsScreen();
      default:
        return const HomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      body: _getScreen(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: l10n.navHome,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.add_circle_outline),
            label: l10n.navRegister,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.view_list),
            label: l10n.navHistory,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: l10n.navSettings,
          ),
        ],
      ),
    );
  }
}

