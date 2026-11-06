import 'package:flutter/material.dart';
import '../models/incident.dart';
import '../screens/incident_details_screen.dart';
import '../utils/format.dart';
import 'app_card.dart';
import 'incident_thumb.dart';
import 'status_chip.dart';

class ReportCard extends StatelessWidget {
  final Incident incident;
  final EdgeInsetsGeometry margin;

  const ReportCard({
    super.key,
    required this.incident,
    this.margin = const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: margin,
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => IncidentDetailsScreen(incidentId: incident.id),
        ),
      ),
      child: Row(
        children: [
          IncidentThumb(incident: incident, size: 56),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  incident.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 15),
                ),
                const SizedBox(height: 2),
                Text(
                  '${incident.category} · ${incident.location}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.schedule, size: 14, color: Colors.grey.shade500),
                    const SizedBox(width: 4),
                    Text(
                      timeAgo(incident.createdAt),
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          StatusChip(status: incident.status),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}