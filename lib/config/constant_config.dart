import 'package:flutter/material.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:malomati/domain/entities/favorite_entity.dart';

import '../core/constants/constants.dart';
import '../res/drawables/drawable_assets.dart';

class ConstantConfig {
  final services = [
    FavoriteEntity(
        id: 1,
        name: 'HR Approvals',
        nameAR: 'موافقات الموارد البشرية',
        iconPath: DrawableAssets.icHrApprovals),
    FavoriteEntity(
        id: 2,
        name: 'Finance Approvals',
        nameAR: 'موافقات المالية',
        iconPath: DrawableAssets.icFinanceApprovals),
    FavoriteEntity(
        id: 3,
        name: 'Annual Leaves',
        nameAR: 'الإجازة الدورية',
        iconPath: DrawableAssets.icAnualleaves),
    FavoriteEntity(
        id: 4,
        name: 'Permission',
        nameAR: 'إذن خروج',
        iconPath: DrawableAssets.icServicePermission),
    FavoriteEntity(
        id: 5,
        name: 'Sick Leaves',
        nameAR: 'اجازة مرضية',
        iconPath: DrawableAssets.icSickleaves),
    FavoriteEntity(
        id: 6,
        name: 'Mission Leaves',
        nameAR: 'اجازة مهمة رسمية',
        iconPath: DrawableAssets.icMissionleaves),
    FavoriteEntity(
        id: 7,
        name: 'Other Leaves',
        nameAR: 'الإجازات اخرى',
        iconPath: DrawableAssets.icServiceLeave),
    FavoriteEntity(
        id: 8,
        name: 'Initiatives',
        nameAR: 'المبادرات',
        iconPath: DrawableAssets.icInitiatives),
    FavoriteEntity(
        id: 9,
        name: 'Certificates',
        nameAR: 'شهادة الراتب',
        iconPath: DrawableAssets.icServiceCertificate),
    FavoriteEntity(
        id: 10,
        name: 'Thank You',
        nameAR: 'شكراً لك',
        iconPath: DrawableAssets.icServiceThankyou),
    FavoriteEntity(
        id: 11,
        name: 'Payslip',
        nameAR: 'كشف الراتب',
        iconPath: DrawableAssets.icPayslip),
    FavoriteEntity(
        id: 12,
        name: 'Advance Salary',
        nameAR: 'راتب الإجازة',
        iconPath: DrawableAssets.icAdvancesalary),
    FavoriteEntity(
        id: 13,
        name: 'Overtime',
        nameAR: 'العمل الإضافي',
        iconPath: DrawableAssets.icOvertime),
    FavoriteEntity(
        id: 14,
        name: 'Badge',
        nameAR: 'بطاقة العمل',
        iconPath: DrawableAssets.icBadge),
    FavoriteEntity(
        id: 15,
        name: 'Delete Leave',
        nameAR: 'حذف الإجازة',
        iconPath: DrawableAssets.icDeleteLeave),
    FavoriteEntity(
        id: 16,
        name: 'Warning',
        nameAR: 'إنذار',
        iconPath: DrawableAssets.icWarning),
    FavoriteEntity(
        id: 19,
        name: 'View Warning',
        nameAR: 'عرض الإنذارات',
        iconPath: DrawableAssets.icViewWarning),
    FavoriteEntity(
        id: 20,
        name: 'Delegation',
        nameAR: 'تفويض الصلاحيات',
        iconPath: DrawableAssets.icVacationRules),
    FavoriteEntity(
        id: 21,
        name: 'Cancel Invoice',
        nameAR: 'الغاء الفاتورة',
        iconPath: DrawableAssets.icCancelInvoice),
    FavoriteEntity(
        id: 25,
        name: 'Remote Work',
        nameAR: 'العمل عن بعد',
        iconPath: DrawableAssets.icWorkFromHome),
    FavoriteEntity(
        id: 22,
        name: 'Contract Renewal',
        nameAR: 'تجديد العقد',
        iconPath: DrawableAssets.icContractRenew),
    FavoriteEntity(
        id: 23,
        name: 'Resignation',
        nameAR: 'استقالة',
        iconPath: DrawableAssets.icResignation),
    FavoriteEntity(
        id: 24,
        name: 'Add Training Certificate',
        nameAR: 'إضافة شهادة تدريب',
        iconPath: DrawableAssets.icResignation),
    FavoriteEntity(
        id: 17,
        name: 'Holidays',
        nameAR: 'العطلات',
        iconPath: DrawableAssets.icEvent),
    FavoriteEntity(
        id: 18,
        name: 'My Team',
        nameAR: 'فريقي',
        iconPath: DrawableAssets.icMyteam),
  ];
  final managerServices = [
    FavoriteEntity(
        id: 1,
        name: 'HR Approvals',
        nameAR: 'موافقات الموارد البشرية',
        iconPath: DrawableAssets.icHrApprovals),
    FavoriteEntity(
        id: 2,
        name: 'Finance Approvals',
        nameAR: 'موافقات المالية',
        iconPath: DrawableAssets.icFinanceApprovals),
    FavoriteEntity(
        id: 18,
        name: 'My Team',
        nameAR: 'فريقي',
        iconPath: DrawableAssets.icMyteam),
    FavoriteEntity(
        id: 16,
        name: 'Warning',
        nameAR: 'التحذير',
        iconPath: DrawableAssets.icWarning),
    FavoriteEntity(
        id: 20,
        name: 'Delegation of authorities',
        nameAR: 'تفويض الصلاحيات',
        iconPath: DrawableAssets.icVacationRules),
    FavoriteEntity(
        id: 21,
        name: 'Cancel Invoice',
        nameAR: 'الغاء الفاتورة',
        iconPath: DrawableAssets.icCancelInvoice),
  ];
  final guestServices = [
    FavoriteEntity(
        id: 31, name: 'Jobs', nameAR: 'وظائف', iconPath: DrawableAssets.icJobs),
    FavoriteEntity(
        id: 17,
        name: 'Holidays',
        nameAR: 'العطلات',
        iconPath: DrawableAssets.icEvent),
    FavoriteEntity(
        id: 32,
        name: 'UAQ Apps',
        nameAR: 'تطبيقات',
        iconPath: DrawableAssets.icApps),
  ];

