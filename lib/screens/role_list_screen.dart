import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/role.dart';
import '../widgets/role_card.dart';
import '../widgets/state_views.dart';
import '../theme/app_theme.dart';
import '../providers/role_provider.dart';

class RoleListScreen extends StatefulWidget {
  final RoleCardType cardType;
  final bool isSavedOnly;

  const RoleListScreen({
    super.key,
    required this.cardType,
    this.isSavedOnly = false,
  });

  @override
  State<RoleListScreen> createState() => _RoleListScreenState();
}

class _RoleListScreenState extends State<RoleListScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!widget.isSavedOnly) {
        context.read<RoleProvider>().fetchRoles(
          active: widget.cardType == RoleCardType.active,
        );
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Role> _applyFilter(List<Role> roles) {
    List<Role> filtered = roles;
    if (widget.isSavedOnly) {
      final savedIds = context.watch<RoleProvider>().savedRoleIds;
      filtered = roles.where((r) => savedIds.contains(r.id)).toList();
    }
    
    if (_selectedFilter == 'Entry Level') {
      filtered = filtered.where((r) => r.minExperience <= 1).toList();
    } else if (_selectedFilter == 'High Salary') {
      filtered = filtered.where((r) => (r.minSalary ?? 0) >= 2000000).toList();
    }
    
    if (_searchQuery.isEmpty) return filtered;
    
    final lower = _searchQuery.toLowerCase();
    return filtered.where((r) {
      return r.name.toLowerCase().contains(lower) ||
          r.companyName.toLowerCase().contains(lower);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final provider = context.watch<RoleProvider>();
    final roles = widget.cardType == RoleCardType.active 
        ? provider.activeRoles 
        : provider.archivedRoles;
    
    final displayRoles = _applyFilter(roles);

    return Column(
      children: [
        Container(
          color: AppTheme.surface,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                onChanged: (v) => setState(() => _searchQuery = v),
                decoration: InputDecoration(
                  hintText: 'Search ${widget.isSavedOnly ? "saved " : ""}roles...',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  isDense: true,
                  fillColor: const Color(0xFFEDF3F8),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['All', 'Entry Level', 'High Salary'].map((filter) {
                    final isSelected = _selectedFilter == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(filter),
                        selected: isSelected,
                        onSelected: (val) => setState(() => _selectedFilter = filter),
                        selectedColor: AppTheme.joblyBlue.withOpacity(0.2),
                        checkmarkColor: AppTheme.joblyBlue,
                        labelStyle: TextStyle(
                          color: isSelected ? AppTheme.joblyBlue : AppTheme.textSecondary,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 13,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: _buildBody(provider, displayRoles),
        ),
      ],
    );
  }

  Widget _buildBody(RoleProvider provider, List<Role> roles) {
    if (provider.isLoading && roles.isEmpty) return const LoadingView();

    if (provider.error != null && roles.isEmpty) {
      return ErrorView(
        message: provider.error!, 
        onRetry: () => provider.fetchRoles(active: widget.cardType == RoleCardType.active),
      );
    }

    if (roles.isEmpty) {
      return EmptyView(searchQuery: _searchQuery.isNotEmpty ? _searchQuery : "");
    }

    return RefreshIndicator(
      onRefresh: () => provider.fetchRoles(active: widget.cardType == RoleCardType.active),
      child: ListView.separated(
        itemCount: roles.length,
        padding: const EdgeInsets.symmetric(vertical: 8),
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          return RoleCard(
            role: roles[index],
            cardType: widget.cardType,
            index: index,
          );
        },
      ),
    );
  }
}
