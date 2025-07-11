import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/services/theme_mode_services.dart';
import 'package:app/services/responsive_services.dart';
import 'package:app/l10n/app_localizations.dart';

class ThemeModePage extends StatelessWidget {
  const ThemeModePage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final currentMode = themeProvider.themeMode;
    final loc = AppLocalizations.of(context)!; // instancia das traduções

    String getSelectedMode() {
      switch (currentMode) {
        case ThemeMode.light:
          return 'light';
        case ThemeMode.dark:
          return 'dark';
        case ThemeMode.system:
          return 'system';
      }
    }

    final selected = getSelectedMode();

    return Scaffold(
      appBar: AppBar(title: Text(loc.themeModeTitle)),
      body: ResponsiveWrapper(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(loc.chooseThemeMode, style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 24),
                _buildFullWidthButton(
                  context,
                  'light',
                  Icons.light_mode,
                  selected,
                  loc.light,
                ),
                const SizedBox(height: 12),
                _buildFullWidthButton(
                  context,
                  'dark',
                  Icons.dark_mode,
                  selected,
                  loc.dark,
                ),
                const SizedBox(height: 12),
                _buildFullWidthButton(
                  context,
                  'system',
                  Icons.settings,
                  selected,
                  loc.system,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFullWidthButton(
    BuildContext context,
    String mode,
    IconData icon,
    String selected,
    String label,
  ) {
    final isSelected = selected == mode;
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
        Provider.of<ThemeProvider>(context, listen: false).setThemeMode(mode);
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: isSelected ? colorScheme.primary : null,
        foregroundColor: isSelected ? colorScheme.onPrimary : null,
      ),
    );
  }
}
