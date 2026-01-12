import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../widgets/custom_icon_widget.dart' as custom_widget;

class ActionButtonWidget extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;
  final Color color;
  final bool isLarge;

  const ActionButtonWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    required this.color,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isLarge ? 6.w : 3.w,
          vertical: 1.5.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLarge)
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: Color(0xFF4ADE80),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.refresh, color: Color(0xFF0F2419), size: 32),
              )
            else
              custom_widget.CustomIconWidget(
                iconName: icon,
                color: color,
                size: 28,
              ),
            SizedBox(height: 0.8.h),
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: isLarge ? Color(0xFF4ADE80) : color,
                fontWeight: FontWeight.w600,
                fontSize: isLarge ? 12.sp : 11.sp,
                letterSpacing: isLarge ? 1.5 : 0.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
