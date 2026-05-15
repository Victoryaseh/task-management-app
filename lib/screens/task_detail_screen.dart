import 'package:flutter/material.dart';
import '../models/task.dart';

const Color kForestGreen = Color(0xFF228B22);

class TaskDetailScreen extends StatefulWidget {
  final Task task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  // Local copy of isCompleted so the UI updates immediately on toggle.
  // widget.task is mutated in place so the task list also reflects the change.
  late bool _isCompleted;

  @override
  void initState() {
    super.initState();
    _isCompleted = widget.task.isCompleted;
  }

  void _toggleComplete() {
    setState(() {
      _isCompleted = !_isCompleted;
      widget.task.isCompleted = _isCompleted;
    });
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Task'),
        content: Text('Delete "${widget.task.title}"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context, 'delete');
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Color _priorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  IconData _categoryIcon(String category) {
    switch (category) {
      case 'School':
        return Icons.school;
      case 'Health':
        return Icons.favorite;
      case 'Work':
        return Icons.work;
      default:
        return Icons.person;
    }
  }

  bool get _isOverdue =>
      !_isCompleted &&
      widget.task.dueDate.isBefore(DateTime.now());

  @override
  Widget build(BuildContext context) {
    final task = widget.task;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Detail'),
        backgroundColor: kForestGreen,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit',
            onPressed: () => Navigator.pop(context, 'edit'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title row with completion indicator
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      decoration:
                          _isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _isCompleted
                        ? Colors.green[50]
                        : Colors.orange[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _isCompleted ? Colors.green : Colors.orange,
                    ),
                  ),
                  child: Text(
                    _isCompleted ? 'Completed' : 'Pending',
                    style: TextStyle(
                      color: _isCompleted ? Colors.green[700] : Colors.orange[700],
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Info cards
            _DetailRow(
              icon: _categoryIcon(task.category),
              label: 'Category',
              value: task.category,
              iconColor: kForestGreen,
            ),
            _DetailRow(
              icon: Icons.flag,
              label: 'Priority',
              value: task.priority,
              iconColor: _priorityColor(task.priority),
              valueColor: _priorityColor(task.priority),
            ),
            _DetailRow(
              icon: Icons.calendar_today,
              label: 'Due Date',
              value:
                  '${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}',
              iconColor: _isOverdue ? Colors.red : kForestGreen,
              valueColor: _isOverdue ? Colors.red : null,
              suffix: _isOverdue
                  ? const Text(
                      ' · OVERDUE',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: 16),
            // Description
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    task.description,
                    style: const TextStyle(fontSize: 15, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Toggle complete button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _isCompleted ? Colors.orange : kForestGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _toggleComplete,
                icon: Icon(
                  _isCompleted ? Icons.undo : Icons.check_circle_outline,
                ),
                label: Text(
                  _isCompleted ? 'Mark as Incomplete' : 'Mark as Complete',
                  style: const TextStyle(fontSize: 15),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Delete button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _confirmDelete,
                icon: const Icon(Icons.delete_outline),
                label: const Text('Delete Task', style: TextStyle(fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;
  final Color? valueColor;
  final Widget? suffix;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
    this.valueColor,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: valueColor ?? Colors.black87,
            ),
          ),
          ?suffix,
        ],
      ),
    );
  }
}
