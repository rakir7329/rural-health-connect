import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/database_service.dart';
import '../models/user_model.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'symptom_checker_screen.dart';
import 'hospital_finder_screen.dart';
import 'profile_screen.dart';
import 'profile_setup_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    HomeScreen(),
    SymptomCheckerScreen(),
    HospitalFinderScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    if (user == null) return const Scaffold();

    final db = DatabaseService(uid: user.uid);

    return StreamBuilder<UserModel>(
      stream: db.userData,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            body: Container(
              decoration: AppTheme.backgroundGradient,
              child: const Center(child: CircularProgressIndicator(color: Colors.white)),
            ),
          );
        }

        final userData = snapshot.data!;
        
        // INTERCEPTOR LOGIC: Trap users without completed profiles
        if (userData.name.isEmpty) {
          return const ProfileSetupScreen();
        }

        return Scaffold(
          extendBody: true,
          body: IndexedStack(
            index: _selectedIndex,
            children: _pages,
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
              boxShadow: [
                BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                child: GNav(
                  rippleColor: Colors.grey[300]!,
                  hoverColor: Colors.grey[100]!,
                  gap: 8,
                  activeColor: AppTheme.primaryBlue,
                  iconSize: 24,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  duration: const Duration(milliseconds: 400),
                  tabBackgroundColor: AppTheme.lightTeal.withOpacity(0.2),
                  color: Colors.grey[600],
                  tabs: const [
                    GButton(icon: Icons.dashboard, text: 'Home'),
                    GButton(icon: Icons.psychology_alt, text: 'Predict'),
                    GButton(icon: Icons.local_hospital, text: 'Hospitals'),
                    GButton(icon: Icons.person, text: 'Profile'),
                  ],
                  selectedIndex: _selectedIndex,
                  onTabChange: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                ),
              ),
            ),
          ).animate().slideY(begin: 1, end: 0, duration: 500.ms, curve: Curves.easeOutCubic),
        );
      }
    );
  }
}
