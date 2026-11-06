import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../utils/app_theme.dart';
import 'home_tab.dart';
import 'profile_tab.dart';
import 'reports_tab.dart';
import 'staff/staff_dashboard.dart';
import 'student/submit_incident_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  void _go(int i) => setState(() => _index = i);

  void _openReport() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const SubmitIncidentScreen()));
  }

  @override
  Widget build(BuildContext context) {
    if (context.watch<AuthProvider>().isStaff) {
      return const _StaffShell();
    }

    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          HomeTab(onSeeAll: () => _go(1)),
          const ReportsTab(),
          const ProfileTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openReport,
        tooltip: 'Report an incident',
        backgroundColor: AppTheme.accent,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        height: 64,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(
              icon: Icons.home_outlined,
              activeIcon: Icons.home,
              label: 'Home',
              selected: _index == 0,
              onTap: () => _go(0),
            ),
            _NavItem(
              icon: Icons.description_outlined,
              activeIcon: Icons.description,
              label: 'Reports',
              selected: _index == 1,
              onTap: () => _go(1),
            ),
            const SizedBox(width: 56),
            _NavItem(
              icon: Icons.person_outline,
              activeIcon: Icons.person,
              label: 'Profile',
              selected: _index == 2,
              onTap: () => _go(2),
            ),
          ],
        ),
      ),
    );
  }
}

class _StaffShell extends StatefulWidget {
  const _StaffShell();

  @override
  State<_StaffShell> createState() => _StaffShellState();
}

class _StaffShellState extends State<_StaffShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: const [StaffDashboard(), ProfileTab()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (index) => setState(() => _index = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppTheme.primary : Colors.grey.shade600;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(selected ? activeIcon : icon, color: color),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
