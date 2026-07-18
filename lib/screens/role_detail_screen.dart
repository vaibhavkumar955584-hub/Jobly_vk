import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/role.dart';
import '../widgets/role_card.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import '../providers/role_provider.dart';

class RoleDetailScreen extends StatefulWidget {
  final Role role;
  final RoleCardType cardType;

  const RoleDetailScreen({
    super.key,
    required this.role,
    required this.cardType,
  });

  @override
  State<RoleDetailScreen> createState() => _RoleDetailScreenState();
}

class _RoleDetailScreenState extends State<RoleDetailScreen> {
  bool _isApplying = false;

  void _handleApply() async {
    setState(() => _isApplying = true);
    
    final success = await context.read<RoleProvider>().applyToRole(widget.role.id);
    
    if (mounted) {
      setState(() => _isApplying = false);
      if (success) {
        _showSuccessDialog();
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Application Submitted'),
        content: Text('You have successfully applied for ${widget.role.name} at ${widget.role.companyName}.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _handleShare() {
    final text = 'Check out this job on Jobly:\n'
        '${widget.role.name} at ${widget.role.companyName}\n'
        'Experience: ${Formatters.formatExperience(widget.role.minExperience, widget.role.maxExperience)}';
    Share.share(text);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isActive = widget.cardType == RoleCardType.active;
    final provider = context.watch<RoleProvider>();
    final isSaved = provider.isSaved(widget.role.id);

    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textSecondary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: AppTheme.textSecondary),
            onPressed: _handleShare,
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: AppTheme.textSecondary),
            onSelected: (value) {
              if (value == 'report') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Job listing reported')),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'report', child: Text('Report Job')),
              const PopupMenuItem(value: 'hide', child: Text('Hide similar jobs')),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.role.name,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.role.hideCompanyName ? 'Confidential Company' : widget.role.companyName,
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Remote · India (TBD) · ${isActive ? "Posted " + Formatters.formatDate(widget.role.startDate) : "Archived"}',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.business_center, size: 18, color: AppTheme.textSecondary),
                      const SizedBox(width: 8),
                      Text(
                        'Full-time · ${widget.role.noOfPositions} openings',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.list_alt, size: 18, color: AppTheme.textSecondary),
                      const SizedBox(width: 8),
                      Text(
                        '${widget.role.minExperience}-${widget.role.maxExperience} years experience',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isApplying || !isActive ? null : _handleApply,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: _isApplying 
                              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : Text(isActive ? 'Apply Now' : 'Closed'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton(
                        onPressed: () => provider.toggleSaveRole(widget.role.id),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppTheme.joblyBlue, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                          backgroundColor: isSaved ? AppTheme.joblyBlue.withOpacity(0.1) : null,
                        ),
                        child: Text(
                          isSaved ? 'Saved' : 'Save',
                          style: const TextStyle(color: AppTheme.joblyBlue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(thickness: 8, color: AppTheme.background),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.description_outlined, color: AppTheme.textPrimary, size: 22),
                      const SizedBox(width: 10),
                      Text(
                        'About the job',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _BriefingHtml(html: widget.role.cleanBriefing),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _BriefingHtml extends StatelessWidget {
  final String html;
  const _BriefingHtml({required this.html});

  @override
  Widget build(BuildContext context) {
    if (html.isEmpty) {
      return const Text('No description provided.');
    }

    return Html(
      data: html,
      style: {
        'body': Style(
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
          fontSize: FontSize(16),
          lineHeight: LineHeight(1.6),
          color: AppTheme.textPrimary.withOpacity(0.8),
          fontFamily: 'Inter',
        ),
        'p': Style(
          margin: Margins.only(bottom: 16),
        ),
        'strong': Style(
          fontWeight: FontWeight.w700,
          color: AppTheme.textPrimary,
        ),
        'b': Style(
          fontWeight: FontWeight.w700,
          color: AppTheme.textPrimary,
        ),
        'ul': Style(
          margin: Margins.only(bottom: 16),
          padding: HtmlPaddings.only(left: 20),
        ),
        'li': Style(
          margin: Margins.only(bottom: 10),
          listStyleType: ListStyleType.disc,
          listStylePosition: ListStylePosition.outside,
        ),
        'h1': Style(fontSize: FontSize(22), fontWeight: FontWeight.bold, margin: Margins.only(top: 16, bottom: 8)),
        'h2': Style(fontSize: FontSize(20), fontWeight: FontWeight.bold, margin: Margins.only(top: 14, bottom: 8)),
        'h3': Style(fontSize: FontSize(18), fontWeight: FontWeight.bold, margin: Margins.only(top: 12, bottom: 6)),
      },
    );
  }
}
