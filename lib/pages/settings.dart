import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  String _currency = 'USD';
  String _language = 'English';
  bool _isDarkMode = false;
  bool _isBiometricEnabled = false;
  final LocalAuthentication auth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _checkBiometrics();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return; // Check if the widget is mounted
    setState(() {
      _currency = prefs.getString('currency') ?? 'USD';
      _language = prefs.getString('language') ?? 'English';
      _isDarkMode = prefs.getBool('darkMode') ?? false;
      _isBiometricEnabled = prefs.getBool('biometric') ?? false;
    });
    _updateTheme();
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currency', _currency);
    await prefs.setString('language', _language);
    await prefs.setBool('darkMode', _isDarkMode);
    await prefs.setBool('biometric', _isBiometricEnabled);
    _updateTheme();
  }

  void _updateTheme() {
    if (_isDarkMode) {
      ThemeData.dark();
    } else {
      ThemeData.light();
    }
  }

  Future<void> _checkBiometrics() async {
    bool canCheckBiometrics = false;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } catch (e) {
      if (!mounted) return; // Check if the widget is mounted
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to check biometrics.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return; // Return to avoid further execution if error occurs
    }

    if (!canCheckBiometrics) {
      if (!mounted) return; // Check if the widget is mounted
      setState(() {
        _isBiometricEnabled = false;
      });
      _saveSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings & Profile')),
      body: ListView(
        children: <Widget>[
          // ... (rest of your build method)
          ListTile(
            title: Text('Backup Data'),
            onTap: () {
              if (!mounted) return; // Check if the widget is mounted
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Backup initiated')));
            },
          ),
          ListTile(
            title: Text('Restore Data'),
            onTap: () {
              if (!mounted) return; // Check if the widget is mounted
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Restore initiated')));
            },
          ),
        ],
      ),
    );
  }
}
