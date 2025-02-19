import 'dart:ui';
import 'package:flutter/material.dart';
import '/widgets/hud.dart';
import '/game/dino_run.dart';
import '/widgets/settings_menu.dart';

class MainMenu extends StatelessWidget {
  static const id = 'MainMenu';
  final DinoRun game;

  const MainMenu(this.game, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
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
                  const Text('Dino Run',
                      style: TextStyle(fontSize: 50, color: Colors.white)),
                  const SizedBox(height: 10),
                  _buildButton('Play', _startGame),
                  _buildButton('Settings', _openSettings),
                ],
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

  void _startGame() {
    game.startGamePlay();
    game.overlays.remove(MainMenu.id);
    game.overlays.add(Hud.id);
  }

  void _openSettings() {
    game.overlays.remove(MainMenu.id);
    game.overlays.add(SettingsMenu.id);
  }
}