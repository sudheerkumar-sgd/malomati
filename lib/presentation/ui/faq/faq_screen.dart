import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:malomati/presentation/ui/faq/widget/typer_animated_text_widget.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final Box chatBox = Hive.box('chatBox');

  List<ChatMessage> _messages = [];
  List<FaqModel> faqList = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    loadFaqs();
    loadChatHistory();
  }

  ////////////////////////////////////////////////
  /// LOAD FAQ DATA
  ////////////////////////////////////////////////

  void loadFaqs() {
    const jsonString = _faqJson;
    final data = json.decode(jsonString);
    faqList = (data['faqs'] as List).map((e) => FaqModel.fromJson(e)).toList();
  }

  ////////////////////////////////////////////////
  /// HIVE CHAT STORAGE
  ////////////////////////////////////////////////

  void saveChatHistory() {
    final List<Map<String, dynamic>> mappedMessages =
        _messages.map((msg) => msg.toMap()).toList();

    chatBox.put("history", mappedMessages);
  }

  void loadChatHistory() {
    final history = chatBox.get("history");

    if (history != null) {
      setState(() {
        _messages = List<Map<dynamic, dynamic>>.from(history)
            .map((e) => ChatMessage.fromMap(e))
            .toList();
      });

      scrollToBottom();
    }
  }

  ////////////////////////////////////////////////
  /// SEND MESSAGE
  ////////////////////////////////////////////////

  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    final userMsg = ChatMessage(role: "user", text: message, animate: false);

    setState(() {
      _messages.add(userMsg);
      _isTyping = true;
    });

    _controller.clear();
    scrollToBottom();

    await Future.delayed(const Duration(milliseconds: 800));

    final match = findBestMatch(message, faqList);
    String reply;

    if (match != null) {
      reply = isArabic(message) ? match.answerAr : match.answerEn;
    } else {
      reply = await callAI(message);
    }

    final botMsg = ChatMessage(role: "bot", text: reply, animate: true);

    setState(() {
      _isTyping = false;
      _messages.add(botMsg);
    });

    saveChatHistory();
    scrollToBottom();
  }

  ////////////////////////////////////////////////
  /// AI FALLBACK
  ////////////////////////////////////////////////

  Future<String> callAI(String message) async {
    return isArabic(message)
        ? "عذراً، سيتم تحويل سؤالك إلى الدعم البشري."
        : "Your question has been forwarded to HR support.";
  }

  ////////////////////////////////////////////////
  /// UI
  ////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HRMS Assistant"),
        actions: [
          IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                chatBox.delete("history");
                setState(() => _messages.clear());
              })
        ],
      ),
      body: Column(
        children: [
          Expanded(child: buildChatList()),
          if (_isTyping) typingIndicator(),
          //suggestedQuestions(),
          buildInput()
        ],
      ),
    );
  }

  Widget buildChatList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(12),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final msg = _messages[index];
        final isUser = msg.role == "user";

        return Align(
          alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            decoration: BoxDecoration(
              color: isUser ? const Color(0xFFDCF8C6) : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(18),
                topRight: const Radius.circular(18),
                bottomLeft: isUser ? const Radius.circular(18) : Radius.zero,
                bottomRight: isUser ? Radius.zero : const Radius.circular(18),
              ),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black12, blurRadius: 3, offset: Offset(0, 1)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                isUser
                    ? Text(msg.text, style: const TextStyle(fontSize: 15))
                    : (msg.animate
                        ? TyperAnimatedTextWidget(text: msg.text)
                        : Text(msg.text, style: const TextStyle(fontSize: 15))),
                const SizedBox(height: 4),
                Text(_formatTime(),
                    style: const TextStyle(fontSize: 10, color: Colors.grey)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildInput() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: "Ask your question...",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          IconButton(
              icon: const Icon(Icons.send),
              onPressed: () => sendMessage(_controller.text))
        ],
      ),
    );
  }

  String _formatTime() {
    final now = DateTime.now();
    return "${now.hour}:${now.minute.toString().padLeft(2, '0')}";
  }
  ////////////////////////////////////////////////
  /// TYPING INDICATOR
  ////////////////////////////////////////////////

  Widget typingIndicator() {
    return const Padding(
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          SizedBox(width: 12),
          Text("Typing...", style: TextStyle(color: Colors.grey))
        ],
      ),
    );
  }

  ////////////////////////////////////////////////
  /// SUGGESTIONS
  ////////////////////////////////////////////////

  Widget suggestedQuestions() {
    final suggestions = [
      "How to apply leave?",
      "نسيت كلمة المرور",
      "When salary credited?",
      "رصيد الإجازة"
    ];

    return SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ElevatedButton(
              onPressed: () => sendMessage(suggestions[index]),
              child: Text(suggestions[index]),
            ),
          );
        },
      ),
    );
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}

