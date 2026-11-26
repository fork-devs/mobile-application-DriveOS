import 'package:flutter/material.dart';
import 'package:mobile_application_driveos/core/localization/app_localizations.dart';
import 'package:mobile_application_driveos/core/theme/app_theme.dart';
import 'package:mobile_application_driveos/core/widgets/driveos_liquid_button.dart';
import 'package:mobile_application_driveos/features/core/domain/core_domain.dart';

/// Image-first DriveOS branch card supporting banner photos with a navy-gradient
/// fallback.
class BranchListCard extends StatelessWidget {
  /// The branch represented by this card.
  final Branch branch;

  /// Whether this branch is currently focused.
  final bool isFocused;

  /// Whether this branch matches the active session branch.
  final bool isCurrentSession;

  /// Callback invoked when the card is tapped.
  final VoidCallback onTap;

  /// Callback invoked when the user clicks the primary Enter button.
  final VoidCallback onEnter;

  /// Optional callback invoked when the user taps Edit.
  final VoidCallback? onEdit;

  /// Creates a [BranchListCard].
  const BranchListCard({
    super.key,
    required this.branch,
    required this.isFocused,
    required this.isCurrentSession,
    required this.onTap,
    required this.onEnter,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final borderColor = isCurrentSession
        ? DriveOSColors.primaryBlue
        : (isFocused ? DriveOSColors.accentSkyBlue : DriveOSColors.borderSlate);

    return Material(
      key: Key('branch_card_${branch.code}'),
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      elevation: isCurrentSession ? 3 : 1,
      shadowColor: const Color(0xFF0F172A).withValues(alpha: 0.10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: borderColor,
              width: isCurrentSession ? 1.8 : 1.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _BranchCoverBanner(
                branch: branch,
                isCurrentSession: isCurrentSession,
                onEdit: onEdit,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      branch.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w800,
                        color: DriveOSColors.graphiteText,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _MetadataRow(
                      icon: Icons.place_outlined,
                      text: branch.address,
                      maxLines: 2,
                    ),
                    if (branch.phone.isNotEmpty) ...[
                      const SizedBox(height: 5),
                      _MetadataRow(
                        icon: Icons.phone_outlined,
                        text: branch.phone,
                      ),
                    ],
                    const SizedBox(height: 14),
                    DriveOSLiquidButton(
                      key: Key('btn_enter_branch_${branch.code}'),
                      icon: Icons.arrow_forward_rounded,
                      label: loc.translate('enter_branch'),
                      expand: true,
                      onPressed: onEnter,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BranchCoverBanner extends StatelessWidget {
  const _BranchCoverBanner({
    required this.branch,
    required this.isCurrentSession,
    this.onEdit,
  });

  final Branch branch;
  final bool isCurrentSession;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final hasBanner =
        branch.bannerImageUrl != null && branch.bannerImageUrl!.isNotEmpty;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(17)),
      child: SizedBox(
        height: 112,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (hasBanner)
              Image.network(
                branch.bannerImageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const _FallbackBanner(),
              )
            else
              const _FallbackBanner(),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.15),
                    Colors.black.withValues(alpha: 0.45),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 10,
              left: 12,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  branch.code,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                    color: DriveOSColors.primaryBlue,
                  ),
                ),
              ),
            ),
            if (onEdit != null)
              Positioned(
                top: 8,
                right: 8,
                child: Material(
                  color: Colors.white.withValues(alpha: 0.92),
                  shape: const CircleBorder(),
                  child: IconButton(
                    icon: const Icon(
                      Icons.edit_outlined,
                      size: 18,
                      color: DriveOSColors.graphiteText,
                    ),
                    onPressed: onEdit,
                    constraints: const BoxConstraints.tightFor(
                      width: 34,
                      height: 34,
                    ),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _FallbackBanner extends StatelessWidget {
  const _FallbackBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0F2D5E),
            Color(0xFF1E3A8A),
            Color(0xFF2563EB),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.garage_outlined,
          size: 38,
          color: Colors.white.withValues(alpha: 0.35),
        ),
      ),
    );
  }
}

class _MetadataRow extends StatelessWidget {
  const _MetadataRow({
    required this.icon,
    required this.text,
    this.maxLines = 1,
  });

  final IconData icon;
  final String text;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16,
          color: DriveOSColors.graphiteText.withValues(alpha: 0.55),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              color: DriveOSColors.graphiteText.withValues(alpha: 0.72),
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}
