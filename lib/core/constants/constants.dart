const String appSettingsDb = 'db_app_settings';
const String userDb = 'db_users';
const String themeModeKey = 'key_theme_mode';
const String appColorKey = 'key_app_color';
const String appThemeKey = 'key_app_theme';
const String appLocalKey = "app_local_key";
const String appFontSizeKey = "app_font_size_key";
const String isSplashDoneKey = "is_splash_done";
const String authorizationTokenKey = "authorization_token";
const String oracleLoginIdKey = "oracle_login_id";
const String userNameKey = "user_name";
const String passwordKey = "password";
const String userFullNameUsKey = "user_full_name_us";
const String userFullNameArKey = "user_full_name_ar";
const String userJobNameEnKey = "user_job_name_en";
const String userJobNameArKey = "user_jon_name_ar";
const String userJobIdEnKey = "user_job_id_en";
const String userJobIdArKey = "user_jon_id_ar";
const String userJoiningDateEnKey = "user_joining_date_en";
const String userJoiningDateArKey = "user_joining_date_ar";
const String userNationalityEnKey = "user_nationality_en";
const String userNationalityArKey = "user_nationality_ar";
const String userPersonIdKey = "user_person_id";
const String isRememberdKey = "is_rememberd";
const String isMaangerKey = "is_manager";
const String favoriteKey = "favorites";
const String departmentIdKey = "department_id";
const String appTourKey = "app_tour";
const String deletedNotificationsKey = "deleted_notifications";
const String openedNotificationsKey = "opened_notifications";
const String userDateOfBirthKey = "user_date_of_birth";
const String isDateOfBirthShowedKey = "is_date_of_birth_showed";
const String isAnniversaryShowedKey = "is_anniversary_showed";

const String fontFamilyEN = "Inter";
const String fontFamilyAR = "AR_GE_SS";

const String supportMobileNumber = '06 764 1000';
const String supportEmailId = 'info@uaqgov.ae';

String authorizationToken = "";
String oracleLoginId = "";
bool isLocalEn = true;

String favoriteAdd = "add";
String favoriteAddAR = "add";

const int maxUploadFilesize = 1024 * 1024;

