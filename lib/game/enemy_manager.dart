import 'dart:math';
import 'package:flame/components.dart';
import '/game/enemy.dart';
import '/game/dino_run.dart';
import '/models/enemy_data.dart';

class EnemyManager extends Component with HasGameReference<DinoRun> {
  final List<EnemyData> _data = [];
  final Random _random = Random();
  final Timer _timer = Timer(2, repeat: true);

  EnemyManager() {
    _timer.onTick = _spawnRandomEnemy;
  }

  void _spawnRandomEnemy() {
    if (_data.isEmpty) return;
    final enemyData = _data[_random.nextInt(_data.length)];
    final enemy = Enemy(enemyData)
      ..anchor = Anchor.bottomLeft
      ..position = Vector2(game.virtualSize.x + 32, game.virtualSize.y - 24)
      ..size = enemyData.textureSize;
    
    if (enemyData.canFly) {
      enemy.position.y -= _random.nextDouble() * 2 * enemyData.textureSize.y;
    }
    game.world.add(enemy);
  }

  @override
  void onMount() {
    if (isMounted) removeFromParent();
    if (_data.isEmpty) _initializeEnemyData();
    _timer.start();
    super.onMount();
  }

  void _initializeEnemyData() {
    _data.addAll([
      EnemyData(
        image: game.images.fromCache('AngryPig/Walk (36x30).png'),
        nFrames: 16,
        stepTime: 0.1,
        textureSize: Vector2(36, 30),
        speedX: 80,
        canFly: false,
      ),
      EnemyData(
        image: game.images.fromCache('Bat/Flying (46x30).png'),
        nFrames: 7,
        stepTime: 0.1,
        textureSize: Vector2(46, 30),
        speedX: 100,
        canFly: true,
      ),
      EnemyData(
        image: game.images.fromCache('Rino/Run (52x34).png'),
        nFrames: 6,
        stepTime: 0.09,
        textureSize: Vector2(52, 34),
        speedX: 150,
        canFly: false,
      ),
    ]);
  }

  @override
  void update(double dt) {
    _timer.update(dt);
    super.update(dt);
  }

  void removeAllEnemies() {
    for (var enemy in game.world.children.whereType<Enemy>()) {
      enemy.removeFromParent();
    }
  }
}