import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/widgets/hud.dart';
import '/game/dino_run.dart';
import '/widgets/main_menu.dart';
import '/models/player_data.dart';
import '/game/audio_manager.dart';

class GameOverMenu extends StatelessWidget {
  static const id = 'GameOverMenu';
  final DinoRun game;

  const GameOverMenu(this.game, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: game.playerData,
      child: Center(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: Colors.black.withAlpha(100),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 100),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('Game Over', style: TextStyle(fontSize: 40, color: Colors.white)),
                    Selector<PlayerData, int>(
                      selector: (_, playerData) => playerData.currentScore,
                      builder: (_, score, __) => Text('Your Score: $score', style: const TextStyle(fontSize: 40, color: Colors.white)),
                    ),
                    const SizedBox(height: 10),
                    _buildButton('Restart', _restartGame),
                    _buildButton('Exit', _exitGame),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text, style: const TextStyle(fontSize: 30)),
    );
  }

  void _restartGame() {
    game.overlays.remove(GameOverMenu.id);
    game.overlays.add(Hud.id);
    game.resumeEngine();
    game.reset();
    game.startGamePlay();
    AudioManager.instance.resumeBgm();
  }

  void _exitGame() {
    game.overlays.remove(GameOverMenu.id);
    game.overlays.add(MainMenu.id);
    game.resumeEngine();
    game.reset();
    AudioManager.instance.resumeBgm();
  }
}
