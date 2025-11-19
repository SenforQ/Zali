import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class PersonCallPage extends StatefulWidget {
  const PersonCallPage({
    super.key,
    required this.personName,
    required this.avatarUrl,
  });

  final String personName;
  final String avatarUrl;

  @override
  State<PersonCallPage> createState() => _PersonCallPageState();
}

class _PersonCallPageState extends State<PersonCallPage> {
  Timer? _timer;
  int _remainingSeconds = 30;
  final AudioPlayer _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds == 0) {
        _endCall();
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
    _playRingtone();
  }

  Future<void> _playRingtone() async {
    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.play(AssetSource('zaliCall.mp3'));
  }

  @override
  void dispose() {
    _timer?.cancel();
    _player.stop();
    _player.dispose();
    super.dispose();
  }

  void _endCall() {
    _timer?.cancel();
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage(widget.avatarUrl),
                ),
                const SizedBox(height: 24),
                Text(
                  widget.personName,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Calling...',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Auto hang up in $_remainingSeconds s',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(200, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  onPressed: _endCall,
                  icon: const Icon(Icons.call_end),
                  label: const Text(
                    'Hang Up',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
