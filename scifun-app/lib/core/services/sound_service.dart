import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

enum SoundLoopTrack { gameBackground }

extension SoundLoopTrackAsset on SoundLoopTrack {
  String get fileName {
    switch (this) {
      case SoundLoopTrack.gameBackground:
        return 'bgm.mp3';
    }
  }
}

enum SoundEffectTrack {
  luyenTap1ChamClick,
  luyenTap1Dragged,
  luyenTap1CoiTauLua,
  luyenTap1Ting,
  luyenTap2Cloud,
  luyenTap5TiengBatLua,
  danhGiaTongKetDiem,
  danhGiaTe,
  danhGiaTrungBinh,
  danhGiaTot,
  cacsotu101110ChamKeo,
  drag,
  error,
  hover,
  success,
  wrong,
  saiNhe,
  ting,
  khoiDong1DragToBlank,
  khoiDong1Correct,
  khoiDong1Wrong,
}

extension SoundEffectTrackAsset on SoundEffectTrack {
  String get fileName {
    switch (this) {
      case SoundEffectTrack.luyenTap1ChamClick:
        return 'cham_click.mp3';
      case SoundEffectTrack.luyenTap1Dragged:
        return 'luyentap1/dragged.mp3';
      case SoundEffectTrack.luyenTap1CoiTauLua:
        return 'luyentap1/coitaulua.mp3';
      case SoundEffectTrack.luyenTap1Ting:
        return 'luyentap1/ting.mp3';
      case SoundEffectTrack.luyenTap2Cloud:
        return 'luyen_tap_2/cloud.mp3';
      case SoundEffectTrack.luyenTap5TiengBatLua:
        return 'luyentap5/tieng_bat_lua.mp3';
      case SoundEffectTrack.danhGiaTongKetDiem:
        return 'danhgia/soundtongketdiem.mp3';
      case SoundEffectTrack.danhGiaTe:
        return 'danhgia/sounddanhgiate.mp3';
      case SoundEffectTrack.danhGiaTrungBinh:
        return 'danhgia/sounddanhgiatrungbinh.mp3';
      case SoundEffectTrack.danhGiaTot:
        return 'danhgia/danhgia5.mp3';
      case SoundEffectTrack.cacsotu101110ChamKeo:
        return 'cacsotu101-110/cham-keo.mp3';
      case SoundEffectTrack.drag:
        return 'drag.mp3';
      case SoundEffectTrack.error:
        return 'error.mp3';
      case SoundEffectTrack.hover:
        return 'hover.mp3';
      case SoundEffectTrack.success:
        return 'success.mp3';
      case SoundEffectTrack.wrong:
        return 'wrong.mp3';
      case SoundEffectTrack.saiNhe:
        return 'sai_nhe.mp3';
      case SoundEffectTrack.ting:
        return 'ting.mp3';
      case SoundEffectTrack.khoiDong1DragToBlank:
        return 'khoidong1/keo_vao_o_trong.mp3';
      case SoundEffectTrack.khoiDong1Correct:
        return 'khoidong1/correct.mp3';
      case SoundEffectTrack.khoiDong1Wrong:
        return 'khoidong1/sai_nhe.mp3';
    }
  }
}

class SoundService {
  SoundService._internal();
  static final SoundService instance = SoundService._internal();

  static const String _assetPrefix = 'assets/sounds/';
  static const double _defaultLoopVolume = 0.6;
  static const double _defaultEffectVolume = 0.4;
  static const Set<SoundEffectTrack> _eagerPreloadEffects = {
    SoundEffectTrack.luyenTap1Dragged,
    SoundEffectTrack.luyenTap1CoiTauLua,
    SoundEffectTrack.luyenTap1ChamClick,
    SoundEffectTrack.luyenTap5TiengBatLua,
    SoundEffectTrack.danhGiaTongKetDiem,
    SoundEffectTrack.danhGiaTe,
    SoundEffectTrack.danhGiaTrungBinh,
    SoundEffectTrack.danhGiaTot,
    SoundEffectTrack.cacsotu101110ChamKeo,
    SoundEffectTrack.success,
    SoundEffectTrack.wrong,
    SoundEffectTrack.saiNhe,
  };

