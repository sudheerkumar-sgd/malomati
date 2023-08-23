import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';
import '../widgets/back_app_bar.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class HRGovernmentLaw extends StatelessWidget {
  static const String route = '/HRGovernmentLaw';
  const HRGovernmentLaw({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: context.resources.color.appScaffoldBg,
        body: Container(
          margin: EdgeInsets.symmetric(
              vertical: context.resources.dimen.dp20,
              horizontal: context.resources.dimen.dp25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: context.resources.dimen.dp10,
              ),
              BackAppBarWidget(title: context.string.hRGovernmentLaw),
              SizedBox(
                height: context.resources.dimen.dp20,
              ),
              Expanded(
                child: SfPdfViewer.asset(
                  'assets/json/hr_law.pdf',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
