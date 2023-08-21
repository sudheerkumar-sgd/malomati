// ignore_for_file: must_be_immutable
class InitiativeRequestModel {
  String? iNITIATIVENAME;
  String? uSERNAME;
  String? cREATORUSERNAME;
  String? iNITIATIVEDESCRIPTION;
  String? aPPLICABILITY;
  String? sPECILIZATIONRELATION;
  String? sERVEDEPARTMENTSTRATEGY;
  String? iNITIATIVEYEAR;
  String? eSTIMATEDCOSTIFANY;
  InitiativeRequestModel();
}

extension SourceModelExtension on InitiativeRequestModel {
  Map<String, dynamic> toJson() => {
        "INITIATIVE_NAME": iNITIATIVENAME,
        "USER_NAME": uSERNAME,
        "CREATOR_USER_NAME": cREATORUSERNAME,
        "INITIATIVE_DESCRIPTION": iNITIATIVEDESCRIPTION,
        "APPLICABILITY": aPPLICABILITY,
        "SPECILIZATION_RELATION": sPECILIZATIONRELATION,
        "SERVE_DEPARTMENT_STRATEGY": sERVEDEPARTMENTSTRATEGY,
        "INITIATIVE_YEAR": iNITIATIVEYEAR,
        "ESTIMATED_COST_IF_ANY": eSTIMATEDCOSTIFANY,
      };
}