  final AudioPlayer _loopPlayer = AudioPlayer(
    handleInterruptions: false,
    handleAudioSessionActivation: false,
    androidApplyAudioAttributes: false,
  );
  final Map<SoundEffectTrack, AudioPlayer> _effectPlayers =
      <SoundEffectTrack, AudioPlayer>{};
  final Map<SoundEffectTrack, bool> _effectPrepared =
      <SoundEffectTrack, bool>{};

  bool _isInitialized = false;
  bool _isLoopEnabled = true;
  bool _isEffectEnabled = true;
  bool _hasUserGesture = !kIsWeb;
  bool _didWarmUpEffects = false;
  bool _pendingLoopStartAfterGesture = false;
  double _loopVolume = _defaultLoopVolume;
  double _effectVolume = _defaultEffectVolume;
  SoundLoopTrack? _currentLoopTrack;
  SoundLoopTrack? _loadedLoopTrack;

  bool get isLoopEnabled => _isLoopEnabled;
  bool get isEffectEnabled => _isEffectEnabled;
  double get loopVolume => _loopVolume;
  double get effectVolume => _effectVolume;
  SoundLoopTrack? get currentLoopTrack => _currentLoopTrack;

  Future<void> init() async {
    if (_isInitialized) return;

    await _loopPlayer.setLoopMode(LoopMode.one);
    await _loopPlayer.setVolume(_loopVolume);

    _isInitialized = true;
  }

  Future<void> registerUserGesture() async {
    if (_hasUserGesture) return;
    _hasUserGesture = true;
    await _ensureInitialized();
    await _warmUpEffectsIfNeeded();

    if (!_pendingLoopStartAfterGesture) return;
    if (!_isLoopEnabled || _currentLoopTrack == null) return;

    _pendingLoopStartAfterGesture = false;
    await _startLoopPlayback();
  }

  Future<void> playLoop(
    SoundLoopTrack track, {
    bool forceRestart = false,
    double? volume,
  }) async {
    await _ensureInitialized();

    final previousTrack = _currentLoopTrack;
    _currentLoopTrack = track;

    if (volume != null) {
      await setLoopVolume(volume);
    }

    if (!_isLoopEnabled) return;
    if (kIsWeb && !_hasUserGesture) {
      _pendingLoopStartAfterGesture = true;
      return;
    }
    _pendingLoopStartAfterGesture = false;

    final isSameTrack = previousTrack == track;
    if (!forceRestart && isSameTrack && _loopPlayer.playing) {
      return;
    }

    await _prepareLoopSource(track, forceReload: forceRestart || !isSameTrack);
    if (forceRestart ||
        _loopPlayer.processingState == ProcessingState.completed) {
      await _loopPlayer.seek(Duration.zero);
    }
    _startPlayer(_loopPlayer);
  }

  Future<void> pauseLoop() async {
    if (!_isInitialized) return;
    await _loopPlayer.pause();
  }

  Future<void> resumeLoop() async {
    await _ensureInitialized();
    if (!_isLoopEnabled || _currentLoopTrack == null) return;
    if (kIsWeb && !_hasUserGesture) {
      _pendingLoopStartAfterGesture = true;
      return;
    }
    _pendingLoopStartAfterGesture = false;
    await _startLoopPlayback();
  }

  Future<void> stopLoop({bool clearCurrentTrack = true}) async {
    if (!_isInitialized) return;

    if (clearCurrentTrack) {
      await _loopPlayer.stop();
      _loadedLoopTrack = null;
      _currentLoopTrack = null;
    } else {
      await _loopPlayer.pause();
      if (_loopPlayer.processingState != ProcessingState.idle) {
        await _loopPlayer.seek(Duration.zero);
      }
    }

    _pendingLoopStartAfterGesture = false;
  }

