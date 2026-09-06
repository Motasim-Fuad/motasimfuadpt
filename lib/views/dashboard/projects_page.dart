import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_portfolio/controllers/project_controller.dart';
import 'package:flutter_portfolio/models/model.dart';
import 'package:flutter_portfolio/services/firebase_services.dart';
import 'package:flutter_portfolio/theme/app_theme.dart';
import 'package:flutter_portfolio/utils/pick_local_image.dart';
import 'package:flutter_portfolio/utils/remote_image.dart';
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
        backgroundColor: AppColors.dashCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Delete Project', style: Theme.of(dialogContext).textTheme.headlineMedium),
        content: Text(
            'Are you sure you want to delete "${project.title}"? This cannot be undone.',
            style: Theme.of(dialogContext).textTheme.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel', style: TextStyle(color: AppColors.dashMuted)),
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
        gradient: AppColors.dashCardGradient,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.dashBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.dashSurface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: project.imageUrl.isNotEmpty
                ? ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: RemoteImage(
                  url: project.imageUrl,
                  fit: BoxFit.contain,
                  placeholder: (_) => const Icon(
                      Icons.phone_android_rounded,
                      color: AppColors.dashMuted,
                      size: 24),
                  error: (_) => const Icon(
                      Icons.phone_android_rounded,
                      color: AppColors.dashMuted,
                      size: 24),
                ),
              ),
            )
                : const Icon(Icons.phone_android_rounded,
                color: AppColors.dashMuted, size: 24),
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
                          color: AppColors.dashText,
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
                      color: AppColors.dashMuted, fontSize: 13),
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
                      color: AppColors.dashSurface,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.dashBorder),
                    ),
                    child: Text(
                      t,
                      style: GoogleFonts.jetBrainsMono(
                          color: AppColors.dashMuted, fontSize: 10),
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
  late final _appStoreCtrl =
  TextEditingController(text: widget.project?.appStoreUrl);
  late final _playStoreCtrl =
  TextEditingController(text: widget.project?.playStoreUrl);
  late final _liveCtrl =
  TextEditingController(text: widget.project?.liveUrl);
  late final _orderCtrl = TextEditingController(
      text: (widget.project?.order ?? 0).toString());
  late bool _featured = widget.project?.featured ?? false;
  bool _loading = false;
  PickedLocalImage? _picked;

  @override
  void dispose() {
    for (final c in [
      _titleCtrl,
      _descCtrl,
      _imgCtrl,
      _techCtrl,
      _ghCtrl,
      _appStoreCtrl,
      _playStoreCtrl,
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

    try {
    final techs = _techCtrl.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    var github = _ghCtrl.text.trim();
    var live = _liveCtrl.text.trim();
    var appStore = _appStoreCtrl.text.trim();
    var playStore = _playStoreCtrl.text.trim();

    if (appStore.isEmpty && ProjectModel.looksLikeAppStore(github)) {
      appStore = github;
      github = '';
    }
    if (playStore.isEmpty && ProjectModel.looksLikePlayStore(github)) {
      playStore = github;
      github = '';
    }
    if (playStore.isEmpty && ProjectModel.looksLikePlayStore(live)) {
      playStore = live;
      live = '';
    }
    if (appStore.isEmpty && ProjectModel.looksLikeAppStore(live)) {
      appStore = live;
      live = '';
    }

    var imageUrl = resolveImageUrl(_imgCtrl.text);
    if (_picked != null) {
      final ext = storageExtFor(_picked!.contentType);
      imageUrl = await FirebaseService().uploadImageBytes(
        bytes: _picked!.bytes,
        storagePath:
            'projects/${DateTime.now().millisecondsSinceEpoch}.$ext',
        contentType: _picked!.contentType,
      );
    }

    final project = ProjectModel(
      id: widget.project?.id ?? '',
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      imageUrl: imageUrl,
      technologies: techs,
      githubUrl: github,
      liveUrl: live,
      appStoreUrl: appStore,
      playStoreUrl: playStore,
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
    if (mounted) Navigator.pop(context);
    } catch (e) {
      setState(() => _loading = false);
      Get.snackbar(
        'Could not save',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.dashCard,
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 560, maxHeight: 760),
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
                        color: AppColors.dashMuted),
                  ),
                ],
              ),
            ),
            const Divider(color: AppColors.dashBorder, height: 1),
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
                      _field(
                        'Image URL (optional if you upload a file)',
                        _imgCtrl,
                        hint: 'Or paste a direct image link',
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: OutlinedButton.icon(
                          onPressed: _loading
                              ? null
                              : () async {
                                  try {
                                    final picked = await pickLocalImage();
                                    if (picked == null) return;
                                    setState(() => _picked = picked);
                                  } catch (e) {
                                    Get.snackbar(
                                      'Image',
                                      e.toString(),
                                      snackPosition: SnackPosition.BOTTOM,
                                    );
                                  }
                                },
                          icon: const Icon(Icons.upload_rounded, size: 18),
                          label: Text(_picked == null
                              ? 'Upload from device'
                              : 'File selected: ${_picked!.name}'),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Max image size ${formatBytesAsMb(maxUploadImageBytes)}',
                          style: const TextStyle(
                            color: AppColors.dashMuted,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      if (_picked != null) ...[
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: ColoredBox(
                            color: AppColors.dashSurface,
                            child: Image.memory(
                              _picked!.bytes,
                              height: 160,
                              width: double.infinity,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ] else if (_imgCtrl.text.trim().isNotEmpty) ...[
                        const SizedBox(height: 12),
                        ColoredBox(
                          color: AppColors.dashSurface,
                          child: SizedBox(
                            height: 160,
                            width: double.infinity,
                            child: RemoteImage(
                              url: _imgCtrl.text,
                              fit: BoxFit.contain,
                              placeholder: (_) => const SizedBox(),
                              error: (_) => const Center(
                                child: Text('Preview failed'),
                              ),
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      _field('Technologies (comma-separated)', _techCtrl,
                          hint: 'Flutter, Firebase, Dart'),
                      const SizedBox(height: 16),
                      _field(
                        'App Store URL',
                        _appStoreCtrl,
                        hint: 'https://apps.apple.com/app/...',
                      ),
                      const SizedBox(height: 16),
                      _field(
                        'Play Store URL',
                        _playStoreCtrl,
                        hint: 'https://play.google.com/store/apps/details?id=...',
                      ),
                      const SizedBox(height: 16),
                      _field('GitHub URL', _ghCtrl, hint: 'https://github.com/...'),
                      const SizedBox(height: 16),
                      _field(
                        'Website / other live URL',
                        _liveCtrl,
                        hint: 'Optional web demo',
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
            const Divider(color: AppColors.dashBorder, height: 1),
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
              size: 80, color: AppColors.dashMuted),
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