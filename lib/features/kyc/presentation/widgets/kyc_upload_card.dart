import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          'Upload Document Photo / Scan',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.emeraldTextSubtle,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: AppSpacing.space8),

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
            const SizedBox(width: AppSpacing.space8),
            Expanded(
              child: _buildChoiceButton(
                label: 'Choose from Gallery',
                icon: Icons.photo_library_outlined,
                onPressed: enabled ? onChooseGallery : null,
              ),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.space10),

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
        borderRadius: AppRadius.border10,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(12),
            borderRadius: AppRadius.border10,
            border: Border.all(
              color: AppColors.goldBorder.withAlpha(100),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                size: 16,
                color: AppColors.goldPrimary,
              ),
              const SizedBox(width: AppSpacing.space6),
              Flexible(
                child: Text(
                  label,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryLight,
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
        borderRadius: AppRadius.border12,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.space20,
            horizontal: AppSpacing.space16,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(8),
            borderRadius: AppRadius.border12,
            border: Border.all(
              color: Colors.white.withAlpha(25),
              width: 1.2,
              strokeAlign: BorderSide.strokeAlignCenter,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.goldPrimary.withAlpha(25),
                ),
                child: const Icon(
                  Icons.cloud_upload_outlined,
                  size: 22,
                  color: AppColors.goldPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.space10),
              Text(
                'Attach Document Image / PDF',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'Supports JPG, PNG, WEBP or PDF (Max 10 MB)',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w400,
                  color: AppColors.emeraldTextSubtle,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewCard(SelectedKycFile file) {
    return Container(
      padding: AppSpacing.all12,
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(20),
        borderRadius: AppRadius.border12,
        border: Border.all(
          color: AppColors.goldPrimary.withAlpha(180),
          width: 1.2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.goldPrimary.withAlpha(25),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          // Thumbnail Preview
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 48,
              height: 48,
              child: _buildThumbnail(file),
            ),
          ),
          const SizedBox(width: AppSpacing.space12),

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
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimaryLight,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  children: <Widget>[
                    const Icon(
                      Icons.check_circle,
                      size: 13,
                      color: AppColors.statusSuccessText,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${file.formattedSize} • Ready',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.statusSuccessText,
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
              icon: const Icon(Icons.close, size: 20),
              color: AppColors.textTertiary,
              onPressed: onRemoveFile,
              tooltip: 'Remove file',
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
    return Container(
      color: AppColors.goldPrimary.withAlpha(30),
      child: const Center(
        child: Icon(
          Icons.description_outlined,
          color: AppColors.goldPrimary,
          size: 24,
        ),
      ),
    );
  }
}
