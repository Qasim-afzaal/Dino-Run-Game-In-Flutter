import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/game/dino_run.dart';
import '/game/audio_manager.dart';
import '/models/player_data.dart';
import '/widgets/pause_menu.dart';

class Hud extends StatelessWidget {
  static const id = 'Hud';
  final DinoRun game;

  const Hud(this.game, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: game.playerData,
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildScoreSection(),
            _buildPauseButton(),
            _buildLivesIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreSection() {
    return Column(
      children: [
        Selector<PlayerData, int>(
          selector: (_, playerData) => playerData.currentScore,
          builder: (_, score, __) => Text('Score: $score',
              style: const TextStyle(fontSize: 20, color: Colors.white)),
        ),
        Selector<PlayerData, int>(
          selector: (_, playerData) => playerData.highScore,
          builder: (_, highScore, __) => Text('High: $highScore',
              style: const TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildPauseButton() {
    return TextButton(
      onPressed: _pauseGame,
      child: const Icon(Icons.pause, color: Colors.white),
    );
  }

  Widget _buildLivesIndicator() {
    return Selector<PlayerData, int>(
      selector: (_, playerData) => playerData.lives,
      builder: (_, lives, __) => Row(
        children: List.generate(5, (index) => Icon(
              index < lives ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            )),
      ),
    );
  }

  void _pauseGame() {
    game.overlays.remove(Hud.id);
    game.overlays.add(PauseMenu.id);
    game.pauseEngine();
    AudioManager.instance.pauseBgm();
  }
}