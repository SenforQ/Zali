import 'package:flutter/material.dart';

import 'pages/home_page.dart';
import 'pages/mine_page.dart';
import 'pages/plan_page.dart';
import 'pages/rank_page.dart';
import 'pages/welcome_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zali',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF28FF5E)),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const WelcomePage(),
    );
  }
}

class TabDestination {
  const TabDestination({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });

  final String label;
  final String icon;
  final String activeIcon;
}

class ZaliTabScaffold extends StatefulWidget {
  const ZaliTabScaffold({super.key});

  @override
  State<ZaliTabScaffold> createState() => _ZaliTabScaffoldState();
}

class _ZaliTabScaffoldState extends State<ZaliTabScaffold> {
  int _currentIndex = 0;

  static const List<TabDestination> _tabs = [
    TabDestination(
      label: '首页',
      icon: 'assets/icon_tab_home_pre.webp',
      activeIcon: 'assets/icon_tab_home_nor.webp',
    ),
    TabDestination(
      label: '排行榜',
      icon: 'assets/icon_tab_activity_pre.webp',
      activeIcon: 'assets/icon_tab_activity_nor.webp',
    ),
    TabDestination(
      label: '计划',
      icon: 'assets/icon_tab_dynamic_pre.webp',
      activeIcon: 'assets/icon_tab_dynamic_nor.webp',
    ),
    TabDestination(
      label: '我的',
      icon: 'assets/icon_tab_me_pre.webp',
      activeIcon: 'assets/icon_tab_me_nor.webp',
    ),
  ];

  static const List<Widget> _pages = [
    HomePage(),
    RankPage(),
    PlanPage(),
    MinePage(),
  ];

  void _onTabTapped(int index) {
    if (_currentIndex == index) {
      return;
    }
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF191D20),
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.white,
        items: _tabs
            .map(
              (tab) => BottomNavigationBarItem(
                icon: Image.asset(tab.icon, width: 24, height: 24),
                activeIcon: Image.asset(tab.activeIcon, width: 24, height: 24),
                label: tab.label,
              ),
            )
            .toList(),
      ),
    );
  }
}
