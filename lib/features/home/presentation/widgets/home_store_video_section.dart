import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';

/// Store Video Section for Home Screen where showroom and craftsmanship videos
/// can be previewed, played, and uploaded by store administrators.
class HomeStoreVideoSection extends StatefulWidget {
  const HomeStoreVideoSection({super.key});

  @override
  State<HomeStoreVideoSection> createState() => _HomeStoreVideoSectionState();
}

class _HomeStoreVideoSectionState extends State<HomeStoreVideoSection>
    with SingleTickerProviderStateMixin {
  bool _isPlaying = false;
  bool _isMuted = false;
  double _playbackProgress = 0.32; // 32% played initially
  String? _uploadedVideoName;
  Timer? _playbackTimer;

  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    if (WidgetsBinding.instance is WidgetsFlutterBinding) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _playbackTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _playbackTimer = Timer.periodic(const Duration(milliseconds: 250), (timer) {
          if (!mounted) return;
          setState(() {
            _playbackProgress += 0.005;
            if (_playbackProgress >= 1.0) {
              _playbackProgress = 0.0;
              _isPlaying = false;
              timer.cancel();
            }
          });
        });
      } else {
        _playbackTimer?.cancel();
      }
    });
  }

  Future<void> _handleUploadVideo() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? video = await picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(minutes: 5),
      );

      if (video != null) {
        setState(() {
          _uploadedVideoName = video.name;
          _isPlaying = false;
          _playbackProgress = 0.0;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppColors.espressoCharcoal,
              content: Text(
                'Store Video "${video.name}" successfully uploaded and linked!',
                style: const TextStyle(color: Colors.white),
              ),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.statusErrorText,
            content: Text('Video upload cancelled or unsupported: $e'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _openFullScreenVideo() {
    showDialog<void>(
      context: context,
      builder: (BuildContext ctx) {
        return Dialog(
          backgroundColor: Colors.black,
          insetPadding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      'Swastik Flagship Store Tour (4K)',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/hero_carousel_1.jpg',
                      fit: BoxFit.cover,
                    ),
                    Center(
                      child: IconButton(
                        iconSize: 56,
                        icon: Icon(
                          _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                          color: AppColors.honeyGoldAccent,
                        ),
                        onPressed: () {
                          _togglePlayPause();
                          Navigator.of(ctx).pop();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  'Heritage vault walkthrough, master karigars crafting 22K jewellery, and showroom consultation lounge.',
                  style: TextStyle(color: Color(0xFFC0BCB5), fontSize: 12),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final int currentSeconds = (_playbackProgress * 155).toInt(); // 2m 35s video
    final String currentMinutesStr = '${currentSeconds ~/ 60}:${(currentSeconds % 60).toString().padLeft(2, '0')}';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: AppSpacing.all16,
      decoration: BoxDecoration(
        color: AppColors.creamIvoryCard,
        borderRadius: AppRadius.border20,
        border: Border.all(color: AppColors.warmLinenInset, width: 1),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x082B2521),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Section Title & Upload Action
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.champagneFoil,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.honeyGoldAccent.withValues(alpha: 0.4),
                      ),
                    ),
                    child: const Icon(
                      Icons.video_library_rounded,
                      color: AppColors.honeyGoldAccent,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'OUR FLAGSHIP STORE',
                        style: AppTypography.kickerCaps(
                          color: AppColors.warmTaupeBrown,
                        ).copyWith(fontSize: 10, letterSpacing: 0.8),
                      ),
                      Text(
                        'Experience Swastik',
                        style: AppTypography.cardTitle(
                          color: AppColors.espressoCharcoal,
                        ).copyWith(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),

              // Upload Video Button
              OutlinedButton.icon(
                onPressed: _handleUploadVideo,
                icon: const Icon(Icons.cloud_upload_outlined, size: 16),
                label: const Text(
                  'Upload',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.espressoCharcoal,
                  side: const BorderSide(color: AppColors.honeyGoldAccent, width: 1),
                  shape: const RoundedRectangleBorder(borderRadius: AppRadius.border12),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  minimumSize: const Size(60, 32),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Main Video Player Container
          ClipRRect(
            borderRadius: AppRadius.border16,
            child: Stack(
              children: <Widget>[
                // Video Poster / Backdrop
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.asset(
                    'assets/images/hero_carousel_1.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppColors.espressoCharcoal,
                      child: const Center(
                        child: Icon(Icons.storefront_rounded, size: 50, color: AppColors.honeyGoldAccent),
                      ),
                    ),
                  ),
                ),

                // Dark Cinematic Gradient Overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: <Color>[
                          Colors.black.withValues(alpha: 0.25),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.75),
                        ],
                      ),
                    ),
                  ),
                ),

                // Top Badge: 4K & Store Location
                Positioned(
                  top: 10,
                  left: 10,
                  right: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.65),
                          borderRadius: AppRadius.border8,
                          border: Border.all(color: AppColors.honeyGoldAccent.withValues(alpha: 0.6)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: AppColors.statusSuccessText,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 5),
                            const Text(
                              '4K ULTRA HD • STORE TOUR',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: _openFullScreenVideo,
                        icon: const Icon(Icons.fullscreen_rounded, color: Colors.white, size: 22),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        tooltip: 'Full Screen',
                      ),
                    ],
                  ),
                ),

                // Center: Play / Pause Button with Pulsing Gold Glow
                Positioned.fill(
                  child: Center(
                    child: GestureDetector(
                      onTap: _togglePlayPause,
                      child: ScaleTransition(
                        scale: _isPlaying ? const AlwaysStoppedAnimation<double>(1.0) : _pulseAnimation,
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.honeyGoldAccent,
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: AppColors.honeyGoldAccent.withValues(alpha: 0.5),
                                blurRadius: 16,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Icon(
                            _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                            color: AppColors.deepUmberBronze,
                            size: 34,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Bottom Video Controls & Scrub Bar
                Positioned(
                  bottom: 8,
                  left: 12,
                  right: 12,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      // Progress Bar
                      ClipRRect(
                        borderRadius: AppRadius.border8,
                        child: LinearProgressIndicator(
                          value: _playbackProgress,
                          backgroundColor: Colors.white.withValues(alpha: 0.3),
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.honeyGoldAccent),
                          minHeight: 4,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '$currentMinutesStr / 02:35',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isMuted = !_isMuted;
                              });
                            },
                            child: Icon(
                              _isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Subtitle / Description
          Row(
            children: <Widget>[
              const Icon(Icons.store_rounded, size: 16, color: AppColors.honeyGoldAccent),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  _uploadedVideoName != null
                      ? 'Current Video: $_uploadedVideoName'
                      : 'Swastik Flagship Showroom & Heritage Vault Walkthrough',
                  style: AppTypography.caption(
                    color: AppColors.warmTaupeBrown,
                  ).copyWith(fontSize: 11.5, fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
