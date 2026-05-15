import 'package:flutter/material.dart';
import '../models/task.dart';

const Color kForestGreen = Color(0xFF228B22);

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final VoidCallback onToggle;

  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
    required this.onToggle,
  });

  Color _priorityColor() {
    switch (task.priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  IconData _categoryIcon() {
    switch (task.category) {
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
      !task.isCompleted && task.dueDate.isBefore(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: _isOverdue ? Colors.red[50] : Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Priority color bar
              Container(
                width: 5,
                height: 60,
                decoration: BoxDecoration(
                  color: _priorityColor(),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 12),
              // Category icon
              Icon(_categoryIcon(), color: kForestGreen, size: 28),
              const SizedBox(width: 12),
              // Task info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        color: task.isCompleted ? Colors.grey : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      task.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: _priorityColor().withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            task.priority,
                            style: TextStyle(
                              fontSize: 10,
                              color: _priorityColor(),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          Icons.calendar_today,
                          size: 11,
                          color: _isOverdue ? Colors.red : Colors.grey,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}',
                          style: TextStyle(
                            fontSize: 11,
                            color: _isOverdue ? Colors.red : Colors.grey[600],
                            fontWeight: _isOverdue ? FontWeight.bold : null,
                          ),
                        ),
                        if (_isOverdue) ...[
                          const SizedBox(width: 4),
                          const Text(
                            'OVERDUE',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              // Checkbox
              Checkbox(
                value: task.isCompleted,
                onChanged: (_) => onToggle(),
                activeColor: kForestGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
