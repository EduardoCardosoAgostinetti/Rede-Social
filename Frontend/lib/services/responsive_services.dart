import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart'; // 👈 Importa onde está o routeObserver

class ResponsiveWrapper extends StatefulWidget {
  final Widget child;

  const ResponsiveWrapper({super.key, required this.child});

  @override
  State<ResponsiveWrapper> createState() => _ResponsiveWrapperState();
}

class _ResponsiveWrapperState extends State<ResponsiveWrapper> with RouteAware {
  String _selected = 'auto';

  final Map<String, double> maxWidths = {
    'auto': double.infinity,
    'mobile': 600,
    'tablet': 800,
    'desktop': 1200,
  };

  @override
  void initState() {
    super.initState();
    _loadSelectedLayout();
  }

  Future<void> _loadSelectedLayout() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString('responsivenessMode') ?? 'auto';
    setState(() => _selected = value);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ModalRoute? route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // Voltou para essa página
    _loadSelectedLayout();
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = maxWidths[_selected] ?? double.infinity;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: widget.child,
      ),
    );
  }
}
