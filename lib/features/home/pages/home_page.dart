import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../widgets/feature_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final user = FirebaseAuth.instance.currentUser;

    final displayName = user?.displayName?.trim().isNotEmpty == true
        ? user!.displayName!
        : user?.email?.split('@').first ?? 'there';

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            tooltip: l10n.profile,
            onPressed: () {
              showModalBottomSheet(
                context: context,
                showDragHandle: true,
                builder: (context) => _ProfileSheet(
                  user: user,
                ),
              );
            },
            icon: const Icon(Icons.account_circle_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              l10n.welcome(displayName),
              style: Theme.of(context).textTheme.headlineSmall,
            ),

            const SizedBox(height: 8),

            Text(
              l10n.chooseVisionTool,
              style: Theme.of(context).textTheme.bodyLarge,
            ),

            const SizedBox(height: 24),

            // Live Object Detector
            FeatureCard(
              icon: Icons.camera_alt_outlined,
              title: l10n.liveObjectDetector,
              description: l10n.liveObjectDetectorDescription,
              buttonText: l10n.startDetector,
              onPressed: () async {
                await FirebaseAnalytics.instance.logEvent(
                  name: 'feature_opened',
                  parameters: {
                    'feature': 'detector',
                  },
                );

                if (context.mounted) {
                  context.push('/detector');
                }
              },
            ),

            const SizedBox(height: 16),

            // AI Image Analyzer
            FeatureCard(
              icon: Icons.image_search_outlined,
              title: l10n.aiImageAnalyzer,
              description: l10n.aiImageAnalyzerDescription,
              buttonText: l10n.analyzeImage,
              onPressed: () async {
                await FirebaseAnalytics.instance.logEvent(
                  name: 'feature_opened',
                  parameters: {
                    'feature': 'analyzer',
                  },
                );

                if (context.mounted) {
                  context.push('/analyzer');
                }
              },
            ),

            const SizedBox(height: 24),

            // History
            Semantics(
              button: true,
              label: l10n.openHistory,
              hint: l10n.openHistoryHint,
              child: Card(
                elevation: 0,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    context.push('/history');
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primaryContainer,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.history_rounded,
                            size: 30,
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                        ),

                        const SizedBox(width: 16),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.history,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                l10n.openHistoryHint,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 8),

                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 18,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurfaceVariant,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _ProfileSheet extends StatelessWidget {
  final User? user;

  const _ProfileSheet({
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.profile,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.person),
              ),
              title: Text(
                user?.displayName ?? l10n.visionCompanionUser,
              ),
              subtitle: Text(
                user?.email ?? l10n.noEmailAvailable,
              ),
            ),

            const SizedBox(height: 12),

            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: Text(l10n.settings),
              onTap: () {
                Navigator.of(context).pop();
                context.push('/settings');
              },
            ),

            const SizedBox(height: 8),

            SizedBox(
              height: 48,
              child: OutlinedButton.icon(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();

                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
                icon: const Icon(Icons.logout),
                label: Text(l10n.signOut),
              ),
            ),
          ],
        ),
      ),
    );
  }
}