const departmentsLocations = [
  {
    "code": "07",
    "name": "FALAJ MUS",
    "latitude": "+25.3520",
    "longitude": "+055.8497",
    "radius": 200,
    "mac": "",
    "type": 0,
    "ble_code": "",
    "address": "",
    "mode": 0,
    "mid": "",
    "did": "",
    "ip": "",
    "event_type": 0,
    "map": "assets/images/map/map_FALAJMUS_office.png",
  },
  {
    "code": "02",
    "name": "MD",
    "latitude": "+25.5751",
    "longitude": "+055.5657",
    "radius": 200,
    "mac": "",
    "type": 0,
    "ble_code": "",
    "address": "",
    "mode": 0,
    "mid": "",
    "did": "",
    "ip": "",
    "event_type": 0,
    "map": "assets/images/map/map_MD_office.png",
  },
  {
    "code": "06",
    "name": "ICA-PWD-LAB",
    "latitude": "+25.5678",
    "longitude": "+055.5625",
    "radius": 150,
    "mac": "",
    "type": 0,
    "ble_code": "",
    "address": "",
    "mode": 0,
    "mid": "",
    "did": "",
    "ip": "",
    "event_type": 0,
    "map": "assets/images/map/map_ICA_PWD_LAB_office.png",
  },
  {
    "code": "12",
    "name": "RAFA",
    "latitude": "+25.6369",
    "longitude": "+055.7843",
    "radius": 200,
    "mac": "",
    "type": 0,
    "ble_code": "",
    "address": "",
    "mode": 0,
    "mid": "",
    "did": "",
    "ip": "",
    "event_type": 0,
    "map": "assets/images/map/map_RAFA_office.png",
  },
  {
    "code": "Mat",
    "name": "Matrix",
    "latitude": "+22.2535",
    "longitude": "+73.1830",
    "radius": 500,
    "mac": "",
    "type": 0,
    "ble_code": "",
    "address": "",
    "mode": 0,
    "mid": "",
    "did": "",
    "ip": "",
    "event_type": 0,
    "map": "assets/images/map/map_Matrix_office.png",
  },
  {
    "code": "01",
    "name": "SGD OFFC",
    "latitude": "+25.5201",
    "longitude": "+055.5452",
    "radius": 300,
    "mac": "",
    "type": 0,
    "ble_code": "",
    "address": "",
    "mode": 0,
    "mid": "",
    "did": "",
    "ip": "",
    "event_type": 0,
    "map": "assets/images/map/map_SGD_office.png",
  },
  {
    "code": "03",
    "name": "BCD",
    "latitude": "+25.5345",
    "longitude": "+055.5375",
    "radius": 500,
    "mac": "",
    "type": 0,
    "ble_code": "",
    "address": "",
    "mode": 0,
    "mid": "",
    "did": "",
    "ip": "",
    "event_type": 0,
    "map": "assets/images/map/map_BDC_office.png",
  },
  {
    "code": "13",
    "name": "ANIMAL MARKET",
    "latitude": "+25.4905",
    "longitude": "+055.5545",
    "radius": 200,
    "mac": "",
    "type": 0,
    "ble_code": "",
    "address": "",
    "mode": 0,
    "mid": "",
    "did": "",
    "ip": "",
    "event_type": 0,
    "map": "assets/images/map/map_ANIMAL_MARKET_office.png",
  },
  {
    "code": "14",
    "name": "FISH MARKET",
    "latitude": "+25.5488",
    "longitude": "+055.5592",
    "radius": 200,
    "mac": "",
    "type": 0,
    "ble_code": "",
    "address": "",
    "mode": 0,
    "mid": "",
    "did": "",
    "ip": "",
    "event_type": 0,
    "map": "assets/images/map/map_FISH_MARKET_office.png",
  },
  {
    "code": "2",
    "name": "SGD OFFC",
    "latitude": "+25.5026",
    "longitude": "+055.5927",
    "radius": 10,
    "mac": "",
    "type": 0,
    "ble_code": "",
    "address": "",
    "mode": 0,
    "mid": "",
    "did": "",
    "ip": "",
    "event_type": 0,
    "map": "assets/images/map/map_SGD2_office.png",
  },
  {
    "code": "04",
    "name": "TAD",
    "latitude": "+25.5855",
    "longitude": "+055.5698",
    "radius": 500,
    "mac": "",
    "type": 0,
    "ble_code": "",
    "address": "",
    "mode": 0,
    "mid": "",
    "did": "",
    "ip": "",
    "event_type": 0,
    "map": "assets/images/map/map_TAD_office.png",
  },
  {
    "code": "05",
    "name": "FALAJ MUN",
    "latitude": "+25.3471",
    "longitude": "+055.8546",
    "radius": 200,
    "mac": "",
    "type": 0,
    "ble_code": "",
    "address": "",
    "mode": 0,
    "mid": "",
    "did": "",
    "ip": "",
    "event_type": 0,
    "map": "assets/images/map/map_FALAJ_MUN_office.png",
  },
  {
    "code": "09",
    "name": "COURT",
    "latitude": "+25.5702",
    "longitude": "+055.5631",
    "radius": 70,
    "mac": "",
    "type": 0,
    "ble_code": "",
    "address": "",
    "mode": 0,
    "mid": "",
    "did": "",
    "ip": "",
    "event_type": 0,
    "map": "assets/images/map/map_COURT_office.png",
  },
  {
    "code": "08",
    "name": "DED",
    "latitude": "+25.5717",
    "longitude": "+055.5640",
    "radius": 20,
    "mac": "",
    "type": 0,
    "ble_code": "",
    "address": "",
    "mode": 0,
    "mid": "",
    "did": "",
    "ip": "",
    "event_type": 0,
    "map": "assets/images/map/map_DED_office.png",
  },
  {
    "code": "10",
    "name": "FAD",
    "latitude": "+25.5723",
    "longitude": "+055.5662",
    "radius": 50,
    "mac": "",
    "type": 0,
    "ble_code": "",
    "address": "",
    "mode": 0,
    "mid": "",
    "did": "",
    "ip": "",
    "event_type": 0,
    "map": "assets/images/map/map_FAD_office.png",
  },
  {
    "code": "11",
    "name": "MOC",
    "latitude": "+25.5090",
    "longitude": "+055.5984",
    "radius": 300,
    "mac": "",
    "type": 0,
    "ble_code": "",
    "address": "",
    "mode": 0,
    "mid": "",
    "did": "",
    "ip": "",
    "event_type": 0,
    "map": "assets/images/map/map_MOC_office.png",
  },
  {
    "code": "99",
    "name": "SGD OFFC",
    "latitude": "+25.3079",
    "longitude": "+055.3787",
    "radius": 10,
    "mac": "",
    "type": 0,
    "ble_code": "",
    "address": "",
    "mode": 0,
    "mid": "",
    "did": "",
    "ip": "",
    "event_type": 0,
    "map": "assets/images/map/map_SGD99_office.png",
  },
  {
    "code": "100",
    "name": "MD",
    "latitude": "+25.4805",
    "longitude": "+055.5756",
    "radius": 10,
    "mac": "",
    "type": 0,
    "ble_code": "",
    "address": "",
    "mode": 0,
    "mid": "",
    "did": "",
    "ip": "",
    "event_type": 0,
    "map": "assets/images/map/map_MD_office.png",
  },
  {
    "code": "15",
    "name": "GARAGE",
    "latitude": "+25.5643",
    "longitude": "+055.5572",
    "radius": 300,
    "mac": "",
    "type": 0,
    "ble_code": "",
    "address": "",
    "mode": 0,
    "mid": "",
    "did": "",
    "ip": "",
    "event_type": 0,
    "map": "assets/images/map/map_GARAGE_office.png",
  },
  {
    "code": "16",
    "name": "Mangroove",
    "latitude": "+25.5284",
    "longitude": "+055.5825",
    "radius": 500,
    "mac": "",
    "type": 0,
    "ble_code": "",
    "address": "",
    "mode": 0,
    "mid": "",
    "did": "",
    "ip": "",
    "event_type": 0,
    "map": "assets/images/map/map_Mangroove_office.png",
  },
  {
    "code": "17",
    "name": "EC",
    "latitude": "+25.5714",
    "longitude": "+055.5633",
    "radius": 50,
    "mac": "",
    "type": 0,
    "ble_code": "",
    "address": "",
    "mode": 0,
    "mid": "",
    "did": "",
    "ip": "",
    "event_type": 0,
    "map": "assets/images/map/map_EC_office.png",
  },
  {
    "code": "18",
    "name": "DIWAN",
    "latitude": "+25.5707",
    "longitude": "+055.5669",
    "radius": 100,
    "mac": "",
    "type": 0,
    "ble_code": "",
    "address": "",
    "mode": 0,
    "mid": "",
    "did": "",
    "ip": "",
    "event_type": 0,
    "map": "assets/images/map/map_DIWAN_office.png",
  },
  {
    "code": "19",
    "name": "DC",
    "latitude": "+25.5713",
    "longitude": "+055.5623",
    "radius": 50,
    "mac": "",
    "type": 0,
    "ble_code": "",
    "address": "",
    "mode": 0,
    "mid": "",
    "did": "",
    "ip": "",
    "event_type": 0,
    "map": "assets/images/map/map_DC_office.png",
  }
];
