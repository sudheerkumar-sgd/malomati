import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// Tooltip shown on the overview fab button
  ///
  /// In en, this message translates to:
  /// **'{bankName} • {dateString}'**
  String transactionSubTittleText(String bankName, String dateString);

  /// The app name
  ///
  /// In en, this message translates to:
  /// **'Malomati'**
  String get appTitle;

  /// No description provided for @please_select_language.
  ///
  /// In en, this message translates to:
  /// **'Please Select Language'**
  String get please_select_language;

  /// No description provided for @please_select_language_ar.
  ///
  /// In en, this message translates to:
  /// **'الرجـاء اخــتيـار اللـغـة'**
  String get please_select_language_ar;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// No description provided for @manager_amp_employee_self_service_of_uaq_government.
  ///
  /// In en, this message translates to:
  /// **'Manager & Employee Self-Service of UAQ Government'**
  String get manager_amp_employee_self_service_of_uaq_government;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember Me'**
  String get rememberMe;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// No description provided for @loginWith.
  ///
  /// In en, this message translates to:
  /// **'Login with'**
  String get loginWith;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @services.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get services;

  /// No description provided for @requests.
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get requests;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @punchIn.
  ///
  /// In en, this message translates to:
  /// **'Punch In'**
  String get punchIn;

  /// No description provided for @punchOut.
  ///
  /// In en, this message translates to:
  /// **'Punch Out'**
  String get punchOut;

  /// No description provided for @morningPunch.
  ///
  /// In en, this message translates to:
  /// **'Good Morning, you didn\'t punch yet'**
  String get morningPunch;

  /// No description provided for @thankYouForPunchIn.
  ///
  /// In en, this message translates to:
  /// **'Thank You, You have punched in'**
  String get thankYouForPunchIn;

  /// No description provided for @thankYouForPunchOut.
  ///
  /// In en, this message translates to:
  /// **'Goodbye, Have a good day'**
  String get thankYouForPunchOut;

  /// No description provided for @myFavoriteService.
  ///
  /// In en, this message translates to:
  /// **'My Favorite Service'**
  String get myFavoriteService;

  /// No description provided for @balanceSickLeaves.
  ///
  /// In en, this message translates to:
  /// **'Balance\nSick Leaves'**
  String get balanceSickLeaves;

  /// No description provided for @balanceLeaves.
  ///
  /// In en, this message translates to:
  /// **'Balance\nLeaves'**
  String get balanceLeaves;

  /// No description provided for @balancePermission.
  ///
  /// In en, this message translates to:
  /// **'Balance\nPermission'**
  String get balancePermission;

  /// No description provided for @totalThankYou.
  ///
  /// In en, this message translates to:
  /// **'Total\nThank You'**
  String get totalThankYou;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'day'**
  String get day;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'hours'**
  String get hours;

  /// No description provided for @star.
  ///
  /// In en, this message translates to:
  /// **'star'**
  String get star;

  /// No description provided for @leaves.
  ///
  /// In en, this message translates to:
  /// **'Leaves'**
  String get leaves;

  /// No description provided for @otherLeaves.
  ///
  /// In en, this message translates to:
  /// **'Other Leaves'**
  String get otherLeaves;

  /// No description provided for @permission.
  ///
  /// In en, this message translates to:
  /// **'Permission'**
  String get permission;

  /// No description provided for @attendance.
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get attendance;

  /// No description provided for @certificate.
  ///
  /// In en, this message translates to:
  /// **'Certificate'**
  String get certificate;

  /// No description provided for @thankYou.
  ///
  /// In en, this message translates to:
  /// **'Thank You'**
  String get thankYou;

  /// No description provided for @badge.
  ///
  /// In en, this message translates to:
  /// **'Badge'**
  String get badge;

  /// No description provided for @myTeam.
  ///
  /// In en, this message translates to:
  /// **'My Team'**
  String get myTeam;

  /// No description provided for @overtime.
  ///
  /// In en, this message translates to:
  /// **'Overtime'**
  String get overtime;

  /// No description provided for @advanceSalary.
  ///
  /// In en, this message translates to:
  /// **'Advance Salary'**
  String get advanceSalary;

  /// No description provided for @payslip.
  ///
  /// In en, this message translates to:
  /// **'Payslip'**
  String get payslip;

  /// No description provided for @initiatives.
  ///
  /// In en, this message translates to:
  /// **'Initiatives'**
  String get initiatives;

  /// No description provided for @missionLeaves.
  ///
  /// In en, this message translates to:
  /// **'Mission Leaves'**
  String get missionLeaves;

  /// No description provided for @sickLeaves.
  ///
  /// In en, this message translates to:
  /// **'Sick Leaves'**
  String get sickLeaves;

  /// No description provided for @annualLeaves.
  ///
  /// In en, this message translates to:
  /// **'Annual Leaves'**
  String get annualLeaves;

  /// No description provided for @hrApprovals.
  ///
  /// In en, this message translates to:
  /// **'HR Approvals'**
  String get hrApprovals;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @financeApprovals.
  ///
  /// In en, this message translates to:
  /// **'Finance Approvals'**
  String get financeApprovals;

  /// No description provided for @deleteLeave.
  ///
  /// In en, this message translates to:
  /// **'Delete Leave'**
  String get deleteLeave;

  /// No description provided for @warnings.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warnings;

  /// No description provided for @viewWarnings.
  ///
  /// In en, this message translates to:
  /// **'View warning'**
  String get viewWarnings;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @selfService.
  ///
  /// In en, this message translates to:
  /// **'Self Service'**
  String get selfService;

  /// No description provided for @approved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get approved;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// No description provided for @absent.
  ///
  /// In en, this message translates to:
  /// **'Absent'**
  String get absent;

  /// No description provided for @present.
  ///
  /// In en, this message translates to:
  /// **'Present'**
  String get present;

  /// No description provided for @weekOff.
  ///
  /// In en, this message translates to:
  /// **'Week Off'**
  String get weekOff;

  /// No description provided for @historyLogs.
  ///
  /// In en, this message translates to:
  /// **'History Logs'**
  String get historyLogs;

  /// No description provided for @notificationSetting.
  ///
  /// In en, this message translates to:
  /// **'Notification Setting'**
  String get notificationSetting;

  /// No description provided for @hRGovernmentLaw.
  ///
  /// In en, this message translates to:
  /// **'HR Government Law'**
  String get hRGovernmentLaw;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @privacyAndPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy and Policy'**
  String get privacyAndPolicy;

  /// No description provided for @aboutMalomati.
  ///
  /// In en, this message translates to:
  /// **'About Ma’lomati'**
  String get aboutMalomati;

  /// No description provided for @teamNotification.
  ///
  /// In en, this message translates to:
  /// **'Team Notification'**
  String get teamNotification;

  /// No description provided for @contactAssistance.
  ///
  /// In en, this message translates to:
  /// **'Contact Assistance'**
  String get contactAssistance;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @employeeID.
  ///
  /// In en, this message translates to:
  /// **'Employee ID'**
  String get employeeID;

  /// No description provided for @designation.
  ///
  /// In en, this message translates to:
  /// **'Designation'**
  String get designation;

  /// No description provided for @emailID.
  ///
  /// In en, this message translates to:
  /// **'Email ID'**
  String get emailID;

  /// No description provided for @departmentName.
  ///
  /// In en, this message translates to:
  /// **'Department Name'**
  String get departmentName;

  /// No description provided for @maritalStatus.
  ///
  /// In en, this message translates to:
  /// **'Marital Status'**
  String get maritalStatus;

  /// No description provided for @dob.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dob;

  /// No description provided for @mobile.
  ///
  /// In en, this message translates to:
  /// **'Mobile'**
  String get mobile;

  /// No description provided for @joiningDate.
  ///
  /// In en, this message translates to:
  /// **'Joining Date'**
  String get joiningDate;

  /// No description provided for @managerName.
  ///
  /// In en, this message translates to:
  /// **'Manager Name'**
  String get managerName;

  /// No description provided for @yearOfService.
  ///
  /// In en, this message translates to:
  /// **'Year of Service'**
  String get yearOfService;

  /// No description provided for @basicSalary.
  ///
  /// In en, this message translates to:
  /// **'Basic Salary'**
  String get basicSalary;

  /// No description provided for @timeAttendance.
  ///
  /// In en, this message translates to:
  /// **'Time Attendance'**
  String get timeAttendance;

  /// No description provided for @regularIn.
  ///
  /// In en, this message translates to:
  /// **'Regular In'**
  String get regularIn;

  /// No description provided for @officialWorkIn.
  ///
  /// In en, this message translates to:
  /// **'Official Work In'**
  String get officialWorkIn;

  /// No description provided for @overtimeIn.
  ///
  /// In en, this message translates to:
  /// **'Overtime In'**
  String get overtimeIn;

  /// No description provided for @shortLeaveIn.
  ///
  /// In en, this message translates to:
  /// **'Short Leave In'**
  String get shortLeaveIn;

  /// No description provided for @regularOut.
  ///
  /// In en, this message translates to:
  /// **'Regular Out'**
  String get regularOut;

  /// No description provided for @officialWorkOut.
  ///
  /// In en, this message translates to:
  /// **'Official Work Out'**
  String get officialWorkOut;

  /// No description provided for @overtimeOut.
  ///
  /// In en, this message translates to:
  /// **'Overtime Out'**
  String get overtimeOut;

  /// No description provided for @shortLeaveOut.
  ///
  /// In en, this message translates to:
  /// **'Short Leave Out'**
  String get shortLeaveOut;

  /// No description provided for @officialIn.
  ///
  /// In en, this message translates to:
  /// **'Official In'**
  String get officialIn;

  /// No description provided for @officialOut.
  ///
  /// In en, this message translates to:
  /// **'Official Out'**
  String get officialOut;

  /// No description provided for @officialInOrOut.
  ///
  /// In en, this message translates to:
  /// **'Official In/Out'**
  String get officialInOrOut;

  /// No description provided for @lunchIn.
  ///
  /// In en, this message translates to:
  /// **'Lunch In'**
  String get lunchIn;

  /// No description provided for @lunchOut.
  ///
  /// In en, this message translates to:
  /// **'Lunch Out'**
  String get lunchOut;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @opps.
  ///
  /// In en, this message translates to:
  /// **'Opps'**
  String get opps;

  /// No description provided for @remaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get remaining;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @attendancelocationErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Not in Office Location!'**
  String get attendancelocationErrorMessage;

  /// No description provided for @currentBalance.
  ///
  /// In en, this message translates to:
  /// **'Current Balance'**
  String get currentBalance;

  /// No description provided for @planned.
  ///
  /// In en, this message translates to:
  /// **'Planned'**
  String get planned;

  /// No description provided for @confirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get confirmed;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @absenceType.
  ///
  /// In en, this message translates to:
  /// **'Absence Type'**
  String get absenceType;

  /// No description provided for @chooseAbsenceType.
  ///
  /// In en, this message translates to:
  /// **'Choose a absence type'**
  String get chooseAbsenceType;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDate;

  /// No description provided for @chooseStartDate.
  ///
  /// In en, this message translates to:
  /// **'Choose a start date'**
  String get chooseStartDate;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get endDate;

  /// No description provided for @chooseEndDate.
  ///
  /// In en, this message translates to:
  /// **'Choose a end date'**
  String get chooseEndDate;

  /// No description provided for @chooseDate.
  ///
  /// In en, this message translates to:
  /// **'Choose a date'**
  String get chooseDate;

  /// No description provided for @startTime.
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get startTime;

  /// No description provided for @chooseStartTime.
  ///
  /// In en, this message translates to:
  /// **'Choose start time'**
  String get chooseStartTime;

  /// No description provided for @endTime.
  ///
  /// In en, this message translates to:
  /// **'End Time'**
  String get endTime;

  /// No description provided for @chooseEndTime.
  ///
  /// In en, this message translates to:
  /// **'Choose end time'**
  String get chooseEndTime;

  /// No description provided for @upload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload;

  /// No description provided for @chooseFiles.
  ///
  /// In en, this message translates to:
  /// **'Choose files'**
  String get chooseFiles;

  /// No description provided for @comments.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get comments;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @initiativeName.
  ///
  /// In en, this message translates to:
  /// **'Initiative Name'**
  String get initiativeName;

  /// No description provided for @initiativeDescription.
  ///
  /// In en, this message translates to:
  /// **'Initiative Description'**
  String get initiativeDescription;

  /// No description provided for @applicability.
  ///
  /// In en, this message translates to:
  /// **'Applicability'**
  String get applicability;

  /// No description provided for @specilizationRelation.
  ///
  /// In en, this message translates to:
  /// **'Specilization Relation'**
  String get specilizationRelation;

  /// No description provided for @serveDepartmentStrategy.
  ///
  /// In en, this message translates to:
  /// **'Serve Department Strategy'**
  String get serveDepartmentStrategy;

  /// No description provided for @initiativeYear.
  ///
  /// In en, this message translates to:
  /// **'Initiative Year'**
  String get initiativeYear;

  /// No description provided for @estimatedCostifAny.
  ///
  /// In en, this message translates to:
  /// **'Estimated Cost if Any'**
  String get estimatedCostifAny;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @jobTitle.
  ///
  /// In en, this message translates to:
  /// **'Job Title'**
  String get jobTitle;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @entityName.
  ///
  /// In en, this message translates to:
  /// **'To (Organization Name)'**
  String get entityName;

  /// No description provided for @organizationName.
  ///
  /// In en, this message translates to:
  /// **'Organization Name'**
  String get organizationName;

  /// No description provided for @showSalary.
  ///
  /// In en, this message translates to:
  /// **'Show Salary'**
  String get showSalary;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @detailedSalary.
  ///
  /// In en, this message translates to:
  /// **'Detailed Salary'**
  String get detailedSalary;

  /// No description provided for @noSalary.
  ///
  /// In en, this message translates to:
  /// **'No Salary'**
  String get noSalary;

  /// No description provided for @totalSalary.
  ///
  /// In en, this message translates to:
  /// **'Total Salary'**
  String get totalSalary;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @received.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get received;

  /// No description provided for @granted.
  ///
  /// In en, this message translates to:
  /// **'Granted'**
  String get granted;

  /// No description provided for @department.
  ///
  /// In en, this message translates to:
  /// **'Department'**
  String get department;

  /// No description provided for @employee.
  ///
  /// In en, this message translates to:
  /// **'Employee'**
  String get employee;

  /// No description provided for @reason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get reason;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @overtimeDate.
  ///
  /// In en, this message translates to:
  /// **'Overtime Date'**
  String get overtimeDate;

  /// No description provided for @chooseOvertimeDate.
  ///
  /// In en, this message translates to:
  /// **'Choose Overtime Date'**
  String get chooseOvertimeDate;

  /// No description provided for @fromTime.
  ///
  /// In en, this message translates to:
  /// **'From Time'**
  String get fromTime;

  /// No description provided for @chooseFromTime.
  ///
  /// In en, this message translates to:
  /// **'Choose From Time'**
  String get chooseFromTime;

  /// No description provided for @chooseTotime.
  ///
  /// In en, this message translates to:
  /// **'Choose To time'**
  String get chooseTotime;

  /// No description provided for @totime.
  ///
  /// In en, this message translates to:
  /// **'To time'**
  String get totime;

  /// No description provided for @noOfHours.
  ///
  /// In en, this message translates to:
  /// **'No of Hours'**
  String get noOfHours;

  /// No description provided for @employeeNumber.
  ///
  /// In en, this message translates to:
  /// **'Employee Number'**
  String get employeeNumber;

  /// No description provided for @nationality.
  ///
  /// In en, this message translates to:
  /// **'Nationality'**
  String get nationality;

  /// No description provided for @hiringDate.
  ///
  /// In en, this message translates to:
  /// **'Hiring Date'**
  String get hiringDate;

  /// No description provided for @attendanceRate.
  ///
  /// In en, this message translates to:
  /// **'Attendance Rate'**
  String get attendanceRate;

  /// No description provided for @createAbsence.
  ///
  /// In en, this message translates to:
  /// **'Create Absence'**
  String get createAbsence;

  /// No description provided for @teamStatusText.
  ///
  /// In en, this message translates to:
  /// **'The team attendance status today'**
  String get teamStatusText;

  /// No description provided for @numberOfEmployee.
  ///
  /// In en, this message translates to:
  /// **'Number of Employees'**
  String get numberOfEmployee;

  /// No description provided for @employeesOnLeaves.
  ///
  /// In en, this message translates to:
  /// **'Employees on Leaves'**
  String get employeesOnLeaves;

  /// No description provided for @employeesPunchedIn.
  ///
  /// In en, this message translates to:
  /// **'Employees Punched In'**
  String get employeesPunchedIn;

  /// No description provided for @employeesNotPunchedIn.
  ///
  /// In en, this message translates to:
  /// **'Employees not Punched In'**
  String get employeesNotPunchedIn;

  /// No description provided for @teamAttendanceReport.
  ///
  /// In en, this message translates to:
  /// **'Team Attendance Report'**
  String get teamAttendanceReport;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @thanks.
  ///
  /// In en, this message translates to:
  /// **'Thanks'**
  String get thanks;

  /// No description provided for @sorry.
  ///
  /// In en, this message translates to:
  /// **'Sorry'**
  String get sorry;

  /// No description provided for @eventNewjoinWishTitle.
  ///
  /// In en, this message translates to:
  /// **'We’re happy to have you on OUR TEAM'**
  String get eventNewjoinWishTitle;

  /// No description provided for @eventBirthDayWishTitle.
  ///
  /// In en, this message translates to:
  /// **'Its Time To Wish Your Colleague Today'**
  String get eventBirthDayWishTitle;

  /// No description provided for @happyBirthday.
  ///
  /// In en, this message translates to:
  /// **'Happy Birthday'**
  String get happyBirthday;

  /// No description provided for @happyWorkAnniversary.
  ///
  /// In en, this message translates to:
  /// **'HAPPy WORK ANNIVERSARY'**
  String get happyWorkAnniversary;

  /// No description provided for @noEventsMessage.
  ///
  /// In en, this message translates to:
  /// **'OOPS!\nNO ANY CELEBRATIONS TODAY'**
  String get noEventsMessage;

  /// No description provided for @approve.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @returntext.
  ///
  /// In en, this message translates to:
  /// **'Return'**
  String get returntext;

  /// No description provided for @submittedOn.
  ///
  /// In en, this message translates to:
  /// **'Submitted on'**
  String get submittedOn;

  /// No description provided for @question.
  ///
  /// In en, this message translates to:
  /// **'Question'**
  String get question;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// No description provided for @noInternet.
  ///
  /// In en, this message translates to:
  /// **'No Internet Connection'**
  String get noInternet;

  /// No description provided for @noHrRequests.
  ///
  /// In en, this message translates to:
  /// **'There is no requests'**
  String get noHrRequests;

  /// No description provided for @fontsSize.
  ///
  /// In en, this message translates to:
  /// **'Fonts size'**
  String get fontsSize;

  /// No description provided for @call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// No description provided for @usernameOrPasswordIsWrong.
  ///
  /// In en, this message translates to:
  /// **'username or password is wrong'**
  String get usernameOrPasswordIsWrong;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @receivedBy.
  ///
  /// In en, this message translates to:
  /// **'Received by'**
  String get receivedBy;

  /// No description provided for @deptName.
  ///
  /// In en, this message translates to:
  /// **'Dept. Name'**
  String get deptName;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @lastUpdateText.
  ///
  /// In en, this message translates to:
  /// **'Last update was on'**
  String get lastUpdateText;

  /// No description provided for @developedBy.
  ///
  /// In en, this message translates to:
  /// **'Developed by Smart Umm Al Quwain'**
  String get developedBy;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @standardPurchaseOrder.
  ///
  /// In en, this message translates to:
  /// **'Standard Purchase Order'**
  String get standardPurchaseOrder;

  /// No description provided for @supplier.
  ///
  /// In en, this message translates to:
  /// **'Supplier'**
  String get supplier;

  /// No description provided for @buyer.
  ///
  /// In en, this message translates to:
  /// **'Buyer'**
  String get buyer;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @tax.
  ///
  /// In en, this message translates to:
  /// **'Tax'**
  String get tax;

  /// No description provided for @paymentTerms.
  ///
  /// In en, this message translates to:
  /// **'Payment Terms'**
  String get paymentTerms;

  /// No description provided for @viewItems.
  ///
  /// In en, this message translates to:
  /// **'View Items'**
  String get viewItems;

  /// No description provided for @viewAttachments.
  ///
  /// In en, this message translates to:
  /// **'View Attachments'**
  String get viewAttachments;

  /// No description provided for @purchaseRequisition.
  ///
  /// In en, this message translates to:
  /// **'Purchase Requisition'**
  String get purchaseRequisition;

  /// No description provided for @nonRecoverable.
  ///
  /// In en, this message translates to:
  /// **'Non Recoverable'**
  String get nonRecoverable;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @invoiceID.
  ///
  /// In en, this message translates to:
  /// **'Invoice ID'**
  String get invoiceID;

  /// No description provided for @invoiceNumber.
  ///
  /// In en, this message translates to:
  /// **'Invoice Number'**
  String get invoiceNumber;

  /// No description provided for @invoiceDate.
  ///
  /// In en, this message translates to:
  /// **'Invoice Date'**
  String get invoiceDate;

  /// No description provided for @invoiceDescription.
  ///
  /// In en, this message translates to:
  /// **'Invoice Description'**
  String get invoiceDescription;

  /// No description provided for @itemAmount.
  ///
  /// In en, this message translates to:
  /// **'Item Amount'**
  String get itemAmount;

  /// No description provided for @itemNumber.
  ///
  /// In en, this message translates to:
  /// **'Item Number'**
  String get itemNumber;

  /// No description provided for @itemDescription.
  ///
  /// In en, this message translates to:
  /// **'Item Description'**
  String get itemDescription;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @unitPrice.
  ///
  /// In en, this message translates to:
  /// **'Unit Price'**
  String get unitPrice;

  /// No description provided for @lineAmount.
  ///
  /// In en, this message translates to:
  /// **'Line Amount'**
  String get lineAmount;

  /// No description provided for @poNumber.
  ///
  /// In en, this message translates to:
  /// **'PO Number'**
  String get poNumber;

  /// No description provided for @thereAreNoItems.
  ///
  /// In en, this message translates to:
  /// **'There are no items'**
  String get thereAreNoItems;

  /// No description provided for @thereAreNoAttachment.
  ///
  /// In en, this message translates to:
  /// **'There are no attachments'**
  String get thereAreNoAttachment;

  /// No description provided for @welcomeTourDescription.
  ///
  /// In en, this message translates to:
  /// **'This is an introductory tour of the most important components of Malomati Application.'**
  String get welcomeTourDescription;

  /// No description provided for @attendanceTourTitle.
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get attendanceTourTitle;

  /// No description provided for @attendanceTourDescription.
  ///
  /// In en, this message translates to:
  /// **'You can Punch in and Punch out from here.'**
  String get attendanceTourDescription;

  /// No description provided for @dashboardTourTitle.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboardTourTitle;

  /// No description provided for @dashboardTourDescription.
  ///
  /// In en, this message translates to:
  /// **'View all your remaining leaves balance, count of thank you and you can see the latest celebrations.'**
  String get dashboardTourDescription;

  /// No description provided for @appBarTourTitle.
  ///
  /// In en, this message translates to:
  /// **'Stay Informed'**
  String get appBarTourTitle;

  /// No description provided for @appBarTourDescription.
  ///
  /// In en, this message translates to:
  /// **'From here you can view your profile, change language, notifications and log-out.'**
  String get appBarTourDescription;

  /// No description provided for @favouriteTourTitle.
  ///
  /// In en, this message translates to:
  /// **'Favourite Service'**
  String get favouriteTourTitle;

  /// No description provided for @favouriteTourDescription.
  ///
  /// In en, this message translates to:
  /// **'Create a custom list of your favourite services and start to applying for the service.'**
  String get favouriteTourDescription;

  /// No description provided for @requestsTourTitle.
  ///
  /// In en, this message translates to:
  /// **'History Logs'**
  String get requestsTourTitle;

  /// No description provided for @requestsTourDescription.
  ///
  /// In en, this message translates to:
  /// **'Here you can see all your Request and Attendance history logs.'**
  String get requestsTourDescription;

  /// No description provided for @endTour.
  ///
  /// In en, this message translates to:
  /// **'End Tour'**
  String get endTour;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @prev.
  ///
  /// In en, this message translates to:
  /// **'Prev'**
  String get prev;

  /// No description provided for @doneEnd.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get doneEnd;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @red.
  ///
  /// In en, this message translates to:
  /// **'red'**
  String get red;

  /// No description provided for @blue.
  ///
  /// In en, this message translates to:
  /// **'blue'**
  String get blue;

  /// No description provided for @loginAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Login as Guest'**
  String get loginAsGuest;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @mobileNo.
  ///
  /// In en, this message translates to:
  /// **'Mobile No.'**
  String get mobileNo;

  /// No description provided for @uploadCV.
  ///
  /// In en, this message translates to:
  /// **'Upload CV'**
  String get uploadCV;

  /// No description provided for @jobs.
  ///
  /// In en, this message translates to:
  /// **'Jobs'**
  String get jobs;

  /// No description provided for @events.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get events;

  /// No description provided for @vacationRules.
  ///
  /// In en, this message translates to:
  /// **'Delegation'**
  String get vacationRules;

  /// No description provided for @holidays.
  ///
  /// In en, this message translates to:
  /// **'Holidays'**
  String get holidays;

  /// No description provided for @uaqApps.
  ///
  /// In en, this message translates to:
  /// **'Apps'**
  String get uaqApps;

  /// No description provided for @appUpdateTitle.
  ///
  /// In en, this message translates to:
  /// **'Update your application'**
  String get appUpdateTitle;

  /// No description provided for @appUpdateBody.
  ///
  /// In en, this message translates to:
  /// **'We improve performance and fix some bugs to make your experience seamless'**
  String get appUpdateBody;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Ttile'**
  String get title;

  /// No description provided for @imageorVideoURL.
  ///
  /// In en, this message translates to:
  /// **'Image or Video URL'**
  String get imageorVideoURL;

  /// No description provided for @audioURL.
  ///
  /// In en, this message translates to:
  /// **'Audio URL'**
  String get audioURL;

  /// No description provided for @test.
  ///
  /// In en, this message translates to:
  /// **'Test'**
  String get test;

  /// No description provided for @preview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get preview;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @noDeleteLeaves.
  ///
  /// In en, this message translates to:
  /// **'There is no leaves to delete'**
  String get noDeleteLeaves;

  /// No description provided for @noWarnings.
  ///
  /// In en, this message translates to:
  /// **'There is no warnings'**
  String get noWarnings;

  /// No description provided for @requestedOn.
  ///
  /// In en, this message translates to:
  /// **'Requested on'**
  String get requestedOn;

  /// No description provided for @requestDetails.
  ///
  /// In en, this message translates to:
  /// **'Request Details'**
  String get requestDetails;

  /// No description provided for @action.
  ///
  /// In en, this message translates to:
  /// **'Action'**
  String get action;

  /// No description provided for @answer.
  ///
  /// In en, this message translates to:
  /// **'Answer'**
  String get answer;

  /// No description provided for @pendingWith.
  ///
  /// In en, this message translates to:
  /// **'Pending with'**
  String get pendingWith;

  /// No description provided for @rejectedBy.
  ///
  /// In en, this message translates to:
  /// **'Rejected by'**
  String get rejectedBy;

  /// No description provided for @returnForCorrection.
  ///
  /// In en, this message translates to:
  /// **'Return for correction'**
  String get returnForCorrection;

  /// No description provided for @vactionTypeSelectTitle.
  ///
  /// In en, this message translates to:
  /// **'Select type of delegation'**
  String get vactionTypeSelectTitle;

  /// No description provided for @reassignEmployeeName.
  ///
  /// In en, this message translates to:
  /// **'Reassign Employee Name'**
  String get reassignEmployeeName;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @delegateYourResponse.
  ///
  /// In en, this message translates to:
  /// **'Delegate your response'**
  String get delegateYourResponse;

  /// No description provided for @delegateYourResponseDes.
  ///
  /// In en, this message translates to:
  /// **'A manager may delegate all notification approvals to an assistant.'**
  String get delegateYourResponseDes;

  /// No description provided for @transferNotificationOwnership.
  ///
  /// In en, this message translates to:
  /// **'Transfer notification ownership'**
  String get transferNotificationOwnership;

  /// No description provided for @transferNotificationOwnershipDes.
  ///
  /// In en, this message translates to:
  /// **'A manager may transfer a notification for a specific project to the new manager of that project.'**
  String get transferNotificationOwnershipDes;

  /// No description provided for @notification.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notification;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @selectBy.
  ///
  /// In en, this message translates to:
  /// **'Select by'**
  String get selectBy;

  /// No description provided for @cancelInvoice.
  ///
  /// In en, this message translates to:
  /// **'Cancel Invoice'**
  String get cancelInvoice;

  /// No description provided for @operatingUnit.
  ///
  /// In en, this message translates to:
  /// **'Operating Unit'**
  String get operatingUnit;

  /// No description provided for @creationDate.
  ///
  /// In en, this message translates to:
  /// **'Creation Date'**
  String get creationDate;

  /// No description provided for @vendorName.
  ///
  /// In en, this message translates to:
  /// **'Vendor Name'**
  String get vendorName;

  /// No description provided for @invoiceAmount.
  ///
  /// In en, this message translates to:
  /// **'Invoice Amount'**
  String get invoiceAmount;

  /// No description provided for @invoiceType.
  ///
  /// In en, this message translates to:
  /// **'Invoice Type'**
  String get invoiceType;

  /// No description provided for @requestInformation.
  ///
  /// In en, this message translates to:
  /// **'Request Information'**
  String get requestInformation;

  /// No description provided for @informationRequestedFrom.
  ///
  /// In en, this message translates to:
  /// **'Information Requested From'**
  String get informationRequestedFrom;

  /// No description provided for @workflowParticipant.
  ///
  /// In en, this message translates to:
  /// **'Workflow participant'**
  String get workflowParticipant;

  /// No description provided for @anyUser.
  ///
  /// In en, this message translates to:
  /// **'Any user'**
  String get anyUser;

  /// No description provided for @informationRequested.
  ///
  /// In en, this message translates to:
  /// **'Information requested'**
  String get informationRequested;

  /// No description provided for @selectEmployee.
  ///
  /// In en, this message translates to:
  /// **'Select Employee'**
  String get selectEmployee;

  /// No description provided for @moreInfo.
  ///
  /// In en, this message translates to:
  /// **'More info.'**
  String get moreInfo;

  /// No description provided for @fetchingLocationDetails.
  ///
  /// In en, this message translates to:
  /// **'Fetching Location Details'**
  String get fetchingLocationDetails;

  /// No description provided for @checkingRemoteWorkDetails.
  ///
  /// In en, this message translates to:
  /// **'Checking remote work details'**
  String get checkingRemoteWorkDetails;

  /// No description provided for @locationErrorText.
  ///
  /// In en, this message translates to:
  /// **'Please enable location to submit attendance'**
  String get locationErrorText;

  /// No description provided for @noDeleteInvoices.
  ///
  /// In en, this message translates to:
  /// **'There is no invoices to delete'**
  String get noDeleteInvoices;

  /// No description provided for @totalWorkTime.
  ///
  /// In en, this message translates to:
  /// **'Total Work time'**
  String get totalWorkTime;

  /// No description provided for @delegateMessageCaption.
  ///
  /// In en, this message translates to:
  /// **'Comments will display with each routed notification'**
  String get delegateMessageCaption;

  /// No description provided for @delegateFor.
  ///
  /// In en, this message translates to:
  /// **'Delegation For'**
  String get delegateFor;

  /// No description provided for @delegateTo.
  ///
  /// In en, this message translates to:
  /// **'Delegation To'**
  String get delegateTo;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @selectReason.
  ///
  /// In en, this message translates to:
  /// **'Select Reason'**
  String get selectReason;

  /// No description provided for @specifyTheReason.
  ///
  /// In en, this message translates to:
  /// **'Please specify the reason'**
  String get specifyTheReason;

  /// No description provided for @visitingDepartment.
  ///
  /// In en, this message translates to:
  /// **'Visiting Department'**
  String get visitingDepartment;

  /// No description provided for @university.
  ///
  /// In en, this message translates to:
  /// **'University'**
  String get university;

  /// No description provided for @training.
  ///
  /// In en, this message translates to:
  /// **'Training'**
  String get training;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @validationMinimum.
  ///
  /// In en, this message translates to:
  /// **'Minimum length should be 0 letters'**
  String get validationMinimum;

  /// No description provided for @sectionName.
  ///
  /// In en, this message translates to:
  /// **'Section Name'**
  String get sectionName;

  /// No description provided for @hireDate.
  ///
  /// In en, this message translates to:
  /// **'Hire Date'**
  String get hireDate;

  /// No description provided for @lastContractStartDate.
  ///
  /// In en, this message translates to:
  /// **'Last Contract Date'**
  String get lastContractStartDate;

  /// No description provided for @newContractStartDate.
  ///
  /// In en, this message translates to:
  /// **'New Contract Start Date'**
  String get newContractStartDate;

  /// No description provided for @resignationDate.
  ///
  /// In en, this message translates to:
  /// **'Resignation Date'**
  String get resignationDate;

  /// No description provided for @resignationReason.
  ///
  /// In en, this message translates to:
  /// **'Resignation Reason'**
  String get resignationReason;

  /// No description provided for @contractRenewal.
  ///
  /// In en, this message translates to:
  /// **'Contract Renewal'**
  String get contractRenewal;

  /// No description provided for @resignation.
  ///
  /// In en, this message translates to:
  /// **'Resignation'**
  String get resignation;

  /// No description provided for @addTrainingCertificate.
  ///
  /// In en, this message translates to:
  /// **'Add Training certificate'**
  String get addTrainingCertificate;

  /// No description provided for @approvalOfSalaries.
  ///
  /// In en, this message translates to:
  /// **'Approval of Salaries'**
  String get approvalOfSalaries;

  /// No description provided for @remoteWork.
  ///
  /// In en, this message translates to:
  /// **'Remote work'**
  String get remoteWork;

  /// No description provided for @typeOfCertificate.
  ///
  /// In en, this message translates to:
  /// **'Type of Certificate'**
  String get typeOfCertificate;

  /// No description provided for @trainingCertificateName.
  ///
  /// In en, this message translates to:
  /// **'Training Certificate Name'**
  String get trainingCertificateName;

  /// No description provided for @string.
  ///
  /// In en, this message translates to:
  /// **''**
  String get string;

  /// No description provided for @dummy.
  ///
  /// In en, this message translates to:
  /// **'dummy'**
  String get dummy;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
