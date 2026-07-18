import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/role.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import '../screens/role_detail_screen.dart';
import '../providers/role_provider.dart';

enum RoleCardType { active, archived }

class RoleCard extends StatelessWidget {
  final Role role;
  final RoleCardType cardType;
  final int index;

  const RoleCard({
    super.key,
    required this.role,
    required this.cardType,
    this.index = 0,
  });

  void _navigate(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RoleDetailScreen(
          role: role,
          cardType: cardType,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isActive = cardType == RoleCardType.active;
    final provider = context.watch<RoleProvider>();
    final isSaved = provider.isSaved(role.id);

    return GestureDetector(
      onTap: () => _navigate(context),
      child: Container(
        color: AppTheme.surface,
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: AppTheme.border),
              ),
              child: const Icon(Icons.business, color: Colors.grey, size: 32),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    role.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.joblyBlue,
                      fontSize: 16,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    role.hideCompanyName ? 'Confidential' : role.companyName,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Remote · India (TBD)',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  if (isActive)
                    Row(
                      children: [
                        const Icon(Icons.flash_on, color: Colors.green, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          'Actively recruiting',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.green[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 4),
                  Text(
                    '${isActive ? "Posted" : "Archived"}: ${isActive ? Formatters.formatDate(role.startDate) : Formatters.formatDate(role.endDate)}',
                    style: theme.textTheme.labelSmall,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (role.minSalary != null)
                        Text(
                          Formatters.formatSalaryRange(role.minSalary, role.maxSalary),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      if (role.minSalary != null) const SizedBox(width: 8),
                      Text(
                        '${role.noOfPositions} openings',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                isSaved ? Icons.bookmark : Icons.bookmark_border, 
                size: 24, 
                color: isSaved ? AppTheme.joblyBlue : AppTheme.textSecondary,
              ),
              onPressed: () => provider.toggleSaveRole(role.id),
            ),
          ],
        ),
      ),
    );
  }
}
