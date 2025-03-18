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
    if (!mounted) return;
    setState(() {
      _currency = prefs.getString('currency') ?? 'USD';
      _language = prefs.getString('language') ?? 'English';
      _isDarkMode = prefs.getBool('darkMode') ?? false;
      _isBiometricEnabled = prefs.getBool('biometric') ?? false;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currency', _currency);
    await prefs.setString('language', _language);
    await prefs.setBool('darkMode', _isDarkMode);
    await prefs.setBool('biometric', _isBiometricEnabled);
  }

  Future<void> _checkBiometrics() async {
    bool canCheckBiometrics = false;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } catch (e) {
      if (!mounted) return;
      _showErrorDialog('Failed to check biometrics.');
      return;
    }

    if (!canCheckBiometrics) {
      if (!mounted) return;
      setState(() {
        _isBiometricEnabled = false;
      });
      _saveSettings();
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings & Profile')),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 20),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            subtitle: Text('Manage your profile details'),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.monetization_on),
            title: Text('Currency'),
            subtitle: Text(_currency),
            onTap: () {
              _showCurrencyDialog();
            },
          ),
          ListTile(
            leading: Icon(Icons.language),
            title: Text('Language'),
            subtitle: Text(_language),
            onTap: () {
              _showLanguageDialog();
            },
          ),
          SwitchListTile(
            title: Text('Dark Mode'),
            secondary: Icon(Icons.dark_mode),
            value: _isDarkMode,
            onChanged: (bool value) {
              setState(() {
                _isDarkMode = value;
              });
              _saveSettings();
            },
          ),
          SwitchListTile(
            title: Text('Enable Biometrics'),
            secondary: Icon(Icons.fingerprint),
            value: _isBiometricEnabled,
            onChanged: (bool value) {
              setState(() {
                _isBiometricEnabled = value;
              });
              _saveSettings();
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.backup),
            title: Text('Backup Data'),
            onTap: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Backup initiated')));
            },
          ),
          ListTile(
            leading: Icon(Icons.restore),
            title: Text('Restore Data'),
            onTap: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Restore initiated')));
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _showCurrencyDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Currency'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children:
                ['USD', 'EUR', 'INR', 'BDT'].map((currency) {
                  return ListTile(
                    title: Text(currency),
                    onTap: () {
                      setState(() {
                        _currency = currency;
                      });
                      _saveSettings();
                      Navigator.of(context).pop();
                    },
                  );
                }).toList(),
          ),
        );
      },
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children:
                ['English', 'Spanish', 'French', 'German'].map((lang) {
                  return ListTile(
                    title: Text(lang),
                    onTap: () {
                      setState(() {
                        _language = lang;
                      });
                      _saveSettings();
                      Navigator.of(context).pop();
                    },
                  );
                }).toList(),
          ),
        );
      },
    );
  }
}
