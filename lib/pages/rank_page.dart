import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import 'training_page.dart';

class RankPage extends StatefulWidget {
  const RankPage({super.key});

  @override
  State<RankPage> createState() => _RankPageState();
}

class _RankPageState extends State<RankPage> {
  late final Future<List<RankPerson>> _peopleFuture;
  int? _todayWorkoutMinutes;

  @override
  void initState() {
    super.initState();
    _peopleFuture = _loadPeople();
    // 延迟加载，确保 SharedPreferences 已初始化
    Future.delayed(const Duration(milliseconds: 100), () {
      _loadTodayWorkout();
    });
  }

  Future<void> _loadTodayWorkout() async {
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
        if (mounted) {
          setState(() {
            _todayWorkoutMinutes = null;
          });
        }
        return;
      }

      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final key = 'workout_$today';

      final minutes = prefs.getInt(key) ?? 0;
      if (mounted) {
        setState(() {
          _todayWorkoutMinutes = minutes > 0 ? minutes : null;
        });
      }
    } catch (e) {
      // 如果加载失败，设置为 null
      debugPrint('Failed to load workout data: $e');
      if (mounted) {
        setState(() {
          _todayWorkoutMinutes = null;
        });
      }
    }
  }

  String _getTodayWorkoutText() {
    if (_todayWorkoutMinutes != null && _todayWorkoutMinutes! > 0) {
      return 'Today\'s workout: $_todayWorkoutMinutes min';
    } else {
      return 'Keep going!';
    }
  }

  Future<List<RankPerson>> _loadPeople() async {
    final raw = await rootBundle.loadString('assets/people.json');
    final decoded = json.decode(raw) as Map<String, dynamic>;
    final List<dynamic> people = decoded['people'] as List<dynamic>;

    final peopleList = people
        .map((p) => RankPerson.fromJson(p as Map<String, dynamic>))
        .toList();

    peopleList.sort((a, b) => b.workoutDuration.compareTo(a.workoutDuration));

    return peopleList.take(10).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final imageWidth = screenWidth - 40;
    final imageHeight = imageWidth * 0.66;

    return Container(
      color: const Color(0xFF0A0A0A),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // const SizedBox(height: 64),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: imageWidth,
                height: imageHeight,
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/rank_top_bg.webp',
                      fit: BoxFit.cover,
                      width: imageWidth,
                      height: imageHeight,
                    ),
                    Positioned(
                      left: 20,
                      bottom: 20,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getTodayWorkoutText(),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const TrainingPage(),
                                ),
                              );
                              // 返回时重新加载今天的锻炼时长
                              _loadTodayWorkout();
                            },
                            child: Container(
                              width: 105,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Training Go',
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            Expanded(
              child: Center(
                child: SizedBox(
                  width: screenWidth - 40,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      color: const Color(0xFF262626),
                      child: FutureBuilder<List<RankPerson>>(
                        future: _peopleFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFFE0F900),
                              ),
                            );
                          }

                          if (snapshot.hasError || !snapshot.hasData) {
                            return Center(
                              child: Text(
                                'Failed to load data',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: Colors.white70,
                                ),
                              ),
                            );
                          }

                          final people = snapshot.data!;

                          return ListView.builder(
                            padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                            itemCount: people.length,
                            itemBuilder: (context, index) {
                              final person = people[index];
                              final rank = index + 1;

                              return Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                child: Row(
                                  children: [
                                    Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          child: Image.asset(
                                            person.userIcon,
                                            width: 64,
                                            height: 64,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  return Container(
                                                    width: 64,
                                                    height: 64,
                                                    color: Colors.grey[800],
                                                    child: const Icon(
                                                      Icons.person,
                                                      color: Colors.grey,
                                                    ),
                                                  );
                                                },
                                          ),
                                        ),
                                        Positioned(
                                          bottom: -4,
                                          right: -4,
                                          child: Image.asset(
                                            'assets/rank_$rank.webp',
                                            width: 28,
                                            height: 28,
                                            fit: BoxFit.contain,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  return Container(
                                                    width: 28,
                                                    height: 28,
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                        0xFFE0F900,
                                                      ),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      '$rank',
                                                      style: theme
                                                          .textTheme
                                                          .labelLarge
                                                          ?.copyWith(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14,
                                                          ),
                                                    ),
                                                  );
                                                },
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            person.nickName,
                                            style: theme.textTheme.titleMedium
                                                ?.copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.fitness_center,
                                                size: 16,
                                                color: Colors.grey[400],
                                              ),
                                              const SizedBox(width: 6),
                                              Flexible(
                                                child: Text(
                                                  '${person.workoutDuration} min',
                                                  style: theme
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(
                                                        color: Colors.grey[400],
                                                      ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RankPerson {
  const RankPerson({
    required this.nickName,
    required this.userIcon,
    required this.workoutDuration,
  });

  factory RankPerson.fromJson(Map<String, dynamic> json) {
    return RankPerson(
      nickName: json['ZaliNickName'] as String,
      userIcon: json['ZaliUserIcon'] as String,
      workoutDuration: json['ZaliWorkoutDuration'] as int,
    );
  }

  final String nickName;
  final String userIcon;
  final int workoutDuration;
}
