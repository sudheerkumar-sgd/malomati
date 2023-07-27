import 'package:equatable/equatable.dart';

class AccountEntity extends Equatable {
  const AccountEntity({
    this.name,
    this.bankName,
    this.number,
    this.amount,
    this.color,
    this.superId,
  });

  final double? amount;
  final String? bankName;
  final int? color;
  final String? name;
  final String? number;
  final int? superId;

  @override
  List<Object?> get props => [
        name,
        bankName,
        number,
        amount,
        color,
        superId,
      ];
}
