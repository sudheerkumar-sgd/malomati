import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/core/common/common_utils.dart';
import 'package:malomati/res/drawables/background_box_decoration.dart';
import '../widgets/back_app_bar.dart';

class PrivacyAndPolicy extends StatelessWidget {
  static const String route = '/PrivacyAndPolicy';
  const PrivacyAndPolicy({super.key});

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
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: context.resources.dimen.dp10,
              ),
              BackAppBarWidget(title: context.string.privacyAndPolicy),
              SizedBox(
                height: context.resources.dimen.dp20,
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(
                    context.resources.dimen.dp15,
                  ),
                  decoration: BackgroundBoxDecoration(
                          boxColor: context.resources.color.colorWhite,
                          radious: context.resources.dimen.dp10)
                      .roundedCornerBox,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: context.textFontWeight400
                                .onFontSize(context.resources.dimen.dp11),
                            children: <TextSpan>[
                              TextSpan(
                                  text:
                                      'Privacy Policy for Malomati Manager and Employee self-service – mobile application\n\n',
                                  style: context.textFontWeight700.onFontSize(
                                      context.resources.dimen.dp15)),
                              TextSpan(
                                  text: 'Our Commitment and Terminology\n\n',
                                  style: context.textFontWeight700.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text:
                                      'UAQ  Government is committed to protecting the rights and privacy of all visitors to its websites and/or mobile applications.\n\n',
                                  style: context.textFontWeight400.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text:
                                      'The terms “we”, “us” or “our(s)” hereunder refer to UAQ  Government and its affiliates and the terms “you” and “your” hereunder refer to the user visiting UAQ  Government’s mobile application.\n\n',
                                  style: context.textFontWeight400.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text: 'Scope of Policy\n\n',
                                  style: context.textFontWeight700.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text:
                                      'This privacy policy (together with any terms of use as set out on our website (',
                                  style: context.textFontWeight400.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text: 'Website Terms',
                                  style: context.textFontWeight700.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text: ') applies to your use of:\n\n',
                                  style: context.textFontWeight400.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text:
                                      'UAQ  Government’s Manager & Employee Self Service mobile application software (',
                                  style: context.textFontWeight400.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text: 'Malomati',
                                  style: context.textFontWeight700.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text: 'i) available on our site (',
                                  style: context.textFontWeight400.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text: 'App Site',
                                  style: context.textFontWeight700.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text:
                                      '), once you have downloaded or streamed a copy of Malomati onto your mobile telephone or handheld device (',
                                  style: context.textFontWeight400.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text: 'Device',
                                  style: context.textFontWeight700.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text: '); and\n\n',
                                  style: context.textFontWeight400.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text:
                                      'Any of the services accessible through Smart Employee (the ',
                                  style: context.textFontWeight400.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text: 'Services',
                                  style: context.textFontWeight700.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text:
                                      ') that are available on the App Site or other sites of ours (',
                                  style: context.textFontWeight400.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text: 'Services Site',
                                  style: context.textFontWeight700.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text:
                                      '), unless the EULA states that a separate privacy policy applies to a particular Service, in which case that privacy policy only applies.\n\n',
                                  style: context.textFontWeight400.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text: 'This privacy policy describes how ',
                                  style: context.textFontWeight400.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text: 'UAQ Government',
                                  style: context.textFontWeight700.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text:
                                      ' collects and uses the personal information you provide. It also describes the choices available to you regarding our use of your personal information and how you can access and update this information. Please read the following carefully to understand our views and practices regarding your personal data and how we will treat it.\n\n',
                                  style: context.textFontWeight400.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text:
                                      'In the event of any inconsistency or conflict between the Website Terms and this privacy policy, the terms of this privacy policy shall prevail.\n\n',
                                  style: context.textFontWeight400.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text: 'Location Services\n\n',
                                  style: context.textFontWeight700.onFontSize(
                                      context.resources.dimen.dp15)),
                              TextSpan(
                                  text:
                                      'Some Services on this App Site may make use of location-based data. If you allow these Services, we will collect information about the wi-fi routers closest to you and the cell IDs of the towers closest to you.\n\n',
                                  style: context.textFontWeight400.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text:
                                      'We use this information to provide the requested location-based Service, not to identify you but to:\n\n',
                                  style: context.textFontWeight400.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text:
                                      '\u2022 Provide you content based upon your location;\n',
                                  style: context.textFontWeight400.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text:
                                      '\u2022 Provide your local search results;\n',
                                  style: context.textFontWeight400.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text:
                                      '\u2022 Enable designated individuals to track your location or you to track the location of others; and\n',
                                  style: context.textFontWeight400.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text:
                                      '\u2022 Map routes and provide directions to locations that you specify.\n\n',
                                  style: context.textFontWeight400.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text: 'Collection and Use\n\n',
                                  style: context.textFontWeight700.onFontSize(
                                      context.resources.dimen.dp15)),
                              TextSpan(
                                  text:
                                      'We also collect the following information from you:\n\n',
                                  style: context.textFontWeight700.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text:
                                      '\u2022 Information you give us (Submitted information)\n\n',
                                  style: context.textFontWeight600.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text:
                                      'You may give us information about you by filling in forms on the App Site and the Services Sites (together ',
                                  style: context.textFontWeight400.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text: 'Our Sites',
                                  style: context.textFontWeight700.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text:
                                      ', or by corresponding with us (for example, by e-mail). This includes information you provide when you register to use the App Site, download or register Smart Employee, subscribe to any of our Services, search for Smart Employee or Services, and when you report a problem with Smart Employee, our Services, or any of Our Sites. The information you give us may include your name, address, e-mail address and phone number, the Device\'s phone number, age, username, password and other registration information, and personal description.\n\n',
                                  style: context.textFontWeight400.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text:
                                      '\u2022 Information we collect about you and your device\n\n',
                                  style: context.textFontWeight600.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text:
                                      'Each time you visit one of Our Sites or use Smart Employee we may automatically collect the following information:\n\n',
                                  style: context.textFontWeight400.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text:
                                      '\u2022 technical information, including the type of mobile device you use, a unique device identifier (for example, your Device\'s IMEI number, the MAC address of the Device\'s wireless network interface, or the mobile phone number used by the Device), mobile network information, your mobile operating system, the type of mobile browser you use, time zone setting, IP address and referring/exit pages (',
                                  style: context.textFontWeight400.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text: 'Device Information',
                                  style: context.textFontWeight700.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text: ');\n\n',
                                  style: context.textFontWeight400.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text:
                                      '\u2022 details of your use of Malomati or your visits to any of Our Sites (including, but not limited to, traffic data, location data, weblogs and other communication data, whether this is required for our own billing purposes or otherwise) and the resources that you access (',
                                  style: context.textFontWeight400.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text: 'Log Information',
                                  style: context.textFontWeight700.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text: ').\n\n',
                                  style: context.textFontWeight400.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text: '\u2022 Unique application numbers\n\n',
                                  style: context.textFontWeight700.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text:
                                      'When you install or uninstall a Service containing a unique application number or when such a Service searches for automatic updates, that number and information about your installation (for example, the type of operating system) may be sent to us.\n\n',
                                  style: context.textFontWeight400.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text: 'We use information collected to:\n\n',
                                  style: context.textFontWeight700.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text: '\u2022 Fulfil your requests;\n',
                                  style: context.textFontWeight400.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text:
                                      '\u2022 Send you a request confirmation;\n',
                                  style: context.textFontWeight400.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text:
                                      '\u2022  Assess your needs to determine suitable products or services;\n',
                                  style: context.textFontWeight400.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text:
                                      '\u2022  Send you requested product or service information;\n',
                                  style: context.textFontWeight400.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text:
                                      '\u2022 Send product updates or warranty information;\n',
                                  style: context.textFontWeight400.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text:
                                      '\u2022  Respond to customer service requests;\n',
                                  style: context.textFontWeight400.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text: '\u2022 Administer your account;\n',
                                  style: context.textFontWeight400.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text:
                                      '\u2022  Send you push notifications when you are using Malomati. If you do not want these notifications, you can manage your preference either through your device or Malomatisettings depending on your device type. You can also contact us at ',
                                  style: context.textFontWeight400.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text: 'info@uaqgov.ae',
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      sendEmail(context, 'info@uaqgov.ae');
                                    },
                                  style: context.textFontWeight400
                                      .onFontSize(context.resources.dimen.dp12)
                                      .onColor(Colors.blue)
                                      .copyWith(
                                          decoration:
                                              TextDecoration.underline)),
                              TextSpan(
                                  text: ';\n',
                                  style: context.textFontWeight400.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text:
                                      '\u2022 Send you marketing communications;\n',
                                  style: context.textFontWeight400.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text:
                                      '\u2022  Improve our Malomati and marketing efforts;\n',
                                  style: context.textFontWeight400.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text:
                                      '\u2022  Conduct research and analysis;\n',
                                  style: context.textFontWeight400.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text:
                                      '\u2022 Respond to your questions and concerns; and\n',
                                  style: context.textFontWeight400.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text:
                                      '\u2022 Display content based upon your interests.\n\n',
                                  style: context.textFontWeight400.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text: 'Cookies\n\n',
                                  style: context.textFontWeight700.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text:
                                      'We use cookies to distinguish you from other users of Malomati, the App Site or the Service Site. This helps us to provide you with a good experience when you use Smart Employee or browse any of the Sites and also allows us to improve Malomati and Our sites.\n\n',
                                  style: context.textFontWeight400.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text: 'Choice/Opt-Out\n\n',
                                  style: context.textFontWeight700.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text:
                                      'You may opt-out of receiving our marketing emails or SMS messages from us by contacting us at ',
                                  style: context.textFontWeight400.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text: 'info@uaqgov.ae',
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      sendEmail(context, 'info@uaqgov.ae');
                                    },
                                  style: context.textFontWeight400
                                      .onFontSize(context.resources.dimen.dp12)
                                      .onColor(Colors.blue)
                                      .copyWith(
                                          decoration:
                                              TextDecoration.underline)),
                              TextSpan(
                                  text: '.\n\n',
                                  style: context.textFontWeight400.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text: 'Sharing Your Information\n\n',
                                  style: context.textFontWeight700.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text:
                                      'We will share your information with third parties only in the ways that are described in this privacy policy.\n\n',
                                  style: context.textFontWeight400.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text:
                                      'We may provide your personal information to affiliates of UAQ Government and/or companies that provide services to help us with our business activities such as offering customer service. These third parties are authorized to use your personal information only as necessary to provide these Services to us.\n\n',
                                  style: context.textFontWeight400.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text:
                                      'We may disclose your personal information',
                                  style: context.textFontWeight700.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text:
                                      '\u2022  as required by law, such as to comply with a court order or any other legal process;\n',
                                  style: context.textFontWeight400.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text:
                                      '\u2022  when we believe in good faith that disclosure is necessary to protect our rights, protect your safety or the safety of others, investigate fraud, or respond to a government request; and/or\n',
                                  style: context.textFontWeight400.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text:
                                      '\u2022 to any other third party with your prior consent to do so.\n\n',
                                  style: context.textFontWeight400.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text: 'Security\n\n',
                                  style: context.textFontWeight700.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text:
                                      'The security of your personal information is important to us. We follow generally accepted industry standards to protect the personal information submitted to us, both during transmission and once we receive it.\n\n',
                                  style: context.textFontWeight400.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text:
                                      'Unfortunately, the transmission of information via the internet is not completely secure. Although we will do our best to protect your personal data, we cannot guarantee the security of your data transmitted to Our Sites; any transmission is at your own risk. Once we have received your information, we will use strict procedures and security features to try to prevent unauthorised access.\n\n',
                                  style: context.textFontWeight400.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text:
                                      'We will retain your information for as long as your account is active or as needed to provide you with Services. If you wish to cancel your account or request that we no longer use your information to provide you with Services please contact us at ',
                                  style: context.textFontWeight400.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text: 'info@uaqgov.ae',
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      sendEmail(context, 'info@uaqgov.ae');
                                    },
                                  style: context.textFontWeight400
                                      .onFontSize(context.resources.dimen.dp12)
                                      .onColor(Colors.blue)
                                      .copyWith(
                                          decoration:
                                              TextDecoration.underline)),
                              TextSpan(
                                  text:
                                      '. We will retain and use your information as necessary to comply with our legal obligations, resolve disputes, and enforce our agreements.',
                                  style: context.textFontWeight400.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text:
                                      'Where we have given you (or where you have chosen) a password that enables you to access certain parts of Our Sites, you are responsible for keeping this password confidential. We ask you not to share a password with anyone.\n\n',
                                  style: context.textFontWeight400.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text: 'Other Information\n\n',
                                  style: context.textFontWeight700.onFontSize(
                                      context.resources.dimen.dp15)),
                              TextSpan(
                                  text:
                                      'Correcting and Updating Your Personal Information\n\n',
                                  style: context.textFontWeight700.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text:
                                      'To review and update your personal information to ensure it is accurate, contact us at ',
                                  style: context.textFontWeight400.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text: 'info@uaqgov.ae',
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      sendEmail(context, 'info@uaqgov.ae');
                                    },
                                  style: context.textFontWeight400
                                      .onFontSize(context.resources.dimen.dp12)
                                      .onColor(Colors.blue)
                                      .copyWith(
                                          decoration:
                                              TextDecoration.underline)),
                              TextSpan(
                                  text: '.\n\n',
                                  style: context.textFontWeight400.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text:
                                      'Notification of Privacy Policy Changes\n\n',
                                  style: context.textFontWeight700.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text:
                                      'We may update this privacy policy to reflect changes to our information practices or any relevant statute, regulations and/or policy. We encourage you to periodically review this page for the latest information on our privacy practices.\n\n',
                                  style: context.textFontWeight400.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text: 'Contact\n\n',
                                  style: context.textFontWeight700.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text:
                                      'You can contact us about this privacy policy by writing or email us at the address below:\n\n',
                                  style: context.textFontWeight400.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text: 'UAQ  Government\n',
                                  style: context.textFontWeight400.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text: 'Telephone number: ',
                                  style: context.textFontWeight400.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text: '+971 6 7641000\n',
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      callNumber(context, '+971 6 7641000');
                                    },
                                  style: context.textFontWeight400
                                      .onFontSize(context.resources.dimen.dp12)
                                      .onColor(const Color.fromARGB(
                                          255, 245, 103, 103))
                                      .copyWith(
                                          decoration:
                                              TextDecoration.underline)),
                              TextSpan(
                                  text: 'Fax number: ',
                                  style: context.textFontWeight400.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text: '+971 6 7641777\n',
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      sendEmail(context, '+971 6 7641777');
                                    },
                                  style: context.textFontWeight400
                                      .onFontSize(context.resources.dimen.dp12)
                                      .onColor(const Color.fromARGB(
                                          255, 245, 103, 103))
                                      .copyWith(
                                          decoration:
                                              TextDecoration.underline)),
                              TextSpan(
                                  text:
                                      'PO Box 225, Umm Al Quwain, United Arab Emirates\n',
                                  style: context.textFontWeight400.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text: 'Email: ',
                                  style: context.textFontWeight400.onFontSize(
                                      context.resources.dimen.dp12)),
                              TextSpan(
                                  text: 'info@uaqgov.ae',
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      sendEmail(context, 'info@uaqgov.ae');
                                    },
                                  style: context.textFontWeight400
                                      .onFontSize(context.resources.dimen.dp12)
                                      .onColor(Colors.blue)
                                      .copyWith(
                                          decoration:
                                              TextDecoration.underline)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
