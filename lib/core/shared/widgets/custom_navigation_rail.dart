import 'package:movie_valut/core/shared/navigation/app_navigation_destinations.dart';
import 'package:movie_valut/core/shared/widgets/custom_text.dart';
import 'package:movie_valut/core/themes/theme_extensions.dart';
import 'package:flutter/material.dart';

/// Navigation rail customizado para tablet y layouts anchos.
///
/// Complementa al bottom nav móvil y se activa cuando el responsive indica que
/// hay suficiente espacio horizontal para una navegación lateral.
class CustomNavigationRail extends StatelessWidget {
  const CustomNavigationRail({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.compact = false,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final destinations = buildAppNavigationDestinations(context);

    if (compact) {
      return SizedBox(
        width: 88,
        child: Align(
          alignment: Alignment.center,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: colors.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(destinations.length, (index) {
                final destination = destinations[index];
                final isSelected = index == currentIndex;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Tooltip(
                    message: destination.label,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => onTap(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOut,
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? colors.primarySoft
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          destination.icon,
                          color: isSelected ? colors.primary : colors.textMuted,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      );
    }

    return Container(
      width: 108,
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(right: BorderSide(color: colors.border)),
      ),
      child: NavigationRail(
        selectedIndex: currentIndex,
        onDestinationSelected: onTap,
        labelType: NavigationRailLabelType.all,
        backgroundColor: colors.surface,
        indicatorColor: colors.primarySoft,
        selectedIconTheme: IconThemeData(color: colors.primary),
        unselectedIconTheme: IconThemeData(color: colors.textMuted),
        selectedLabelTextStyle: TextStyle(
          color: colors.primary,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelTextStyle: TextStyle(color: colors.textMuted),
        leading: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Icon(
            Icons.account_balance_wallet_rounded,
            color: colors.primary,
          ),
        ),
        destinations: destinations
            .map(
              (destination) => NavigationRailDestination(
                icon: Icon(destination.icon),
                selectedIcon: Icon(destination.icon),
                label: CustomText(text: destination.label, maxLines: 1),
              ),
            )
            .toList(),
      ),
    );
  }
}
