import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_portfolio/controllers/stats_controller.dart';
import 'package:flutter_portfolio/models/model.dart';
import 'package:flutter_portfolio/theme/app_theme.dart';
import 'package:flutter_portfolio/views/portfolio/portfolio_widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Portfolio Stats',
              style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 6),
          Text(
              'Numbers shown on your public portfolio homepage',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 32),

          Obx(() {
            final stats = StatsController.to.stats.value;
            return Column(
              children: [
                _StatsGrid(stats: stats),
                const SizedBox(height: 32),
                _EditStatsCard(stats: stats),
              ],
            );
          }),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────
// PREVIEW GRID
// ──────────────────────────────────────────────
class _StatsGrid extends StatelessWidget {
  final StatsModel stats;
  const _StatsGrid({required this.stats});

  @override
  Widget build(BuildContext context) {
    final items = [
      _StatPreview(
        value: '${stats.projectsCompleted}+',
        label: 'Projects Completed',
        icon: Icons.rocket_launch_rounded,
        color: AppColors.cyan,
      ),
      _StatPreview(
        value: '${stats.yearsExperience}+',
        label: 'Years Experience',
        icon: Icons.schedule_rounded,
        color: AppColors.purple,
      ),
      _StatPreview(
        value: '${stats.deliveryOnTime}%',
        label: 'Delivery On Time',
        icon: Icons.schedule_send_rounded,
        color: AppColors.green,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Live Preview',
          style: GoogleFonts.spaceGrotesk(
            color: AppColors.dashMuted,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 260,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.1,
          ),
          itemCount: items.length,
          itemBuilder: (_, i) =>
              _StatPreviewCard(stat: items[i], index: i),
        ),
      ],
    );
  }
}

class _StatPreview {
  final String value, label;
  final IconData icon;
  final Color color;
  _StatPreview(
      {required this.value,
        required this.label,
        required this.icon,
        required this.color});
}

class _StatPreviewCard extends StatelessWidget {
  final _StatPreview stat;
  final int index;
  const _StatPreviewCard({required this.stat, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.dashCardGradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: stat.color.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: stat.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(stat.icon, color: stat.color, size: 22),
          ),
          const SizedBox(height: 12),
          GradientText(
            stat.value,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
            gradient: LinearGradient(
                colors: [stat.color, stat.color.withOpacity(0.6)]),
          ),
          const SizedBox(height: 4),
          Text(
            stat.label,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontSize: 11),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    )
        .animate(delay: (index * 80).ms)
        .fadeIn(duration: 400.ms)
        .scale(begin: const Offset(0.9, 0.9));
  }
}

// ──────────────────────────────────────────────
// EDIT FORM
// ──────────────────────────────────────────────
class _EditStatsCard extends StatefulWidget {
  final StatsModel stats;
  const _EditStatsCard({required this.stats});

  @override
  State<_EditStatsCard> createState() => _EditStatsCardState();
}

// পুরো _EditStatsCardState ক্লাসটি replace করুন:

class _EditStatsCardState extends State<_EditStatsCard> {
  late final _projectsCtrl = TextEditingController(
      text: widget.stats.projectsCompleted.toString());
  late final _yearsCtrl = TextEditingController(
      text: widget.stats.yearsExperience.toString());
  late final _deliveryCtrl = TextEditingController(
      text: widget.stats.deliveryOnTime.toString());

  bool _loading = false;
  bool _saved = false;

  @override
  void didUpdateWidget(covariant _EditStatsCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.stats.projectsCompleted != widget.stats.projectsCompleted ||
        oldWidget.stats.yearsExperience != widget.stats.yearsExperience ||
        oldWidget.stats.deliveryOnTime != widget.stats.deliveryOnTime) {
      _projectsCtrl.text = widget.stats.projectsCompleted.toString();
      _yearsCtrl.text = widget.stats.yearsExperience.toString();
      _deliveryCtrl.text = widget.stats.deliveryOnTime.toString();
    }
  }

  @override
  void dispose() {
    _projectsCtrl.dispose();
    _yearsCtrl.dispose();
    _deliveryCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final projects = int.tryParse(_projectsCtrl.text);
    final years = int.tryParse(_yearsCtrl.text);
    final delivery = int.tryParse(_deliveryCtrl.text);

    if ([projects, years, delivery].any((v) => v == null)) {
      Get.snackbar(
        'Error',
        'All fields must be valid numbers',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.redAccent,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    setState(() => _loading = true);
    await StatsController.to.updateStats(StatsModel(
      projectsCompleted: projects!,
      yearsExperience: years!,
      deliveryOnTime: delivery!.clamp(0, 100).toInt(),
      githubStars: widget.stats.githubStars,
    ));
    setState(() {
      _loading = false;
      _saved = true;
    });
    Future.delayed(const Duration(seconds: 2), () => setState(() => _saved = false));
  }

  @override
  Widget build(BuildContext context) {
    return GlowCard(
      glowColor: AppColors.purple,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.edit_rounded, color: AppColors.cyan, size: 20),
              const SizedBox(width: 10),
              Text(
                'Edit Stats',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 18),
              ),
              const Spacer(),
              if (_saved)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: AppColors.green.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle_rounded, color: AppColors.green, size: 14),
                      const SizedBox(width: 6),
                      Text('Saved!',
                          style: GoogleFonts.spaceGrotesk(
                              color: AppColors.green, fontWeight: FontWeight.w600, fontSize: 12)),
                    ],
                  ),
                ).animate().fadeIn(),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _numField(
                  'Projects Completed',
                  _projectsCtrl,
                  Icons.rocket_launch_rounded,
                  AppColors.cyan,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _numField(
                  'Years Experience',
                  _yearsCtrl,
                  Icons.schedule_rounded,
                  AppColors.purple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _numField(
                  'Delivery On Time (%)',
                  _deliveryCtrl,
                  Icons.schedule_send_rounded,
                  AppColors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _loading ? null : _save,
              icon: _loading
                  ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                  : const Icon(Icons.save_rounded, size: 18),
              label: Text(_loading ? 'Saving...' : 'Save Stats'),
            ),
          ),
        ],
      ),
    ).animate(delay: 200.ms).fadeIn(duration: 500.ms).slideY(begin: 0.2);
  }

  Widget _numField(
      String label,
      TextEditingController ctrl,
      IconData icon,
      Color color,
      ) {
    return TextFormField(
      controller: ctrl,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: color, size: 18),
      ),
    );
  }
}