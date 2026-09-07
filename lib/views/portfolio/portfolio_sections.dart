import 'package:flutter/material.dart';
import 'package:flutter_portfolio/data/site_config.dart';
import 'package:flutter_portfolio/services/firebase_services.dart';
import 'package:flutter_portfolio/theme/app_theme.dart';
import 'package:flutter_portfolio/utils/motion.dart';
import 'package:flutter_portfolio/utils/open_link.dart';
import 'package:flutter_portfolio/utils/responsive.dart';
import 'package:flutter_portfolio/views/portfolio/portfolio_widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/model.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    return Container(
      color: AppColors.surface,
      child: _SectionWrapper(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              label: '01  —  About',
              title: 'How I like to work',
              subtitle:
                  'Production Flutter: GetX + MVVM, Firebase, maps, and billing. I would rather ship a boring reliable session than a clever widget.',
              alignStart: true,
            ),
            const SizedBox(height: 20),
            MotionReveal(
              delay: const Duration(milliseconds: 80),
              child: Text(
                SiteConfig.aboutNote,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 48),
            ...SiteConfig.experience.asMap().entries.map((e) {
              final job = e.value;
              return MotionReveal(
                delay: Duration(milliseconds: 80 + e.key * 90),
                child: Padding(
                padding: const EdgeInsets.only(bottom: 28),
                child: isMobile
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _JobMeta(job: job),
                          const SizedBox(height: 12),
                          _JobBody(job: job),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(width: 220, child: _JobMeta(job: job)),
                          Expanded(child: _JobBody(job: job)),
                        ],
                      ),
              ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _JobMeta extends StatelessWidget {
  final SiteExperience job;
  const _JobMeta({required this.job});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          job.period.toUpperCase(),
          style: GoogleFonts.ibmPlexMono(
            color: AppColors.rust,
            fontSize: 11,
            letterSpacing: 1.4,
          ),
        ),
        const SizedBox(height: 6),
        Text(job.company, style: Theme.of(context).textTheme.headlineMedium),
      ],
    );
  }
}

