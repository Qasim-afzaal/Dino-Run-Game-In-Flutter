import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/game/dino_run.dart';
import '/models/settings.dart';
import '/widgets/main_menu.dart';
import '/game/audio_manager.dart';

class SettingsMenu extends StatelessWidget {
  static const id = 'SettingsMenu';
  final DinoRun game;

  const SettingsMenu(this.game, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: game.settings,
      child: Center(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.8,
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              color: Colors.black.withAlpha(100),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 100),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSwitchTile('Music', (settings) => settings.bgm, _toggleBgm),
                    _buildSwitchTile('Effects', (settings) => settings.sfx, _toggleSfx),
                    _buildBackButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile(String title, bool Function(Settings) selector, Function(BuildContext, bool) onChanged) {
    return Selector<Settings, bool>(
      selector: (_, settings) => selector(settings),
      builder: (context, value, __) {
        return SwitchListTile(
          title: Text(title, style: const TextStyle(fontSize: 30, color: Colors.white)),
          value: value,
          onChanged: (bool newValue) => onChanged(context, newValue),
        );
      },
    );
  }

  void _toggleBgm(BuildContext context, bool value) {
    Provider.of<Settings>(context, listen: false).bgm = value;
    if (value) {
      AudioManager.instance.startBgm('8BitPlatformerLoop.wav');
    } else {
      AudioManager.instance.stopBgm();
    }
  }

  void _toggleSfx(BuildContext context, bool value) {
    Provider.of<Settings>(context, listen: false).sfx = value;
  }

  Widget _buildBackButton() {
    return TextButton(
      onPressed: _goBack,
      child: const Icon(Icons.arrow_back_ios_rounded),
    );
  }

  void _goBack() {
    game.overlays.remove(SettingsMenu.id);
    game.overlays.add(MainMenu.id);
  }
}