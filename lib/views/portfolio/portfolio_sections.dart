import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_portfolio/services/firebase_services.dart';
import 'package:flutter_portfolio/theme/app_theme.dart';
import 'package:flutter_portfolio/utils/responsive.dart';
import 'package:flutter_portfolio/views/portfolio/portfolio_widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/model.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cols = Responsive.projectGridCols(context);

    return _SectionWrapper(
      child: Column(
        children: [
          const SectionHeader(
            label: 'My Work',
            title: 'Featured Projects',
            subtitle: 'A selection of apps and projects I\'ve built with Flutter & beyond.',
          ),
          const SizedBox(height: 60),
          StreamBuilder<List<ProjectModel>>(
            stream: FirebaseService().streamProjects(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: AppColors.cyan));
              }
              final projects = snapshot.data ?? [];
              if (projects.isEmpty) {
                return _EmptyState(icon: Icons.phone_android_rounded, label: 'No projects yet');
              }
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: cols,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.72,
                ),
                itemCount: projects.length,
                itemBuilder: (_, i) => ProjectCard(project: projects[i], index: i),
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
              label: 'My Skills',
              title: 'Technologies & Tools',
              subtitle: 'Skills I\'ve honed through building real-world projects.',
            ),
            const SizedBox(height: 60),
            StreamBuilder<List<SkillModel>>(
              stream: FirebaseService().streamSkills(),
              builder: (context, snapshot) {
                final skills = snapshot.data ?? [];
                if (skills.isEmpty) {
                  return _EmptyState(icon: Icons.code_rounded, label: 'No skills added');
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

  Widget _buildSkillsGrid(BuildContext context, Map<String, List<SkillModel>> byCategory, bool isMobile) {
    final categories = byCategory.entries.toList();
    return Wrap(
      spacing: 24,
      runSpacing: 24,
      children: categories.asMap().entries.map((entry) {
        final cat = entry.value;
        return SizedBox(
          width: isMobile ? double.infinity : (MediaQuery.of(context).size.width > 1200
              ? (MediaQuery.of(context).size.width - 240 - 48) / 2
              : (MediaQuery.of(context).size.width - 96 - 24) / 2),
          child: GlowCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cat.key,
                  style: GoogleFonts.spaceGrotesk(
                    color: AppColors.cyan,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 24),
                ...cat.value.asMap().entries.map(
                      (e) => SkillBar(skill: e.value, index: e.key),
                ),
              ],
            ),
          ).animate(delay: (entry.key * 150).ms).fadeIn(duration: 500.ms).slideY(begin: 0.2, end: 0),
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
          final stats = snapshot.data ?? StatsModel(
            projectsCompleted: 25,
            yearsExperience: 3,
            happyClients: 15,
            githubStars: 120,
          );

          final items = [
            _StatItem('${stats.projectsCompleted}+', 'Projects Completed', Icons.rocket_launch_rounded, AppColors.cyan),
            _StatItem('${stats.yearsExperience}+', 'Years Experience', Icons.schedule_rounded, AppColors.purple),
            _StatItem('${stats.happyClients}+', 'Happy Clients', Icons.sentiment_satisfied_rounded, AppColors.green),
            _StatItem('${stats.githubStars}+', 'GitHub Stars', Icons.star_rounded, const Color(0xFFFFB800)),
          ];

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile ? 2 : 4,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: isMobile ? 1 : 0.9,
            ),
            itemCount: items.length,
            itemBuilder: (_, i) => StatCard(
              value: items[i].value,
              label: items[i].label,
              icon: items[i].icon,
              color: items[i].color,
              index: i,
            ),
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
    final isMobile = Responsive.isMobile(context);
    final cols = Responsive.projectGridCols(context);

    return Container(
      color: AppColors.surface,
      child: _SectionWrapper(
        child: Column(
          children: [
            const SectionHeader(
              label: 'My Blog',
              title: 'Articles & Insights',
              subtitle: 'Sharing knowledge about Flutter, mobile dev & tech.',
            ),
            const SizedBox(height: 60),
            StreamBuilder<List<BlogModel>>(
              stream: FirebaseService().streamBlogs(),
              builder: (context, snapshot) {
                final blogs = snapshot.data ?? [];
                if (blogs.isEmpty) {
                  return _EmptyState(icon: Icons.article_rounded, label: 'No articles yet');
                }
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: cols,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: isMobile ? 0.9 : 0.75,
                  ),
                  itemCount: blogs.take(6).length,
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
    setState(() => _sending = true);

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
    });

    if (ok) {
      _nameCtrl.clear();
      _emailCtrl.clear();
      _subjectCtrl.clear();
      _msgCtrl.clear();
      Future.delayed(const Duration(seconds: 3), () => setState(() => _sent = false));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return _SectionWrapper(
      child: Column(
        children: [
          const SectionHeader(
            label: 'Contact',
            title: 'Let\'s Work Together',
            subtitle: 'Have a project in mind? Let\'s build something awesome.',
          ),
          const SizedBox(height: 60),
          isMobile
              ? _ContactForm(
            formKey: _formKey,
            controllers: [_nameCtrl, _emailCtrl, _subjectCtrl, _msgCtrl],
            sending: _sending,
            sent: _sent,
            onSend: _send,
          )
              : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 4, child: _ContactInfo()),
              const SizedBox(width: 40),
              Expanded(
                flex: 6,
                child: _ContactForm(
                  formKey: _formKey,
                  controllers: [_nameCtrl, _emailCtrl, _subjectCtrl, _msgCtrl],
                  sending: _sending,
                  sent: _sent,
                  onSend: _send,
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
          GradientText(
            'Get in Touch',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          Text(
            'I\'m always open to discussing new projects, creative ideas or opportunities to be part of your vision.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 32),
          _InfoRow(icon: Icons.mail_outline_rounded, text: 'motasimfuad99@gmail.com'),
          const SizedBox(height: 16),
          _InfoRow(icon: Icons.location_on_outlined, text: 'Dhaka, Bangladesh'),
          const SizedBox(height: 16),
          //_InfoRow(icon: Icons.access_time_rounded, text: 'Mon - Fri, 9am - 6pm'),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.cyanDim,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.cyan, size: 18),
        ),
        const SizedBox(width: 14),
        Text(text, style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }
}

class _ContactForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final List<TextEditingController> controllers;
  final bool sending;
  final bool sent;
  final VoidCallback onSend;

  const _ContactForm({
    required this.formKey,
    required this.controllers,
    required this.sending,
    required this.sent,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return GlowCard(
      glowColor: AppColors.purple,
      child: Form(
        key: formKey,
        child: Column(
          children: [
            if (sent)
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: AppColors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.green.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded, color: AppColors.green),
                    const SizedBox(width: 10),
                    Text('Message sent! I\'ll get back to you soon.',
                        style: TextStyle(color: AppColors.green)),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2, end: 0),
            Row(
              children: [
                Expanded(child: _field('Name', controllers[0])),
                const SizedBox(width: 16),
                Expanded(child: _field('Email', controllers[1])),
              ],
            ),
            const SizedBox(height: 16),
            _field('Subject', controllers[2]),
            const SizedBox(height: 16),
            _field('Message', controllers[3], maxLines: 5),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: sending ? null : onSend,
                child: sending
                    ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                    : const Text('Send Message'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl, {int maxLines = 1}) {
    return TextFormField(
      controller: ctrl,
      maxLines: maxLines,
      decoration: InputDecoration(labelText: label),
      validator: (v) => (v == null || v.isEmpty) ? '$label is required' : null,
    );
  }
}

class _SectionWrapper extends StatelessWidget {
  final Widget child;
  final bool slim;

  const _SectionWrapper({required this.child, this.slim = false});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1200),
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.isMobile(context) ? 24 : 48,
          vertical: slim ? 60 : 100,
        ),
        child: child,
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String label;
  const _EmptyState({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Icon(icon, size: 60, color: AppColors.textMuted),
          const SizedBox(height: 16),
          Text(label, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}