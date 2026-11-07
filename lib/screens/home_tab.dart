import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/incident_provider.dart';
import '../utils/app_theme.dart';
import '../utils/constants.dart';
import '../widgets/report_card.dart';
import '../widgets/section_header.dart';
import 'student/submit_incident_screen.dart';

class HomeTab extends StatelessWidget {
  final VoidCallback onSeeAll;

  const HomeTab({super.key, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final data = context.watch<IncidentProvider>();
    final user = auth.appUser;
    final scopeId = auth.isStaff ? null : user?.uid;
    final recent = data.filtered(reporterId: scopeId).take(3).toList();
    final firstName = (user?.name ?? '').trim().split(' ').first;
    final initial = firstName.isEmpty ? '?' : firstName[0].toUpperCase();

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 28),
        children: [
          _StudentHeader(
            firstName: firstName,
            initial: initial,
            data: data,
            scopeId: scopeId,
          ),
          const SizedBox(height: 22),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: _ReportBanner(),
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Quick report',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w800,
                color: Color(0xFF102A43),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _QuickCategories(onTap: (_) => _openReport(context)),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SectionHeader(title: 'Recent reports', onSeeAll: onSeeAll),
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
                child: Text(
                  'No reports yet. Tap + to add one.',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
            )
          else
            ...recent.map((incident) => ReportCard(incident: incident)),
        ],
      ),
    );
  }

  static void _openReport(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const SubmitIncidentScreen()));
  }
}

class _StudentHeader extends StatelessWidget {
  final String firstName;
  final String initial;
  final IncidentProvider data;
  final String? scopeId;

  const _StudentHeader({
    required this.firstName,
    required this.initial,
    required this.data,
    required this.scopeId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF087F7D), Color(0xFF20AAA0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Good evening, $firstName',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Help keep our campus safe and running smoothly.',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.88),
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              CircleAvatar(
                radius: 27,
                backgroundColor: AppTheme.accent,
                child: Text(
                  initial,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 360;
              return Row(
                children: [
                  _HeaderMetric(
                    icon: Icons.description_rounded,
                    value: data.count(reporterId: scopeId),
                    label: 'My reports',
                    compact: compact,
                  ),
                  _HeaderMetric(
                    icon: Icons.assignment_rounded,
                    value: data.count(
                      status: IncidentStatus.submitted,
                      reporterId: scopeId,
                    ),
                    label: 'Submitted',
                    compact: compact,
                  ),
                  _HeaderMetric(
                    icon: Icons.autorenew_rounded,
                    value: data.count(
                      status: IncidentStatus.inProgress,
                      reporterId: scopeId,
                    ),
                    label: 'In progress',
                    compact: compact,
                  ),
                  _HeaderMetric(
                    icon: Icons.check_circle_rounded,
                    value: data.count(
                      status: IncidentStatus.resolved,
                      reporterId: scopeId,
                    ),
                    label: 'Resolved',
                    compact: compact,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _HeaderMetric extends StatelessWidget {
  final IconData icon;
  final int value;
  final String label;
  final bool compact;

  const _HeaderMetric({
    required this.icon,
    required this.value,
    required this.label,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: compact ? 18 : 20),
            SizedBox(height: compact ? 3 : 5),
            Text(
              '$value',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.86),
                fontSize: compact ? 9 : 10,
              ),
            ),
          ],
        ),
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
          colors: [AppTheme.accent, Color(0xFFFFA07F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -12,
            top: 10,
            child: Icon(
              Icons.campaign_rounded,
              size: 118,
              color: Colors.white.withValues(alpha: 0.2),
            ),
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
                    height: 1.15,
                  ),
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
                    onTap: () => HomeTab._openReport(context),
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: AppTheme.accent,
                            child: Icon(
                              Icons.add_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Report an issue',
                              style: TextStyle(
                                color: AppTheme.primary,
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: AppTheme.primary,
                          ),
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

class _QuickCategories extends StatelessWidget {
  final ValueChanged<String> onTap;

  const _QuickCategories({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 132,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: IncidentCategory.all.length,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (_, index) {
          final category = IncidentCategory.all[index];
          final color = IncidentCategory.colorFor(category);
          return GestureDetector(
            onTap: () => onTap(category),
            child: SizedBox(
              width: 92,
              child: Column(
                children: [
                  Container(
                    width: 78,
                    height: 78,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 14,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.13),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          IncidentCategory.iconFor(category),
                          color: color,
                          size: 29,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF102A43),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
