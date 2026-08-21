import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_routes.dart';

/// Data model for each group type card
class GroupType {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final List<String> modules;

  const GroupType({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.modules,
  });
}

class GroupTypeScreen extends StatefulWidget {
  const GroupTypeScreen({super.key});

  @override
  State<GroupTypeScreen> createState() => _GroupTypeScreenState();
}

class _GroupTypeScreenState extends State<GroupTypeScreen> {

  String? _selectedTypeId;

  final List<GroupType> _groupTypes = const [
    GroupType(
      id: 'njangi',
      title: 'Njangi / Rotating Savings',
      description: 'Rotating contributions and payouts. Each member receives the pot in turn.',
      icon: Icons.currency_exchange_rounded,
      modules: ['Cycles', 'Rotation', 'Contributions', 'Loans', 'Fines'],
    ),
    GroupType(
      id: 'village',
      title: 'Village Development Association',
      description: 'Annual dues, community projects and transparent expenditure tracking.',
      icon: Icons.location_city_rounded,
      modules: ['Annual Dues', 'Projects', 'AGM', 'Voting', 'Meetings'],
    ),
    GroupType(
      id: 'welfare',
      title: 'Funeral / Welfare Society',
      description: 'Welfare events and death contributions managed with full transparency.',
      icon: Icons.favorite_rounded,
      modules: ['Welfare Events', 'Death Contributions', 'Fines'],
    ),
    GroupType(
      id: 'church',
      title: 'Church / Religious Group',
      description: 'Track offerings, building funds and religious group finances.',
      icon: Icons.church_rounded,
      modules: ['Offerings', 'Building Funds', 'Announcements'],
    ),
    GroupType(
      id: 'pta',
      title: 'School PTA',
      description: 'Term dues, school project funding and parent meeting records.',
      icon: Icons.school_rounded,
      modules: ['Term Dues', 'School Projects', 'Meetings'],
    ),
    GroupType(
      id: 'cooperative',
      title: 'Cooperative / Union',
      description: 'Share capital, dividends and cooperative governance.',
      icon: Icons.handshake_rounded,
      modules: ['Share Capital', 'Dividends', 'Governance', 'Voting'],
    ),
    GroupType(
      id: 'custom',
      title: 'Custom Group',
      description: 'Configure all modules manually to fit your unique group needs.',
      icon: Icons.tune_rounded,
      modules: ['All modules — you choose'],
    ),
  ];

  void _continue() {
    if (_selectedTypeId == null) return;
    Navigator.pushNamed(
      context,
      AppRoutes.createGroup,       // ← was groupType
      arguments: _selectedTypeId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey100,
      appBar: AppBar(
        title: const Text('Create a Group'),
      ),
      body: SafeArea(
        child: Column(
          children: [

            // ── Header ──────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'What type of group\nare you creating?',
                    style: AppTextStyles.headlineLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This sets up the right features for your group automatically.',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.grey700,
                    ),
                  ),
                ],
              ),
            ),

            // ── Group Type List ──────────────────────────
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                itemCount: _groupTypes.length,
                itemBuilder: (context, index) {
                  return _buildTypeCard(_groupTypes[index]);
                },
              ),
            ),

            // ── Continue Button ──────────────────────────
            Padding(
              padding: const EdgeInsets.all(24),
              child: ElevatedButton(
                onPressed: _selectedTypeId != null
                    ? _continue
                    : null,
                child: const Text('Continue'),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildTypeCard(GroupType type) {
    bool isSelected = _selectedTypeId == type.id;

    return GestureDetector(
      onTap: () => setState(() => _selectedTypeId = type.id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primarySurface
              : AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.grey300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [

            // ── Icon ────────────────────────────────────
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.grey100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                type.icon,
                color: isSelected
                    ? AppColors.white
                    : AppColors.grey700,
                size: 24,
              ),
            ),

            const SizedBox(width: 14),

            // ── Text ────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type.title,
                    style: AppTextStyles.headlineSmall.copyWith(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.grey900,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    type.description,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.grey700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  // Module tags
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: type.modules.map((module) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withOpacity(0.1)
                              : AppColors.grey100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          module,
                          style: AppTextStyles.caption.copyWith(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.grey700,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // ── Selection Indicator ──────────────────────
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? AppColors.primary
                    : AppColors.transparent,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.grey300,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check_rounded,
                      size: 14,
                      color: AppColors.white,
                    )
                  : null,
            ),

          ],
        ),
      ),
    );
  }
}