import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '/game/enemy.dart';
import '/game/dino_run.dart';
import '/game/audio_manager.dart';
import '/models/player_data.dart';

/// Enum representing different animation states for [Dino].
enum DinoAnimationStates {
  idle,
  run,
  kick,
  hit,
  sprint,
}

class Dino extends SpriteAnimationGroupComponent<DinoAnimationStates>
    with CollisionCallbacks, HasGameReference<DinoRun> {
  static final _animationMap = {
    DinoAnimationStates.idle: _animationData(4, 0),
    DinoAnimationStates.run: _animationData(6, 4),
    DinoAnimationStates.kick: _animationData(4, 10),
    DinoAnimationStates.hit: _animationData(3, 14),
    DinoAnimationStates.sprint: _animationData(7, 17),
  };

  static SpriteAnimationData _animationData(int amount, int offset) {
    return SpriteAnimationData.sequenced(
      amount: amount,
      stepTime: 0.1,
      textureSize: Vector2.all(24),
      texturePosition: Vector2(offset * 24, 0),
    );
  }

  double yMax = 0.0;
  double speedY = 0.0;
  final Timer _hitTimer = Timer(1);
  static const double gravity = 800;
  final PlayerData playerData;
  bool isHit = false;

  Dino(Image image, this.playerData) : super.fromFrameData(image, _animationMap);

  @override
  void onMount() {
    _reset();
    add(RectangleHitbox.relative(Vector2(0.5, 0.7), parentSize: size, position: Vector2(size.x * 0.5, size.y * 0.3) / 2));
    yMax = y;
    _hitTimer.onTick = () {
      current = DinoAnimationStates.run;
      isHit = false;
    };
    super.onMount();
  }

  @override
  void update(double dt) {
    speedY += gravity * dt;
    y += speedY * dt;
    if (isOnGround) {
      y = yMax;
      speedY = 0.0;
      if (!isHit && current != DinoAnimationStates.run) {
        current = DinoAnimationStates.run;
      }
    }
    _hitTimer.update(dt);
    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Enemy && !isHit) {
      hit();
    }
    super.onCollision(intersectionPoints, other);
  }

  bool get isOnGround => (y >= yMax);

  void jump() {
    if (isOnGround) {
      speedY = -300;
      current = DinoAnimationStates.idle;
      AudioManager.instance.playSfx('jump14.wav');
    }
  }

  void hit() {
    isHit = true;
    AudioManager.instance.playSfx('hurt7.wav');
    current = DinoAnimationStates.hit;
    _hitTimer.start();
    playerData.lives -= 1;
  }

  void _reset() {
    if (isMounted) {
      removeFromParent();
    }
    anchor = Anchor.bottomLeft;
    position = Vector2(32, game.virtualSize.y - 22);
    size = Vector2.all(24);
    current = DinoAnimationStates.run;
    isHit = false;
    speedY = 0.0;
  }
}