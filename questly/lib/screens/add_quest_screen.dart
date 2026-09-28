import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/app_state.dart';
import '../models/quest.dart';
import '../theme/app_theme.dart';

/// A form to create a new quest, with validation on every field.
class AddQuestScreen extends StatefulWidget {
  const AddQuestScreen({super.key, required this.state});

  final AppState state;

  @override
  State<AddQuestScreen> createState() => _AddQuestScreenState();
}

class _AddQuestScreenState extends State<AddQuestScreen> {
  static const List<String> _subjects = [
    'DBMS',
    'CN',
    'DSA',
    'OS',
    'Flutter',
    'Other',
  ];

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _xpController = TextEditingController(text: '50');

  String? _subject;
  DateTime? _deadline;
  Priority _priority = Priority.medium;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _xpController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(FormFieldState<DateTime> field) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: _deadline ?? today,
      firstDate: today,
      lastDate: today.add(const Duration(days: 730)),
    );
    if (picked != null) {
      setState(() => _deadline = picked);
      field.didChange(picked);
    }
  }

  void _submit() {
    // validate() runs every validator and shows the error messages.
    if (!_formKey.currentState!.validate()) return;

    final quest = Quest(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      subject: _subject!,
      description: _descriptionController.text.trim(),
      deadline: _deadline!,
      priority: _priority,
      xpReward: int.parse(_xpController.text),
    );
    widget.state.addQuest(quest);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('✅ Quest "${quest.title}" added!')),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Quest'),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    TextFormField(
                      controller: _titleController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: AppTheme.inputDecoration(
                          'Quest title', Icons.edit_note),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a quest title.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Subject: chips inside a FormField so it can be validated.
                    FormField<String>(
                      validator: (value) =>
                          value == null ? 'Please select a subject.' : null,
                      builder: (field) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Subject',
                              style: TextStyle(color: Colors.white70)),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              for (final subject in _subjects)
                                ChoiceChip(
                                  label: Text(subject),
                                  selected: _subject == subject,
                                  onSelected: (_) {
                                    setState(() => _subject = subject);
                                    field.didChange(subject);
                                  },
                                ),
                            ],
                          ),
                          if (field.hasError)
                            Padding(
                              padding: const EdgeInsets.only(top: 6, left: 4),
                              child: Text(
                                field.errorText!,
                                style: const TextStyle(
                                    color: AppTheme.danger, fontSize: 12),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 3,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: AppTheme.inputDecoration(
                          'Description (optional)', Icons.notes),
                    ),
                    const SizedBox(height: 16),

                    // Deadline: opens the date picker.
                    FormField<DateTime>(
                      validator: (value) =>
                          value == null ? 'Please pick a deadline.' : null,
                      builder: (field) => InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () => _pickDate(field),
                        child: InputDecorator(
                          decoration:
                              AppTheme.inputDecoration('Deadline', Icons.event)
                                  .copyWith(errorText: field.errorText),
                          child: Text(
                            _deadline == null
                                ? 'Tap to choose a date'
                                : '${_deadline!.day}/${_deadline!.month}/${_deadline!.year}',
                            style: TextStyle(
                              color: _deadline == null
                                  ? Colors.white54
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    const Text('Priority',
                        style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 8),
                    SegmentedButton<Priority>(
                      segments: [
                        for (final priority in Priority.values)
                          ButtonSegment(
                            value: priority,
                            label: Text(priority.label),
                          ),
                      ],
                      selected: {_priority},
                      onSelectionChanged: (selection) =>
                          setState(() => _priority = selection.first),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _xpController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: AppTheme.inputDecoration(
                          'XP reward', Icons.bolt),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter an XP reward.';
                        }
                        final xp = int.tryParse(value);
                        if (xp == null || xp < 5 || xp > 200) {
                          return 'XP must be between 5 and 200.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    FilledButton.icon(
                      onPressed: _submit,
                      icon: const Icon(Icons.rocket_launch),
                      label: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: Text('Create Quest',
                            style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
