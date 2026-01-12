import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class QuoteCardWidget extends StatelessWidget {
  final Map<String, dynamic> quote;
  final VoidCallback? onLongPress;

  const QuoteCardWidget({super.key, required this.quote, this.onLongPress});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onLongPress: onLongPress,
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(maxWidth: 90.w),
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.format_quote, color: Color(0xFF2C5F41), size: 80),
              SizedBox(height: 4.h),
              Text(
                quote["text"] ?? '',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  height: 1.4,
                  fontSize: 20.sp,
                  letterSpacing: 0.3,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 4.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 12.w,
                    height: 0.3.h,
                    decoration: BoxDecoration(
                      color: Color(0xFF4ADE80),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Flexible(
                    child: Text(
                      '- ${quote["author"] ?? ''}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Color(0xFF4ADE80),
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.visible,
                      softWrap: true,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Container(
                    width: 12.w,
                    height: 0.3.h,
                    decoration: BoxDecoration(
                      color: Color(0xFF4ADE80),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomIconWidget extends StatelessWidget {
  final String iconName;
  final Color color;
  final double size;

  const CustomIconWidget({
    super.key,
    required this.iconName,
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    IconData? iconData;

    switch (iconName) {
      case 'format_quote':
        iconData = Icons.format_quote;
        break;
      case 'favorite':
        iconData = Icons.favorite;
        break;
      case 'favorite_border':
        iconData = Icons.favorite_border;
        break;
      case 'share':
        iconData = Icons.share;
        break;
      case 'refresh':
        iconData = Icons.refresh;
        break;
      case 'content_copy':
        iconData = Icons.content_copy;
        break;
      case 'person':
        iconData = Icons.person;
        break;
      default:
        iconData = Icons.help_outline;
    }

    return Icon(iconData, color: color, size: size);
  }
}
