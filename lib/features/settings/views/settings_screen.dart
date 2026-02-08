import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wo_tracker/generated/l10n/app_localizations.dart';
import '../../../core/themes/app_colors.dart';
import '../view_models/settings_view_model.dart';
import '../models/language.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          l10n.settingsTitle,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: Consumer<SettingsViewModel>(
        builder: (context, viewModel, child) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                // Language Section
                _buildLanguageSection(context, viewModel, l10n),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLanguageSection(
    BuildContext context,
    SettingsViewModel viewModel,
    AppLocalizations l10n,
  ) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              l10n.language,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
                letterSpacing: 0.5,
              ),
            ),
          ),
          
          // Language Selector Button
          InkWell(
            onTap: () => _showLanguagePicker(context, viewModel),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.divider, width: 1),
                ),
              ),
              child: Row(
                children: [
                  // Flag emoji
                  Text(
                    viewModel.currentLanguage.flagEmoji,
                    style: const TextStyle(fontSize: 28),
                  ),
                  const SizedBox(width: 16),
                  
                  // Language name
                  Expanded(
                    child: Text(
                      viewModel.currentLanguage.nativeName,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  
                  // Arrow icon
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguagePicker(BuildContext context, SettingsViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Title
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                child: Text(
                  AppLocalizations.of(context)!.selectLanguage,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              
              // Language options
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: viewModel.supportedLanguages.length,
                itemBuilder: (context, index) {
                  final language = viewModel.supportedLanguages[index];
                  final isSelected = viewModel.currentLanguage == language;
                  
                  return InkWell(
                    onTap: () async {
                      await viewModel.changeLanguage(language);
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withValues(alpha: 0.05)
                            : Colors.transparent,
                      ),
                      child: Row(
                        children: [
                          // Flag emoji
                          Text(
                            language.flagEmoji,
                            style: const TextStyle(fontSize: 28),
                          ),
                          const SizedBox(width: 16),
                          
                          // Language name
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  language.nativeName,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.textPrimary,
                                  ),
                                ),
                                if (language.name != language.nativeName)
                                  Text(
                                    language.name,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          
                          // Checkmark for selected language
                          if (isSelected)
                            const Icon(
                              Icons.check_circle,
                              color: AppColors.primary,
                              size: 24,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
