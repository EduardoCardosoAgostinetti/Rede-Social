import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/services/language_services.dart';
import 'package:app/services/responsive_services.dart';

class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LanguageProvider>(context);
    final currentLocale = provider.locale.languageCode;
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(loc.language)),
      body: ResponsiveWrapper(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(loc.chooseLanguage, style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 24),
                _buildLanguageButton(
                  context,
                  'pt',
                  Icons.language,
                  currentLocale,
                  'Português',
                ),
                const SizedBox(height: 12),
                _buildLanguageButton(
                  context,
                  'en',
                  Icons.language,
                  currentLocale,
                  'English',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageButton(
    BuildContext context,
    String localeCode,
    IconData icon,
    String currentLocale,
    String label,
  ) {
    final isSelected = currentLocale == localeCode;
    final colorScheme = Theme.of(context).colorScheme;

    return ElevatedButton.icon(
      icon: Icon(icon, color: isSelected ? Colors.white : null),
      label: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: isSelected ? Colors.white : null,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onPressed: () {
        Provider.of<LanguageProvider>(
          context,
          listen: false,
        ).setLocale(Locale(localeCode));
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: isSelected ? colorScheme.primary : null,
        foregroundColor: isSelected ? colorScheme.onPrimary : null,
      ),
    );
  }
}
