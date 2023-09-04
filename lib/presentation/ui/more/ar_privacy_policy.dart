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
              text: 'Cookies\n\n',
              style: context.textFontWeight700
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text:
                  'We use cookies to distinguish you from other users of Malomati, the App Site or the Service Site. This helps us to provide you with a good experience when you use Smart Employee or browse any of the Sites and also allows us to improve Malomati and Our sites.\n\n',
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text: 'Choice/Opt-Out\n\n',
              style: context.textFontWeight700
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text:
                  'You may opt-out of receiving our marketing emails or SMS messages from us by contacting us at ',
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
              text: 'Sharing Your Information\n\n',
              style: context.textFontWeight700
                  .onFontSize(context.resources.fontSize.dp15)),
          TextSpan(
              text:
                  'We will share your information with third parties only in the ways that are described in this privacy policy.\n\n',
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text:
                  'We may provide your personal information to affiliates of UAQ Government and/or companies that provide services to help us with our business activities such as offering customer service. These third parties are authorized to use your personal information only as necessary to provide these Services to us.\n\n',
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text: 'We may disclose your personal information',
              style: context.textFontWeight700
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text:
                  '\u2022  as required by law, such as to comply with a court order or any other legal process;\n',
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text:
                  '\u2022  when we believe in good faith that disclosure is necessary to protect our rights, protect your safety or the safety of others, investigate fraud, or respond to a government request; and/or\n',
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text:
                  '\u2022 to any other third party with your prior consent to do so.\n\n',
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text: 'Security\n\n',
              style: context.textFontWeight700
                  .onFontSize(context.resources.fontSize.dp15)),
          TextSpan(
              text:
                  'The security of your personal information is important to us. We follow generally accepted industry standards to protect the personal information submitted to us, both during transmission and once we receive it.\n\n',
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text:
                  'Unfortunately, the transmission of information via the internet is not completely secure. Although we will do our best to protect your personal data, we cannot guarantee the security of your data transmitted to Our Sites; any transmission is at your own risk. Once we have received your information, we will use strict procedures and security features to try to prevent unauthorised access.\n\n',
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text:
                  'We will retain your information for as long as your account is active or as needed to provide you with Services. If you wish to cancel your account or request that we no longer use your information to provide you with Services please contact us at ',
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
              text:
                  '. We will retain and use your information as necessary to comply with our legal obligations, resolve disputes, and enforce our agreements.',
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text:
                  'Where we have given you (or where you have chosen) a password that enables you to access certain parts of Our Sites, you are responsible for keeping this password confidential. We ask you not to share a password with anyone.\n\n',
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text: 'Other Information\n\n',
              style: context.textFontWeight700
                  .onFontSize(context.resources.fontSize.dp15)),
          TextSpan(
              text: 'Correcting and Updating Your Personal Information\n\n',
              style: context.textFontWeight700
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text:
                  'To review and update your personal information to ensure it is accurate, contact us at ',
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
              text: 'Notification of Privacy Policy Changes\n\n',
              style: context.textFontWeight700
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text:
                  'We may update this privacy policy to reflect changes to our information practices or any relevant statute, regulations and/or policy. We encourage you to periodically review this page for the latest information on our privacy practices.\n\n',
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text: 'Contact\n\n',
              style: context.textFontWeight700
                  .onFontSize(context.resources.fontSize.dp15)),
          TextSpan(
              text:
                  'You can contact us about this privacy policy by writing or email us at the address below:\n\n',
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text: 'UAQ  Government\n',
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text: 'Telephone number: ',
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
              text: 'Fax number: ',
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
              text: 'PO Box 225, Umm Al Quwain, United Arab Emirates\n',
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)),
          TextSpan(
              text: 'Email: ',
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