  final dashboardFavorites = [
    {
      'id': 3,
      'name': 'Annual Leaves',
      'nameAR': 'الإجازة الدورية',
      'iconPath': DrawableAssets.icAnualleaves
    },
    {
      'id': 4,
      'name': 'Permission',
      'nameAR': 'إذن خروج',
      'iconPath': DrawableAssets.icServicePermission
    },
    {
      'id': 10,
      'name': 'Thank You',
      'nameAR': 'شكراً لك',
      'iconPath': DrawableAssets.icServiceThankyou
    },
    {
      'id': 0,
      'name': favoriteAdd,
      'nameAR': favoriteAddAR,
      'iconPath': DrawableAssets.icServiceAdd
    },
    {
      'id': 0,
      'name': favoriteAdd,
      'nameAR': favoriteAddAR,
      'iconPath': DrawableAssets.icServiceAdd
    },
    {
      'id': 0,
      'name': favoriteAdd,
      'nameAR': favoriteAddAR,
      'iconPath': DrawableAssets.icServiceAdd
    },
  ];

  List<FavoriteEntity> getServicesByManager(
      {required bool isManager, bool isGuest = false}) {
    if (isGuest) {
      return guestServices;
    }
    return isManager
        ? services
        : services
            .where((element) => !managerServices.contains(element))
            .toList();
  }

