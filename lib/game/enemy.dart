import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '/game/dino_run.dart';
import '/models/enemy_data.dart';

/// Represents an enemy in the game world.
class Enemy extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameReference<DinoRun> {
  final EnemyData enemyData;

  Enemy(this.enemyData) {
    animation = SpriteAnimation.fromFrameData(
      enemyData.image,
      SpriteAnimationData.sequenced(
        amount: enemyData.nFrames,
        stepTime: enemyData.stepTime,
        textureSize: enemyData.textureSize,
      ),
    );
  }

  @override
  void onMount() {
    _initializeEnemy();
    super.onMount();
  }

  void _initializeEnemy() {
    size *= 0.6;
    add(
      RectangleHitbox.relative(
        Vector2.all(0.8),
        parentSize: size,
        position: Vector2(size.x * 0.2, size.y * 0.2) / 2,
      ),
    );
  }

  @override
  void update(double dt) {
    _moveEnemy(dt);
    super.update(dt);
  }

  void _moveEnemy(double dt) {
    position.x -= enemyData.speedX * dt;
    if (position.x < -enemyData.textureSize.x) {
      removeFromParent();
      game.playerData.currentScore += 1;
    }
  }
}