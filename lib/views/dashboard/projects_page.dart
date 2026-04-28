import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_portfolio/controllers/project_controller.dart';
import 'package:flutter_portfolio/models/model.dart';
import 'package:flutter_portfolio/theme/app_theme.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Projects',
                      style: Theme.of(context).textTheme.headlineLarge),
                  Text('Manage your portfolio projects',
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () => _showProjectDialog(context),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Add Project'),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Expanded(
            child: Obx(() {
              if (ProjectController.to.isLoading.value) {
                return const Center(
                    child:
                    CircularProgressIndicator(color: AppColors.cyan));
              }
              final projects = ProjectController.to.projects;
              if (projects.isEmpty) {
                return _EmptyProjectsState(
                    onAdd: () => _showProjectDialog(context));
              }
              return ListView.separated(
                itemCount: projects.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) => _ProjectTile(
                  project: projects[i],
                  index: i,
                  onEdit: () =>
                      _showProjectDialog(context, project: projects[i]),
                  onDelete: () => _confirmDelete(context, projects[i]),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showProjectDialog(BuildContext context, {ProjectModel? project}) {
    showDialog(
      context: context,
      builder: (dialogContext) => _ProjectDialog(project: project),
    );
  }

  void _confirmDelete(BuildContext context, ProjectModel project) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Delete Project', style: Theme.of(dialogContext).textTheme.headlineMedium),
        content: Text(
            'Are you sure you want to delete "${project.title}"? This cannot be undone.',
            style: Theme.of(dialogContext).textTheme.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await ProjectController.to.delete(project.id);
              Navigator.pop(dialogContext);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _ProjectTile extends StatelessWidget {
  final ProjectModel project;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ProjectTile({
    required this.project,
    required this.index,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: project.imageUrl.isNotEmpty
                ? ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(project.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(
                      Icons.phone_android_rounded,
                      color: AppColors.textMuted,
                      size: 24)),
            )
                : const Icon(Icons.phone_android_rounded,
                color: AppColors.textMuted, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        project.title,
                        style: GoogleFonts.spaceGrotesk(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (project.featured) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.cyanDim,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          'Featured',
                          style: GoogleFonts.spaceGrotesk(
                            color: AppColors.cyan,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  project.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 13),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  children: project.technologies
                      .take(3)
                      .map((t) => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Text(
                      t,
                      style: GoogleFonts.jetBrainsMono(
                          color: AppColors.textMuted, fontSize: 10),
                    ),
                  ))
                      .toList(),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            children: [
              IconButton(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_rounded,
                    color: AppColors.cyan, size: 20),
                tooltip: 'Edit',
              ),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline_rounded,
                    color: Colors.redAccent, size: 20),
                tooltip: 'Delete',
              ),
            ],
          ),
        ],
      ),
    )
        .animate(delay: (index * 60).ms)
        .fadeIn(duration: 400.ms)
        .slideX(begin: 0.1, end: 0);
  }
}

// ──────────────────────────────────────────────
// PROJECT DIALOG
// ──────────────────────────────────────────────
class _ProjectDialog extends StatefulWidget {
  final ProjectModel? project;
  const _ProjectDialog({this.project});

  @override
  State<_ProjectDialog> createState() => _ProjectDialogState();
}

class _ProjectDialogState extends State<_ProjectDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _titleCtrl =
  TextEditingController(text: widget.project?.title);
  late final _descCtrl =
  TextEditingController(text: widget.project?.description);
  late final _imgCtrl =
  TextEditingController(text: widget.project?.imageUrl);
  late final _techCtrl = TextEditingController(
      text: widget.project?.technologies.join(', '));
  late final _ghCtrl =
  TextEditingController(text: widget.project?.githubUrl);
  late final _liveCtrl =
  TextEditingController(text: widget.project?.liveUrl);
  late final _orderCtrl = TextEditingController(
      text: (widget.project?.order ?? 0).toString());
  late bool _featured = widget.project?.featured ?? false;
  bool _loading = false;

  @override
  void dispose() {
    for (final c in [
      _titleCtrl,
      _descCtrl,
      _imgCtrl,
      _techCtrl,
      _ghCtrl,
      _liveCtrl,
      _orderCtrl
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final techs = _techCtrl.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final project = ProjectModel(
      id: widget.project?.id ?? '',
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      imageUrl: _imgCtrl.text.trim(),
      technologies: techs,
      githubUrl: _ghCtrl.text.trim(),
      liveUrl: _liveCtrl.text.trim(),
      featured: _featured,
      order: int.tryParse(_orderCtrl.text) ?? 0,
      createdAt: widget.project?.createdAt ?? DateTime.now(),
    );

    if (widget.project != null) {
      await ProjectController.to.updateProject(project);
    } else {
      await ProjectController.to.add(project);
    }

    setState(() => _loading = false);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.card,
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 560, maxHeight: 700),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Text(
                    widget.project != null ? 'Edit Project' : 'Add Project',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded,
                        color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const Divider(color: AppColors.border, height: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _field('Title *', _titleCtrl),
                      const SizedBox(height: 16),
                      _field('Description *', _descCtrl, maxLines: 3),
                      const SizedBox(height: 16),
                      _field('Image URL', _imgCtrl),
                      const SizedBox(height: 16),
                      _field('Technologies (comma-separated)', _techCtrl,
                          hint: 'Flutter, Firebase, Dart'),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(child: _field('GitHub URL', _ghCtrl)),
                          const SizedBox(width: 12),
                          Expanded(child: _field('Live URL', _liveCtrl)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _field('Display Order', _orderCtrl,
                          hint: '0 = first',
                          keyboardType: TextInputType.number),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Switch(
                            value: _featured,
                            onChanged: (v) =>
                                setState(() => _featured = v),
                            activeColor: AppColors.cyan,
                          ),
                          const SizedBox(width: 8),
                          Text('Featured project',
                              style:
                              Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Divider(color: AppColors.border, height: 1),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _loading ? null : _save,
                      child: _loading
                          ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              color: Colors.black, strokeWidth: 2))
                          : Text(widget.project != null
                          ? 'Update'
                          : 'Add'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl,
      {int maxLines = 1,
        String? hint,
        TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: ctrl,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(labelText: label, hintText: hint),
      validator: label.endsWith('*')
          ? (v) => (v == null || v.isEmpty) ? '$label is required' : null
          : null,
    );
  }
}

class _EmptyProjectsState extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyProjectsState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.phone_android_rounded,
              size: 80, color: AppColors.textMuted),
          const SizedBox(height: 20),
          Text('No projects yet',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text('Add your first project to get started',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add Project'),
          ),
        ],
      ),
    );
  }
}