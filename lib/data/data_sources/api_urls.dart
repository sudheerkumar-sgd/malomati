//attendance server Urls
const String attendanceApiUrl = 'attendance-daily?action=get;format=json;';
const String attendanceDetailsApiUrl = 'event-ta-date?action=get;format=json;';
const String attendanceSubmitApiUrl = 'events?action=set;';
const String attendanceRequestedParams =
    ';Field-name=USERID,USERNAME,PROCESSDATE,PUNCH1_TIME,PUNCH2_TIME,PUNCH3_TIME,PUNCH4_TIME,PUNCH5_TIME,PUNCH6_TIME,PUNCH7_TIME,PUNCH8_TIME,PUNCH9_TIME,PUNCH10_TIME,WORKTIME_HHMM,FIRSTHALF,SECONDHALF,SPFID1,SPFID2,SPFID3,SPFID4,SPFID5,SPFID6,SPFID7,SPFID8,SPFID9,SPFID10';
const String attendanceDetailsRequestedParams =
    ';field-name=UserID,username,edate,EVENTDATETIME_D,gps_latitude,gps_longitude,ENTRYEXITTYPE,SPECIALFUNCTIONID';

//malomati server Urls
const String loginApiUrl = 'UAQSGD_MOB_ERP_GetLogin/GetLogin';
const String getProfileApiUrl = 'UAQSGD_MOB_ERP_GetProfile/GetProfile';
const String dashboardApiUrl =
    'UAQSGD_MOB_ERP_EmployeeDashboard/LeavesAndThankyouCount';
const String eventApiUrl = 'UAQSGD_MOB_ERP_GetEvents/GetEvents';
const String leaveSubmitApiUrl =
    'UAQSGD_MOB_ERP_RequestForLeaves/RequestLeaves';
const String initiativeSubmitApiUrl =
    'UAQSGD_MOB_ERP_InitiateRequest/InitiativeRequest';
const String submitThankyouApiUrl =
    'UAQSGD_MOB_ERP_Department/DepartmentRS/ThankYouRequest';
const String employeesApiUrl =
    'UAQSGD_MOB_ERP_Department/DepartmentRS/DeptEmpsList';
const String certificateApiUrl =
    'UAQSGD_MOB_ERP_SalaryCertificateRequest/SalaryCertificate';
const String advanceSalaryApiUrl =
    'UAQSGD_MOB_ERP_AdvanceSalaryRequest/AdvanceSalary';
const String badgeApiUrl = 'UAQSGD_MOB_ERP_BadgeRequest/CreateBadge';
const String overtimeApiUrl = 'UAQSGD_MOB_ERP_OvertimeRequest/OvertimeRequest';
const String leavesApiUrl =
    'UAQSGD_MOB_ERP_AdvanceSalaryRequest/AdvanceSalary/LeaveDetails';
const String employeesByManagerApiUrl = 'UAQSGD_MOB_ERP_GetMyTeam/GetMyTeam';
const String hrApprovalListApiUrl = 'UAQSGD_MOB_ERP_HRApprovals/Approvals';
const String hrApprovalDetailsApiUrl =
    'UAQSGD_MOB_ERP_HRApprovals/Approvals/NotificationDtls';
const String submitHrApprovalApiUrl =
    'UAQSGD_MOB_ERP_HRApprovals/Approvals/NotificationAction';
const String thankYouReceivedApiUrl =
    'UAQSGD_MOB_ERP_Department/DepartmentRS/ThankYouReceived';
const String thankYouGrantedApiUrl =
    'UAQSGD_MOB_ERP_Department/DepartmentRS/ThankYouGranted';
const String payslipsApiUrl = 'UAQSGD_MOB_ERP_GetPayslips/Payslips';
const String workingDaysApiUrl = 'UAQSGD_MOB_ERP_GetWorkingDays/WorkingDays';
const String financeInvoiceApiUrl =
    'UAQSGD_MOB_ERP_FinINVApprovals/Approvals/INV';
const String financeInvoiceItemsApiUrl =
    'UAQSGD_MOB_ERP_FinINVApprovals/Approvals/INVItems';
const String financePRApiUrl = 'UAQSGD_MOB_ERP_FinPRApprovals/Approvals/PR';
const String financePRItemsApiUrl =
    'UAQSGD_MOB_ERP_FinPRApprovals/Approvals/PRItems';
const String financePOApiUrl = 'UAQSGD_MOB_ERP_FinPOApprovals/Approvals/PO';
const String financePOItemsApiUrl =
    'UAQSGD_MOB_ERP_FinPOApprovals/Approvals/POItems';
const String requestsCountApiUrl =
    'UAQSGD_MOB_ERP_GetNotificationCount/GetCount';
