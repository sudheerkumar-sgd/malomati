import 'package:malomati/data/data_sources/remote_data_source.dart';

import '../../core/network/network_info.dart';
import '../../domain/repository/apis_repository.dart';

class ApisRepositoryImpl extends ApisRepository {
  final RemoteDataSource dataSource;
  final NetworkInfo networkInfo;
  ApisRepositoryImpl({required this.dataSource, required this.networkInfo});
}