  Future<void> setLoopEnabled(bool enabled) async {
    _isLoopEnabled = enabled;
    if (!_isInitialized) return;

    if (!enabled) {
      _pendingLoopStartAfterGesture = false;
      await _loopPlayer.pause();
      return;
    }

    await resumeLoop();
  }

  Future<void> setLoopVolume(double value) async {
    _loopVolume = _normalizeVolume(value);
    if (!_isInitialized) return;
    await _loopPlayer.setVolume(_loopVolume);
  }

  Future<void> playEffect(SoundEffectTrack effect, {double? volume}) async {
    await _ensureInitialized();
    if (!_isEffectEnabled) return;
    if (kIsWeb && !_hasUserGesture) return;

    if (volume != null) {
      await setEffectVolume(volume);
    }

    final player = await _getOrCreateEffectPlayer(effect);
    await _prepareEffectSource(effect, player, forceReload: kIsWeb);
    if (!kIsWeb) {
      await player.seek(Duration.zero);
    }
    _startPlayer(player);
  }

  Future<void> preloadEffect(SoundEffectTrack effect) async {
    await _ensureInitialized();
    final player = await _getOrCreateEffectPlayer(effect);
    await _prepareEffectSource(effect, player);
  }

  Future<void> stopEffect() async {
    if (!_isInitialized) return;
    for (final player in _effectPlayers.values) {
      await player.pause();
      if (player.processingState != ProcessingState.idle) {
        await player.seek(Duration.zero);
      }
    }
  }

  Future<void> setEffectEnabled(bool enabled) async {
    _isEffectEnabled = enabled;
    if (!enabled && _isInitialized) {
      await stopEffect();
    }
  }

  Future<void> setEffectVolume(double value) async {
    _effectVolume = _normalizeVolume(value);
    if (!_isInitialized) return;
    for (final player in _effectPlayers.values) {
      await player.setVolume(_effectVolume);
    }
  }

  Future<void> stopAll() async {
    await stopLoop();
    await stopEffect();
  }

  Future<void> dispose() async {
    await _loopPlayer.dispose();
    for (final player in _effectPlayers.values) {
      await player.dispose();
    }
    _effectPlayers.clear();
    _effectPrepared.clear();
    _loadedLoopTrack = null;
    _currentLoopTrack = null;
    _isInitialized = false;
    _didWarmUpEffects = false;
    _pendingLoopStartAfterGesture = false;
    _hasUserGesture = !kIsWeb;
  }

