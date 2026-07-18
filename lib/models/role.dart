/// Role model matching the verified API response shape from
/// https://api.wraeglobal.com/roleRouter/getActiveRoles &
/// https://api.wraeglobal.com/roleRouter/getArchivedRoles
///
/// NOTE: There is NO `location` field in the API response.
/// This is handled gracefully in the UI with a fallback label.
class Role {
  final int id;
  final String name;
  final String companyName;
  final int companyId;
  final int noOfPositions;
  final DateTime? startDate;
  final DateTime? endDate;
  final int minExperience;
  final int maxExperience;
  final int? categoryId;
  final int? domainId;
  final int? statusId;
  final bool active;
  final int? minSalary;
  final int? maxSalary;
  final int? referralAmount;
  final bool hideCompanyName;
  final String? recruiterId;
  final String? briefing;
  final DateTime? createdDate;
  final DateTime? updatedDate;
  final String? createdBy;
  final String? updatedBy;

  const Role({
    required this.id,
    required this.name,
    required this.companyName,
    required this.companyId,
    required this.noOfPositions,
    this.startDate,
    this.endDate,
    required this.minExperience,
    required this.maxExperience,
    this.categoryId,
    this.domainId,
    this.statusId,
    required this.active,
    this.minSalary,
    this.maxSalary,
    this.referralAmount,
    required this.hideCompanyName,
    this.recruiterId,
    this.briefing,
    this.createdDate,
    this.updatedDate,
    this.createdBy,
    this.updatedBy,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: _toInt(json['id']) ?? 0,
      // Field is `name`, not `title` or `jobTitle`
      name: json['name'] as String? ?? 'Untitled Role',
      // Field is `CompanyName` (capitalised — copy exactly)
      companyName: json['CompanyName'] as String? ?? 'Unknown Company',
      companyId: _toInt(json['company_id']) ?? 0,
      noOfPositions: _toInt(json['no_of_positions']) ?? 1,
      startDate: _parseDate(json['start_date']),
      endDate: _parseDate(json['end_date']),
      minExperience: _toInt(json['min_experience']) ?? 0,
      maxExperience: _toInt(json['max_experience']) ?? 0,
      categoryId: _toInt(json['category_id']),
      domainId: _toInt(json['domain_id']),
      statusId: _toInt(json['status_id']),
      active: json['active'] == true || json['active'] == 1 || json['active'] == '1',
      minSalary: _toInt(json['min_salary']),
      maxSalary: _toInt(json['max_salary']),
      referralAmount: _toInt(json['referral_amount']),
      hideCompanyName: json['hide_company_name'] == true || json['hide_company_name'] == 1 || json['hide_company_name'] == '1',
      recruiterId: json['recruiter_id']?.toString(),
      briefing: json['briefing'] as String?,
      createdDate: _parseDate(json['created_date']),
      updatedDate: _parseDate(json['updated_date']),
      createdBy: json['created_by'] as String?,
      updatedBy: json['updated_by'] as String?,
    );
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  static DateTime? _parseDate(dynamic raw) {
    if (raw == null) return null;
    try {
      return DateTime.parse(raw as String);
    } catch (_) {
      return null;
    }
  }

  /// Strips the outer escaped-quote wrapping that appears on many `briefing`
  /// values in the real API response (e.g. `"\"<p>...</p>\""` → `<p>...</p>`).
  /// Also handles `null` or empty briefing gracefully.
  String get cleanBriefing {
    if (briefing == null || briefing!.isEmpty) return '';
    String cleaned = briefing!.trim();
    
    // Strip a leading/trailing stray double-quote (double-encoding quirk)
    if (cleaned.startsWith('"') && cleaned.endsWith('"') && cleaned.length > 1) {
      cleaned = cleaned.substring(1, cleaned.length - 1);
    }
    
    // Unescape any remaining escaped quotes
    cleaned = cleaned.replaceAll('\\"', '"');
    
    // Some API briefings use \n for lists instead of HTML tags
    if (!cleaned.contains('<p>') && !cleaned.contains('<li>')) {
      cleaned = cleaned.replaceAll('\n', '<br>');
    }

    return cleaned.trim();
  }
}
