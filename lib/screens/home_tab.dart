import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/incident_provider.dart';
import '../utils/app_theme.dart';
import '../utils/constants.dart';
import '../widgets/report_card.dart';
import '../widgets/section_header.dart';
import '../widgets/stat_tile.dart';
import 'student/submit_incident_screen.dart';

class HomeTab extends StatelessWidget {
  final VoidCallback onSeeAll;
  const HomeTab({super.key, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final data = context.watch<IncidentProvider>();
    final user = auth.appUser;

    // Students see their own numbers, staff see everything.
    final scopeId = auth.isStaff ? null : user?.uid;
    final recent = data.filtered(reporterId: scopeId).take(3).toList();

    final firstName = (user?.name ?? '').trim().split(' ').first;
    final initial = firstName.isEmpty ? '?' : firstName[0].toUpperCase();

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hello, $firstName 👋',
                          style: const TextStyle(
                              fontSize: 26, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 4),
                      const Text('Help make our campus safer.',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                      Text('Report issues and track their resolution.',
                          style: TextStyle(color: Colors.grey.shade600)),
                    ],
                  ),
                ),
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppTheme.primary.withValues(alpha: 0.12),
                  child: Text(initial,
                      style: const TextStyle(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w800,
                          fontSize: 20)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: _ReportBanner(),
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SectionHeader(title: 'Report Summary'),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: StatTile(
                    icon: Icons.description_outlined,
                    color: AppTheme.primary,
                    value: data.count(reporterId: scopeId),
                    label: auth.isStaff ? 'All Reports' : 'My Reports',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: StatTile(
                    icon: Icons.schedule,
                    color: AppTheme.statusColor(IncidentStatus.inProgress),
                    value: data.count(
                        status: IncidentStatus.inProgress,
                        reporterId: scopeId),
                    label: 'In Progress',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: StatTile(
                    icon: Icons.check_circle_outline,
                    color: AppTheme.statusColor(IncidentStatus.resolved),
                    value: data.count(
                        status: IncidentStatus.resolved, reporterId: scopeId),
                    label: 'Resolved',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: StatTile(
                    icon: Icons.error_outline,
                    color: AppTheme.statusColor(IncidentStatus.submitted),
                    value: data.count(
                        status: IncidentStatus.submitted, reporterId: scopeId),
                    label: 'Submitted',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SectionHeader(title: 'Recent Reports', onSeeAll: onSeeAll),
          ),
          if (data.loading)
            const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (data.error != null)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Center(child: Text(data.error!)),
            )
          else if (recent.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Text('No reports yet. Tap + to add one.',
                    style: TextStyle(color: Colors.grey.shade600)),
              ),
            )
          else
            ...recent.map((i) => ReportCard(incident: i)),
        ],
      ),
    );
  }
}

class _ReportBanner extends StatelessWidget {
  const _ReportBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF5B3DF5), Color(0xFF8E7BFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -12,
            top: 10,
            child: Icon(Icons.apartment_rounded,
                size: 120, color: Colors.white.withValues(alpha: 0.18)),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'See an issue\non campus?',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      height: 1.15),
                ),
                const SizedBox(height: 8),
                Text(
                  'Report it and help improve\nour learning environment.',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.9)),
                ),
                const SizedBox(height: 16),
                Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const SubmitIncidentScreen()),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: AppTheme.primary,
                            child:
                                Icon(Icons.add, color: Colors.white, size: 20),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text('Report an Issue',
                                style: TextStyle(
                                    color: AppTheme.primary,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16)),
                          ),
                          Icon(Icons.chevron_right, color: AppTheme.primary),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}