  Future<void> playSuccess() => playEffect(SoundEffectTrack.success);
  Future<void> playLuyenTap1ChamClick() =>
      playEffect(SoundEffectTrack.luyenTap1ChamClick);
  Future<void> playLuyenTap1Dragged() =>
      playEffect(SoundEffectTrack.luyenTap1Dragged);
  Future<void> playLuyenTap1CoiTauLua() =>
      playEffect(SoundEffectTrack.luyenTap1CoiTauLua);
  Future<void> playLuyenTap1Ting() =>
      playEffect(SoundEffectTrack.luyenTap1Ting);
  Future<void> playLuyenTap2Cloud() =>
      playEffect(SoundEffectTrack.luyenTap2Cloud);
  Future<void> playLuyenTap5TiengBatLua() =>
      playEffect(SoundEffectTrack.luyenTap5TiengBatLua);
  Future<void> playDanhGiaTongKetDiem() =>
      playEffect(SoundEffectTrack.danhGiaTongKetDiem);
  Future<void> playDanhGiaTe() => playEffect(SoundEffectTrack.danhGiaTe);
  Future<void> playDanhGiaTrungBinh() =>
      playEffect(SoundEffectTrack.danhGiaTrungBinh);
  Future<void> playDanhGiaTot() => playEffect(SoundEffectTrack.danhGiaTot);
  Future<void> playCacSoTu101110ChamKeo() =>
      playEffect(SoundEffectTrack.cacsotu101110ChamKeo);
  Future<void> playError() => playEffect(SoundEffectTrack.error);
  Future<void> playWrong() => playEffect(SoundEffectTrack.wrong);
  Future<void> playSaiNhe() => playEffect(SoundEffectTrack.saiNhe);
  Future<void> playHover() => playEffect(SoundEffectTrack.hover);
  Future<void> playDrag() => playEffect(SoundEffectTrack.drag);
  Future<void> playTing() => playEffect(SoundEffectTrack.ting);
  Future<void> playBell() => playEffect(SoundEffectTrack.ting);
  Future<void> playKhoiDong1DragToBlank() =>
      playEffect(SoundEffectTrack.khoiDong1DragToBlank);
  Future<void> playKhoiDong1Correct() =>
      playEffect(SoundEffectTrack.khoiDong1Correct);
  Future<void> playKhoiDong1Wrong() =>
      playEffect(SoundEffectTrack.khoiDong1Wrong);

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await init();
    }
  }

  Future<void> _warmUpEffectsIfNeeded() async {
    if (_didWarmUpEffects) return;
    if (kIsWeb && !_hasUserGesture) return;

    // Warm up latency-sensitive effects to avoid first-play decoding delay.
    for (final effect in _eagerPreloadEffects) {
      await preloadEffect(effect);
    }
    _didWarmUpEffects = true;
  }

  Future<void> _startLoopPlayback() async {
    final track = _currentLoopTrack;
    if (track == null) return;

    await _prepareLoopSource(track);
    if (_loopPlayer.processingState == ProcessingState.completed) {
      await _loopPlayer.seek(Duration.zero);
    }
    _startPlayer(_loopPlayer);
  }

  Future<AudioPlayer> _getOrCreateEffectPlayer(SoundEffectTrack effect) async {
    final existing = _effectPlayers[effect];
    if (existing != null) {
      return existing;
    }

    final player = AudioPlayer(
      handleInterruptions: false,
      handleAudioSessionActivation: false,
      androidApplyAudioAttributes: false,
    );
    await player.setLoopMode(LoopMode.off);
    await player.setVolume(_effectVolume);

    _effectPlayers[effect] = player;
    return player;
  }

  Future<void> _prepareLoopSource(
    SoundLoopTrack track, {
    bool forceReload = false,
  }) async {
    if (!forceReload &&
        _loadedLoopTrack == track &&
        _loopPlayer.processingState != ProcessingState.idle) {
      return;
    }

    await _loopPlayer.setAudioSource(_buildAssetSource(track.fileName));
    _loadedLoopTrack = track;
  }

  Future<void> _prepareEffectSource(
    SoundEffectTrack effect,
    AudioPlayer player, {
    bool forceReload = false,
  }) async {
    final isPrepared = _effectPrepared[effect] ?? false;
    if (!forceReload &&
        isPrepared &&
        player.processingState != ProcessingState.idle) {
      return;
    }

    await player.setAudioSource(_buildAssetSource(effect.fileName));
    _effectPrepared[effect] = true;
  }

  AudioSource _buildAssetSource(String fileName) {
    final path = _buildAssetPath(fileName);
    return AudioSource.asset(
      path,
      tag: MediaItem(id: 'asset:$path', title: fileName),
    );
  }

  String _buildAssetPath(String fileName) => '$_assetPrefix$fileName';

  double _normalizeVolume(double value) {
    return value.clamp(0.0, 1.0).toDouble();
  }

  void _startPlayer(AudioPlayer player) {
    unawaited(
      player.play().catchError((Object error, StackTrace stackTrace) {
        if (_isAutoplayBlockedError(error)) {
          return;
        }
        debugPrint('SoundService play error: $error');
      }),
    );
  }

  bool _isAutoplayBlockedError(Object error) {
    if (!kIsWeb) return false;
    final msg = error.toString().toLowerCase();
    return msg.contains('audiocontext was not allowed to start') ||
        msg.contains('notallowederror') ||
        msg.contains('user gesture');
  }
}