class _JobBody extends StatelessWidget {
  final SiteExperience job;
  const _JobBody({required this.job});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(job.role, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.ink)),
        const SizedBox(height: 10),
        ...job.points.map(
          (p) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text('—  $p', style: Theme.of(context).textTheme.bodyMedium),
          ),
        ),
      ],
    );
  }
}

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cols = Responsive.projectGridCols(context);

    return _SectionWrapper(
      child: Column(
        children: [
          const SectionHeader(
            label: '02  —  Work',
            title: 'Selected projects',
            subtitle:
                'Client builds stay private. What I can show is the kind of product work I actually do.',
            alignStart: true,
          ),
          const SizedBox(height: 48),
          StreamBuilder<List<ProjectModel>>(
            stream: FirebaseService().streamProjects(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.rust),
                );
              }
              final projects = snapshot.data ?? [];
              if (projects.isEmpty) {
                return const _EmptyHint(label: 'Projects will show here from the dashboard.');
              }
              return LayoutBuilder(
                builder: (context, constraints) {
                  const gap = 16.0;
                  final width =
                      (constraints.maxWidth - gap * (cols - 1)) / cols;
                  return Wrap(
                    spacing: gap,
                    runSpacing: gap,
                    children: [
                      for (var i = 0; i < projects.length; i++)
                        SizedBox(
                          width: width,
                          child: ProjectCard(
                            project: projects[i],
                            index: i,
                          ),
                        ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Container(
      color: AppColors.surface,
      child: _SectionWrapper(
        child: Column(
          children: [
            const SectionHeader(
              label: '03  —  Stack',
              title: 'Tools I reach for',
              subtitle: 'The list matches how I ship, not a generic keyword dump.',
              alignStart: true,
            ),
            const SizedBox(height: 48),
            StreamBuilder<List<SkillModel>>(
              stream: FirebaseService().streamSkills(),
              builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.rust),
                );
              }
              final skills = snapshot.data ?? [];
              if (skills.isEmpty) {
                return const _EmptyHint(label: 'Skills will show here from the dashboard.');
              }
              final byCategory = <String, List<SkillModel>>{};
                for (final s in skills) {
                  byCategory.putIfAbsent(s.category, () => []).add(s);
                }
                return _buildSkillsGrid(context, byCategory, isMobile);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillsGrid(
    BuildContext context,
    Map<String, List<SkillModel>> byCategory,
    bool isMobile,
  ) {
    final categories = byCategory.entries.toList();
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: categories.asMap().entries.map((entry) {
        final cat = entry.value;
        return SizedBox(
          width: isMobile
              ? double.infinity
              : (MediaQuery.of(context).size.width > 1200
                  ? 500
                  : (MediaQuery.of(context).size.width - 96 - 16) / 2),
          child: MotionReveal(
            delay: Duration(milliseconds: entry.key * 100),
            child: GlowCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cat.key.toUpperCase(),
                  style: GoogleFonts.ibmPlexMono(
                    color: AppColors.rust,
                    fontWeight: FontWeight.w500,
                    fontSize: 11,
                    letterSpacing: 1.6,
                  ),
                ),
                const SizedBox(height: 20),
                ...cat.value.asMap().entries.map(
                      (e) => SkillBar(skill: e.value, index: e.key),
                    ),
              ],
            ),
          ),
          ),
        );
      }).toList(),
    );
  }
}

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return _SectionWrapper(
      slim: true,
      child: StreamBuilder<StatsModel>(
        stream: FirebaseService().streamStats(),
        builder: (context, snapshot) {
          final stats = snapshot.data ??
              StatsModel(
                projectsCompleted: 25,
                yearsExperience: 3,
                deliveryOnTime: 96,
                githubStars: 120,
              );

          final items = [
            _StatItem('${stats.projectsCompleted}+', 'Projects shipped', Icons.circle, AppColors.ink),
            _StatItem('${stats.yearsExperience}+', 'Years building', Icons.circle, AppColors.ink),
            _StatItem('${stats.deliveryOnTime}%', 'Delivery On Time', Icons.circle, AppColors.ink),
          ];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const MotionLine(color: AppColors.ink),
              const SizedBox(height: 28),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isMobile ? 1 : 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 8,
                  childAspectRatio: isMobile ? 1.6 : 1.8,
                ),
                itemCount: items.length,
                itemBuilder: (_, i) => StatCard(
                  value: items[i].value,
                  label: items[i].label,
                  icon: items[i].icon,
                  color: items[i].color,
                  index: i,
                ),
              ),
              const SizedBox(height: 12),
              const MotionLine(
                color: AppColors.ink,
                delay: Duration(milliseconds: 120),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StatItem {
  final String value, label;
  final IconData icon;
  final Color color;
  _StatItem(this.value, this.label, this.icon, this.color);
}

class BlogSection extends StatelessWidget {
  const BlogSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cols = Responsive.projectGridCols(context);

    return Container(
      color: AppColors.surface,
      child: _SectionWrapper(
        child: Column(
          children: [
            const SectionHeader(
              label: '04  —  Notes',
              title: 'Writing from the work',
              subtitle:
                  'Articles I publish from the dashboard — Flutter first, and whatever I am actually working on.',
              alignStart: true,
            ),
            const SizedBox(height: 48),
            StreamBuilder<List<BlogModel>>(
              stream: FirebaseService().streamBlogs(publishedOnly: true),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.rust),
                  );
                }
                final blogs = snapshot.data ?? [];
                if (blogs.isEmpty) {
                  return const _EmptyHint(label: 'Notes will show here once you publish from the dashboard.');
                }
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: cols,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.95,
                  ),
                  itemCount: blogs.length,
                  itemBuilder: (_, i) => BlogCard(blog: blogs[i], index: i),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _subjectCtrl = TextEditingController();
  final _msgCtrl = TextEditingController();
  bool _sending = false;
  bool _sent = false;
  bool _failed = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _subjectCtrl.dispose();
    _msgCtrl.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _sending = true;
      _failed = false;
    });

    final contact = ContactModel(
      id: '',
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      subject: _subjectCtrl.text.trim(),
      message: _msgCtrl.text.trim(),
      sentAt: DateTime.now(),
    );

    final ok = await FirebaseService().sendContact(contact);
    setState(() {
      _sending = false;
      _sent = ok;
      _failed = !ok;
    });

    if (ok) {
      _nameCtrl.clear();
      _emailCtrl.clear();
      _subjectCtrl.clear();
      _msgCtrl.clear();
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) setState(() => _sent = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return _SectionWrapper(
      child: Column(
        children: [
          const SectionHeader(
            label: '05  —  Contact',
            title: 'If you have a Flutter product',
            subtitle: 'Roles, contracts, or a messy subscription flow. Dhaka timezone.',
            alignStart: true,
          ),
          const SizedBox(height: 48),
          isMobile
              ? Column(
                  children: [
                    MotionReveal(
                      slide: MotionSlide.left,
                      child: _ContactInfo(),
                    ),
                    const SizedBox(height: 20),
                    MotionReveal(
                      delay: const Duration(milliseconds: 100),
                      child: _ContactForm(
                      formKey: _formKey,
                      controllers: [_nameCtrl, _emailCtrl, _subjectCtrl, _msgCtrl],
                      sending: _sending,
                      sent: _sent,
                      failed: _failed,
                      onSend: _send,
                    ),
                    ),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: MotionReveal(
                        slide: MotionSlide.left,
                        child: _ContactInfo(),
                      ),
                    ),
                    const SizedBox(width: 28),
                    Expanded(
                      flex: 6,
                      child: MotionReveal(
                        delay: const Duration(milliseconds: 90),
                        slide: MotionSlide.right,
                        child: _ContactForm(
                        formKey: _formKey,
                        controllers: [_nameCtrl, _emailCtrl, _subjectCtrl, _msgCtrl],
                        sending: _sending,
                        sent: _sent,
                        failed: _failed,
                        onSend: _send,
                      ),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}

class _ContactInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GlowCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Direct', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 16),
          Text(
            'I read every message. If it is a production Flutter app — auth, maps, billing, or a factory-floor workflow — say so in the subject.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 28),
          _InfoRow(
            label: 'Email',
            text: SiteConfig.email,
            url: SiteConfig.mailUrl,
          ),
          const SizedBox(height: 14),
          const _InfoRow(label: 'Based', text: SiteConfig.location),
          const SizedBox(height: 28),
          const SocialRow(),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String text;
  final String? url;
  const _InfoRow({required this.label, required this.text, this.url});

  @override
  Widget build(BuildContext context) {
    final row = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 64,
          child: Text(
            label.toUpperCase(),
            style: GoogleFonts.ibmPlexMono(
              color: AppColors.textMuted,
              fontSize: 10,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.ink,
                  decoration: url != null ? TextDecoration.underline : null,
                ),
          ),
        ),
      ],
    );
    if (url == null) return row;
    return WebLink(url: url!, child: row);
  }
}

class _ContactForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final List<TextEditingController> controllers;
  final bool sending;
  final bool sent;
  final bool failed;
  final VoidCallback onSend;

  const _ContactForm({
    required this.formKey,
    required this.controllers,
    required this.sending,
    required this.sent,
    required this.failed,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return GlowCard(
      child: Form(
        key: formKey,
        child: Column(
          children: [
            AnimatedSwitcher(
              duration: Motion.fast,
              switchInCurve: Motion.ease,
              child: sent
                  ? const _Banner(
                      key: ValueKey('sent'),
                      color: AppColors.green,
                      text: 'Sent. I will reply from my inbox.',
                    )
                  : failed
                      ? const _Banner(
                          key: ValueKey('fail'),
                          color: AppColors.rust,
                          text: 'Could not send. Email me directly instead.',
                        )
                      : const SizedBox.shrink(key: ValueKey('none')),
            ),
            Row(
              children: [
                Expanded(child: _field('Name', controllers[0])),
                const SizedBox(width: 12),
                Expanded(
                  child: _field(
                    'Email',
                    controllers[1],
                    email: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _field('Subject', controllers[2]),
            const SizedBox(height: 14),
            _field('Message', controllers[3], maxLines: 5),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: sending ? null : onSend,
                child: sending
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          color: Color(0xFFFFF8F0),
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Send'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController ctrl, {
    int maxLines = 1,
    bool email = false,
  }) {
    return TextFormField(
      controller: ctrl,
      maxLines: maxLines,
      keyboardType: email ? TextInputType.emailAddress : TextInputType.text,
      decoration: InputDecoration(labelText: label),
      validator: (v) {
        if (v == null || v.trim().isEmpty) return '$label is required';
        if (email && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v.trim())) {
          return 'Enter a valid email';
        }
        return null;
      },
    );
  }
}

class _Banner extends StatelessWidget {
  final Color color;
  final String text;
  const _Banner({super.key, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(0.4)),
        color: color.withOpacity(0.08),
      ),
      child: Text(text, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
    );
  }
}


class _EmptyHint extends StatelessWidget {
  final String label;
  const _EmptyHint({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}

class SectionWrapper extends StatelessWidget {
  final Widget child;
  final bool slim;
  const SectionWrapper({super.key, required this.child, this.slim = false});

  @override
  Widget build(BuildContext context) => _SectionWrapper(slim: slim, child: child);
}

class _SectionWrapper extends StatelessWidget {
  final Widget child;
  final bool slim;

  const _SectionWrapper({required this.child, this.slim = false});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1120),
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.isMobile(context) ? 24 : 48,
          vertical: slim ? 48 : 88,
        ),
        child: child,
      ),
    );
  }
}