  final leaveTypes = {
    "LeaveTypeList": [
      {
        "NAME": "Annual Leave",
        "NAME_AR": "الأجازة الدورية",
        "ABSENCE_ATTENDANCE_TYPE_ID": 61,
        "HOURS_OR_DAYS": "D"
      },
      {
        "NAME": "Compassionate Leave",
        "NAME_AR": "إجازة حداد",
        "ABSENCE_ATTENDANCE_TYPE_ID": 62,
        "HOURS_OR_DAYS": "D"
      },
      {
        "NAME": "Escort Leave International",
        "NAME_AR": "أجازة مرافقة دولية",
        "ABSENCE_ATTENDANCE_TYPE_ID": 2062,
        "HOURS_OR_DAYS": "D"
      },
      {
        "NAME": "Escort Leave National",
        "NAME_AR": "إجازة مرافقة محلية",
        "ABSENCE_ATTENDANCE_TYPE_ID": 64,
        "HOURS_OR_DAYS": "D"
      },
      {
        "NAME": "Exam Leave",
        "NAME_AR": "إجازة امتحان",
        "ABSENCE_ATTENDANCE_TYPE_ID": 66,
        "HOURS_OR_DAYS": "D"
      },
      {
        "NAME": "Exam day leave",
        "NAME_AR": "إجازة يوم الامتحان",
        "ABSENCE_ATTENDANCE_TYPE_ID": 67,
        "HOURS_OR_DAYS": "D"
      },
      {
        "NAME": "Exceptional Mission Leave",
        "NAME_AR": "أجازة مهمة رسمية",
        "ABSENCE_ATTENDANCE_TYPE_ID": 68,
        "HOURS_OR_DAYS": "D"
      },
      {
        "NAME": "Hajj Leave",
        "NAME_AR": "إجازة الحج",
        "ABSENCE_ATTENDANCE_TYPE_ID": 69,
        "HOURS_OR_DAYS": "D"
      },
      {
        "NAME": "Maternity Leave",
        "NAME_AR": "إجازة أمومة",
        "ABSENCE_ATTENDANCE_TYPE_ID": 70,
        "HOURS_OR_DAYS": "D"
      },
      {
        "NAME": "National Service",
        "NAME_AR": "الخدمة الوطنية",
        "ABSENCE_ATTENDANCE_TYPE_ID": 71,
        "HOURS_OR_DAYS": "D"
      },
      {
        "NAME": "Nursing Hours",
        "NAME_AR": "ساعات الإرضاع",
        "ABSENCE_ATTENDANCE_TYPE_ID": 72,
        "HOURS_OR_DAYS": "H"
      },
      {
        "NAME": "Occupational Injury",
        "NAME_AR": "إصابة عمل",
        "ABSENCE_ATTENDANCE_TYPE_ID": 73,
        "HOURS_OR_DAYS": "D"
      },
      {
        "NAME": "Overtime leave",
        "NAME_AR": "إجازة الأيام البديلة",
        "ABSENCE_ATTENDANCE_TYPE_ID": 63,
        "HOURS_OR_DAYS": "D"
      },
      {
        "NAME": "Paternity Leave",
        "NAME_AR": "إجازة الأبوة",
        "ABSENCE_ATTENDANCE_TYPE_ID": 74,
        "HOURS_OR_DAYS": "D"
      },
      {
        "NAME": "Permission",
        "NAME_AR": "إذن خروج",
        "ABSENCE_ATTENDANCE_TYPE_ID": 75,
        "HOURS_OR_DAYS": "H"
      },
      {
        "NAME": "Sick Leave",
        "NAME_AR": "إجازة مرضية",
        "ABSENCE_ATTENDANCE_TYPE_ID": 76,
        "HOURS_OR_DAYS": "D"
      },
      {
        "NAME": "Sick Leave Extension",
        "NAME_AR": "تمديد لإجازة مرضية",
        "ABSENCE_ATTENDANCE_TYPE_ID": 77,
        "HOURS_OR_DAYS": "D"
      },
      {
        "NAME": "Spouse Escort Leave",
        "NAME_AR": "إجازة مرافقة الزوج",
        "ABSENCE_ATTENDANCE_TYPE_ID": 1061,
        "HOURS_OR_DAYS": "D"
      },
      {
        "NAME": "Study Leave Full",
        "NAME_AR": "إجازة دراسة كاملة",
        "ABSENCE_ATTENDANCE_TYPE_ID": 1062,
        "HOURS_OR_DAYS": "D"
      },
      {
        "NAME": "Study Leave Partial Permission",
        "NAME_AR": "إجازة دراسة بإذن جزئي",
        "ABSENCE_ATTENDANCE_TYPE_ID": 1063,
        "HOURS_OR_DAYS": "H"
      },
      {
        "NAME": "Uddah Leave",
        "NAME_AR": "إجازة العدّة",
        "ABSENCE_ATTENDANCE_TYPE_ID": 1064,
        "HOURS_OR_DAYS": "D"
      },
      {
        "NAME": "Unauthorized Absence",
        "NAME_AR": "إنقطاع عن العمل ",
        "ABSENCE_ATTENDANCE_TYPE_ID": 1066,
        "HOURS_OR_DAYS": "D"
      },
      {
        "NAME": "Unpaid Leave",
        "NAME_AR": "إجازة غير مدفوعة الاجر",
        "ABSENCE_ATTENDANCE_TYPE_ID": 1065,
        "HOURS_OR_DAYS": "D"
      },
      // {
      //   "NAME": "Work From Home",
      //   "NAME_AR": "العمل من المنزل",
      //   "ABSENCE_ATTENDANCE_TYPE_ID": 4061,
      //   "HOURS_OR_DAYS": "D"
      // }
    ]
  };
  static ValueNotifier<bool> isApprovalCountChange = ValueNotifier(false);
  static int hrApprovalCount = 0;
  static int financePOApprovalCount = 0;
  static int financePRApprovalCount = 0;
  static int financeINVApprovalCount = 0;
  static int financePayrollApprovalCount = 0;
  static int requestsApprovalCount = 0;
  static int requestsRejectCount = 0;
  static int requestsPendingCount = 0;
  static int notificationsCount = 0;
  static int badgeCount = 0;
  static ValueNotifier<Map<String, dynamic>?> onFCMMessageReceived =
      ValueNotifier(null);
  static const fcmServerApiKey =
      'AAAAW47t3kQ:APA91bFuEWK4MWc7bVSf24RYAdcBuSPIeu4CLhOV2qOp_UctljSHas5BvNngpFNf_OQVAOWXtuNSjNOdbOqWpXRUscryDK8sPqTGUnVk2qrtwVs21eOVr8mK9sDhcotgxKslSm6vB3LW';
  static String cancelInvoiceUsers = '';
  static AccessToken? fcmAccessTokenJson;

