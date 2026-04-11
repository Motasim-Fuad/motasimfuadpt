import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_theme.dart';
import 'firebase_services.dart';

class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Dashboard Overview',
              style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 6),
          Text('Welcome back, Admin!',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 32),

          // Stats cards
          FutureBuilder<Map<String, int>>(
            future: FirebaseService().getDashboardCounts(),
            builder: (context, snapshot) {
              final counts = snapshot.data ??
                  {
                    'projects': 0,
                    'skills': 0,
                    'blogs': 0,
                    'unreadMessages': 0
                  };
              return _StatsGrid(counts: counts);
            },
          ),

          const SizedBox(height: 32),

          // Charts row
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
        value: counts['projects'].toString(),
        icon: Icons.phone_android_rounded,
        color: AppColors.cyan,
        trend: '+2 this month',
      ),
      _DashStat(
        label: 'Skills Listed',
        value: counts['skills'].toString(),
        icon: Icons.code_rounded,
        color: AppColors.purple,
        trend: 'Up to date',
      ),
      _DashStat(
        label: 'Blog Articles',
        value: counts['blogs'].toString(),
        icon: Icons.article_rounded,
        color: AppColors.green,
        trend: '+1 this week',
      ),
      _DashStat(
        label: 'Unread Messages',
        value: counts['unreadMessages'].toString(),
        icon: Icons.mark_email_unread_rounded,
        color: const Color(0xFFFFB800),
        trend: 'Pending reply',
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
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
      padding: const EdgeInsets.all(16), // 20 → 16
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
                width: 38, // 42 → 38
                height: 38,
                decoration: BoxDecoration(
                  color: stat.color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(stat.icon, color: stat.color, size: 18),
              ),
              Flexible( // ✅ Flexible দিয়ে wrap করো
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
                      fontSize: 9, // 10 → 9
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis, // ✅ overflow handle
                    maxLines: 1,
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox( // ✅ FittedBox দিয়ে value auto-scale হবে
                fit: BoxFit.scaleDown,
                child: Text(
                  stat.value,
                  style: GoogleFonts.spaceGrotesk(
                    color: AppColors.textPrimary,
                    fontSize: 32, // 36 → 32
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                stat.label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 11, // 12 → 11
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ],
      ),
    )
        .animate(delay: (index * 80).ms)
        .fadeIn(duration: 400.ms)
        .slideY(begin: 0.2, end: 0);
  }
}

// ──────────────────────────────────────────────
// SKILLS BAR CHART
// ──────────────────────────────────────────────
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
          Text('Top Skills',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 18)),
          const SizedBox(height: 4),
          Text('Proficiency levels',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 24),
          StreamBuilder(
            stream: FirebaseService().streamSkills(),
            builder: (context, snapshot) {
              final skills = (snapshot.data ?? []).take(6).toList();
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
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 100,
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipColor: (_) => AppColors.card,
                        getTooltipItem: (group, _, rod, __) {
                          return BarTooltipItem(
                            '${rod.toY.round()}%',
                            GoogleFonts.spaceGrotesk(
                              color: AppColors.cyan,
                              fontWeight: FontWeight.w700,
                            ),
                          );
                        },
                      ),
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      topTitles:
                      const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles:
                      const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 36,
                          getTitlesWidget: (value, _) => Text(
                            '${value.toInt()}',
                            style: GoogleFonts.jetBrainsMono(
                              color: AppColors.textMuted,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, _) {
                            final i = value.toInt();
                            if (i < 0 || i >= skills.length)
                              return const SizedBox();
                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                skills[i].name,
                                style: GoogleFonts.spaceGrotesk(
                                  color: AppColors.textSecondary,
                                  fontSize: 10,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      horizontalInterval: 25,
                      getDrawingHorizontalLine: (_) => const FlLine(
                        color: AppColors.border,
                        strokeWidth: 1,
                      ),
                      drawVerticalLine: false,
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: skills.asMap().entries.map((e) {
                      return BarChartGroupData(
                        x: e.key,
                        barRods: [
                          BarChartRodData(
                            toY: e.value.proficiency.toDouble(),
                            gradient: const LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [AppColors.purple, AppColors.cyan],
                            ),
                            width: 20,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(6),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0);
  }
}

// ──────────────────────────────────────────────
// RECENT MESSAGES
// ──────────────────────────────────────────────
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
          Text('Latest contact submissions',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 20),
          StreamBuilder(
            stream: FirebaseService().streamContacts(),
            builder: (context, snapshot) {
              final contacts = (snapshot.data ?? []).take(5).toList();
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
                separatorBuilder: (_, __) =>
                const Divider(color: AppColors.border, height: 1),
                itemBuilder: (_, i) {
                  final c = contacts[i];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor: AppColors.cyanDim,
                      child: Text(
                        c.name.isNotEmpty ? c.name[0].toUpperCase() : '?',
                        style: const TextStyle(
                            color: AppColors.cyan, fontWeight: FontWeight.w700),
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
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: !c.read
                        ? Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.cyan,
                        shape: BoxShape.circle,
                      ),
                    )
                        : null,
                  );
                },
              );
            },
          ),
        ],
      ),
    ).animate(delay: 200.ms).fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0);
  }
}