import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/entities/kyc_entity.dart';

/// KYC Document Upload section matching `kyc.html` / `kyc.css`.
class KycUploadCard extends StatelessWidget {
  const KycUploadCard({
    super.key,
    required this.selectedFile,
    required this.onTakePhoto,
    required this.onChooseGallery,
    required this.onRemoveFile,
    this.enabled = true,
  });

  final SelectedKycFile? selectedFile;
  final VoidCallback onTakePhoto;
  final VoidCallback onChooseGallery;
  final VoidCallback onRemoveFile;
  final bool enabled;

  static const Color _goldLight = Color(0xFFF4E2AA);
  static const Color _goldPrimary = Color(0xFFCCA243);
  static const Color _goldMuted = Color(0x47CCA243); // rgba(204, 162, 65, 0.28)
  static const Color _emeraldBorder = Color(0x38CCA243); // rgba(204, 162, 65, 0.22)
  static const Color _choiceBtnBg = Color(0x730D4A3A); // rgba(13, 74, 58, 0.45)
  static const Color _dropzoneBg = Color(0xA6041913); // rgba(4, 25, 19, 0.65)
  static const Color _previewBg = Color(0xE6041913); // rgba(4, 25, 19, 0.90)
  static const Color _textMuted = Color(0xFF8FA499);
  static const Color _textDim = Color(0xFF5C7469);
  static const Color _success = Color(0xFF10B981);
  static const Color _danger = Color(0xFFEF4444);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          'UPLOAD DOCUMENT PHOTO / SCAN',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: _goldLight,
            letterSpacing: 0.04 * 12,
          ),
        ),
        const SizedBox(height: 8),

        // Quick Choice Buttons: Take Photo & Choose Gallery
        Row(
          children: <Widget>[
            Expanded(
              child: _buildChoiceButton(
                label: 'Take Photo',
                icon: Icons.camera_alt_outlined,
                onPressed: enabled ? onTakePhoto : null,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildChoiceButton(
                label: 'Choose from Gallery',
                icon: Icons.drive_folder_upload_outlined,
                onPressed: enabled ? onChooseGallery : null,
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        // Selected File Preview OR Dropzone Area
        if (selectedFile != null)
          _buildPreviewCard(selectedFile!)
        else
          _buildDropzone(context),
      ],
    );
  }

  Widget _buildChoiceButton({
    required String label,
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: _choiceBtnBg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _emeraldBorder,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                size: 16,
                color: _goldLight,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    color: _goldLight,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropzone(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onChooseGallery : null,
        borderRadius: BorderRadius.circular(14),
        child: CustomPaint(
          painter: const _DashedRRectPainter(
            color: Color(0x59CCA243), // rgba(204, 162, 65, 0.35)
            strokeWidth: 1.5,
            radius: 14,
            dashPattern: <double>[6, 4],
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 16,
            ),
            decoration: BoxDecoration(
              color: _dropzoneBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // Dropzone Icon Orb (44x44 circular orb)
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0x1FCCA243), // rgba(204, 162, 65, 0.12)
                    border: Border.all(
                      color: _goldMuted,
                      width: 1,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.image_outlined,
                      size: 22,
                      color: _goldLight,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Supports JPG, PNG, WEBP or PDF (Max 10 MB)',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: _textMuted,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewCard(SelectedKycFile file) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _previewBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0x59CCA243), // rgba(204, 162, 65, 0.35)
          width: 1,
        ),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          // Thumbnail Preview 52x52
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFF031711),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _goldMuted,
                  width: 1,
                ),
              ),
              child: _buildThumbnail(file),
            ),
          ),
          const SizedBox(width: 12),

          // File metadata
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  file.name,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: <Widget>[
                    const Icon(
                      Icons.check_rounded,
                      size: 13,
                      color: _success,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${file.formattedSize} • Ready',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: _goldLight,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Remove Button
          if (enabled)
            IconButton(
              icon: const Icon(Icons.close_rounded, size: 18),
              color: _textDim,
              splashRadius: 18,
              onPressed: onRemoveFile,
              tooltip: 'Remove file',
              hoverColor: _danger.withAlpha(30),
            ),
        ],
      ),
    );
  }

  Widget _buildThumbnail(SelectedKycFile file) {
    if (!kIsWeb && file.isImage && file.path.isNotEmpty) {
      final File localFile = File(file.path);
      if (localFile.existsSync()) {
        return Image.file(
          localFile,
          fit: BoxFit.cover,
          errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) =>
              _fallbackDocIcon(),
        );
      }
    }
    return _fallbackDocIcon();
  }

  Widget _fallbackDocIcon() {
    return const Center(
      child: Icon(
        Icons.description_outlined,
        color: _goldPrimary,
        size: 24,
      ),
    );
  }
}

/// Custom dashed border painter for dropzone matching `1.5px dashed rgba(204, 162, 65, 0.35)`.
class _DashedRRectPainter extends CustomPainter {
  const _DashedRRectPainter({
    required this.color,
    required this.strokeWidth,
    required this.radius,
    required this.dashPattern,
  });

  final Color color;
  final double strokeWidth;
  final double radius;
  final List<double> dashPattern;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        strokeWidth / 2,
        strokeWidth / 2,
        size.width - strokeWidth,
        size.height - strokeWidth,
      ),
      Radius.circular(radius),
    );

    final Path path = Path()..addRRect(rrect);
    final Path dashedPath = _createDashedPath(path, dashPattern);
    canvas.drawPath(dashedPath, paint);
  }

  Path _createDashedPath(Path source, List<double> pattern) {
    final Path dest = Path();
    for (final PathMetric metric in source.computeMetrics()) {
      double distance = 0.0;
      int patternIndex = 0;
      bool draw = true;

      while (distance < metric.length) {
        final double len = pattern[patternIndex];
        if (draw) {
          final double end = (distance + len < metric.length)
              ? distance + len
              : metric.length;
          dest.addPath(
            metric.extractPath(distance, end),
            Offset.zero,
          );
        }
        distance += len;
        patternIndex = (patternIndex + 1) % pattern.length;
        draw = !draw;
      }
    }
    return dest;
  }

  @override
  bool shouldRepaint(covariant _DashedRRectPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.radius != radius;
  }
}
