import '/models/settings.dart';
import 'package:flame/flame.dart';
import 'package:flame_audio/flame_audio.dart';

/// Manages the audio functionality for the game, interfacing with [Flame] engine.
class AudioManager {
  late Settings settings;
  
  AudioManager._internal();

  /// Singleton instance of [AudioManager].
  static final AudioManager _instance = AudioManager._internal();
  static AudioManager get instance => _instance;

  /// Initializes audio by preloading [files] and assigning game [settings].
  Future<void> init(List<String> files, Settings settings) async {
    this.settings = settings;
    FlameAudio.bgm.initialize();
    await FlameAudio.audioCache.loadAll(files);
  }

  /// Starts background music if enabled in settings.
  void startBgm(String fileName) {
    if (settings.bgm) {
      FlameAudio.bgm.play(fileName, volume: 0.4);
    }
  }

  /// Pauses background music if playing.
  void pauseBgm() {
    if (settings.bgm) {
      FlameAudio.bgm.pause();
    }
  }

  /// Resumes background music if it was paused.
  void resumeBgm() {
    if (settings.bgm) {
      FlameAudio.bgm.resume();
    }
  }

  /// Stops the currently playing background music.
  void stopBgm() {
    FlameAudio.bgm.stop();
  }

  /// Plays a sound effect if enabled in settings.
  void playSfx(String fileName) {
    if (settings.sfx) {
      FlameAudio.play(fileName);
    }
  }
}
