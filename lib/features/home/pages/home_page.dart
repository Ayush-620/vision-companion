import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/feature_card.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    final displayName = user?.displayName?.trim().isNotEmpty == true
        ? user!.displayName!
        : user?.email?.split('@').first ?? 'there';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vision Companion'),
        actions: [
          IconButton(
            tooltip: 'Profile',
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
              'Welcome, $displayName 👋',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Choose a vision tool to get started.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),

            FeatureCard(
              icon: Icons.camera_alt_outlined,
              title: 'Live Object Detector',
              description:
                  'Use your camera to detect objects in real time.',
              buttonText: 'Start Detector',
             onPressed: () {
  context.push('/detector');
},
            ),

            const SizedBox(height: 16),

            FeatureCard(
              icon: Icons.image_search_outlined,
              title: 'AI Image Analyzer',
              description:
                  'Capture an image and get an AI-powered description.',
              buttonText: 'Analyze Image',
                   onPressed: () {
                   context.go('/analyzer');
             },
            ),
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
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Profile',
              style: TextStyle(
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
                user?.displayName ?? 'Vision Companion User',
              ),
              subtitle: Text(
                user?.email ?? 'No email available',
              ),
            ),
            const SizedBox(height: 12),
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
                label: const Text('Sign Out'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}