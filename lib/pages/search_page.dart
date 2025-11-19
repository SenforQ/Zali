import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

import 'person_detail_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final Future<List<WorkoutPerson>> _peopleFuture;
  final TextEditingController _controller = TextEditingController();
  String _query = '';
  final Set<String> _blockedUsers = {};

  @override
  void initState() {
    super.initState();
    _peopleFuture = _loadPeopleWithVideos();
    _loadBlockedUsers();
    _controller.addListener(() {
      setState(() {
        _query = _controller.text.trim();
      });
    });
  }

  Future<void> _loadBlockedUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList('blocked_users') ?? [];
    setState(() {
      _blockedUsers
        ..clear()
        ..addAll(stored);
    });
  }

  Future<List<WorkoutPerson>> _loadPeopleWithVideos() async {
    final raw = await rootBundle.loadString('assets/people.json');
    final decoded = json.decode(raw) as Map<String, dynamic>;
    final List<dynamic> people = decoded['people'] as List<dynamic>;

    return people
        .map((p) => WorkoutPerson.fromJson(p as Map<String, dynamic>))
        .where((person) => person.videos.isNotEmpty)
        .toList();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
        elevation: 0,
        title: const Text('Search'),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
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
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search Workout Moves',
                          hintStyle: theme.textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF999999),
                            fontSize: 16,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: FutureBuilder<List<WorkoutPerson>>(
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
                          'Failed to load data',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      );
                    }

                    final people = snapshot.data!;
                    final filtered = _query.isEmpty
                        ? people
                        : people
                              .where(
                                (p) => p.name.toLowerCase().contains(
                                  _query.toLowerCase(),
                                ),
                              )
                              .toList();

                    final visible = filtered
                        .where((person) => !_blockedUsers.contains(person.name))
                        .toList();

                    if (visible.isEmpty) {
                      return Center(
                        child: Text(
                          'No results found',
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
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    PersonDetailPage(person: person),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF151515),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.asset(
                                    person.thumbnail ??
                                        person.photos.firstOrNull ??
                                        'assets/home_cover.webp',
                                    width: 72,
                                    height: 72,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        person.name,
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        '${person.videos.length} workout videos',
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(color: Colors.white70),
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
}

class WorkoutPerson {
  const WorkoutPerson({
    required this.name,
    required this.photos,
    required this.videos,
    required this.thumbnails,
  });

  factory WorkoutPerson.fromJson(Map<String, dynamic> json) {
    final photos = (json['ZaliShowPhotoArray'] as List<dynamic>)
        .map((e) => e as String)
        .toList();
    final videos = (json['ZaliShowVideoArray'] as List<dynamic>)
        .map((e) => e as String)
        .toList();
    final thumbnails = (json['ZaliShowThumbnailArray'] as List<dynamic>)
        .map((e) => e as String)
        .toList();

    return WorkoutPerson(
      name: json['ZaliNickName'] as String,
      photos: photos,
      videos: videos,
      thumbnails: thumbnails,
    );
  }

  final String name;
  final List<String> photos;
  final List<String> videos;
  final List<String> thumbnails;

  String? get thumbnail =>
      thumbnails.isNotEmpty ? thumbnails.first : photos.firstOrNull;
}

extension<T> on List<T> {
  T? get firstOrNull => isNotEmpty ? first : null;
}
