import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../repository/history_repository.dart';

class HistoryPage extends StatelessWidget {
  final HistoryRepository repository;

  const HistoryPage({
    super.key,
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: repository.watchHistory(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Unable to load history.\n\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final documents = snapshot.data?.docs ?? [];

          if (documents.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'No history yet.\nUse the detector or analyzer to create your first result.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: documents.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final data = documents[index].data();

              final featureType =
                  data['featureType'] as String? ?? 'unknown';

              final resultSummary =
                  data['resultSummary'] as String? ?? '';

              final timestamp =
                  data['timestamp'] as Timestamp?;

              final dateText = timestamp == null
                  ? 'Time unavailable'
                  : _formatTimestamp(timestamp);

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            featureType == 'analyzer'
                                ? Icons.image_search_outlined
                                : Icons.camera_alt_outlined,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _featureTitle(featureType),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(resultSummary),
                      const SizedBox(height: 12),
                      Text(
                        dateText,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  static String _featureTitle(String featureType) {
    switch (featureType) {
      case 'analyzer':
        return 'AI Image Analyzer';
      case 'detector':
        return 'Live Object Detector';
      default:
        return 'Vision Result';
    }
  }

  static String _formatTimestamp(Timestamp timestamp) {
    final date = timestamp.toDate();

    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();

    final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';

    return '$day/$month/$year • $hour:$minute $period';
  }
}