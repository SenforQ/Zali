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
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFF28FF5E),
                              borderRadius: BorderRadius.circular(32),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _MealLine(
                                  label: 'Breakfast',
                                  value: plan.meals.breakfast,
                                ),
                                const SizedBox(height: 14),
                                _MealLine(
                                  label: 'Lunch',
                                  value: plan.meals.lunch,
                                ),
                                const SizedBox(height: 14),
                                _MealLine(
                                  label: 'Dinner',
                                  value: plan.meals.dinner,
                                ),
                              ],
                            ),
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