  final triningCertificateType = [
    {"id": 1, "typeEn": "General Skill", "typeAr": "المهارات العامة"},
    {"id": 2, "typeEn": " Specialized Skill", "typeAr": "المهارة المتخصصة"},
  ];
  final resignationReasons = [
    {
      "id": 1,
      "reasonEn": "Termination by employer within probation period",
      "reasonAr": "إنهاء الخدمة من قبل صاحب العمل خلال فترة الاختبار"
    },
    {"id": 2, "reasonEn": "By amiri decrae", "reasonAr": "بمرسوم اميرى"},
    {
      "id": 3,
      "reasonEn":
          "Termination by employer with approval UWV (Wage Report Only)",
      "reasonAr":
          "إنهاء الخدمة من قبل صاحب العمل بموافقة UWV (تقرير الأجور فقط)"
    },
    {"id": 4, "reasonEn": "Lack of fitness", "reasonAr": "عدم اللياقة الصحية"},
    {
      "id": 5,
      "reasonEn": "Dissolution by the court at request of employer",
      "reasonAr": "حل الشركة من قبل المحكمة بناء على طلب صاحب العمل"
    },
    {
      "id": 6,
      "reasonEn": "Functional incompetence",
      "reasonAr": "عدم الكفاءة الوظيفية"
    },
    {
      "id": 7,
      "reasonEn": "Termination with mutual approval initiated by employer",
      "reasonAr": "إنهاء الخدمة بموافقة متبادلة من قبل صاحب العمل"
    },
    {"id": 8, "reasonEn": "Discharge", "reasonAr": "الفصل من الخدمة"},
    {
      "id": 9,
      "reasonEn":
          "Non-Renewal or Termination of Contract before its completion",
      "reasonAr": "عدم تجديد العقد أوأنهائه قبل انتهاء مدته"
    },
    {
      "id": 10,
      "reasonEn": "Interruption from work without justification",
      "reasonAr": "إنقطاع عن العمل دون مبرر"
    },
    {"id": 11, "reasonEn": "Restructuring", "reasonAr": "اعادة الهيكلة"},
    {
      "id": 12,
      "reasonEn":
          "Replacement in accordance with the plans to settle the functions of non-citizens",
      "reasonAr": "الإحلال وفقا لخطط توطين وظائف"
    },
    {
      "id": 13,
      "reasonEn": "End of contract by employee, caused, initiated by employee",
      "reasonAr": "نهاية العقد من قبل الموظف، تسبب فيه، بدأه الموظف"
    },
    {
      "id": 14,
      "reasonEn": "Termination by employer without notice",
      "reasonAr": "إنهاء الخدمة من قبل صاحب العمل دون إشعار"
    },
    {
      "id": 15,
      "reasonEn": "End of contract for exp of a fixed-term employment contract",
      "reasonAr": "نهاية العقد لانتهاء عقد عمل محدد المدة"
    },
    {
      "id": 16,
      "reasonEn":
          "End of contract due to other reason (Pension, deceased, etc.)",
      "reasonAr": "نهاية العقد لأي سبب آخر (معاش، وفاة، الخ.)"
    },
    {
      "id": 17,
      "reasonEn":
          "End of temp employment contract,due to illness of temp worker",
      "reasonAr": "نهاية عقد العمل المؤقت بسبب مرض العامل المؤقت"
    },
    {
      "id": 18,
      "reasonEn": "End of temporary employment contract, due to other reason",
      "reasonAr": "انتهاء عقد العمل المؤقت لأي سبب آخر"
    },
    {
      "id": 19,
      "reasonEn": "Labour disability with approval UWV (PGGM Only)",
      "reasonAr": "إعاقة العمل مع موافقة UWV (PGGM فقط)"
    },
    {
      "id": 20,
      "reasonEn": "Business economical reason with approval UWV (PGGM Only)",
      "reasonAr": "سبب اقتصادي تجاري مع موافقة UWV (PGGM فقط)"
    },
    {
      "id": 21,
      "reasonEn": "Active contract but administrative termination of contract",
      "reasonAr": "عقد نشط ولكن إنهاء إداري للعقد"
    },
    {
      "id": 22,
      "reasonEn": "Other reason, not mentioned before",
      "reasonAr": "سبب آخر لم يذكر من قبل"
    },
    {
      "id": 23,
      "reasonEn":
          "Separation from service or administrative segregation violated a court order",
      "reasonAr": "الفصل من الخدمة لمخالفة ادارية"
    },
    {
      "id": 24,
      "reasonEn": "Transfer to Other Enitiy",
      "reasonAr": "النقل إلى جهة أخرى"
    },
    {"id": 25, "reasonEn": "The Resignation", "reasonAr": "استقاله"},
    {
      "id": 26,
      "reasonEn": "Transfer to Diplomatic and Consulate Staff",
      "reasonAr": "النقل إلى السلك الدبلوماسي"
    },
    {
      "id": 27,
      "reasonEn":
          "Dismissal by virtue of resolution issued by the Council of Ministers",
      "reasonAr": "إقالة بموجب ق ا رر صادر عن"
    },
    {
      "id": 28,
      "reasonEn": "Issuance of federal decree",
      "reasonAr": "بمرسوم اتحادي"
    },
    {
      "id": 29,
      "reasonEn": "Not Transferred Visa",
      "reasonAr": "عدم نقل الكفالة"
    },
    {"id": 30, "reasonEn": "No Show", "reasonAr": "عدم مباشرة العمل"},
    {"id": 31, "reasonEn": "Early Retirement", "reasonAr": "تقاعد مبكر"},
    {"id": 32, "reasonEn": "PHD Completion", "reasonAr": "اكمال الدكتوراه"},
    {"id": 33, "reasonEn": "Act of God", "reasonAr": "قضاء و قدر"},
    {
      "id": 34,
      "reasonEn": "Resignation due to Disability",
      "reasonAr": "الاستقالة بسبب الإعاقة"
    },
    {"id": 35, "reasonEn": "By Contract", "reasonAr": "حسب العقد"},
    {
      "id": 36,
      "reasonEn": "By employee's initiative",
      "reasonAr": "بمبادرة من الموظف"
    },
    {"id": 37, "reasonEn": "Deceased", "reasonAr": "الوفاة"},
    {
      "id": 38,
      "reasonEn": "Expiry of Determined Period",
      "reasonAr": "انتهاء فترة محددة"
    },
    {"id": 39, "reasonEn": "Disciplinary", "reasonAr": "تأديبي"},
    {"id": 40, "reasonEn": "Dismissed", "reasonAr": "مفصول"},
    {"id": 41, "reasonEn": "Disability", "reasonAr": "إعاقة"}
  ];
}
