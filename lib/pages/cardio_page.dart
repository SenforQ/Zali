import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

import 'report_page.dart';
import 'search_page.dart';
import 'video_page.dart';

class CardioPage extends StatefulWidget {
  const CardioPage({super.key});

  @override
  State<CardioPage> createState() => _CardioPageState();
}

class _CardioPageState extends State<CardioPage> {
  late Future<List<CardioPerson>> _peopleFuture;
  Set<String> _blockedNames = {};

  @override
  void initState() {
    super.initState();
    _loadFilters();
    _peopleFuture = _loadCardioPeople();
  }

  Future<void> _loadFilters() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList('blocked_users') ?? [];
    setState(() {
      _blockedNames = stored.toSet();
    });
  }

  Future<List<CardioPerson>> _loadCardioPeople() async {
    final raw = await rootBundle.loadString('assets/Cardio.json');
    final decoded = json.decode(raw) as Map<String, dynamic>;
    final List<dynamic> people = decoded['people'] as List<dynamic>;
    return people
        .map((p) => CardioPerson.fromJson(p as Map<String, dynamic>))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 23, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Cardio training',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 23),
              GestureDetector(
                onTap: () {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => const SearchPage()));
                },
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF282829),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.grey[500]),
                      const SizedBox(width: 12),
                      Text(
                        'Search Workout Moves',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF999999),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'High-energy cardio routines to boost endurance and burn calories fast.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'RECOMMEND',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: const Color(0xFFCACACA),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: FutureBuilder<List<CardioPerson>>(
                  future: _peopleFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF28FF5E),
                        ),
                      );
                    }
                    if (snapshot.hasError || !snapshot.hasData) {
                      return Center(
                        child: Text(
                          'Failed to load recommendations',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      );
                    }
                    final people = snapshot.data!;
                    final visible = people
                        .where((p) => !_blockedNames.contains(p.name))
                        .toList();
                    if (visible.isEmpty) {
                      return Center(
                        child: Text(
                          'No recommendations available',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      );
                    }
                    return ListView.separated(
                      itemCount: visible.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final person = visible[index];
                        final cover =
                            person.thumbnails.firstOrNull ??
                            person.photos.firstOrNull ??
                            'assets/home_cover.webp';
                        final avatar = person.photos.firstOrNull ?? cover;
                        final videoPath = person.videos.firstOrNull;
                        return GestureDetector(
                          onTap: () {
                            if (videoPath == null) return;
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => VideoPage(
                                  videoPath: videoPath,
                                  coverPath: cover,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            height: 274,
                            decoration: BoxDecoration(
                              color: const Color(0xFF151515),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(24),
                                        topRight: Radius.circular(24),
                                      ),
                                      child: Image.asset(
                                        cover,
                                        width: double.infinity,
                                        height: 200,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFD0FE00),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.play_arrow,
                                        color: Colors.black,
                                        size: 30,
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    16,
                                    12,
                                    20,
                                    12,
                                  ),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(24),
                                        child: Image.asset(
                                          avatar,
                                          width: 48,
                                          height: 48,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          person.name,
                                          style: theme.textTheme.titleMedium
                                              ?.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ),
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(
                                          minWidth: 40,
                                        ),
                                        icon: const Icon(
                                          Icons.more_horiz,
                                          color: Colors.white,
                                        ),
                                        onPressed: () =>
                                            _showCardActions(context, person),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCardActions(BuildContext context, CardioPerson person) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1C1C1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildActionTile(
                label: 'Report',
                onTap: () => _handleReport(context, sheetContext, person),
              ),
              const Divider(height: 1, color: Color(0xFF2C2C2E)),
              _buildActionTile(
                label: 'Block',
                onTap: () => _handleFilterAction(sheetContext, person),
              ),
              const Divider(height: 1, color: Color(0xFF2C2C2E)),
              _buildActionTile(
                label: 'Mute',
                onTap: () => _handleFilterAction(sheetContext, person),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.of(sheetContext).pop(),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Color(0xFF0A84FF)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  ListTile _buildActionTile({
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white),
      ),
      onTap: onTap,
    );
  }

  Future<void> _handleFilterAction(
    BuildContext sheetContext,
    CardioPerson person,
  ) async {
    Navigator.of(sheetContext).pop();
    await _addToFilter(person.name);
  }

  Future<void> _handleReport(
    BuildContext pageContext,
    BuildContext sheetContext,
    CardioPerson person,
  ) async {
    Navigator.of(sheetContext).pop();
    final result = await Navigator.of(pageContext).push<bool>(
      MaterialPageRoute(builder: (_) => ReportPage(personName: person.name)),
    );
    if (result == true) {
      await _addToFilter(person.name);
    }
  }

  Future<void> _addToFilter(String name) async {
    final prefs = await SharedPreferences.getInstance();
    _blockedNames.add(name);
    await prefs.setStringList('blocked_users', _blockedNames.toList());
    setState(() {
      _peopleFuture = _loadCardioPeople();
    });
  }
}

class CardioPerson {
  const CardioPerson({
    required this.name,
    required this.photos,
    required this.videos,
    required this.thumbnails,
  });

  factory CardioPerson.fromJson(Map<String, dynamic> json) {
    return CardioPerson(
      name: json['ZaliNickName'] as String,
      photos: (json['ZaliShowPhotoArray'] as List<dynamic>)
          .cast<String>()
          .toList(),
      videos: (json['ZaliShowVideoArray'] as List<dynamic>)
          .cast<String>()
          .toList(),
      thumbnails: (json['ZaliShowThumbnailArray'] as List<dynamic>)
          .cast<String>()
          .toList(),
    );
  }

  final String name;
  final List<String> photos;
  final List<String> videos;
  final List<String> thumbnails;
}

extension<T> on List<T> {
  T? get firstOrNull => isNotEmpty ? first : null;
}
