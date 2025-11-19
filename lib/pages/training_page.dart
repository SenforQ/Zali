import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class TrainingPage extends StatefulWidget {
  const TrainingPage({super.key});

  @override
  State<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  String? _selectedWorkout;
  int _seconds = 0;
  bool _isRunning = false;
  Timer? _timer;

  final List<String> _workoutOptions = [
    'Boxing',
    'Running',
    'Jump Rope',
    'Cycling',
    'Swimming',
    'Yoga',
    'Weight Training',
    'HIIT',
    'Pilates',
    'Dancing',
  ];

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _saveTodayWorkout(int minutes) async {
    try {
      // 添加重试机制
      SharedPreferences? prefs;
      int retries = 3;
      while (retries > 0 && prefs == null) {
        try {
          prefs = await SharedPreferences.getInstance();
        } catch (e) {
          retries--;
          if (retries > 0) {
            await Future.delayed(const Duration(milliseconds: 200));
          }
        }
      }

      if (prefs == null) {
        debugPrint('Failed to initialize SharedPreferences after retries');
        return;
      }

      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final key = 'workout_$today';

      final existingMinutes = prefs.getInt(key) ?? 0;
      final totalMinutes = existingMinutes + minutes;

      await prefs.setInt(key, totalMinutes);
    } catch (e) {
      // 如果保存失败，静默处理，避免应用崩溃
      debugPrint('Failed to save workout data: $e');
    }
  }

  void _toggleWorkout() {
    if (_isRunning) {
      setState(() {
        _isRunning = false;
        _stopTimer();
      });
      // 保存锻炼时长（转换为分钟）
      final minutes = _seconds ~/ 60;
      if (minutes > 0) {
        _saveTodayWorkout(minutes);
      }
    } else {
      if (_selectedWorkout != null) {
        setState(() {
          _isRunning = true;
          _startTimer();
        });
      }
    }
  }

  void _resetTimer() {
    setState(() {
      _seconds = 0;
      _isRunning = false;
      _stopTimer();
    });
  }

  String _formatTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Training'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Workout',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF262626),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF3A3A3A)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedWorkout,
                    isExpanded: true,
                    dropdownColor: const Color(0xFF262626),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                    ),
                    hint: Text(
                      'Choose a workout type',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[400],
                      ),
                    ),
                    icon: Icon(Icons.arrow_drop_down, color: Colors.grey[400]),
                    items: _workoutOptions.map((String workout) {
                      return DropdownMenuItem<String>(
                        value: workout,
                        child: Text(workout),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (!_isRunning) {
                        setState(() {
                          _selectedWorkout = newValue;
                        });
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 48),
              Center(
                child: Column(
                  children: [
                    Text(
                      _formatTime(_seconds),
                      style: theme.textTheme.displayLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 64,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _selectedWorkout ?? 'No workout selected',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  if (_isRunning || _seconds > 0)
                    Expanded(
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFF262626),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFF3A3A3A)),
                        ),
                        child: TextButton(
                          onPressed: _resetTimer,
                          child: Text(
                            'Reset',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (_isRunning || _seconds > 0) const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: _isRunning
                            ? Colors.red
                            : const Color(0xFFE0F900),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextButton(
                        onPressed: _selectedWorkout != null
                            ? _toggleWorkout
                            : null,
                        child: Text(
                          _isRunning ? 'Stop' : 'Start Training',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: _isRunning ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
