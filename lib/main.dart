import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ionicons/ionicons.dart';

import 'config/theme.dart';
import 'data/models/icon_info.dart';
import 'states/theme_mode_state.dart';
import 'ui/screens/home_screen.dart';

late Box<String> prefBox;
late Box<IconInfo> iconBox;

void main() async {
  /// Initialize packages
  WidgetsFlutterBinding.ensureInitialized();

  /// Init Hive
  await Hive.initFlutter();
  Hive.registerAdapter(IconInfoAdapter());
  prefBox = await Hive.openBox<String>('prefs');
  iconBox = await Hive.openBox<IconInfo>('icons');

  /// Create database entries for the current version
  if (prefBox.get('version') != 'v0.2.1' ||
      iconBox.length != ioniconsMapping.length) {
    await iconBox.clear();

    for (final MapEntry<String, String> element in ioniconsMapping.entries) {
      await iconBox.put(
          element.key,
          IconInfo(
            name: element.key,
            value: int.parse(element.value),
          ));
    }
    await prefBox.put('version', 'v0.2.1');
  }

  /// Init refresh rate
  if (Platform.isAndroid) {
    await FlutterDisplayMode.setHighRefreshRate();
  }

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeModeState currentTheme = ref.watch(themeProvider);

    return MaterialApp(
      title: 'flutter-ionicons v0.2.1',

      /// Theme stuff
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: currentTheme.themeMode,

      /// Misc
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
