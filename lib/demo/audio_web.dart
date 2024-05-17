import 'package:web/web.dart' as web;

import 'audio.dart';

class AudioPlayerImpl implements AudioPlayer {
  AudioPlayerImpl(this.src) : _audioElement = web.HTMLAudioElement()..src = src;

  final web.HTMLAudioElement _audioElement;
  final String src;

  @override
  Future<void> pause() async {
    _audioElement.pause();
  }

  @override
  Future<void> play() async {
    _audioElement.play();
  }

  @override
  Duration get position =>
      Duration(milliseconds: (_audioElement.currentTime * 1000).toInt());
}
