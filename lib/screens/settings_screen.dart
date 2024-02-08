import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/Model/provider_model.dart';
import 'package:task_manager/controllers/settings_controller.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  Settings_Controller settings_controller = new Settings_Controller();


  bool _darkMode = false; // Example setting
  double _textSize = 16.0; // Example setting for text size
 



  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderModel>(
      builder:(context, providerInstance, child) => Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
        ),
        body: ListView(
          children: <Widget>[
            SwitchListTile(
              title: const Text("Dark Mode"),
              value: _darkMode,
              onChanged: (bool value) {
                setState(() {
                  //_darkMode = value;
                  //settings_controller._saveDarkModePreference(value);
                });
              },
            ),
            ListTile(
              title: const Text("Text Size"),
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
        )));
  }

// Call _loadDarkModePreference() in initState() to load the setting when the screen initializes.
}
