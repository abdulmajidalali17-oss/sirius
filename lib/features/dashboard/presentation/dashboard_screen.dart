import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/application/auth_providers.dart';
import 'theme/sirius_palette.dart';
import 'widgets/dashboard_sidebar.dart';
import 'widgets/dashboard_top_bar.dart';
import 'widgets/mobile_bottom_nav.dart';
import 'widgets/welcome_section.dart';
import 'widgets/how_sirius_works.dart';
import 'widgets/knowledge_map_preview.dart';
import 'widgets/discover_topics.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  DashboardSection _selectedSection = DashboardSection.dashboard;

  String get _userEmail {
    return ref.read(firebaseAuthProvider).currentUser?.email ??
        'you@example.com';
  }

  String get _userName {
    final email = _userEmail;

    if (email == 'you@example.com') {
      return 'Explorer';
    }

    return email.split('@').first;
  }

  String get _userInitial {
    return _userName.isNotEmpty ? _userName[0].toUpperCase() : 'S';
  }

  void _selectSection(DashboardSection section) {
    setState(() {
      _selectedSection = section;
    });
  }

  Future<void> _logout() async {
    try {
      await ref.read(authRepositoryProvider).signOut();
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Unable to sign out: $error')));
    }
  }

  void _openCreateMap() {
    _selectSection(DashboardSection.create);
  }

  void _exploreTopic(String topic) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Selected topic: $topic')));
  }

  String get _pageTitle {
    return _selectedSection.label;
  }

  Widget _buildDashboardContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WelcomeSection(onCreateMap: _openCreateMap),
        const SizedBox(height: 32),
        const HowSiriusWorks(),
        const SizedBox(height: 32),
        const KnowledgeMapPreview(),
        const SizedBox(height: 32),
        DiscoverTopics(onExploreTopic: _exploreTopic),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildOtherSection() {
    final section = _selectedSection;

    IconData icon;
    String description;

    switch (section) {
      case DashboardSection.dashboard:
        return _buildDashboardContent();

      case DashboardSection.maps:
        icon = Icons.account_tree_rounded;
        description = 'Your saved knowledge maps will appear here.';

      case DashboardSection.create:
        icon = Icons.add_circle_outline_rounded;
        description = 'Start with an idea and turn it into a knowledge map.';

      case DashboardSection.explore:
        icon = Icons.explore_outlined;
        description = 'Discover new topics and explore connected ideas.';

      case DashboardSection.activity:
        icon = Icons.history_rounded;
        description = 'Your recent activity will appear here.';

      case DashboardSection.settings:
        icon = Icons.settings_outlined;
        description = 'Manage your account and application preferences.';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: SiriusPalette.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: SiriusPalette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: SiriusPalette.electricBlue, size: 36),
          const SizedBox(height: 20),
          Text(
            section.label,
            style: const TextStyle(
              color: SiriusPalette.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(
              color: SiriusPalette.textSecondary,
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 900;

        return Scaffold(
          backgroundColor: SiriusPalette.navy,
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  SiriusPalette.navy,
                  SiriusPalette.navyLight,
                  SiriusPalette.card,
                ],
              ),
            ),
            child: Row(
              children: [
                if (isDesktop)
                  DashboardSidebar(
                    selected: _selectedSection,
                    onSelect: _selectSection,
                    onLogout: _logout,
                    userName: _userName,
                    userEmail: _userEmail,
                  ),
                Expanded(
                  child: Column(
                    children: [
                      DashboardTopBar(
                        title: _pageTitle,
                        userInitial: _userInitial,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.symmetric(
                            horizontal: isDesktop ? 32 : 20,
                            vertical: 28,
                          ),
                          child: _buildOtherSection(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: isDesktop
              ? null
              : MobileBottomNav(
                  selected: _selectedSection,
                  onSelect: _selectSection,
                ),
        );
      },
    );
  }
}
