import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_portfolio/controllers/contact_controller.dart';
import 'package:flutter_portfolio/controllers/skill_controller.dart';
import 'package:flutter_portfolio/controllers/stats_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';

class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ডাটা রিফ্রেশ করুন
    WidgetsBinding.instance.addPostFrameCallback((_) {
      StatsController.to.refreshDashCounts();
    });

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Dashboard Overview', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 6),
          Text('Welcome back, Admin!', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 32),
          Obx(() {
            final counts = StatsController.to.dashCounts;
            print('Overview counts: $counts'); // Debug
            if (counts.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.cyan),
              );
            }
            return _StatsGrid(counts: counts);
          }),
          const SizedBox(height: 32),
          LayoutBuilder(builder: (context, constraints) {
            final wide = constraints.maxWidth > 700;
            if (wide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: _SkillsChart()),
                  const SizedBox(width: 24),
                  Expanded(flex: 2, child: _RecentMessages()),
                ],
              );
            }
            return Column(
              children: [
                _SkillsChart(),
                const SizedBox(height: 24),
                _RecentMessages(),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final Map<String, int> counts;
  const _StatsGrid({required this.counts});

  @override
  Widget build(BuildContext context) {
    final items = [
      _DashStat(
        label: 'Total Projects',
        value: (counts['projects'] ?? 0).toString(),
        icon: Icons.phone_android_rounded,
        color: AppColors.cyan,
        trend: '+2 this month',
      ),
      _DashStat(
        label: 'Skills Listed',
        value: (counts['skills'] ?? 0).toString(),
        icon: Icons.code_rounded,
        color: AppColors.purple,
        trend: 'Up to date',
      ),
      _DashStat(
        label: 'Blog Articles',
        value: (counts['blogs'] ?? 0).toString(),
        icon: Icons.article_rounded,
        color: AppColors.green,
        trend: '+1 this week',
      ),
      _DashStat(
        label: 'Unread Messages',
        value: (counts['unreadMessages'] ?? 0).toString(),
        icon: Icons.mark_email_unread_rounded,
        color: const Color(0xFFFFB800),
        trend: 'Pending reply',
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 280,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.6,
      ),
      itemCount: items.length,
      itemBuilder: (_, i) => _DashStatCard(stat: items[i], index: i),
    );
  }
}

class _DashStat {
  final String label, value, trend;
  final IconData icon;
  final Color color;
  _DashStat({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.trend,
  });
}

class _DashStatCard extends StatelessWidget {
  final _DashStat stat;
  final int index;
  const _DashStatCard({required this.stat, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: stat.color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: stat.color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(stat.icon, color: stat.color, size: 18),
              ),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: stat.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    stat.trend,
                    style: GoogleFonts.spaceGrotesk(
                      color: stat.color,
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  stat.value,
                  style: GoogleFonts.spaceGrotesk(
                    color: AppColors.textPrimary,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                stat.label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 11),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ],
      ),
    ).animate(delay: (index * 80).ms).fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0);
  }
}

class _SkillsChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Top Skills', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 18)),
          const SizedBox(height: 4),
          Text('Proficiency levels', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 24),
          Obx(() {
            final skills = SkillController.to.skills.take(6).toList();
            if (skills.isEmpty) {
              return const SizedBox(
                height: 200,
                child: Center(
                  child: Text('No skills added yet',
                      style: TextStyle(color: AppColors.textMuted)),
                ),
              );
            }
            return SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: skills.length,
                itemBuilder: (_, i) => Container(
                  width: 120,
                  margin: const EdgeInsets.only(right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(skills[i].name,
                          style: GoogleFonts.spaceGrotesk(
                              color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: 60,
                            height: skills[i].proficiency.toDouble() * 1.5,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [AppColors.purple, AppColors.cyan],
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('${skills[i].proficiency}%',
                          style: GoogleFonts.jetBrainsMono(color: AppColors.cyan)),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0);
  }
}

class _RecentMessages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recent Messages',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 18)),
          const SizedBox(height: 4),
          Text('Latest contact submissions', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 20),
          Obx(() {
            final contacts = ContactController.to.contacts.take(5).toList();
            if (contacts.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: Text('No messages yet',
                      style: TextStyle(color: AppColors.textMuted)),
                ),
              );
            }
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: contacts.length,
              separatorBuilder: (_, __) => const Divider(color: AppColors.border, height: 1),
              itemBuilder: (_, i) {
                final c = contacts[i];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  leading: CircleAvatar(
                    backgroundColor: AppColors.cyanDim,
                    child: Text(
                      c.name.isNotEmpty ? c.name[0].toUpperCase() : '?',
                      style: const TextStyle(color: AppColors.cyan, fontWeight: FontWeight.w700),
                    ),
                  ),
                  title: Text(
                    c.name,
                    style: GoogleFonts.spaceGrotesk(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  subtitle: Text(
                    c.subject,
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: !c.read
                      ? Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(color: AppColors.cyan, shape: BoxShape.circle),
                  )
                      : null,
                );
              },
            );
          }),
        ],
      ),
    ).animate(delay: 200.ms).fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0);
  }
}