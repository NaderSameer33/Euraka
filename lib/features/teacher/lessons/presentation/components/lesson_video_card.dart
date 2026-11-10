import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../data/models/lesson_model.dart';

class LessonVideoCard extends StatelessWidget {
  final LessonVideoModel video;
  final String? chapterTitle;
  final int index;
  final VoidCallback? onTap;

  const LessonVideoCard({
    super.key,
    required this.video,
    this.chapterTitle,
    this.index = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isHighlighted = index < 2;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: isHighlighted
              ? colorScheme.primary.withValues(alpha: 0.08)
              : colorScheme.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isHighlighted
                ? colorScheme.primary.withValues(alpha: 0.35)
                : colorScheme.outline.withValues(alpha: 0.3),
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: IntrinsicHeight(
          child: Row(
            children: [
              if (isHighlighted)
                Container(
                  width: 4.w,
                  color: AppColors.primary,
                ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 26.w,
                                  height: 26.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.primary,
                                      width: 1.5,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.play_arrow_rounded,
                                    color: AppColors.primary,
                                    size: 16.sp,
                                  ),
                                ),
                                8.horizontalSpace,
                                Expanded(
                                  child: Text(
                                    video.name,
                                    style: AppStyles.font14Bold(context),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            10.verticalSpace,
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.menu_book_outlined,
                                    size: 13.sp,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                  4.horizontalSpace,
                                  Text(
                                    chapterTitle ?? 'الفصل الاول',
                                    style: AppStyles.font12Regular(context).copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      12.horizontalSpace,
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: SizedBox(
                          width: 110.w,
                          height: 72.h,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              _buildThumbnail(video),
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.15),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail(LessonVideoModel video) {
    final thumb = video.formattedThumbnailUrl;
    if (thumb != null && thumb.trim().isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: thumb,
        fit: BoxFit.cover,
        errorWidget: (context, url, error) => Image.asset(
          AppAssets.unitImage,
          fit: BoxFit.cover,
        ),
      );
    }

    return Image.asset(
      AppAssets.unitImage,
      fit: BoxFit.cover,
    );
  }
}
