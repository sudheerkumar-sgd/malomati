//attendance server Urls
const String attendanceApiUrl = 'attendance-daily?action=get;format=json;';
const String attendanceDetailsApiUrl = 'event-ta-date?action=get;format=json;';
const String attendanceRequestedParams =
    ';Field-name=USERID,USERNAME,PROCESSDATE,PUNCH1_TIME,PUNCH2_TIME,PUNCH3_TIME,PUNCH4_TIME,PUNCH5_TIME,PUNCH6_TIME,PUNCH7_TIME,PUNCH8_TIME,PUNCH9_TIME,PUNCH10_TIME,WORKTIME_HHMM,FIRSTHALF,SECONDHALF,SPFID1,SPFID2,SPFID3,SPFID4,SPFID5,SPFID6,SPFID7,SPFID8,SPFID9,SPFID10';
const String attendanceDetailsRequestedParams =
    ';field-name=UserID,username,edate,EVENTDATETIME_D,gps_latitude,gps_longitude,ENTRYEXITTYPE,SPECIALFUNCTIONID';

//malomati server Urls
const String loginApiUrl = 'UAQSGD_MOB_ERP_GetLogin/GetLogin';
const String getProfileApiUrl = 'UAQSGD_MOB_ERP_GetProfile/GetProfile';
const String dashboardApiUrl =
    'UAQSGD_MOB_ERP_EmployeeDashboard/LeavesAndThankyouCount';
