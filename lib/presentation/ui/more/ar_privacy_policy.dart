import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';

import '../../../core/common/common_utils.dart';
import '../home/widgets/call_confirmation.dart';
import '../utils/dialogs.dart';

class ArPrivacyPolicy extends StatelessWidget {
  const ArPrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: context.textFontWeight400
            .onFontSize(context.resources.fontSize.dp11),
        children: <TextSpan>[
          TextSpan(
              text:
                  'الخصوصية و السياسة – تطبيق معلوماتي الخدمة الذاتية للمدارء والموظفين ام القيوين\n\n',
              style: context.textFontWeight700
                  .onFontSize(context.resources.fontSize.dp15)),
          TextSpan(
              text: 'التزامنا ومصطلحاتنا المستخدمة\n\n',
              style: context.textFontWeight700
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text:
                  'تلتزم حكومة أم القيوين بحماية حقوق جميع زوار مواقعها الإلكترونية و/أو تطبيقات الهاتف المحمول الخاصة بها.\n\n',
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text:
                  ' تعود جميع ضمائر المتكلم المشار إليها فيما يلي على حكومة أم القيوين والجهات التابعة لها بينما تعود جميع ضمائر المخاطب المشار إليها فيما يلي على مستخدمي تطبيقات الهاتف الخاصة بحكومة أم القيوين.\n\n',
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text: 'نطاق السياسة\n\n',
              style: context.textFontWeight700
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text:
                  'تسري سياسة السرية هذه (فضلا عن أية شروط استخدام يشار إليها في موقعنا الإلكتروني "شروط الموقع الإلكتروني") على استخدامكم لما يلي:\n\n',
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text:
                  '• تطبيق الخدمة الذاتية للموظف عبر الهوتف الذكية "معلوماتي" الذي أطلقته ام القيوين الذكية والمتاح على موقعنا (موقع التطبيقات)، فبمجرد تحميلك نسخة من هذا التطبيق على هاتفك المحمول أو جهازك المحمول (الجهاز)، و \n\n',
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text:
                  '• أي من الخدمات المتاحة من خلال موقع التطبيقات أو غيرها من المواقع الخاصة بنا (موقع الخدمات)، وذلك ما لم تنص اتفاقية ترخيص المستخدم النهائي على تطبيق سياسة سرية مستقلة على خدمة معينة، والتي تسري وحدها في هذه الحالة.\n\n',
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text:
                  'توضح سياسة السرية الطريقة التي تتبعها حكومة أم القيوين في جمع واستخدام البيانات الشخصية التي تقوم أنت بتقديمها. كما تبين الخيارات المتاحة لك فيما يتعلق باستخدامنا لبياناتك الشخصية وكيف يمكنك الوصول إلى هذه البيانات وتحديثها. رجاء الاطلاع على ما يلي بعناية لكي تفهم أفكارنا والإجراءات التي نتبعها بخصوص بياناتك الشخصية وكيف سنقوم بالتعامل معها.\n\n',
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text:
                  'في حال نشأ أي اختلاف أو تعارض بين أحكام الموقع الالكتروني وسياسة السرية هذه، تكون الأولوية لسياسة السرية.\n\n',
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text: 'الخدمات المعتمدة على الموقع\n\n',
              style: context.textFontWeight700
                  .onFontSize(context.resources.fontSize.dp15)),
          TextSpan(
              text:
                  'تستخدم بعض الخدمات المتاحة في موقع التطبيقات هذا بيانات خاصة بالموقع. فإذا قمتم بإتاحة هذه الخدمات، سوف نقوم بجمع معلومات عن أجهزة توزيع (routers) الـ "واي فاي" الأقرب إليك وأرقام الخلية الخاصة بالأبراج الأقرب إليك.\n\n',
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text:
                  'نقوم باستخدام هذه المعلومات لكي نقدم الخدمة المعتمدة على الموقع، وذلك ليس بهدف التلصص على أمورك الشخصية ولكن للأغراض التالية:\n\n',
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text: '• تزويدك ببيانات بالاعتماد على موقعك،\n',
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text: '• تزويدك بنتائج البحث الداخلي،\n',
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text:
                  '• تمكين أفراد يتم تعيينهم لتتبع موقعك أو تتبعك لغرض تتبع موقع أشخاص آخرين،\n',
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text:
                  '• مسارات خارطة وتقديم إرشادات للمواقع التي تقوم بتحديدها.\n\n',
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text: 'تجميع البيانات واستخدامها\n\n',
              style: context.textFontWeight700
                  .onFontSize(context.resources.fontSize.dp15)),
          TextSpan(
              text: 'نقوم أيضا بتجميع البيانات التالية منك:\n\n',
              style: context.textFontWeight700
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text: '• البيانات التي تقوم بتقديمها لنا (البيانات المقدمة)\n\n',
              style: context.textFontWeight600
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text:
                  'يمكنك تزويدنا ببيانات عنك من خلال ملء نماذج متاحة على موقع التطبيقات وموقع الخدمات (المشار إليها معا بعبارة مواقعنا)، أو من خلال التراسل معنا (عن طريق البريد الالكتروني على سبيل المثال). ويشمل ذلك البيانات التي تقوم بتقديمها عند قيامك بالتسجيل لاستخدام موقع التطبيقات أو عند تحميل أو تسجيل برنامج الخدمة الذاتية للموظف عن طريق الهاتف المحمول (معلوماتي) أو عند الاشتراك في أي من خدماتنا أو البحث عن برنامج الخدمة الذاتية للموظف عن طريق الهاتف المحمول (معلوماتي) أو الخدمات أو أي من مواقعنا. وقد تشمل البيانات التي تقوم بتقديمها لنا اسمك وعنوانك وبريدك الالكتروني ورقم هاتفك ورقم هاتفك المحمول وعمرك واسمك المستخدم ورقمك السري وغير ذلك من بيانات التسجيل ووصفك الشخصي.\n\n',
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text: '• البيانات التي نقوم بجمعها عنك وعن جهازك\n\n',
              style: context.textFontWeight600
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text:
                  'كلما قمت بزيارة مواقعنا أو كلما قمت باستخدام برنامج الخدمة الذاتية للموظف عن طريق الهاتف المحمول (معلوماتي) يمكننا وبشكل آلي تجميع المعلومات التالية:\n\n',
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text:
                  '• بيانات فنية تشمل نوع الجهاز المحمول الذي تقوم باستخدامه ومعرف الجهاز الوحيد (مثلا الهوية الدولية الخاصة بمعدات الهاتف المحمول، عنوان "التحكم في الوصول إلى الوسائط" (MAC) الخاص بواجهة الشبكة اللاسلكية للجهاز، رقم الهاتف المحمول المستخدم بواسطة الجهاز)، بيانات شبكة الهاتف المحمول ونظام تشغيل هاتفك المحمول ونوع متصفح الهاتف الذي تستخدمه وإعدادات توقيت المنطقة ورقم IP والتردد/ منفذ الصفحة.\n\n',
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text:
                  '• تفاصيل عن استخدامك لبرنامج الخدمة الذاتية للموظف عن طريق الهاتف المحمول (معلوماتي) وزياراتك لأي من مواقعنا (بما في ذلك، على سبيل المثال لا الحصر، معلومات حركة مرور البيانات، بيانات الموقع، سجلات web(weblogs) وغيرها من بيانات الاتصال، (سواء كانت هذه البيانات مطلوبة لأغراض إعداد الإعتمادات ) بالإضافة إلى المعلومات التي تقوم بالاطلاع عليها (معلومات التسجيل).\n\n',
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text: '• رقم التطبيق الوحيد\n\n',
              style: context.textFontWeight700
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text:
                  'عندما تقوم بتثبيت أو إلغاء تثبيت خدمة تشتمل على رقم تطبيق وحيد أو عندما لكون لهذه الخدمة خاصية إجراء تحديثات تلقائية، فإنه من الممكن إرسال ذلك الرقم والمعلومات المتعلقة بثبيتك للخدمة (مثل نوع نظام التشغيل) إلينا: \n\n',
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text: 'نقوم باستخدام البيانات المجمعة لكي:\n\n',
              style: context.textFontWeight700
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text: '• نقوم بتنفيذ طلباتك،\n',
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text: '• نقوم بإرسال تأكيد الطلب إليك،\n',
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text:
                  '• نقوم بتقييم حاجياتك لتحديد المنتجات أو الخدمات المناسبة،\n',
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text: '• نقوم بإرسال بيانات المنتج أو الخدمة المطلوبة إليك،\n',
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text: '• نقوم بإرسال تحديثات المنتج أو بيانات الضمان إليك،\n',
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text: '• نقوم بالاستجابة لطلبات خدمة العملاء،\n',
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text: '• نقوم بإدارة حسابك،\n',
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text:
                  '• نقوم بإرسال رسائل تذكيرية إليك عندما تقوم باستخدام برنامج الخدمة الذاتية للموظف عن طريق الهاتف المحمول (معلوماتي). وإذا كنت لا ترغب في تلقي هذه الرسائل، يمكنك التحكم في اختيارك سواء من خلال جهازك أو من خلال إعدادات برنامج الخدمة الذاتية للموظف عن طريق الهاتف المحمول (معلوماتي) حسب نوع جهازك. كما يمكنك الاتصال بنا على البريد الإلكتروني ',
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text: 'info@uaqgov.ae',
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  sendEmail(context, 'info@uaqgov.ae');
                },
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)
                  .onColor(Colors.blue)
                  .copyWith(decoration: TextDecoration.underline)),
          TextSpan(
              text: ';\n',
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text: '• نقوم بإرسال إعلانات تسويقية إليك،\n',
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text:
                  '• نقوم بتطوير برنامج الخدمة الذاتية للموظف عن طريق الهاتف المحمول (معلوماتي) الخاص بنا وجهودنا التسويقية،\n',
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text: '• نقوم بإجراء بحث وتحليل،\n',
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text: '• نقوم بالإجابة على أسئلتكم ومشاكلكم، و\n',
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text:
                  '• نقوم بعرض المحتوى/ البيانات بناء على ما تقتضيه مصالحك.\n\n',
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text: '• ملفات تعريف الارتباط (الكوكيز)\n\n',
              style: context.textFontWeight700
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text:
                  'نستخدم ملفات تعريف الارتباط لكي نميزك عن باقي مستخدمي برنامج الخدمة الذاتية للموظف عن طريق الهاتف المحمول (معلوماتي)وزوار موقع التطبيقات أو موقع الخدمات. وهذا يساعدنا على منحك تجربة جيدة عندما تقوم باستخدام برنامج الخدمة الذاتية للموظف عن طريق الهاتف المحمول (معلوماتي) أو عندما تقوم بتصفح أي من المواقع، كما يسمح لنا بتطوير برنامج الخدمة الذاتية للموظف عن طريق الهاتف المحمول (معلوماتي) ومواقعنا.\n\n',
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text: 'اختيار/ إيقاف استلام الرسائل\n\n',
              style: context.textFontWeight700
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text:
                  'يمكنك توقيف استلام رسائلنا القصيرة أو الالكترونية وذلك من خلال اتصالك بنا على البريد الالكتروني التالي:',
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text: 'info@uaqgov.ae',
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  sendEmail(context, 'info@uaqgov.ae');
                },
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)
                  .onColor(Colors.blue)
                  .copyWith(decoration: TextDecoration.underline)),
          TextSpan(
              text: '.\n\n',
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text: 'مشاركة معلوماتك\n\n',
              style: context.textFontWeight700
                  .onFontSize(context.resources.fontSize.dp15)),
          TextSpan(
              text:
                  'لن نقوم بمشاركة بياناتك الشخصية مع الغير إلا بالطرق المبينة في سياسة السرية هذه.\n\n',
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text:
                  'من الممكن أن نقوم بتقديم بياناتك الشخصية لبعض الجهات التابعة لام القيوين الذكية و/أو لبعض الشركات التي تقدم خدمات لمساعدتنا في أعمالنا مثل تقديم خدمة العملاء، حيث إن هؤلاء مخولون لاستخدام بياناتك الشخصية فقط في الحدود اللازمة لتزويدنا بتلك الخدمات.\n\n',
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text: 'من الممكن أن نفصح عن بياناتك الشخصية',
              style: context.textFontWeight700
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text:
                  '• عندما يكون ذلك مطلوبا منا بموجب القانون، كالامتثال لقرار محكمة أو أي إجراء قانوني آخر.\n',
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text:
                  '• عندما نعتقد، بحسن نية، أن الافصاح عن بياناتك الشخصية ضروري لحماية حقوقك و/أو للحفاظ على سلامتك أو سلامة أشخاص آخرين و/أو للتحقيق في قضية احتيال و/أو للاستجابة لطلب من الحكومة و/أو\n',
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text: '• لأي طرف من الغير عند موافقتك المسبقة على ذلك.\n\n',
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text: 'الحماية\n\n',
              style: context.textFontWeight700
                  .onFontSize(context.resources.fontSize.dp15)),
          TextSpan(
              text:
                  'إن حماية بياناتك الشخصية أمر مهم بالنسبة لنا، ونحن نتبع معايير معترف بها عالميا في حماية البيانات التي تقوم بتقديمها لنا سواء أثناء ارسالها أو عندما نتوصل بها.\n\n',
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text:
                  'عندما نقدم لك (أو عندما تختار) رمزا سريا يسمح لك بالدخول إلى أجزاء من مواقعنا، فإنك تتحمل مسؤولية الحفاظ على سرية ذلك الرمز السري، كما نطلب منك عدم مشاركته مع أي شخص آخر.\n\n',
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text: 'معلومات أخرى\n\n',
              style: context.textFontWeight700
                  .onFontSize(context.resources.fontSize.dp15)),
          TextSpan(
              text: 'تصحيح وتحديث بياناتك الشخصية\n\n',
              style: context.textFontWeight700
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text:
                  'للتحقق من صحة بياناتك الشخصية وتحديثها لضمان دقتها، رجاء مراسلتنا على البريد الالكتروني التالي:',
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text: 'info@uaqgov.ae',
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  sendEmail(context, 'info@uaqgov.ae');
                },
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)
                  .onColor(Colors.blue)
                  .copyWith(decoration: TextDecoration.underline)),
          TextSpan(
              text: '.\n\n',
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text: 'الإشعار بالتعديلات على سياسة السرية\n\n',
              style: context.textFontWeight700
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text:
                  'من الممكن أن نقوم بتحديث سياسة السرية هذه لإجراء تعديلات على إجراءاتنا الخاصة بالبيانات أو أي تشريع و/أو أنظمة و/أو سياسة، لذلك نحثك على مراجعة هذه الصفحة بانتظام للاطلاع على أحدث المعلومات عن الإجراءات التي نتبعها فيما يتعلق بالسرية.\n\n',
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text: 'اتصل بنا\n\n',
              style: context.textFontWeight700
                  .onFontSize(context.resources.fontSize.dp15)),
          TextSpan(
              text:
                  'يمكنك أن تتصل بنا بخصوص سياسة السرية هذه عن طريق رسالة خطية أو بريد الكتروني على العناوين المبينة أدناه:\n\n',
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text: 'حكومة ام القيوين\n',
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text: 'الهاتف: ',
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text: '+971 6 7641000\n',
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Dialogs.showBottomSheetDialogTransperrent(
                      context,
                      const CallConfirmationWidget(
                          mobileNumber: '+971 6 7641000'));
                },
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)
                  .onColor(const Color.fromARGB(255, 245, 103, 103))
                  .copyWith(decoration: TextDecoration.underline)),
          TextSpan(
              text: 'الفاكس: ',
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text: '+971 6 7641777\n',
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Dialogs.showBottomSheetDialogTransperrent(
                      context,
                      const CallConfirmationWidget(
                          mobileNumber: '+971 6 7641777'));
                },
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)
                  .onColor(const Color.fromARGB(255, 245, 103, 103))
                  .copyWith(decoration: TextDecoration.underline)),
          TextSpan(
              text: 'ص.ب:  225،  أم القيوين، الإمارات العربية المتحدة\n',
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text: 'البريد الالكتروني: ',
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text: 'info@uaqgov.ae',
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  sendEmail(context, 'info@uaqgov.ae');
                },
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)
                  .onColor(Colors.blue)
                  .copyWith(decoration: TextDecoration.underline)),
        ],
      ),
    );
  }
}
