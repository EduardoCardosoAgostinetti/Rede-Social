import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/l10n/app_localizations.dart';

class ResponsivenessPage extends StatefulWidget {
  const ResponsivenessPage({super.key});

  @override
  State<ResponsivenessPage> createState() => _ResponsivenessPageState();
}

class _ResponsivenessPageState extends State<ResponsivenessPage> {
  String _selected = 'auto';

  final Map<String, double> maxWidths = {
    'auto': double.infinity,
    'mobile': 600,
    'tablet': 800,
    'desktop': 1200,
  };

  void _changeLayout(String type) async {
    setState(() => _selected = type);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('responsivenessMode', type);
  }

  @override
  void initState() {
    super.initState();
    _loadSelectedLayout();
  }

  void _loadSelectedLayout() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString('responsivenessMode') ?? 'auto';
    setState(() => _selected = value);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    double appliedMaxWidth = maxWidths[_selected]!;

    String _getLabel(String key) {
      switch (key) {
        case 'auto':
          return loc.auto;
        case 'mobile':
          return loc.mobile;
        case 'tablet':
          return loc.tablet;
        case 'desktop':
          return loc.desktop;
        default:
          return key.toUpperCase();
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(loc.selectLayoutTitle)),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: appliedMaxWidth),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  loc.chooseLayoutMode,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 24),
                _buildFullWidthButton(
                  'auto',
                  Icons.settings,
                  _getLabel('auto'),
                ),
                const SizedBox(height: 12),
                _buildFullWidthButton(
                  'mobile',
                  Icons.smartphone,
                  _getLabel('mobile'),
                ),
                const SizedBox(height: 12),
                _buildFullWidthButton(
                  'tablet',
                  Icons.tablet,
                  _getLabel('tablet'),
                ),
                const SizedBox(height: 12),
                _buildFullWidthButton(
                  'desktop',
                  Icons.desktop_windows,
                  _getLabel('desktop'),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFullWidthButton(String type, IconData icon, String label) {
    final isSelected = _selected == type;
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(icon),
        label: Text(label),
        onPressed: () => _changeLayout(type),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: isSelected ? colorScheme.primary : null,
          foregroundColor: isSelected ? colorScheme.onPrimary : null,
        ),
      ),
    );
  }
}
