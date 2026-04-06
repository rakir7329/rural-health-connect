import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';
import 'main_wrapper.dart';
import '../widgets/glass_card.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      'title': 'Track Your Vitals',
      'body': 'Easily monitor your blood pressure, sugar levels, and temperature daily with beautiful interactive charts.',
      'icon': 'favorite'
    },
    {
      'title': 'AI Symptom Checker',
      'body': 'Feel unwell? Enter your symptoms and let our AI logic engine predict illnesses and suggest steps.',
      'icon': 'psychology'
    },
    {
      'title': 'Locate Hospitals',
      'body': 'Enter your pincode to instantly discover emergency contacts and nearby clinics.',
      'icon': 'local_hospital'
    }
  ];

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);
    if (mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainWrapper()));
    }
  }

  IconData _getIcon(String icon) {
    switch (icon) {
      case 'favorite': return Icons.monitor_heart;
      case 'psychology': return Icons.psychology_alt;
      case 'local_hospital': return Icons.local_hospital;
      default: return Icons.star;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppTheme.backgroundGradient,
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemCount: _pages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GlassCard(
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          children: [
                            Icon(_getIcon(_pages[index]['icon']!), size: 100, color: Colors.white),
                            const SizedBox(height: 32),
                            Text(
                              _pages[index]['title']!,
                              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            Text(
                              _pages[index]['body']!,
                              style: const TextStyle(fontSize: 16, color: Colors.white70, height: 1.5),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
            Positioned(
              bottom: 60,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _completeOnboarding,
                    child: const Text('SKIP', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
                  ),
                  Row(
                    children: List.generate(
                      _pages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(right: 8),
                        height: 10,
                        width: _currentPage == index ? 24 : 10,
                        decoration: BoxDecoration(
                          color: _currentPage == index ? Colors.white : Colors.white24,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                    onPressed: () {
                      if (_currentPage == _pages.length - 1) {
                        _completeOnboarding();
                      } else {
                        _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                      }
                    },
                    child: Text(
                      _currentPage == _pages.length - 1 ? 'START' : 'NEXT',
                      style: const TextStyle(color: AppTheme.primaryBlue)
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
