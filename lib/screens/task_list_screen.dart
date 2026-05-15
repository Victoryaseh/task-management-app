import 'package:flutter/material.dart';
import '../models/task.dart';
import '../widgets/task_card.dart';
import 'task_detail_screen.dart';

const Color kForestGreen = Color(0xFF228B22);

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final List<Task> _tasks = [
    Task(
      title: 'Complete Flutter Assignment',
      description: 'Build the personal task manager app for the Mobile App Development course.',
      category: 'School',
      priority: 'High',
      dueDate: DateTime.now().add(const Duration(days: 1)),
    ),
    Task(
      title: 'Morning Jog',
      description: 'Run 5 km around the campus to keep fit.',
      category: 'Health',
      priority: 'Medium',
      dueDate: DateTime.now().add(const Duration(days: 2)),
    ),
    Task(
      title: 'Read Algorithm Notes',
      description: 'Review chapter 5 on sorting algorithms before the upcoming test.',
      category: 'School',
      priority: 'Low',
      dueDate: DateTime.now().subtract(const Duration(days: 1)),
      isCompleted: true,
    ),
  ];

  String _filterOption = 'All';
  String _sortOption = 'None';
  String _searchQuery = '';
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  List<Task> get _filteredTasks {
    List<Task> result = List.from(_tasks);

    if (_searchQuery.isNotEmpty) {
      result = result
          .where((t) => t.title.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    if (_filterOption == 'Pending') {
      result = result.where((t) => !t.isCompleted).toList();
    } else if (_filterOption == 'Completed') {
      result = result.where((t) => t.isCompleted).toList();
    }

    if (_sortOption == 'Due Date') {
      result.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    } else if (_sortOption == 'Priority') {
      const order = {'High': 0, 'Medium': 1, 'Low': 2};
      result.sort((a, b) => (order[a.priority] ?? 1).compareTo(order[b.priority] ?? 1));
    }

    return result;
  }

  void _deleteTask(Task task) {
    setState(() => _tasks.remove(task));
  }

  void _toggleComplete(Task task) {
    setState(() => task.isCompleted = !task.isCompleted);
  }

  void _showTaskForm({Task? existing}) {
    final titleCtrl = TextEditingController(text: existing?.title ?? '');
    final descCtrl = TextEditingController(text: existing?.description ?? '');
    String category = existing?.category ?? 'School';
    String priority = existing?.priority ?? 'Medium';
    DateTime dueDate = existing?.dueDate ?? DateTime.now().add(const Duration(days: 1));
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (_, setSheet) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    existing == null ? 'Add New Task' : 'Edit Task',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: kForestGreen,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: titleCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.title),
                    ),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Title is required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: descCtrl,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.description),
                    ),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Description is required' : null,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: category,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.category),
                    ),
                    items: ['School', 'Personal', 'Health', 'Work']
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) setSheet(() => category = v);
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: priority,
                    decoration: const InputDecoration(
                      labelText: 'Priority',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.flag),
                    ),
                    items: ['Low', 'Medium', 'High']
                        .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) setSheet(() => priority = v);
                    },
                  ),
                  const SizedBox(height: 12),
                  // Due date picker row
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[400]!),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.calendar_today, color: kForestGreen),
                      title: Text(
                        'Due: ${dueDate.day}/${dueDate.month}/${dueDate.year}',
                        style: const TextStyle(fontSize: 15),
                      ),
                      trailing: TextButton(
                        child: const Text('Change',
                            style: TextStyle(color: kForestGreen)),
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: ctx,
                            initialDate: dueDate,
                            firstDate: DateTime(2024),
                            lastDate: DateTime(2030),
                          );
                          if (picked != null) setSheet(() => dueDate = picked);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kForestGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          setState(() {
                            if (existing != null) {
                              existing.title = titleCtrl.text.trim();
                              existing.description = descCtrl.text.trim();
                              existing.category = category;
                              existing.priority = priority;
                              existing.dueDate = dueDate;
                            } else {
                              _tasks.add(Task(
                                title: titleCtrl.text.trim(),
                                description: descCtrl.text.trim(),
                                category: category,
                                priority: priority,
                                dueDate: dueDate,
                              ));
                            }
                          });
                          Navigator.pop(ctx);
                        }
                      },
                      child: Text(
                        existing == null ? 'Add Task' : 'Save Changes',
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showSortDialog() {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Sort By'),
        children: [
          _buildSortChip('Due Date (Earliest First)', 'Due Date', ctx),
          _buildSortChip('Priority (High → Low)', 'Priority', ctx),
          _buildSortChip('None', 'None', ctx),
        ],
      ),
    );
  }

  Widget _buildSortChip(String label, String value, BuildContext ctx) {
    return SimpleDialogOption(
      onPressed: () {
        setState(() => _sortOption = value);
        Navigator.pop(ctx);
      },
      child: Row(
        children: [
          Icon(
            _sortOption == value ? Icons.radio_button_checked : Icons.radio_button_off,
            color: kForestGreen,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }

  void _confirmClearAll() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear All Tasks'),
        content: const Text(
            'Are you sure you want to delete all tasks? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () {
              setState(() => _tasks.clear());
              Navigator.pop(ctx);
            },
            child: const Text('Delete All'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsBar() {
    final total = _tasks.length;
    final completed = _tasks.where((t) => t.isCompleted).length;
    final pending = total - completed;
    final progress = total == 0 ? 0.0 : completed / total;

    return Container(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _statItem('Total', total, Colors.blue[700]!),
              _statItem('Done', completed, kForestGreen),
              _statItem('Pending', pending, Colors.orange[700]!),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              color: kForestGreen,
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${(progress * 100).toStringAsFixed(0)}% complete',
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _statItem(String label, int count, Color color) {
    return Column(
      children: [
        Text('$count',
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: color)),
        Text(label,
            style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayed = _filteredTasks;

    return Scaffold(
      appBar: _isSearching
          ? AppBar(
              backgroundColor: kForestGreen,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => setState(() {
                  _isSearching = false;
                  _searchQuery = '';
                  _searchController.clear();
                }),
              ),
              title: TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                decoration: const InputDecoration(
                  hintText: 'Search tasks...',
                  hintStyle: TextStyle(color: Colors.white60),
                  border: InputBorder.none,
                ),
                onChanged: (v) => setState(() => _searchQuery = v),
              ),
            )
          : AppBar(
              title: const Text('My Tasks'),
              backgroundColor: kForestGreen,
              foregroundColor: Colors.white,
              actions: [
                IconButton(
                  icon: const Icon(Icons.search),
                  tooltip: 'Search',
                  onPressed: () => setState(() => _isSearching = true),
                ),
                IconButton(
                  icon: const Icon(Icons.sort),
                  tooltip: 'Sort',
                  onPressed: _showSortDialog,
                ),
                IconButton(
                  icon: const Icon(Icons.delete_sweep),
                  tooltip: 'Clear All',
                  onPressed: _tasks.isEmpty ? null : _confirmClearAll,
                ),
              ],
            ),
      body: Column(
        children: [
          _buildStatsBar(),
          // Filter chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: ['All', 'Pending', 'Completed'].map((option) {
                final selected = _filterOption == option;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(
                      option,
                      style: TextStyle(
                        color: selected ? Colors.white : Colors.black87,
                        fontWeight: selected ? FontWeight.w600 : null,
                      ),
                    ),
                    selected: selected,
                    selectedColor: kForestGreen,
                    checkmarkColor: Colors.white,
                    backgroundColor: Colors.grey[100],
                    onSelected: (_) => setState(() => _filterOption = option),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 6),
          // Task list
          Expanded(
            child: displayed.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox_outlined,
                            size: 72, color: Colors.grey[300]),
                        const SizedBox(height: 12),
                        Text(
                          _searchQuery.isNotEmpty
                              ? 'No tasks match your search.'
                              : _filterOption == 'All'
                                  ? 'No tasks yet.\nTap + to add your first task!'
                                  : 'No $_filterOption tasks.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[500],
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: displayed.length,
                    padding: const EdgeInsets.only(bottom: 88),
                    itemBuilder: (context, index) {
                      final task = displayed[index];
                      return Dismissible(
                        key: ValueKey(task),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 24),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: const Icon(Icons.delete,
                              color: Colors.white, size: 28),
                        ),
                        onDismissed: (_) => _deleteTask(task),
                        child: TaskCard(
                          task: task,
                          onTap: () async {
                            final result = await Navigator.push<String>(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    TaskDetailScreen(task: task),
                              ),
                            );
                            if (result == 'delete') {
                              setState(() => _tasks.remove(task));
                            } else if (result == 'edit') {
                              _showTaskForm(existing: task);
                            } else {
                              // Refresh UI to reflect any toggle done in detail screen
                              setState(() {});
                            }
                          },
                          onToggle: () => _toggleComplete(task),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTaskForm(),
        backgroundColor: kForestGreen,
        foregroundColor: Colors.white,
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
    );
  }
}
