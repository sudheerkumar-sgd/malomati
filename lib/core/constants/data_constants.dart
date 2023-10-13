const departments = [
  {
    "IsSuccess": true,
    "Message": "Success",
    "Dept_Name_EN": "Department of Economic Development",
    "Dept_Name_AR": "دائرة التنمية الاقتصادية",
    "PAYROLL_ID": 104
  },
  {
    "IsSuccess": true,
    "Message": "Success",
    "Dept_Name_EN": "Department of Falaj Al Mualla",
    "Dept_Name_AR": "بلدية فلج المعلا",
    "PAYROLL_ID": 102
  },
  {
    "IsSuccess": true,
    "Message": "Success",
    "Dept_Name_EN": "Department of Finance",
    "Dept_Name_AR": "الدائرة المالية",
    "PAYROLL_ID": 62
  },
  {
    "IsSuccess": true,
    "Message": "Success",
    "Dept_Name_EN": "Smart Umm Al Quwain",
    "Dept_Name_AR": "ام القيوين الذكية",
    "PAYROLL_ID": 63
  },
  {
    "IsSuccess": true,
    "Message": "Success",
    "Dept_Name_EN": "Department of Tourism and Archaeology",
    "Dept_Name_AR": "دائرة السياحة والاثار",
    "PAYROLL_ID": 105
  },
  {
    "IsSuccess": true,
    "Message": "Success",
    "Dept_Name_EN": "Department of Urban Planning",
    "Dept_Name_AR": "دائرة التخطيط العمراني",
    "PAYROLL_ID": 108
  },
  {
    "IsSuccess": true,
    "Message": "Success",
    "Dept_Name_EN": "Executive Council",
    "Dept_Name_AR": "الأمانة العامة للمجلس التنفيذي",
    "PAYROLL_ID": 110
  },
  {
    "IsSuccess": true,
    "Message": "Success",
    "Dept_Name_EN": "UAQ  Municipality ",
    "Dept_Name_AR": "بلدية ام القيوين",
    "PAYROLL_ID": 107
  }
];

const thankYouReasonList = [
  {
    "IsSuccess": true,
    "Message": "Success",
    "LOOKUP_CODE": "06",
    "MEANING": "Attend workshops and conferences",
    "attribute8": "حضور ورش العمل والمؤتمرات"
  },
  {
    "IsSuccess": true,
    "Message": "Success",
    "LOOKUP_CODE": "01",
    "MEANING": "Complete task on time",
    "attribute8": "أكمل المهمة في الوقت المحدد\n"
  },
  {
    "IsSuccess": true,
    "Message": "Success",
    "LOOKUP_CODE": "02",
    "MEANING": "Helped me to finish a certain task",
    "attribute8": "المساعده في إنهاء مهمة معينة"
  },
  {
    "IsSuccess": true,
    "Message": "Success",
    "LOOKUP_CODE": "04",
    "MEANING": "Introduce and adopt an innovative idea",
    "attribute8": "تقديم وتبني فكرة إبداعية"
  },
  {
    "IsSuccess": true,
    "Message": "Success",
    "LOOKUP_CODE": "08",
    "MEANING": "Other",
    "attribute8": "آخرى"
  },
  {
    "IsSuccess": true,
    "Message": "Success",
    "LOOKUP_CODE": "05",
    "MEANING": "Participated in committees and events",
    "attribute8": "المشاركة في اللجان والفعاليات"
  },
  {
    "IsSuccess": true,
    "Message": "Success",
    "LOOKUP_CODE": "07",
    "MEANING": "Spread the positivity in work environment",
    "attribute8": "نشر الإيجابية في بيئة العمل"
  },
  {
    "IsSuccess": true,
    "Message": "Success",
    "LOOKUP_CODE": "03",
    "MEANING": "Work in unofficial hours to finish a certain task",
    "attribute8": "العمل في ساعات غير رسمية لإنجاز مهمة معينة"
  }
];

const aboutMalomati =
    'Malomati is Umm Al Quwain Government Self Service Mobile Application for its employees. The application is developed by UAQ Department of eGovernment and will enable employees to use features of the Oracle EBS self-services features over mobile using with the same credentials as the ERP login. Malomati smart application provides six relevant services, which are listed below.';
String getArabicDayName(String dayNameEn) {
  switch (dayNameEn) {
    case 'Sunday':
      return 'الأحد';
    case 'Monday':
      return 'الإثنين';
    case 'Tuesday':
      return 'الثلاثاء';
    case 'Wednesday':
      return 'الأربعاء';
    case 'Thursday':
      return 'الخميس';
    case 'Friday':
      return 'الجمعة';
    case 'Saturday':
      return 'السبت';
    default:
      return '';
  }
}

String getArabicMonthName(String dayNameEn) {
  switch (dayNameEn) {
    case 'January':
      return 'يناير';
    case 'February':
      return 'فبراير';
    case 'March':
      return 'مارس';
    case 'April':
      return 'أبريل';
    case 'May':
      return 'مايو';
    case 'June':
      return 'يونيو';
    case 'July':
      return 'يوليو';
    case 'August':
      return 'أغسطس';
    case 'September':
      return 'سبتمبر';
    case 'October':
      return 'أكتوبر';
    case 'November':
      return 'نوفمبر';
    case 'December':
      return 'ديسمبر';
    default:
      return '';
  }
}

const months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December'
];

const notificationUser = ['MOOZA.BINYEEM', 'MOHAMMED.KAMRAN', 'SUDHEER.AKULA'];
