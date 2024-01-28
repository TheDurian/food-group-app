import 'package:flutter/material.dart';
import 'package:food_group_app/src/config/globals.dart';
import 'package:food_group_app/src/utils/shared_prefs.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({
    super.key,
  });

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: CustomScrollView(
          slivers: [
            const SliverAppBar.large(
              title: Text('Settings'),
            ),
            SliverList.list(
              children: [
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Text(
                    'General',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.invert_colors),
                  title: const Text('Dark Mode:'),
                  value: SharedPrefs().isDarkMode,
                  onChanged: (value) {
                    setState(() => appTheme.switchTheme());
                  },
                ),
              ],
            ),
          ],
        ),
      );
}
