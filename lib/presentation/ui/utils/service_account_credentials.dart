import 'package:googleapis_auth/auth_io.dart';

class ServiceAccountCredentials2 {
  final String clientEmail;
  final String privateKey;
  final String projectId;

  ServiceAccountCredentials2(
      {required this.clientEmail,
      required this.privateKey,
      required this.projectId});

  static ServiceAccountCredentials fromJson() {
    return ServiceAccountCredentials(
      'firebase-adminsdk-98xin@malomati-bf7ab.iam.gserviceaccount.com',
      ClientId('105305531494607984685'),
      '-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC+QIerR5t3sniZ\nFOeaqxt55yAV327CDri5t/Oyrc5J6eE7AF93TpIRN2oKz5HsG0e4Xqa8Eu2Yt87h\nwVZ0F1BhFJKmHNlWpVv+gxZ5oAMIPlrneImpYLOdSi8aeUqIdFzMRi/BRIa7bMji\nOwn4+jkee8GI9Hsia0pEHXCaLoKP1O+T9KcQHQBtHVeDr19hK5XsNKv1HONafx1A\n0H6ZHnf3epvjIHxyRyAOL/2zemGn9jNVpUiUW7xx2epOYrx7zf87dFojmDTSnJfQ\ndUw5Fhg1smNi1M/FD/j1fqYVOR4NuXP/c6407fb9SULtOE+VFDGNP6zJ/imUlCi9\ni9TrTMdhAgMBAAECggEAAgZay0pgT7ZRDUQJMP64NKRulX0Cx0Lz2VopWFH8O5In\nKQMYgQMPj+pYkRPjeDFUIpSzTpYe/DyckY+GtYaX/uiCpQzyjTcGUx+fCh1XWuua\n+RKx2GEkmDx1YuE+l1QxtqTalkJ98pm2S54YPZOgLwBfL292rgeZSz9K9wEet5wm\nVx/Y4oby9WaPNgMr+5PVBchOO+/ILaJWBGRCkSrqlutjoT2oxB7vXvELYDoPHlEy\n8M4MdnPuH9/+Y0kpom1e2mNtJQdn57HGwvkWz6+g32jbtBiamE5W9fAvPhDteC1y\ntW9hkJPOg2rni7p4Hm3AacMTFmxqaBlT63ejnNQGSQKBgQDxgdOv2YrkK7f937lW\n3nRjBERoAnqT9TvhErDjfvMfXPUQlX+d8cuPUQrkNbmKeab3TXtRMtvUX8GOGzKq\nTRI0ggN14esmUmuBUhDfl4XK/iYVioaJ1Us5nOONN86lRAyJBYz5CIK+/keSLRav\nZ8LhJOJDhTxPTI3BtPkWjxSq9QKBgQDJq0r8lMYMtklqUFKGfgMi5fujGhVUkJD9\nJt1ffLi9aYgYYGyQxfXJrEr4XALHQr8VIDU+8z93GTVxM4lJkgMTTOHsWParXf3n\nbEeCL0Hrkwk8D50dC961VZ3Ik/LPAAaDhJqM0OSrtdC0vTCL2DchPW1ul1Yxccei\nYhsQZv7/PQKBgD7ysfRx5WvXoVuAxtRHo1pzsEjT7JNIJlViA80oN8KC/jVWYi8O\n6Rnv68DT6AqZ7tUi0vO1J+tREigyGqCc+hPJl5FQU3RnozHP7Cn7WpowaEjRFIQ0\nnijkJcOXOjuFYycL1VTLzRhvOsR1ECakCv2YGYmz3qZks8Y7n3krzh1JAoGAUEY9\n4BK8Tv0Udhwo7V4lk3OmWcMdMH8nJ42b2tGDm+nxAXsIXAxgjPlnEjtV48k+1ILw\njvE2lwrSyg+wmzdiwAD/gRvcfFQ6qC7ivABhpgruRxkT+ibqbJX664dwxFMHRLy4\n5EqWa39A52DTfScAstuHvtjAt4fJ5mpUyY+l+yUCgYEAswzkl13LpuHJJ3Uw3bQi\n9jrhOnNIx5lFiplePA/xf5pqrfyiuK4kC+x5+P0dDtim6rAu2KCe+ykIPoUhuBi3\nIruY5lqD6+USxgRoKl4WRHieWA8RtoSDqbUs/R12wVYSHyOnKWAxKrBibzZl/hO9\noVHxdbgy8tbDuXHBT8R7XmE=\n-----END PRIVATE KEY-----\n',
    );
  }
}

Future<AccessToken> getAccessToken(String jsonString) async {
  final client = await clientViaServiceAccount(
    ServiceAccountCredentials(
      'uaq.egd.gmail.com',
      ClientId(
          '393239977540-inlgnnc2fir916b31pv3fp6squkkq44k.apps.googleusercontent.com'),
      'AAAAW47t3kQ:APA91bFuEWK4MWc7bVSf24RYAdcBuSPIeu4CLhOV2qOp_UctljSHas5BvNngpFNf_OQVAOWXtuNSjNOdbOqWpXRUscryDK8sPqTGUnVk2qrtwVs21eOVr8mK9sDhcotgxKslSm6vB3LW',
    ),
    ['https://www.googleapis.com/auth/firebase.messaging'],
  );

  final accessToken = client.credentials.accessToken;
  return accessToken;
}
