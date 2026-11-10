import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/helper/helper_method.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';

class LessonVideoPlayerBox extends StatefulWidget {
  final String? videoUrl;
  final String? thumbnailUrl;
  final String durationText;
  final VoidCallback? onPlay;

  const LessonVideoPlayerBox({
    super.key,
    this.videoUrl,
    this.thumbnailUrl,
    this.durationText = '00:00',
    this.onPlay,
  });

  @override
  State<LessonVideoPlayerBox> createState() => _LessonVideoPlayerBoxState();
}

class _LessonVideoPlayerBoxState extends State<LessonVideoPlayerBox> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isInitializing = false;
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void didUpdateWidget(covariant LessonVideoPlayerBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      _disposeControllers();
      setState(() {
        _isInitialized = false;
        _isInitializing = false;
        _hasError = false;
      });
    }
  }

  Future<void> _startVideo() async {
    widget.onPlay?.call();

    final url = widget.videoUrl;
    if (url == null || url.trim().isEmpty) {
      HelperMethod.showErrorToast(
        context: context,
        message: 'لا يتوفر رابط فيديو صالح لهذا المحتوى',
      );
      return;
    }

    setState(() {
      _isInitializing = true;
      _hasError = false;
    });

    try {
      final uri = Uri.parse(url);
      _videoPlayerController = VideoPlayerController.networkUrl(uri);
      await _videoPlayerController!.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: true,
        looping: false,
        aspectRatio: _videoPlayerController!.value.aspectRatio > 0
            ? _videoPlayerController!.value.aspectRatio
            : (16 / 9),
        allowFullScreen: true,
        allowMuting: true,
        showControls: true,
        materialProgressColors: ChewieProgressColors(
          playedColor: AppColors.primary,
          handleColor: AppColors.primary,
          bufferedColor: AppColors.primary.withValues(alpha: 0.3),
          backgroundColor: Colors.white24,
        ),
      );

      if (mounted) {
        setState(() {
          _isInitialized = true;
          _isInitializing = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isInitializing = false;
          _hasError = true;
        });
        HelperMethod.showErrorToast(
          context: context,
          message: 'تعذر تحميل أو تشغيل الفيديو',
        );
      }
    }
  }

  void _disposeControllers() {
    _chewieController?.dispose();
    _chewieController = null;
    _videoPlayerController?.dispose();
    _videoPlayerController = null;
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200.h,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16.r),
      ),
      clipBehavior: Clip.antiAlias,
      child: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_isInitialized && _chewieController != null) {
      return Chewie(controller: _chewieController!);
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        _buildThumbnail(),
        DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.4),
          ),
        ),
        Center(
          child: _isInitializing
              ? SizedBox(
                  width: 44.w,
                  height: 44.w,
                  child: const CircularProgressIndicator(
                    color: AppColors.primary,
                    strokeWidth: 3.5,
                  ),
                )
              : GestureDetector(
                  onTap: _startVideo,
                  child: Container(
                    width: 60.w,
                    height: 60.w,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.4),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      _hasError ? Icons.refresh_rounded : Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 36.sp,
                    ),
                  ),
                ),
        ),
        Positioned(
          bottom: 12.h,
          left: 12.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.65),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text(
              widget.durationText,
              style: AppStyles.font12Regular(context).copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildThumbnail() {
    final thumb = widget.thumbnailUrl;
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
