import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'app_theme.dart';
import 'firebase_services.dart';
import 'model.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Messages', style: Theme.of(context).textTheme.headlineLarge),
          Text('Contact form submissions',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 32),
          Expanded(
            child: StreamBuilder<List<ContactModel>>(
              stream: FirebaseService().streamContacts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(color: AppColors.cyan));
                }
                final msgs = snapshot.data ?? [];
                if (msgs.isEmpty) {
                  return const _EmptyMessages();
                }
                return ListView.separated(
                  itemCount: msgs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, i) =>
                      _MessageCard(contact: msgs[i], index: i),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageCard extends StatelessWidget {
  final ContactModel contact;
  final int index;

  const _MessageCard({required this.contact, required this.index});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      backgroundColor: AppColors.card,
      collapsedBackgroundColor: AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: !contact.read
              ? AppColors.cyan.withOpacity(0.3)
              : AppColors.border,
        ),
      ),
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: !contact.read
              ? AppColors.cyan.withOpacity(0.3)
              : AppColors.border,
        ),
      ),
      onExpansionChanged: (expanded) {
        if (expanded && !contact.read) {
          FirebaseService().markContactRead(contact.id);
        }
      },
      leading: Stack(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.cyanDim,
            child: Text(
              contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '?',
              style: const TextStyle(
                  color: AppColors.cyan, fontWeight: FontWeight.w700),
            ),
          ),
          if (!contact.read)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: AppColors.cyan,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.card, width: 1.5),
                ),
              ),
            ),
        ],
      ),
      title: Text(
        contact.name,
        style: GoogleFonts.spaceGrotesk(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
      subtitle: Text(
        contact.subject,
        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            DateFormat('MMM dd').format(contact.sentAt),
            style: GoogleFonts.spaceGrotesk(
                color: AppColors.textMuted, fontSize: 11),
          ),
          const SizedBox(height: 4),
          Icon(
            !contact.read
                ? Icons.mark_email_unread_rounded
                : Icons.mark_email_read_rounded,
            size: 14,
            color:
            !contact.read ? AppColors.cyan : AppColors.textMuted,
          ),
        ],
      ),
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          decoration: const BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(14)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(color: AppColors.border),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.mail_outline_rounded,
                      size: 14, color: AppColors.textMuted),
                  const SizedBox(width: 6),
                  Text(
                    contact.email,
                    style: GoogleFonts.jetBrainsMono(
                        color: AppColors.cyan, fontSize: 13),
                  ),
                  const Spacer(),
                  Text(
                    DateFormat('MMM dd, yyyy  HH:mm').format(contact.sentAt),
                    style: const TextStyle(
                        color: AppColors.textMuted, fontSize: 11),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  contact.message,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(height: 1.7),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () async {
                      await FirebaseService().deleteContact(contact.id);
                    },
                    icon: const Icon(Icons.delete_outline_rounded,
                        size: 16, color: Colors.redAccent),
                    label: const Text('Delete',
                        style: TextStyle(color: Colors.redAccent)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    )
        .animate(delay: (index * 60).ms)
        .fadeIn(duration: 400.ms)
        .slideX(begin: 0.1, end: 0);
  }
}

class _EmptyMessages extends StatelessWidget {
  const _EmptyMessages();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.inbox_rounded, size: 80, color: AppColors.textMuted),
          const SizedBox(height: 20),
          Text('No messages yet',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text('Messages from the contact form will appear here',
              style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}