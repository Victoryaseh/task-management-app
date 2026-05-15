import 'package:flutter/material.dart';

const Color kForestGreen = Color(0xFF228B22);

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: kForestGreen,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            // Avatar
            CircleAvatar(
              radius: 55,
              backgroundColor: kForestGreen,
              child: const Text(
                'AV',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Name
            const Text(
              'Aseh Victory',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            // Student ID
            Text(
              'Matricule: LMUI2637001',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 4),
            // Programme
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(
                color: kForestGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'BSc Computer Science · Level 400',
                style: TextStyle(
                  color: kForestGreen,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(height: 28),
            // Bio card
            _SectionCard(
              icon: Icons.info_outline,
              title: 'About Me',
              child: const Text(
                'I am a final-year Computer Science student passionate about '
                'mobile development and building software that solves real-world problems. '
                'I enjoy learning new technologies, especially in the Flutter ecosystem, '
                'and I aim to build impactful applications that make everyday life easier.',
                style: TextStyle(fontSize: 14, height: 1.6, color: Colors.black87),
              ),
            ),
            const SizedBox(height: 16),
            // Goals card
            _SectionCard(
              icon: Icons.flag_outlined,
              title: 'My Top 3 Goals This Semester',
              child: Column(
                children: const [
                  _GoalItem(
                    number: '1',
                    text: 'Complete all coursework assignments on time and score above 80% in every module.',
                  ),
                  SizedBox(height: 10),
                  _GoalItem(
                    number: '2',
                    text: 'Build and publish a Flutter app on the Google Play Store before graduation.',
                  ),
                  SizedBox(height: 10),
                  _GoalItem(
                    number: '3',
                    text: 'Improve my problem-solving skills by solving at least 3 LeetCode problems per week.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const _SectionCard({
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: kForestGreen, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: kForestGreen,
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          child,
        ],
      ),
    );
  }
}

class _GoalItem extends StatelessWidget {
  final String number;
  final String text;

  const _GoalItem({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: kForestGreen,
          child: Text(
            number,
            style: const TextStyle(
                color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, height: 1.5, color: Colors.black87),
          ),
        ),
      ],
    );
  }
}
