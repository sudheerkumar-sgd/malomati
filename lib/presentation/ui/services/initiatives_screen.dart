// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/core/common/common_utils.dart';
import 'package:malomati/data/data_sources/api_urls.dart';
import 'package:malomati/data/model/initiative_request_model.dart';
import 'package:malomati/domain/entities/name_id_entity.dart';
import 'package:malomati/injection_container.dart';
import 'package:malomati/presentation/bloc/services/services_bloc.dart';
import 'package:malomati/presentation/ui/utils/dialogs.dart';
import 'package:malomati/presentation/ui/widgets/dropdown_widget.dart';
import 'package:malomati/presentation/ui/widgets/right_icon_text_widget.dart';
import 'package:malomati/res/drawables/background_box_decoration.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';
import 'package:malomati/res/resources.dart';
import '../widgets/alert_dialog_widget.dart';
import '../widgets/back_app_bar.dart';

class InitiativesScreen extends StatelessWidget {
  static const String route = '/InitiativesScreen';
  InitiativesScreen({super.key});
  late Resources resources;
  final _servicesBloc = sl<ServicesBloc>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  NameIdEntity? applicability;
  NameIdEntity? specilizationRelation;
  NameIdEntity? serveDepartmentStrategy;
  String? initiativeYear;

  onApplicabilitySelected(NameIdEntity? value) {
    applicability = value;
  }

  onSpecilizationRelationSelected(NameIdEntity? value) {
    specilizationRelation = value;
  }

  onServeDepartmentStrategySelected(NameIdEntity? value) {
    serveDepartmentStrategy = value;
  }

  onInitiativeYearSelected(String? value) {
    initiativeYear = value ?? '';
  }

  _submitInitiativeRequest(BuildContext context) {
    final initiativeRequestModel = InitiativeRequestModel();
    initiativeRequestModel.uSERNAME =
        context.userDB.get(userNameKey, defaultValue: '');
    initiativeRequestModel.iNITIATIVENAME = _nameController.text;
    initiativeRequestModel.iNITIATIVEDESCRIPTION = _descriptionController.text;
    initiativeRequestModel.aPPLICABILITY = applicability?.id ?? '';
    initiativeRequestModel.sPECILIZATIONRELATION =
        specilizationRelation?.id ?? '';
    initiativeRequestModel.sERVEDEPARTMENTSTRATEGY =
        serveDepartmentStrategy?.id ?? '';
    initiativeRequestModel.iNITIATIVEYEAR = initiativeYear;
    initiativeRequestModel.eSTIMATEDCOSTIFANY = _costController.text;
    _servicesBloc.submitServicesRequest(
        apiUrl: initiativeSubmitApiUrl,
        requestParams: initiativeRequestModel.toJson());
  }

