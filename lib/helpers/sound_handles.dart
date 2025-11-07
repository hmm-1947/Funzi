import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

final player = AudioPlayer();

Future<void> playCrossPlatformSound(String assetPath) async {
  await player.stop();

  if (Platform.isAndroid) {
    // Android handles AssetSource directly
    await player.play(AssetSource(assetPath.replaceFirst('assets/', '')));
    return;
  }

  // For Windows, Linux, macOS → copy to temp then play
  final byteData = await rootBundle.load(assetPath);
  final tempDir = await getTemporaryDirectory();
  final tempFile = File('${tempDir.path}/${assetPath.split('/').last}');
  await tempFile.writeAsBytes(byteData.buffer.asUint8List());
  await player.play(DeviceFileSource(tempFile.path));
}

class AppAudio {
  static final AudioPlayer _player = AudioPlayer();
  static final List<String> _preloadSounds = [
    'soundeffects/correct.mp3',
    'soundeffects/pluck.mp3',
    'soundeffects/won.mp3',
    'soundeffects/wrong.mp3',
  ];

  static Future<void> preload() async {
    // Load all 4 into memory
    for (final path in _preloadSounds) {
      await _player.setSource(AssetSource(path));
    }
  }

  static Future<void> play(String assetPath) async {
    await _player.stop();
    await _player.play(AssetSource(assetPath));
  }
}
