/// Request DTO for KYC submission.
class KycSubmitRequestDto {
  const KycSubmitRequestDto({
    required this.documentType,
    required this.documentNumber,
    required this.consentAgreed,
  });

  final String documentType;
  final String documentNumber;
  final bool consentAgreed;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'documentType': documentType,
        'documentNumber': documentNumber,
        'consentAgreed': consentAgreed,
      };
}

/// Response DTO for KYC submission.
class KycSubmitResponseDto {
  const KycSubmitResponseDto({
    required this.referenceId,
    required this.status,
    required this.documentType,
    required this.documentNumberMasked,
    this.documentUrl,
    this.submittedAt,
  });

  factory KycSubmitResponseDto.fromJson(Map<String, dynamic> json) {
    return KycSubmitResponseDto(
      referenceId: json['referenceId'] as String? ?? 'KYC-000000',
      status: json['status'] as String? ?? 'PENDING',
      documentType: json['documentType'] as String? ?? 'AADHAAR',
      documentNumberMasked: json['documentNumberMasked'] as String? ?? 'XXXX XXXX 0000',
      documentUrl: json['documentUrl'] as String?,
      submittedAt: json['submittedAt'] as String?,
    );
  }

  final String referenceId;
  final String status;
  final String documentType;
  final String documentNumberMasked;
  final String? documentUrl;
  final String? submittedAt;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'referenceId': referenceId,
        'status': status,
        'documentType': documentType,
        'documentNumberMasked': documentNumberMasked,
        if (documentUrl != null) 'documentUrl': documentUrl,
        if (submittedAt != null) 'submittedAt': submittedAt,
      };
}
