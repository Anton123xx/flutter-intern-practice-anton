import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false; // Example setting
  double _textSize = 16.0; // Example setting for text size
  // Saving a setting
  Future<void> _saveDarkModePreference(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', value);
  }

// Loading a setting
  Future<void> _loadDarkModePreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkMode = prefs.getBool('darkMode') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Settings"),
        ),
        body: ListView(
          children: <Widget>[
            SwitchListTile(
              title: Text("Dark Mode"),
              value: _darkMode,
              onChanged: (bool value) {
                setState(() {
                  //_darkMode = value;
                  _saveDarkModePreference(value);
                });
              },
            ),
            ListTile(
              title: Text("Text Size"),
              trailing: Text(_textSize.toString()),
            ),
            Slider(
              min: 10.0,
              max: 30.0,
              divisions: 20,
              label: _textSize.round().toString(),
              value: _textSize,
              onChanged: (double value) {
                setState(() {
                  _textSize = value;
                  // Implement functionality to change text size in your app.
                });
              },
            ),
            // Add more settings here
          ],
        ));
  }

// Call _loadDarkModePreference() in initState() to load the setting when the screen initializes.
}
