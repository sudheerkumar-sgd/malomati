import 'package:flutter/material.dart';
import 'package:malomati/core/extensions/build_context_extension.dart';
import 'package:malomati/core/extensions/text_style_extension.dart';
import 'package:malomati/presentation/ui/widgets/right_icon_text_widget.dart';

class SearchWidget extends StatelessWidget {
  final searchTextController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  final List<String> list;
  final ValueNotifier<List<String>> _resultList = ValueNotifier([]);

  SearchWidget({required this.list, super.key});
  @override
  Widget build(BuildContext context) {
    _resultList.value = list;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        padding: EdgeInsets.symmetric(horizontal: context.resources.dimen.dp25),
        child: Column(
          children: [
            RightIconTextWidget(
              textController: searchTextController,
              focusNode: searchFocusNode,
            ),
            SizedBox(
              height: context.resources.dimen.dp20,
            ),
          ],
        ),
      ),
      Expanded(
        child: ValueListenableBuilder(
            valueListenable: _resultList,
            builder: (context, data, child) {
              return ListView.separated(
                  itemBuilder: (context, index) {
                    return Text(
                      data[index],
                      style: context.textFontWeight400,
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: context.resources.dimen.dp20,
                    );
                  },
                  itemCount: data.length);
            }),
      ),
    ]);
  }
}
