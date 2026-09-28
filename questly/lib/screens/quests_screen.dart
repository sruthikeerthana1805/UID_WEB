import 'package:flutter/material.dart';

import '../animations/page_transitions.dart';
import '../data/app_state.dart';
import '../widgets/quest_actions.dart';
import '../widgets/quest_card.dart';
import '../widgets/screen_header.dart';
import 'add_quest_screen.dart';

enum QuestFilter { all, pending, completed }

/// Lists every quest with a filter and a floating "Add Quest" button.
class QuestsScreen extends StatefulWidget {
  const QuestsScreen({super.key, required this.state});

  final AppState state;

  @override
  State<QuestsScreen> createState() => _QuestsScreenState();
}

class _QuestsScreenState extends State<QuestsScreen> {
  QuestFilter _filter = QuestFilter.all;

  void _openAddQuest() {
    Navigator.of(context).push(
      FadeSlideRoute<void>(page: AddQuestScreen(state: widget.state)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddQuest,
        icon: const Icon(Icons.add),
        label: const Text('Add Quest'),
      ),
      body: ListenableBuilder(
        listenable: widget.state,
        builder: (context, child) {
          final all = widget.state.quests;
          final quests = all.where((quest) {
            switch (_filter) {
              case QuestFilter.all:
                return true;
              case QuestFilter.pending:
                return !quest.isCompleted;
              case QuestFilter.completed:
                return quest.isCompleted;
            }
          }).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: ScreenHeader(
                  title: 'Quests',
                  subtitle: '${widget.state.pendingCount} active  •  '
                      '${widget.state.completedCount} completed. Tap a quest to finish it.',
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: SegmentedButton<QuestFilter>(
                  showSelectedIcon: false,
                  segments: const [
                    ButtonSegment(value: QuestFilter.all, label: Text('All')),
                    ButtonSegment(
                        value: QuestFilter.pending, label: Text('Pending')),
                    ButtonSegment(
                        value: QuestFilter.completed, label: Text('Done')),
                  ],
                  selected: {_filter},
                  onSelectionChanged: (selection) =>
                      setState(() => _filter = selection.first),
                ),
              ),
              Expanded(
                child: quests.isEmpty
                    ? const Center(
                        child: Text(
                          'No quests here yet.',
                          style: TextStyle(color: Colors.white60),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 96),
                        itemCount: quests.length,
                        itemBuilder: (context, index) {
                          final quest = quests[index];
                          return QuestCard(
                            key: ValueKey(quest.id),
                            quest: quest,
                            onTap: () => completeQuestWithFeedback(
                                context, widget.state, quest),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
