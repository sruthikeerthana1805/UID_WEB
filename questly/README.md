# Questly – Gamified Student Productivity App

## 1. Project Name
**Questly** – turn your tasks into quests.

## 2. Project Objective
A Flutter UID lab project that converts a student's academic tasks into
game-like quests. Completing quests earns XP, levels, streaks and
achievements. The goal is to demonstrate good UI, good UX, core Flutter
concepts and meaningful animations using only local, in-memory data.

## 3. Features
- Animated splash screen
- Home dashboard: level, XP bar, streak, quick stats, today's quests
- Quests list with All / Pending / Done filter; tap a quest to complete it
- Add Quest form with validation
- Progress dashboard (animated level bar + completion ring)
- Achievements (locked / unlocked, unlock celebration)
- Profile screen
- Bottom navigation (side navigation rail on tablet / web)

## 4. Technologies Used
Flutter, Dart (null safety), Material 3. No packages, no backend.

## 5. Flutter Concepts Demonstrated
- **StatelessWidget** – `QuestlyApp`, `StatCard`, `LevelBadge`, `StreakCard`, `XPProgressBar`, `AnimatedXP`, `HomeScreen`, `ProgressScreen`
- **StatefulWidget** – `SplashScreen`, `MainShell`, `QuestsScreen`, `AddQuestScreen`, `QuestCard`, `AchievementCard`
- **Custom Widgets** – everything in `lib/widgets/`
- **Navigation** – `Navigator.push` with a custom route, `pushReplacement` from the splash, bottom navigation between tabs
- **Forms** – `Form`, `GlobalKey<FormState>`, `TextFormField`, `FormField`, `SegmentedButton`, `showDatePicker`
- **Validation** – validators for title, subject, deadline and XP reward
- **Animations** – see below
- **Lists** – `ListView.builder`, `ListView`, `Wrap`, list/collection `for`
- **Responsive UI** – `LayoutBuilder`, `Expanded`, `ConstrainedBox`, `SafeArea`, `ResponsiveWrap`, `NavigationRail` on wide screens
- **Material 3** – `useMaterial3`, `ColorScheme.fromSeed`, `NavigationBar`, `FilledButton`, `SegmentedButton`, `ChoiceChip`
- **Dart OOP** – classes, constructors, named parameters, enums (`Priority`, `QuestStatus`), extensions, getters, `ChangeNotifier`, null safety

## 6. Animation Concepts Demonstrated
| Animation | Where | API |
|---|---|---|
| Logo fade + scale | Splash | `AnimationController`, `FadeTransition`, `ScaleTransition`, `Interval` |
| Page transition | Splash → app, Add Quest | `PageRouteBuilder`, `SlideTransition` |
| Tab switch fade | Main shell | `AnimatedSwitcher` |
| Quest completion (check, card pulse, colour change, floating +XP) | `QuestCard` | `AnimationController`, `AnimatedBuilder`, `AnimatedContainer`, `AnimatedSwitcher` |
| XP bar fill | `XPProgressBar` | `TweenAnimationBuilder` |
| XP number counting | `AnimatedXP` | `TweenAnimationBuilder` |
| Completion ring | Progress | `TweenAnimationBuilder` |
| Achievement unlock (scale, bounce, rotate, star burst) | `AchievementCard` | `AnimationController`, `Transform` |

## 7. Folder Structure
```
lib/
  main.dart
  animations/  page_transitions.dart
  data/        app_state.dart, sample_data.dart
  models/      quest.dart, achievement.dart, student_profile.dart
  screens/     splash, main_shell, home, quests, add_quest, progress, achievements, profile
  theme/       app_theme.dart
  utils/       format.dart
  widgets/     xp_progress_bar, quest_card, achievement_card, stat_card,
               level_badge, streak_card, animated_xp, app_bottom_navigation,
               responsive_wrap, screen_header, quest_actions
test/          widget_test.dart
```

## 8. How to Run
Requires Flutter 3.27 or newer (Dart 3.6+).

```bash
cd questly
flutter create .        # generates android/ios/web folders (keeps lib/ and pubspec.yaml)
flutter pub get
flutter run             # or: flutter run -d chrome
```

## Game rules
- Every level needs 250 XP (`StudentProfile.xpPerLevel`).
- Completing the sample quests reaches Level 6 and unlocks new achievements,
  which is a good way to show the animations during a demo.
- Sample data lives in `lib/data/sample_data.dart` and is easy to replace.
