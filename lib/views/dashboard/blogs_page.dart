import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_portfolio/controllers/blog_controller.dart';
import 'package:flutter_portfolio/models/model.dart';
import 'package:flutter_portfolio/theme/app_theme.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class BlogsPage extends StatelessWidget {
  const BlogsPage({super.key});

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
                  Text('Blogs',
                      style: Theme.of(context).textTheme.headlineLarge),
                  Text('Manage your articles & posts',
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () => _showBlogDialog(context),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('New Blog'),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Expanded(
            child: Obx(() {
              if (BlogController.to.isLoading.value) {
                return const Center(
                    child:
                    CircularProgressIndicator(color: AppColors.cyan));
              }
              final blogs = BlogController.to.allBlogs;
              if (blogs.isEmpty) {
                return _EmptyBlogsState(
                    onAdd: () => _showBlogDialog(context));
              }
              return ListView.separated(
                itemCount: blogs.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) => _BlogTile(
                  blog: blogs[i],
                  index: i,
                  onEdit: () =>
                      _showBlogDialog(context, blog: blogs[i]),
                  onDelete: () => _confirmDelete(context, blogs[i]),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
// _showBlogDialog মেথডটি এরকম হবে:
  void _showBlogDialog(BuildContext context, {BlogModel? blog}) {
    showDialog(
      context: context,
      builder: (dialogContext) => _BlogDialog(blog: blog),  // আলাদা context নাম দিন
    );
  }

// _confirmDelete মেথড:
  void _confirmDelete(BuildContext context, BlogModel blog) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(  // আলাদা context নাম দিন
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Delete Blog', style: Theme.of(dialogContext).textTheme.headlineMedium),
        content: Text('Delete "${blog.title}"? This cannot be undone.',
            style: Theme.of(dialogContext).textTheme.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await BlogController.to.delete(blog.id);
              Navigator.pop(dialogContext);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _BlogTile extends StatelessWidget {
  final BlogModel blog;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _BlogTile({
    required this.blog,
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
        border: Border.all(
          color: blog.published
              ? AppColors.border
              : Colors.orange.withOpacity(0.3),
        ),
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
            child: blog.imageUrl.isNotEmpty
                ? ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(blog.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(
                      Icons.article_rounded,
                      color: AppColors.textMuted,
                      size: 24)),
            )
                : const Icon(Icons.article_rounded,
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
                        blog.title,
                        style: GoogleFonts.spaceGrotesk(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: blog.published
                            ? AppColors.green.withOpacity(0.15)
                            : Colors.orange.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        blog.published ? 'Published' : 'Draft',
                        style: GoogleFonts.spaceGrotesk(
                          color: blog.published
                              ? AppColors.green
                              : Colors.orange,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  blog.excerpt,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 13),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.schedule_rounded,
                        size: 12, color: AppColors.textMuted),
                    const SizedBox(width: 4),
                    Text(
                      '${blog.readTimeMinutes} min read  •  '
                          '${DateFormat('MMM dd, yyyy').format(blog.publishedAt)}',
                      style: const TextStyle(
                          color: AppColors.textMuted, fontSize: 11),
                    ),
                  ],
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
// BLOG DIALOG
// ──────────────────────────────────────────────
class _BlogDialog extends StatefulWidget {
  final BlogModel? blog;
  const _BlogDialog({this.blog});

  @override
  State<_BlogDialog> createState() => _BlogDialogState();
}

class _BlogDialogState extends State<_BlogDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _titleCtrl =
  TextEditingController(text: widget.blog?.title);
  late final _excerptCtrl =
  TextEditingController(text: widget.blog?.excerpt);
  late final _contentCtrl =
  TextEditingController(text: widget.blog?.content);
  late final _imgCtrl =
  TextEditingController(text: widget.blog?.imageUrl);
  late final _tagsCtrl =
  TextEditingController(text: widget.blog?.tags.join(', '));
  late final _readTimeCtrl = TextEditingController(
      text: (widget.blog?.readTimeMinutes ?? 5).toString());
  late bool _published = widget.blog?.published ?? true;
  bool _loading = false;

  @override
  void dispose() {
    for (final c in [
      _titleCtrl,
      _excerptCtrl,
      _contentCtrl,
      _imgCtrl,
      _tagsCtrl,
      _readTimeCtrl
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final tags = _tagsCtrl.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final blog = BlogModel(
      id: widget.blog?.id ?? '',
      title: _titleCtrl.text.trim(),
      excerpt: _excerptCtrl.text.trim(),
      content: _contentCtrl.text.trim(),
      imageUrl: _imgCtrl.text.trim(),
      tags: tags,
      readTimeMinutes: int.tryParse(_readTimeCtrl.text) ?? 5,
      publishedAt: widget.blog?.publishedAt ?? DateTime.now(),
      published: _published,
    );

    if (widget.blog != null) {
      await BlogController.to.updateBlog(blog);
    } else {
      await BlogController.to.add(blog);
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
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 750),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Text(
                    widget.blog != null ? 'Edit Blog' : 'New Blog',
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
                      _field('Excerpt *', _excerptCtrl, maxLines: 2),
                      const SizedBox(height: 16),
                      _field('Content (Markdown)', _contentCtrl,
                          maxLines: 6),
                      const SizedBox(height: 16),
                      _field('Cover Image URL', _imgCtrl),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                              child: _field(
                                  'Tags (comma-separated)', _tagsCtrl,
                                  hint: 'Flutter, Dart')),
                          const SizedBox(width: 12),
                          SizedBox(
                            width: 130,
                            child: _field('Read Time (min)', _readTimeCtrl,
                                keyboardType: TextInputType.number),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Switch(
                            value: _published,
                            onChanged: (v) =>
                                setState(() => _published = v),
                            activeColor: AppColors.green,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _published ? 'Published' : 'Draft',
                            style: GoogleFonts.spaceGrotesk(
                              color: _published
                                  ? AppColors.green
                                  : Colors.orange,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
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
                          : Text(
                          widget.blog != null ? 'Update' : 'Publish'),
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

class _EmptyBlogsState extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyBlogsState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.article_rounded,
              size: 80, color: AppColors.textMuted),
          const SizedBox(height: 20),
          Text('No blogs yet',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text('Write your first article',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add_rounded),
            label: const Text('New Blog'),
          ),
        ],
      ),
    );
  }
}