////////////////////////////////////////////////////////////
/// MODEL + MATCHING (same as before)
////////////////////////////////////////////////////////////
class ChatMessage {
  final String role; // "user" or "bot"
  final String text;
  final bool animate; // true = animate typing

  ChatMessage({
    required this.role,
    required this.text,
    this.animate = true,
  });

  Map<String, dynamic> toMap() {
    return {'role': role, 'text': text};
  }

  factory ChatMessage.fromMap(Map<dynamic, dynamic> map) {
    return ChatMessage(
      role: map['role'],
      text: map['text'],
      animate: false, // loaded from history → no animation
    );
  }
}

class FaqModel {
  final int id;
  final String question;
  final List<String> keywords;
  final String answerEn;
  final String answerAr;

  FaqModel({
    required this.id,
    required this.question,
    required this.keywords,
    required this.answerEn,
    required this.answerAr,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    return FaqModel(
      id: json['id'],
      question: json['question'],
      keywords: List<String>.from(json['keywords']),
      answerEn: json['answer_en'],
      answerAr: json['answer_ar'],
    );
  }
}

FaqModel? findBestMatch(String input, List<FaqModel> faqs) {
  final normalizedInput = normalizeText(input);
  FaqModel? bestMatch;
  int highestScore = 0;

  for (var faq in faqs) {
    int score = 0;

    for (var keyword in faq.keywords) {
      if (normalizedInput.contains(normalizeText(keyword))) {
        score++;
      }
    }

    if (score > highestScore) {
      highestScore = score;
      bestMatch = faq;
    }
  }

  return bestMatch;
}

String normalizeText(String text) {
  text = text.toLowerCase();
  text = text.replaceAll(RegExp(r'[\u064B-\u0652]'), '');
  return text
      .replaceAll('أ', 'ا')
      .replaceAll('إ', 'ا')
      .replaceAll('آ', 'ا')
      .replaceAll('ى', 'ي')
      .replaceAll('ة', 'ه');
}

bool isArabic(String text) {
  return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
}

////////////////////////////////////////////////////////////
/// SAMPLE JSON
////////////////////////////////////////////////////////////

const String _faqJson = '''
{
  "faqs": [
    {
      "id": 1,
      "category": "Attendance",
      "question": "How do I mark my attendance?",
      "keywords": [
        "attendance", "check in", "punch", "clock in",
        "الحضور", "تسجيل الحضور", "بصمة", "تسجيل الدخول", "دوام"
      ],
      "answer_en": "You can mark your attendance by tapping on the 'Check In' button from the home screen. Make sure your GPS is enabled.",
      "answer_ar": "يمكنك تسجيل الحضور بالضغط على زر 'تسجيل الدخول' من الشاشة الرئيسية. تأكد من تفعيل خدمة الموقع."
    },
    {
      "id": 2,
      "category": "Attendance",
      "question": "Why can't I check in?",
      "keywords": [
        "attendance error", "check in failed", "location error",
        "مشكلة حضور", "فشل تسجيل", "خطأ في الموقع", "لا استطيع تسجيل"
      ],
      "answer_en": "Please ensure that location services are enabled and you are within the allowed office radius. Also check your internet connection.",
      "answer_ar": "يرجى التأكد من تفعيل خدمة الموقع وأنك ضمن النطاق المسموح به للمكتب، وكذلك التحقق من اتصال الإنترنت."
    },
    {
      "id": 3,
      "category": "Leave",
      "question": "How do I apply for leave?",
      "keywords": [
        "leave", "apply leave", "annual leave", "vacation",
        "اجازة", "طلب اجازة", "إجازة سنوية", "إجازة", "إجازة مرضية"
      ],
      "answer_en": "Go to the Leave section, select the leave type, choose dates, and submit your request for manager approval.",
      "answer_ar": "انتقل إلى قسم الإجازات، اختر نوع الإجازة وحدد التواريخ ثم أرسل الطلب لاعتماده من المدير."
    },
    {
      "id": 4,
      "category": "Leave",
      "question": "How can I check my leave balance?",
      "keywords": [
        "leave balance", "remaining leave", "vacation balance",
        "رصيد الاجازة", "رصيد الإجازات", "المتبقي من الاجازة"
      ],
      "answer_en": "Your leave balance is available in the Leave section under 'My Balance'.",
      "answer_ar": "يمكنك الاطلاع على رصيد الإجازات من خلال قسم الإجازات ضمن خيار 'رصيدي'."
    },
    {
      "id": 5,
      "category": "Payroll",
      "question": "When will my salary be credited?",
      "keywords": [
        "salary", "payroll", "payment date",
        "راتب", "الراتب", "موعد الراتب", "الرواتب", "تحويل الراتب"
      ],
      "answer_en": "Salaries are credited at the end of each month as per company policy.",
      "answer_ar": "يتم تحويل الرواتب في نهاية كل شهر حسب سياسة الجهة."
    },
    {
      "id": 6,
      "category": "Payroll",
      "question": "How can I download my payslip?",
      "keywords": [
        "payslip", "salary slip", "download payslip",
        "قسيمة راتب", "كشف راتب", "تحميل قسيمة", "تحميل الراتب"
      ],
      "answer_en": "Navigate to Payroll > Payslips, select the month, and tap 'Download'.",
      "answer_ar": "انتقل إلى الرواتب > قسائم الرواتب، اختر الشهر ثم اضغط على 'تحميل'."
    },
    {
      "id": 7,
      "category": "Work Hours",
      "question": "How do I track my remaining work hours?",
      "keywords": [
        "remaining hours", "work hours", "timer",
        "الساعات المتبقية", "ساعات العمل", "مؤقت", "دوام اليوم"
      ],
      "answer_en": "Your remaining work hours are displayed on the dashboard under the Work Hours Timer section.",
      "answer_ar": "يتم عرض ساعات العمل المتبقية في لوحة التحكم ضمن قسم مؤقت ساعات العمل."
    },
    {
      "id": 8,
      "category": "Profile",
      "question": "How do I update my personal information?",
      "keywords": [
        "update profile", "edit details", "change phone",
        "تحديث البيانات", "تعديل البيانات", "تغيير رقم الهاتف", "الملف الشخصي"
      ],
      "answer_en": "Go to Profile > Edit Information and update your details. Some fields may require HR approval.",
      "answer_ar": "انتقل إلى الملف الشخصي > تعديل المعلومات وقم بتحديث بياناتك. قد تتطلب بعض الحقول موافقة الموارد البشرية."
    },
    {
      "id": 9,
      "category": "Remote Work",
      "question": "How do I request Work From Home?",
      "keywords": [
        "work from home", "WFH", "remote work",
        "العمل من المنزل", "طلب عمل من المنزل", "دوام عن بعد"
      ],
      "answer_en": "Go to Services > Work From Home, select the date, provide a reason, and submit for approval.",
      "answer_ar": "انتقل إلى الخدمات > العمل من المنزل، اختر التاريخ وأدخل السبب ثم أرسل الطلب للاعتماد."
    },
    {
      "id": 10,
      "category": "Technical Support",
      "question": "I forgot my password. What should I do?",
      "keywords": [
        "forgot password", "reset password", "login issue",
        "نسيت كلمة المرور", "اعادة تعيين كلمة المرور", "مشكلة تسجيل الدخول"
      ],
      "answer_en": "Tap on 'Forgot Password' on the login screen and follow the instructions to reset your password.",
      "answer_ar": "اضغط على 'نسيت كلمة المرور' في شاشة تسجيل الدخول واتبع التعليمات لإعادة تعيين كلمة المرور."
    }
  ]
}
''';
