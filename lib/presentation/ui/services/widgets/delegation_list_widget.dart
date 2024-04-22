import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/domain/entities/delegation_entity.dart';
import 'package:malomati/injection_container.dart';
import 'package:malomati/presentation/bloc/services/services_bloc.dart';
import 'package:malomati/presentation/ui/services/widgets/item_delegation_list.dart';

class DelegationListWidget extends StatelessWidget {
  DelegationListWidget({super.key});
  final _servicesBloc = sl<ServicesBloc>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _servicesBloc,
      child: BlocListener<ServicesBloc, ServicesState>(
        listener: (context, state) {},
        child: FutureBuilder(
            future: _servicesBloc.getDelegationList(
                requestParams: {'UserName': 'MOOZA.BINYEEM'}),
            builder: (context, snapShot) {
              List<DelegationItemEntity> list = snapShot.data ?? [];
              return ListView.separated(
                  itemBuilder: (context, index) {
                    return ItemDelegationList(
                      delegationItem: list[index],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      color: context.resources.color.colorD6D6D6,
                    );
                  },
                  itemCount: list.length);
            }),
      ),
    );
  }
}
