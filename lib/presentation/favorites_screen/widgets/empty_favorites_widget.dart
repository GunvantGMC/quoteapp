import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Empty state widget for favorites screen
class EmptyFavoritesWidget extends StatelessWidget {
  final bool isSearching;
  final VoidCallback onDiscoverQuotes;

  const EmptyFavoritesWidget({
    super.key,
    required this.isSearching,
    required this.onDiscoverQuotes,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration
            Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: isSearching ? 'search_off' : 'favorite_border',
                  color: theme.colorScheme.primary,
                  size: 80,
                ),
              ),
            ),

            SizedBox(height: 4.h),

            // Title
            Text(
              isSearching ? 'No Results Found' : 'No Favorites Yet',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 2.h),

            // Description
            Text(
              isSearching
                  ? 'Try adjusting your search terms or explore more quotes to find what inspires you.'
                  : 'Start building your collection of inspirational quotes. Tap the heart icon on any quote to save it here.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 4.h),

            // Action button
            if (!isSearching)
              ElevatedButton.icon(
                onPressed: onDiscoverQuotes,
                icon: CustomIconWidget(
                  iconName: 'explore',
                  color: Colors.white,
                  size: 20,
                ),
                label: Text(
                  'Discover Quotes',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
