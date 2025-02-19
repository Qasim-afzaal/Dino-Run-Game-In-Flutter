import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/widgets/hud.dart';
import '/game/dino_run.dart';
import '/widgets/main_menu.dart';
import '/game/audio_manager.dart';
import '/models/player_data.dart';

class PauseMenu extends StatelessWidget {
  static const id = 'PauseMenu';
  final DinoRun game;

  const PauseMenu(this.game, {super.key});

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
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Selector<PlayerData, int>(
                        selector: (_, playerData) => playerData.currentScore,
                        builder: (_, score, __) => Text('Score: $score',
                            style: const TextStyle(fontSize: 40, color: Colors.white)),
                      ),
                    ),
                    _buildButton('Resume', _resumeGame),
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

  void _resumeGame() {
    game.overlays.remove(PauseMenu.id);
    game.overlays.add(Hud.id);
    game.resumeEngine();
    AudioManager.instance.resumeBgm();
  }

  void _restartGame() {
    game.overlays.remove(PauseMenu.id);
    game.overlays.add(Hud.id);
    game.resumeEngine();
    game.reset();
    game.startGamePlay();
    AudioManager.instance.resumeBgm();
  }

  void _exitGame() {
    game.overlays.remove(PauseMenu.id);
    game.overlays.add(MainMenu.id);
    game.resumeEngine();
    game.reset();
    AudioManager.instance.resumeBgm();
  }
}