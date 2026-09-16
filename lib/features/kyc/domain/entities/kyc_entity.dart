import '../../../../core/enums/app_enums.dart';

/// Request parameters for submitting statutory identity verification.
class KycSubmissionEntity {
  const KycSubmissionEntity({
    required this.documentType,
    required this.documentNumber,
    required this.consentAgreed,
    this.filePath,
    this.fileName,
    this.fileSizeBytes,
  });

  final DocTypeEnum documentType;
  final String documentNumber;
  final bool consentAgreed;
  final String? filePath;
  final String? fileName;
  final int? fileSizeBytes;
}

/// Confirmation result of submitted KYC.
class KycResultEntity {
  const KycResultEntity({
    required this.referenceId,
    required this.status,
    required this.documentType,
    required this.documentNumberMasked,
    this.documentUrl,
    this.submittedAt,
  });

  final String referenceId;
  final KycStatusEnum status;
  final DocTypeEnum documentType;
  final String documentNumberMasked;
  final String? documentUrl;
  final DateTime? submittedAt;
}
