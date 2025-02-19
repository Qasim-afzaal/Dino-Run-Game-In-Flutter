# 🦖 Dino Run Game in Flutter

A simple and fun **Dino Run** game built using **Flutter** and the **Flame** game engine.

## 📸 Screenshots

## 🚀 Features
- 🏃 **Endless Runner Gameplay**
- 🎨 **Pixel Art & Parallax Scrolling**
- 🎶 **Sound Effects & Background Music**
- 🎯 **Score Tracking & High Scores (Hive Database)**
- ⚡ **Power-ups & Obstacles**

## 📦 Dependencies
This game uses the following Flutter packages:

```yaml
dependencies:
  flame: 1.18.0
  flame_audio: 2.10.2
  hive: 2.2.3
  path_provider: 2.1.3
  provider: 6.1.2
  flutter:
    sdk: flutter
```

## 🛠 Installation & Setup



2. **Install dependencies**
   ```sh
   flutter pub get
   ```

3. **Run the game**
   ```sh
   flutter run
   ```

## 🎮 How to Play
- **Tap** or **Press Space** to jump.
- **Avoid obstacles** (cactus, flying enemies).
- **Survive as long as possible** to score high.
- **Game Over** when you hit an obstacle.

## 🏗️ Project Structure
```
flutter_dino_run/
│── assets/            # Game assets (images, sounds, fonts)
│── lib/
|-- ├── models/    
│   ├── game/          # Game logic and components
│   ├── widgets/            # UI elements (menus, score, etc.)
│   ├── main.dart      # Main entry point
│── pubspec.yaml       # Project dependencies
│── README.md          # Project documentation
```

## 🤝 Contributing
1. **Fork** the repository.
2. **Create a new branch** (`feature-name`).
3. **Commit your changes** (`git commit -m 'Add new feature'`).
4. **Push to your branch** (`git push origin feature-name`).
5. **Create a Pull Request**.

## 📜 License
This project is licensed under the **MIT License**.

---

🎮 **Enjoy the game!** 🚀 Feel free to contribute and make it even better!
