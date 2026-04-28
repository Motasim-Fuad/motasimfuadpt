import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_portfolio/controllers/skill_controller.dart';
import 'package:flutter_portfolio/models/model.dart';
import 'package:flutter_portfolio/theme/app_theme.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


class SkillsPage extends StatelessWidget {
  const SkillsPage({super.key});

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
                  Text('Skills',
                      style: Theme.of(context).textTheme.headlineLarge),
                  Text('Manage your technology skills',
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () => _showSkillDialog(context),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Add Skill'),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Expanded(
            child: Obx(() {
              if (SkillController.to.isLoading.value) {
                return const Center(
                    child:
                    CircularProgressIndicator(color: AppColors.cyan));
              }
              final skills = SkillController.to.skills;
              if (skills.isEmpty) {
                return _EmptySkillsState(
                    onAdd: () => _showSkillDialog(context));
              }
              return ListView.separated(
                itemCount: skills.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) => _SkillTile(
                  skill: skills[i],
                  index: i,
                  onEdit: () =>
                      _showSkillDialog(context, skill: skills[i]),
                  onDelete: () => _confirmDelete(context, skills[i]),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showSkillDialog(BuildContext context, {SkillModel? skill}) {
    showDialog(
      context: context,
      builder: (dialogContext) => _SkillDialog(skill: skill),
    );
  }

  void _confirmDelete(BuildContext context, SkillModel skill) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Delete Skill', style: Theme.of(dialogContext).textTheme.headlineMedium),
        content: Text(
            'Are you sure you want to delete "${skill.name}"?',
            style: Theme.of(dialogContext).textTheme.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await SkillController.to.delete(skill.id);
              Navigator.pop(dialogContext);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _SkillTile extends StatelessWidget {
  final SkillModel skill;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _SkillTile({
    required this.skill,
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
          // Proficiency badge
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.cyanDim,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '${skill.proficiency}%',
                style: GoogleFonts.spaceGrotesk(
                  color: AppColors.cyan,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  skill.name,
                  style: GoogleFonts.spaceGrotesk(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.purpleDim,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        skill.category,
                        style: GoogleFonts.spaceGrotesk(
                          color: AppColors.purple,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Progress bar
                Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) => Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: constraints.maxWidth *
                            (skill.proficiency / 100),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.cyan, AppColors.purple],
                          ),
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),
                  ),
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
// SKILL DIALOG
// ──────────────────────────────────────────────
class _SkillDialog extends StatefulWidget {
  final SkillModel? skill;
  const _SkillDialog({this.skill});

  @override
  State<_SkillDialog> createState() => _SkillDialogState();
}

class _SkillDialogState extends State<_SkillDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _nameCtrl =
  TextEditingController(text: widget.skill?.name);
  late final _categoryCtrl =
  TextEditingController(text: widget.skill?.category);
  late double _proficiency =
  (widget.skill?.proficiency ?? 70).toDouble();
  bool _loading = false;

  final _categories = [
    'Mobile',
    'Language',
    'Framework',
    'Backend',
    'Tools',
    'Database',
    'Other'
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _categoryCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final skill = SkillModel(
      id: widget.skill?.id ?? '',
      name: _nameCtrl.text.trim(),
      category: _categoryCtrl.text.trim(),
      proficiency: _proficiency.round(),
    );

    if (widget.skill != null) {
      await SkillController.to.updateSkill(skill);
    } else {
      await SkillController.to.add(skill);
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
        constraints: const BoxConstraints(maxWidth: 480),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Text(
                    widget.skill != null ? 'Edit Skill' : 'Add Skill',
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
            Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _nameCtrl,
                      decoration: const InputDecoration(labelText: 'Skill Name *'),
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Name is required'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    // Category dropdown
                    DropdownButtonFormField<String>(
                      value: _categories.contains(_categoryCtrl.text)
                          ? _categoryCtrl.text
                          : null,
                      dropdownColor: AppColors.surface,
                      decoration: const InputDecoration(labelText: 'Category *'),
                      items: _categories
                          .map((c) => DropdownMenuItem(
                        value: c,
                        child: Text(c,
                            style: const TextStyle(
                                color: AppColors.textPrimary)),
                      ))
                          .toList(),
                      onChanged: (v) {
                        if (v != null) _categoryCtrl.text = v;
                      },
                      validator: (v) =>
                      (v == null || v.isEmpty) ? 'Select a category' : null,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Proficiency',
                            style: GoogleFonts.spaceGrotesk(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600)),
                        Text(
                          '${_proficiency.round()}%',
                          style: GoogleFonts.jetBrainsMono(
                              color: AppColors.cyan,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    StatefulBuilder(builder: (context, setSliderState) {
                      return Slider(
                        value: _proficiency,
                        min: 10,
                        max: 100,
                        divisions: 18,
                        activeColor: AppColors.cyan,
                        inactiveColor: AppColors.border,
                        onChanged: (v) {
                          setSliderState(() => _proficiency = v);
                          setState(() => _proficiency = v);
                        },
                      );
                    }),
                  ],
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
                          : Text(
                          widget.skill != null ? 'Update' : 'Add'),
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
}

class _EmptySkillsState extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptySkillsState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.code_rounded,
              size: 80, color: AppColors.textMuted),
          const SizedBox(height: 20),
          Text('No skills yet',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text('Add your first skill to get started',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add Skill'),
          ),
        ],
      ),
    );
  }
}