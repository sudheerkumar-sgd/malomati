/// Holds formatted dashboard leave balances for routes that cannot read [HomeBloc]
/// directly (e.g. [LeavesScreen]).
class DashboardLeaveBalances {
  String annualLeaveBalance = '';
  String sickLeaveBalance = '';
  String permissionLeaveBalance = '';

  void update({
    required String annual,
    required String sick,
    required String permission,
  }) {
    annualLeaveBalance = annual;
    sickLeaveBalance = sick;
    permissionLeaveBalance = permission;
  }
}