  @override
  Widget build(BuildContext context) {
    resources = context.resources;
    return SafeArea(
      child: Scaffold(
        backgroundColor: context.resources.color.appScaffoldBg,
        body: BlocProvider<ServicesBloc>(
          create: (context) => _servicesBloc,
          child: BlocListener<ServicesBloc, ServicesState>(
            listener: (context, state) {
              if (state is OnServicesLoading) {
                Dialogs.loader(context);
              } else if (state is OnServicesRequestSubmitSuccess) {
                Navigator.of(context, rootNavigator: true).pop();
                if (state.servicesRequestSuccessResponse.isSuccess ?? false) {
                  Dialogs.showInfoDialog(
                          context,
                          PopupType.success,
                          state.servicesRequestSuccessResponse
                              .getDisplayMessage(resources))
                      .then((value) => Navigator.pop(context));
                } else {
                  Dialogs.showInfoDialog(
                      context,
                      PopupType.fail,
                      state.servicesRequestSuccessResponse
                          .getDisplayMessage(resources));
                }
              } else if (state is OnServicesError) {
                Navigator.of(context, rootNavigator: true).pop();
                Dialogs.showInfoDialog(context, PopupType.fail, state.message);
              }
            },
            child: Container(
              margin: EdgeInsets.symmetric(
                  vertical: context.resources.dimen.dp20,
                  horizontal: context.resources.dimen.dp25),
              child: Column(
                children: [
                  SizedBox(
                    height: context.resources.dimen.dp10,
                  ),
                  BackAppBarWidget(title: context.string.initiatives),
                  SizedBox(
                    height: context.resources.dimen.dp20,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RightIconTextWidget(
                              isEnabled: true,
                              height: resources.dimen.dp27,
                              labelText: context.string.initiativeName,
                              errorMessage: context.string.initiativeName,
                              textController: _nameController,
                            ),
                            SizedBox(
                              height: resources.dimen.dp20,
                            ),
                            RightIconTextWidget(
                              isEnabled: true,
                              height: resources.dimen.dp100,
                              labelText: context.string.initiativeDescription,
                              errorMessage:
                                  context.string.initiativeDescription,
                              textController: _descriptionController,
                            ),
                            SizedBox(
                              height: resources.dimen.dp20,
                            ),
                            DropDownWidget<NameIdEntity>(
                              list: getDropDownYesNo(context),
                              height: resources.dimen.dp27,
                              labelText: context.string.applicability,
                              errorMessage: context.string.applicability,
                              suffixIconPath: DrawableAssets.icChevronDown,
                              selectedValue: applicability,
                              callback: onApplicabilitySelected,
                            ),
                            SizedBox(
                              height: resources.dimen.dp20,
                            ),
                            DropDownWidget<NameIdEntity>(
                              list: getDropDownYesNo(context),
                              height: resources.dimen.dp27,
                              labelText: context.string.specilizationRelation,
                              errorMessage:
                                  context.string.specilizationRelation,
                              suffixIconPath: DrawableAssets.icChevronDown,
                              selectedValue: specilizationRelation,
                              callback: onSpecilizationRelationSelected,
                            ),
                            SizedBox(
                              height: resources.dimen.dp20,
                            ),
                            DropDownWidget<NameIdEntity>(
                              list: getDropDownYesNo(context),
                              height: resources.dimen.dp27,
                              labelText: context.string.serveDepartmentStrategy,
                              errorMessage:
                                  context.string.serveDepartmentStrategy,
                              suffixIconPath: DrawableAssets.icChevronDown,
                              selectedValue: serveDepartmentStrategy,
                              callback: onServeDepartmentStrategySelected,
                            ),
                            SizedBox(
                              height: resources.dimen.dp20,
                            ),
                            DropDownWidget<String>(
                              list: const [
                                '2023',
                                '2024',
                                '2025',
                                '2026',
                                '2027',
                                '2028',
                                '2029',
                                '2030',
                              ],
                              height: resources.dimen.dp27,
                              labelText: context.string.initiativeYear,
                              errorMessage: context.string.initiativeYear,
                              suffixIconPath: DrawableAssets.icChevronDown,
                              selectedValue: initiativeYear,
                              callback: onInitiativeYearSelected,
                            ),
                            SizedBox(
                              height: resources.dimen.dp20,
                            ),
                            RightIconTextWidget(
                              isEnabled: true,
                              height: resources.dimen.dp27,
                              labelText: context.string.estimatedCostifAny,
                              textController: _costController,
                              textInputType: TextInputType.number,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: resources.dimen.dp20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: context.resources.dimen.dp15,
                                vertical: resources.dimen.dp7),
                            decoration: BackgroundBoxDecoration(
                                    boxColor:
                                        context.resources.color.textColorLight,
                                    radious: context.resources.dimen.dp15)
                                .roundedCornerBox,
                            child: Text(
                              context.string.cancel,
                              style: context.textFontWeight600
                                  .onFontSize(context.resources.fontSize.dp17)
                                  .onColor(resources.color.colorWhite)
                                  .copyWith(height: 1),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: resources.dimen.dp20,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              _submitInitiativeRequest(context);
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: context.resources.dimen.dp15,
                                vertical: resources.dimen.dp7),
                            decoration: BackgroundBoxDecoration(
                                    boxColor:
                                        context.resources.color.viewBgColor,
                                    radious: context.resources.dimen.dp15)
                                .roundedCornerBox,
                            child: Text(
                              context.string.submit,
                              style: context.textFontWeight600
                                  .onFontSize(context.resources.fontSize.dp17)
                                  .onColor(resources.color.colorWhite)
                                  .copyWith(height: 1),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: resources.dimen.dp10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
