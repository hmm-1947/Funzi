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
