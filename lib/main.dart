import 'package:flame/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'widgets/hud.dart';
import 'game/dino_run.dart';
import 'models/settings.dart';
import 'widgets/main_menu.dart';
import 'models/player_data.dart';
import 'widgets/pause_menu.dart';
import 'widgets/settings_menu.dart';
import 'widgets/game_over_menu.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initHive();
  runApp(const DinoRunApp());
}

Future<void> _initHive() async {
  if (!kIsWeb) {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
  }
  
  Hive.registerAdapter(PlayerDataAdapter());
  Hive.registerAdapter(SettingsAdapter());
}

class DinoRunApp extends StatelessWidget {
  const DinoRunApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dino Run',
      theme: _buildThemeData(),
      home: Scaffold(
        body: _buildGameWidget(),
      ),
    );
  }

  ThemeData _buildThemeData() {
    return ThemeData(
      fontFamily: 'Audiowide',
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          fixedSize: const Size(200, 60),
        ),
      ),
    );
  }

  Widget _buildGameWidget() {
    return GameWidget<DinoRun>.controlled(
      loadingBuilder: (context) => const Center(
        child: SizedBox(
          width: 200,
          child: LinearProgressIndicator(),
        ),
      ),
      overlayBuilderMap: {
        MainMenu.id: (_, game) => MainMenu(game),
        PauseMenu.id: (_, game) => PauseMenu(game),
        Hud.id: (_, game) => Hud(game),
        GameOverMenu.id: (_, game) => GameOverMenu(game),
        SettingsMenu.id: (_, game) => SettingsMenu(game),
      },
      initialActiveOverlays: const [MainMenu.id],
      gameFactory: () => DinoRun(
        camera: CameraComponent.withFixedResolution(
          width: 360,
          height: 180,
        ),
      ),
    );
  }
}
