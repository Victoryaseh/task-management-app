import 'package:flutter/material.dart';

const Color kForestGreen = Color(0xFF228B22);

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;

  late TextEditingController _nameCtrl;
  late TextEditingController _matriculeCtrl;
  late TextEditingController _programmeCtrl;
  late TextEditingController _bioCtrl;
  late TextEditingController _goal1Ctrl;
  late TextEditingController _goal2Ctrl;
  late TextEditingController _goal3Ctrl;

  // Profile data
  String _name = 'Aseh Victory';
  String _matricule = 'LMUI2637001';
  String _programme = 'BSc Computer Science · Level 400';
  String _bio =
      'I am a final-year Computer Science student passionate about '
      'mobile development and building software that solves real-world problems. '
      'I enjoy learning new technologies, especially in the Flutter ecosystem, '
      'and I aim to build impactful applications that make everyday life easier.';
  String _goal1 =
      'Complete all coursework assignments on time and score above 80% in every module.';
  String _goal2 =
      'Build and publish a Flutter app on the Google Play Store before graduation.';
  String _goal3 =
      'Improve my problem-solving skills by solving at least 3 LeetCode problems per week.';

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _nameCtrl = TextEditingController(text: _name);
    _matriculeCtrl = TextEditingController(text: _matricule);
    _programmeCtrl = TextEditingController(text: _programme);
    _bioCtrl = TextEditingController(text: _bio);
    _goal1Ctrl = TextEditingController(text: _goal1);
    _goal2Ctrl = TextEditingController(text: _goal2);
    _goal3Ctrl = TextEditingController(text: _goal3);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _matriculeCtrl.dispose();
    _programmeCtrl.dispose();
    _bioCtrl.dispose();
    _goal1Ctrl.dispose();
    _goal2Ctrl.dispose();
    _goal3Ctrl.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    if (_isEditing) {
      // Save changes
      setState(() {
        _name = _nameCtrl.text.trim().isEmpty ? _name : _nameCtrl.text.trim();
        _matricule = _matriculeCtrl.text.trim().isEmpty ? _matricule : _matriculeCtrl.text.trim();
        _programme = _programmeCtrl.text.trim().isEmpty ? _programme : _programmeCtrl.text.trim();
        _bio = _bioCtrl.text.trim().isEmpty ? _bio : _bioCtrl.text.trim();
        _goal1 = _goal1Ctrl.text.trim().isEmpty ? _goal1 : _goal1Ctrl.text.trim();
        _goal2 = _goal2Ctrl.text.trim().isEmpty ? _goal2 : _goal2Ctrl.text.trim();
        _goal3 = _goal3Ctrl.text.trim().isEmpty ? _goal3 : _goal3Ctrl.text.trim();
        _isEditing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: kForestGreen,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      setState(() => _isEditing = true);
    }
  }

  void _cancelEdit() {
    setState(() {
      _nameCtrl.text = _name;
      _matriculeCtrl.text = _matricule;
      _programmeCtrl.text = _programme;
      _bioCtrl.text = _bio;
      _goal1Ctrl.text = _goal1;
      _goal2Ctrl.text = _goal2;
      _goal3Ctrl.text = _goal3;
      _isEditing = false;
    });
  }

  // Returns initials from the name
  String get _initials {
    final parts = _name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return _name.isNotEmpty ? _name[0].toUpperCase() : '?';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: kForestGreen,
        foregroundColor: Colors.white,
        actions: [
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.close),
              tooltip: 'Cancel',
              onPressed: _cancelEdit,
            ),
          IconButton(
            icon: Icon(_isEditing ? Icons.check : Icons.edit),
            tooltip: _isEditing ? 'Save' : 'Edit Profile',
            onPressed: _toggleEdit,
          ),
        ],
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
              child: Text(
                _initials,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Name
            _isEditing
                ? _EditField(controller: _nameCtrl, label: 'Full Name', icon: Icons.person)
                : Text(
                    _name,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
            const SizedBox(height: 8),

            // Matricule
            _isEditing
                ? _EditField(controller: _matriculeCtrl, label: 'Matricule', icon: Icons.badge)
                : Text(
                    'Matricule: $_matricule',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
            const SizedBox(height: 8),

            // Programme
            _isEditing
                ? _EditField(controller: _programmeCtrl, label: 'Programme', icon: Icons.school)
                : Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                    decoration: BoxDecoration(
                      color: kForestGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _programme,
                      style: const TextStyle(
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
              child: _isEditing
                  ? _EditField(
                      controller: _bioCtrl,
                      label: 'Bio',
                      icon: Icons.edit_note,
                      maxLines: 4,
                    )
                  : Text(
                      _bio,
                      style: const TextStyle(
                          fontSize: 14, height: 1.6, color: Colors.black87),
                    ),
            ),
            const SizedBox(height: 16),

            // Goals card
            _SectionCard(
              icon: Icons.flag_outlined,
              title: 'My Top 3 Goals This Semester',
              child: Column(
                children: [
                  _isEditing
                      ? _EditField(controller: _goal1Ctrl, label: 'Goal 1', icon: Icons.looks_one)
                      : _GoalItem(number: '1', text: _goal1),
                  const SizedBox(height: 10),
                  _isEditing
                      ? _EditField(controller: _goal2Ctrl, label: 'Goal 2', icon: Icons.looks_two)
                      : _GoalItem(number: '2', text: _goal2),
                  const SizedBox(height: 10),
                  _isEditing
                      ? _EditField(controller: _goal3Ctrl, label: 'Goal 3', icon: Icons.looks_3)
                      : _GoalItem(number: '3', text: _goal3),
                ],
              ),
            ),

            if (_isEditing) ...[
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _cancelEdit,
                      icon: const Icon(Icons.close, color: Colors.red),
                      label: const Text('Cancel',
                          style: TextStyle(color: Colors.red)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _toggleEdit,
                      icon: const Icon(Icons.check),
                      label: const Text('Save'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kForestGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// Reusable editable text field
class _EditField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final int maxLines;

  const _EditField({
    required this.controller,
    required this.label,
    required this.icon,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: kForestGreen),
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: kForestGreen, width: 2),
          ),
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
            style: const TextStyle(
                fontSize: 14, height: 1.5, color: Colors.black87),
          ),
        ),
      ],
    );
  }
}
