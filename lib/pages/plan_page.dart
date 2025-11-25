import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class PlanPage extends StatefulWidget {
  const PlanPage({super.key});

  @override
  State<PlanPage> createState() => _PlanPageState();
}

class _PlanPageState extends State<PlanPage> {
  late final Future<List<PlanItem>> _plansFuture;
  int _selectedDayIndex = (DateTime.now().weekday - 1).clamp(0, 6);
  int _displayedPlanIndex = (DateTime.now().weekday - 1).clamp(0, 6);
  bool _showAiAdvice = false;
  String? _aiAdvice;

  @override
  void initState() {
    super.initState();
    _plansFuture = _loadPlans();
  }

  Future<List<PlanItem>> _loadPlans() async {
    final raw = await rootBundle.loadString('assets/plan.json');
    final decoded = json.decode(raw) as Map<String, dynamic>;
    final List<dynamic> plans = decoded['plans'] as List<dynamic>;
    return plans.map((plan) => PlanItem.fromJson(plan)).toList();
  }

  Future<void> _handleAiPrompt(PlanItem plan) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF12161C),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.smart_toy_outlined, color: Color(0xFF28FF5E)),
            SizedBox(width: 8),
            Flexible(
              child: Text(
                'AI Diet Companion',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        content: const Text(
          'These tips are generated in real time by an AI assistant and should be used as general guidance only. '
          'For precise assessments, please visit healthcare providers near you.',
          style: TextStyle(color: Colors.white70, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF888888)),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'OK',
              style: TextStyle(
                color: Color(0xFF28FF5E),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() {
        _showAiAdvice = true;
        _aiAdvice =
            'Plan "${plan.title}" benefits from steady hydration, lean protein breakfasts, and post-workout snacks rich in complex carbs. '
            'Adjust portion sizes based on your energy output.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: const Color(0xFF0E1319),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              SizedBox(
                width: 310,
                height: 27,
                child: Image.asset(
                  'assets/plan_top_bg.webp',
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 28),
              _WeekSelector(
                selectedIndex: _selectedDayIndex,
                onChanged: (index) {
                  setState(() {
                    _selectedDayIndex = index;
                    _displayedPlanIndex = index;
                    _showAiAdvice = false;
                    _aiAdvice = null;
                  });
                },
              ),
              const SizedBox(height: 24),
              Expanded(
                child: FutureBuilder<List<PlanItem>>(
                  future: _plansFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFE0F900),
                        ),
                      );
                    }
                    if (snapshot.hasError || !snapshot.hasData) {
                      return Center(
                        child: Text(
                          'Failed to load plans',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      );
                    }
                    final plans = snapshot.data!;
                    if (_displayedPlanIndex >= plans.length) {
                      _displayedPlanIndex = plans.length - 1;
                    }
                    final plan =
                        plans[_displayedPlanIndex.clamp(0, plans.length - 1)];

                    return SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(32),
                                child: SizedBox(
                                  width: 275,
                                  height: 275,
                                  child: Image.asset(
                                    plan.image,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              GestureDetector(
                                onTap: () {
                                  if (plans.isNotEmpty) {
                                    setState(() {
                                      _displayedPlanIndex =
                                          (_displayedPlanIndex + 1) %
                                          plans.length;
                                  _showAiAdvice = false;
                                  _aiAdvice = null;
                                    });
                                  }
                                },
                                child: Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFFE0F900),
                                      width: 1.5,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                    'assets/plan_reload.webp',
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Text(
                            plan.title,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            plan.trainingDuration,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 24),
                          _showAiAdvice
                              ? _AiAdviceCard(
                                  advice: _aiAdvice ??
                                      'Focus on balanced meals with lean protein, complex carbohydrates, and colorful vegetables to fuel this training.',
                                )
                              : _AiPromptCard(
                                  onTap: () => _handleAiPrompt(plan),
                                ),
                        ],
                      ),
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

class _AiPromptCard extends StatelessWidget {
  const _AiPromptCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1F24),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFF28FF5E)),
        ),
        child: Row(
          children: const [
            Icon(Icons.smart_toy_outlined, color: Color(0xFF28FF5E)),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Need AI diet tips for this plan?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AiAdviceCard extends StatelessWidget {
  const _AiAdviceCard({required this.advice});

  final String advice;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF161A20),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF28FF5E)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'AI Suggestion',
            style: TextStyle(
              color: Color(0xFF28FF5E),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            advice,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'This recommendation is AI-generated. For personalized nutrition, please consult nearby medical professionals.',
            style: TextStyle(
              color: Color(0xFFAAAAAA),
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _WeekSelector extends StatelessWidget {
  const _WeekSelector({required this.selectedIndex, required this.onChanged});

  final int selectedIndex;
  final ValueChanged<int> onChanged;

  static const _labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(_labels.length, (index) {
        final isSelected = index == selectedIndex;
        return GestureDetector(
          onTap: () => onChanged(index),
          child: Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFE0F900) : Colors.transparent,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: isSelected ? Colors.transparent : Colors.white,
                width: 1,
              ),
            ),
            child: Text(
              _labels[index],
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _MealLine extends StatelessWidget {
  const _MealLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: '$label: ',
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        children: [
          TextSpan(
            text: value,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class PlanItem {
  const PlanItem({
    required this.id,
    required this.title,
    required this.image,
    required this.meals,
    required this.trainingDuration,
  });

  factory PlanItem.fromJson(Map<String, dynamic> json) {
    return PlanItem(
      id: json['id'] as int,
      title: json['title'] as String,
      image: json['image'] as String,
      meals: PlanMeals.fromJson(json['meals'] as Map<String, dynamic>),
      trainingDuration: json['trainingDuration'] as String,
    );
  }

  final int id;
  final String title;
  final String image;
  final PlanMeals meals;
  final String trainingDuration;
}

class PlanMeals {
  const PlanMeals({
    required this.breakfast,
    required this.lunch,
    required this.dinner,
  });

  factory PlanMeals.fromJson(Map<String, dynamic> json) {
    return PlanMeals(
      breakfast: json['breakfast'] as String,
      lunch: json['lunch'] as String,
      dinner: json['dinner'] as String,
    );
  }

  final String breakfast;
  final String lunch;
  final String dinner;
}
