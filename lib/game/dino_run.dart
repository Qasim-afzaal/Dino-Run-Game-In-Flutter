import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:hive/hive.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';

import '/game/dino.dart';
import '/widgets/hud.dart';
import '/models/settings.dart';
import '/game/audio_manager.dart';
import '/game/enemy_manager.dart';
import '/models/player_data.dart';
import '/widgets/pause_menu.dart';
import '/widgets/game_over_menu.dart';

class DinoRun extends FlameGame with TapDetector, HasCollisionDetection {
  DinoRun({super.camera});

  static const _imageAssets = [
    'DinoSprites - tard.png',
    'AngryPig/Walk (36x30).png',
    'Bat/Flying (46x30).png',
    'Rino/Run (52x34).png',
    'parallax/plx-1.png',
    'parallax/plx-2.png',
    'parallax/plx-3.png',
    'parallax/plx-4.png',
    'parallax/plx-5.png',
    'parallax/plx-6.png',
  ];

  static const _audioAssets = [
    '8BitPlatformerLoop.wav',
    'hurt7.wav',
    'jump14.wav',
  ];

  late Dino _dino;
  late Settings settings;
  late PlayerData playerData;
  late EnemyManager _enemyManager;

  Vector2 get virtualSize => camera.viewport.virtualSize;

  @override
  Future<void> onLoad() async {
    await _initializeGame();
  }

  Future<void> _initializeGame() async {
    await Flame.device.fullScreen();
    await Flame.device.setLandscape();
    playerData = await _readPlayerData();
    settings = await _readSettings();
    await AudioManager.instance.init(_audioAssets, settings);
    AudioManager.instance.startBgm('8BitPlatformerLoop.wav');
    await images.loadAll(_imageAssets);
    camera.viewfinder.position = camera.viewport.virtualSize * 0.5;
    _addParallaxBackground();
  }

  Future<void> _addParallaxBackground() async {
    final parallaxBackground = await loadParallaxComponent(
      [
        for (int i = 1; i <= 6; i++) ParallaxImageData('parallax/plx-\$i.png')
      ],
      baseVelocity: Vector2(10, 0),
      velocityMultiplierDelta: Vector2(1.4, 0),
    );
    camera.backdrop.add(parallaxBackground);
  }

  void startGamePlay() {
    _dino = Dino(images.fromCache('DinoSprites - tard.png'), playerData);
    _enemyManager = EnemyManager();
    world.addAll([_dino, _enemyManager]);
  }

  void _disconnectActors() {
    _dino.removeFromParent();
    _enemyManager.removeAllEnemies();
    _enemyManager.removeFromParent();
  }

  void reset() {
    _disconnectActors();
    playerData.currentScore = 0;
    playerData.lives = 5;
  }

  @override
  void update(double dt) {
    if (playerData.lives <= 0) {
      overlays.add(GameOverMenu.id);
      overlays.remove(Hud.id);
      pauseEngine();
      AudioManager.instance.pauseBgm();
    }
    super.update(dt);
  }

  @override
  void onTapDown(TapDownInfo info) {
    if (overlays.isActive(Hud.id)) {
      _dino.jump();
    }
    super.onTapDown(info);
  }

  Future<PlayerData> _readPlayerData() async {
    final box = await Hive.openBox<PlayerData>('DinoRun.PlayerDataBox');
    return box.get('DinoRun.PlayerData') ?? PlayerData();
  }

  Future<Settings> _readSettings() async {
    final box = await Hive.openBox<Settings>('DinoRun.SettingsBox');
    return box.get('DinoRun.Settings') ?? Settings(bgm: true, sfx: true);
  }

  @override
  void lifecycleStateChange(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      if (overlays.isActive(Hud.id)) {
        overlays.remove(Hud.id);
        overlays.add(PauseMenu.id);
      }
      pauseEngine();
    } else if (state == AppLifecycleState.resumed && 
               !overlays.isActive(PauseMenu.id) && 
               !overlays.isActive(GameOverMenu.id)) {
      resumeEngine();
    }
    super.lifecycleStateChange(state);
  }
}