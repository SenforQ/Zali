import 'package:flutter/material.dart';

import 'search_page.dart';
import 'image_page.dart';
import 'video_page.dart';
import 'report_page.dart';
import 'person_chat_page.dart';
import 'person_call_page.dart';

class PersonDetailPage extends StatelessWidget {
  const PersonDetailPage({super.key, required this.person});

  final WorkoutPerson person;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
        elevation: 0,
        foregroundColor: Colors.white,
        title: Text(person.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () => _showMoreActions(context),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundImage: AssetImage(
                      person.photos.firstOrNull ?? 'assets/home_cover.webp',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          person.name,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${person.videos.length} workout videos',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF282829),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => PersonChatPage(
                              personName: person.name,
                            ),
                          ),
                        );
                      },
                      child: const Text('Chat'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF28FF5E),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => PersonCallPage(
                              personName: person.name,
                              avatarUrl: person.photos.firstOrNull ??
                                  'assets/home_cover.webp',
                            ),
                          ),
                        );
                      },
                      child: const Text('Call'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Text(
                'Photos',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: person.photos.length,
                itemBuilder: (context, index) {
                  final imagePath = person.photos[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ImagePage(imagePath: imagePath),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(imagePath, fit: BoxFit.cover),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
              Text(
                'Videos',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Column(
                children: List.generate(person.videos.length, (index) {
                  final video = person.videos[index];
                  final cover = index < person.thumbnails.length
                      ? person.thumbnails[index]
                      : person.photos.firstOrNull ?? 'assets/home_cover.webp';
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              VideoPage(videoPath: video, coverPath: cover),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF151515),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  cover,
                                  width: 100,
                                  height: 70,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Container(
                                width: 32,
                                height: 32,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF28FF5E),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.play_arrow,
                                  color: Colors.black,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Workout video ${index + 1}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMoreActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1C1C1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildActionTile(
                context,
                label: 'Report',
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ReportPage(personName: person.name),
                    ),
                  );
                },
              ),
              const Divider(height: 1, color: Color(0xFF2C2C2E)),
              _buildActionTile(
                context,
                label: 'Block',
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(); // 返回上一页
                },
              ),
              const Divider(height: 1, color: Color(0xFF2C2C2E)),
              _buildActionTile(
                context,
                label: 'Mute',
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(); // 返回上一页
                },
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
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

  Widget _buildActionTile(
    BuildContext context, {
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
}
