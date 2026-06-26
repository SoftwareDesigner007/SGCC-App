import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math';
import '../theme/app_colors.dart';
import '../models/course_model.dart';
import '../services/ai_service.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final _scrollCtrl = ScrollController();
  final _inputCtrl = TextEditingController();
  final List<_Msg> _messages = [
    _Msg(
        text:
            "👋 Namaste! I'm your SGCC Smart Guide. ✨\n\nI'm not just a bot; I'm here to be your mentor. Whether you're a student, a professional, or just curious, I'll help you find the perfect path in tech.\n\nAre you looking to start a new career, or just want to upgrade your skills? Tell me what you're interested in! 🌟",
        isBot: true),
  ];
  
  bool _isLoading = false;

  final _jokes = [
    "Why do programmers prefer dark mode? Because light attracts bugs! 🐛",
    "Real programmers count from 0, not 1. That's why I'm your #0 friend! 😎",
    "Why was the computer cold? It left its Windows open! 🪟",
    "Hardware is the part of a computer that you can kick; software is the part you can only curse at! 😂",
    "I'm not lazy, I'm just on power-saving mode. 🔋",
    "What do you call a programmer from Finland? Nerdic! ❄️",
  ];

  final _quickReplies = [
    'Hardware course',
    'Marathi Typing',
    'MS-CIT fees',
    'Tally details',
    'AI courses',
    'Campus location',
  ];

  void _handleSend([String? text]) async {
    final input = text ?? _inputCtrl.text.trim();
    if (input.isEmpty || _isLoading) return;

    setState(() {
      _messages.add(_Msg(text: input, isBot: false));
      if (text == null) _inputCtrl.clear();
      _isLoading = true;
    });

    _scrollToBottom();

    // 1. Try Advanced AI (Gemini)
    String response = await AIService.getAIResponse(input);

    // 2. Fallback to Local Brain Logic if AI is unavailable or fails
    if (response.isEmpty) {
      final query = input.toLowerCase();

      // Language Detection (Romanized & Script)
      bool isMarathi = query.contains('marathi') ||
          query.contains('maala') ||
          query.contains('mala') ||
          query.contains('aahe') ||
          query.contains('karay') ||
          query.contains('sang') ||
          query.contains('kaay') ||
          query.contains('mi') ||
          query.contains('namaskar') ||
          query.contains('pahije') ||
          query.contains('mahit');

      bool isHindi = query.contains('hindi') ||
          query.contains('mujhe') ||
          query.contains('hai') ||
          query.contains('karna') ||
          query.contains('batao') ||
          query.contains('kya') ||
          query.contains('namaste') ||
          query.contains('chahiye') ||
          query.contains('jaankari');

      // Course Identification Logic
      CourseModel? matchedCourse;
      for (var course in allCourses) {
        final name = course.name.toLowerCase();
        final keywords = course.keywords;
        
        bool keywordMatch = keywords.any((k) => query.contains(k.toLowerCase()));
        
        if (query.contains(name) || keywordMatch) {
          matchedCourse = course;
          break;
        }
      }

      // Response Generation
      if (matchedCourse != null) {
        bool askingProcess = query.contains('process') || query.contains('admission') || query.contains('join') || query.contains('admisan') || query.contains('prakriya');
        bool askingMaterial = query.contains('material') || query.contains('book') || query.contains('notes') || query.contains('saahitya') || query.contains('pustak');

        if (isMarathi) {
          if (askingProcess) {
            response = "📝 **${matchedCourse.name} - प्रवेश प्रक्रिया:**\n\n${matchedCourse.admissionProcess}\n\nतुम्ही आजच केंद्रावर येऊन आपली जागा निश्चित करू शकता! 😊";
          } else if (askingMaterial) {
            response = "📚 **${matchedCourse.name} - अभ्यास साहित्य:**\n\n${matchedCourse.studyMaterials}\n\nआम्ही तुम्हाला सर्व आवश्यक नोट्स आणि प्रॅक्टिस फाईल्स देऊ! 📖";
          } else {
            response = "🎯 **${matchedCourse.name}** (सोप्या भाषेत):\n\n${matchedCourse.simpleExplanation}\n\n⏳ **कालावधी:** ${matchedCourse.duration}\n\nतुम्हाला या कोर्सच्या प्रवेशाबद्दल (Admission) किंवा पुस्तकांबद्दल (Study Material) माहिती हवी आहे का? 😊";
          }
        } else if (isHindi) {
          if (askingProcess) {
            response = "📝 **${matchedCourse.name} - एडमिशन प्रोसेस:**\n\n${matchedCourse.admissionProcess}\n\nआप आज ही सेंटर पर आकर अपनी सीट पक्की कर सकते हैं! 😊";
          } else if (askingMaterial) {
            response = "📚 **${matchedCourse.name} - स्टडी मटेरियल:**\n\n${matchedCourse.studyMaterials}\n\nहम आपको सभी जरूरी नोट्स और प्रैक्टिस फाइल्स देंगे! 📖";
          } else {
            response = "🎯 **${matchedCourse.name}** (आसान शब्दों में):\n\n${matchedCourse.simpleExplanation}\n\n⏳ **अवधि:** ${matchedCourse.duration}\n\nक्या आप इस कोर्स के एडमिशन या बुक्स के बारे में और जानना चाहते हैं? 😊";
          }
        } else {
          if (askingProcess) {
            response = "📝 **${matchedCourse.name} - Admission Process:**\n\n${matchedCourse.admissionProcess}\n\nVisit us today to secure your seat! 🚀";
          } else if (askingMaterial) {
            response = "📚 **${matchedCourse.name} - Study Materials:**\n\n${matchedCourse.studyMaterials}\n\nWe provide all the necessary notes and practice files! 📖";
          } else {
            response = "🎯 **${matchedCourse.name}** (In Simple Terms):\n\n${matchedCourse.simpleExplanation}\n\n⏳ **Duration:** ${matchedCourse.duration}\n\nWould you like to know about the Admission Process or Study Materials for this? 🚀";
          }
        }
      } 
      else if (query.contains('fee') || query.contains('paisa') || query.contains('cost') || query.contains('paise') || query.contains('bhada')) {
        if (isMarathi) {
          response = "💰 **फी बद्दल माहिती:**\n\n• MS-CIT: ₹4,500\n• प्रोफेशनल कोर्सेस: ₹5,000 पासून पुढे\n\nआम्ही तुम्हाला सुलभ हप्त्यांमध्ये (Installments) मदत करू शकतो. अधिक माहितीसाठी आम्हाला +91 88989 19457 वर कॉल करा! 📞";
        } else if (isHindi) {
          response = "💰 **फीस की जानकारी:**\n\n• MS-CIT: ₹4,500\n• प्रोफेशनल कोर्सेस: ₹5,000 से शुरू\n\nहम आपको आसान किस्तों (Installments) में भी मदद कर सकते हैं। ज्यादा जानकारी के लिए हमें +91 88989 19457 वर कॉल करें! 📞";
        } else {
          response = "💰 **Fees Information:**\n\n• MS-CIT: ₹4,500\n• Professional courses: Starting from ₹5,000\n\nWe offer easy installment options to help you! Call us at +91 88989 19457 for a detailed fee structure! 📞";
        }
      } 
      else if (query.contains('address') || query.contains('location') || query.contains('where') || query.contains('kuthe') || query.contains('kaha')) {
        response = "📍 **येथे आमचा पत्ता आहे:**\n\nNear Cardinal School, Bandra East, Mumbai 400051.\n\nआम्ही सोमवार ते शनिवार, सकाळी ८ ते रात्री १० पर्यंत तुमच्यासाठी उपलब्ध आहोत. भेटूया! 🏫✨";
      }
      else if (query.contains('admission') || query.contains('join') || query.contains('start') || query.contains('prakriya')) {
        response = "Joining SGCC is very easy! 🌟\n\n1. Pick a course you like.\n2. Visit our center in Bandra East.\n3. Fill a simple form and submit your ID proof.\n4. Start learning from the next day! 🚀\n\nWhich course are you planning to join?";
      }
      else if (query.contains('joke') || query.contains('hasav') || query.contains('chutkula')) {
        response = "Haha, here's a little something to brighten your day! 😊\n\n${_jokes[Random().nextInt(_jokes.length)]}";
      }
      else if (query.contains('how are you') || query.contains('kasa aahes') || query.contains('kaise ho') || query.contains('kashi aahes')) {
        response = "I'm doing great, thank you for asking! 😊 I'm always happy when I can help someone find their path in the world of technology. How are you doing today? Is there anything I can help you with?";
      }
      else if (RegExp(r'\b(hi|hello|hey|namaste|namaskar)\b').hasMatch(query)) {
        response = "Hello! 👋 It's wonderful to meet you. I'm your dedicated SGCC Smart Guide, here to guide you toward success in very simple words. 🌟\n\nI can explain any of our **15+ Courses**, their Admission Process, or Study Materials. What would you like to know first?";
      } else {
        response = "I'm here to support you! 🌟 While I'm still learning, I can explain everything about SGCC in simple terms. \n\nAre you asking about a specific course like **MS-CIT, Tally, or Hardware**? Or do you want to know about **Admissions** or **Study Materials**? 🚀\n\nYou can also call us directly at +91 88989 19457! 📞";
      }
    }

    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _messages.add(_Msg(text: response, isBot: true));
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    _inputCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface.withOpacity(0.95),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: colorScheme.onSurface, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.15),
              shape: BoxShape.circle,
              border: Border.all(color: colorScheme.primary.withOpacity(0.4)),
            ),
            child: Icon(Icons.auto_awesome,
                color: colorScheme.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('SGCC Smart Guide',
                style: GoogleFonts.sora(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface)),
            Row(children: [
              Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, 
                      color: AIService.isConfigured ? const Color(0xFF00FF88) : Colors.orange)),
              const SizedBox(width: 5),
              Text(AIService.isConfigured ? 'Online: Advanced Tutor' : 'Offline: Smart Guide',
                  style: GoogleFonts.inter(
                      fontSize: 11, color: colorScheme.onSurfaceVariant)),
            ]),
          ]),
        ]),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, size: 20),
            onPressed: () {
              setState(() {
                AIService.resetChat();
                _messages.clear();
                _messages.add(_Msg(
                  text: "🔄 History cleared! How can I guide you now? ✨",
                  isBot: true,
                ));
              });
            },
            tooltip: 'Reset Conversation',
          ),
        ],
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
                height: 1, color: colorScheme.primary.withOpacity(0.2))),
      ),
      body: Column(children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollCtrl,
            padding: const EdgeInsets.all(16),
            itemCount: _messages.length + (_isLoading ? 1 : 0),
            itemBuilder: (_, i) {
              if (i == _messages.length && _isLoading) {
                return _buildTypingIndicator(context);
              }
              
              final m = _messages[i];
              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment:
                      m.isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
                  children: [
                    if (m.isBot) ...[
                      Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                              color: colorScheme.primary.withOpacity(0.15),
                              shape: BoxShape.circle),
                          child: Icon(Icons.auto_awesome,
                              color: colorScheme.primary, size: 16)),
                      const SizedBox(width: 8),
                    ],
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: m.isBot
                              ? (isDark
                                  ? AppColors.darkSurfaceContainerHigh
                                  : AppColors.lightSurfaceContainerHigh)
                              : colorScheme.primary.withOpacity(0.9),
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(18),
                            topRight: const Radius.circular(18),
                            bottomLeft: Radius.circular(m.isBot ? 4 : 18),
                            bottomRight: Radius.circular(m.isBot ? 18 : 4),
                          ),
                          border: m.isBot
                              ? Border.all(
                                  color: colorScheme.outline.withOpacity(0.3))
                              : null,
                          boxShadow: m.isBot
                              ? null
                              : [
                                  BoxShadow(
                                      color: colorScheme.primary.withOpacity(0.3),
                                      blurRadius: 12)
                                ],
                        ),
                        child: Text(m.text,
                            style: GoogleFonts.inter(
                                fontSize: 13,
                                color: m.isBot
                                    ? colorScheme.onSurface
                                    : colorScheme.onPrimary,
                                height: 1.55)),
                      ),
                    ),
                    if (!m.isBot) ...[
                      const SizedBox(width: 8),
                      Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.darkSurfaceContainerHigh
                                  : AppColors.lightSurfaceContainerHigh,
                              shape: BoxShape.circle),
                          child: Icon(Icons.person_outline,
                              color: colorScheme.onSurfaceVariant, size: 16)),
                    ],
                  ],
                ).animate().fadeIn(duration: 300.ms).slideY(
                    begin: 0.1, end: 0, curve: Curves.easeOutCubic),
              );
            },
          ),
        ),

        // Input Area
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            border: Border(
                top: BorderSide(color: colorScheme.primary.withOpacity(0.1))),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5))
            ],
          ),
          child: Column(children: [
            // Suggestions
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(bottom: 8),
                itemCount: _quickReplies.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) => GestureDetector(
                  onTap: () => _handleSend(_quickReplies[i]),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(15),
                      border:
                          Border.all(color: colorScheme.primary.withOpacity(0.2)),
                    ),
                    child: Text(_quickReplies[i],
                        style: GoogleFonts.inter(
                            fontSize: 11,
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkSurfaceContainer
                        : AppColors.lightSurfaceContainer,
                    borderRadius: BorderRadius.circular(25),
                    border:
                        Border.all(color: colorScheme.outline.withOpacity(0.2)),
                  ),
                  child: TextField(
                    controller: _inputCtrl,
                    onSubmitted: (_) => _handleSend(),
                    enabled: !_isLoading,
                    style: GoogleFonts.inter(
                        fontSize: 14, color: colorScheme.onSurface),
                    decoration: InputDecoration(
                      hintText: _isLoading ? 'Typing...' : 'Type your doubt here...',
                      hintStyle: GoogleFonts.inter(
                          fontSize: 14, color: colorScheme.onSurfaceVariant),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: _isLoading ? null : () => _handleSend(),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: _isLoading 
                          ? [Colors.grey, Colors.grey.shade400]
                          : [colorScheme.primary, colorScheme.secondary]),
                    shape: BoxShape.circle,
                    boxShadow: _isLoading ? null : [
                      BoxShadow(
                          color: colorScheme.primary.withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4))
                    ],
                  ),
                  child:
                      const Icon(Icons.send_rounded, color: Colors.white, size: 22),
                ),
              ),
            ]),
          ]),
        ),
      ]),
    );
  }

  Widget _buildTypingIndicator(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.15),
                  shape: BoxShape.circle),
              child: Icon(Icons.auto_awesome,
                  color: colorScheme.primary, size: 16)),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurfaceContainerHigh : AppColors.lightSurfaceContainerHigh,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(18),
              ),
              border: Border.all(color: colorScheme.outline.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _dot(0),
                _dot(1),
                _dot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot(int index) {
    return Container(
      width: 6, height: 6,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
        shape: BoxShape.circle,
      ),
    ).animate(onPlay: (c) => c.repeat())
     .scale(delay: (index * 200).ms, duration: 600.ms, begin: const Offset(1, 1), end: const Offset(1.5, 1.5))
     .then().scale(duration: 600.ms, begin: const Offset(1.5, 1.5), end: const Offset(1, 1));
  }
}

class _Msg {
  final String text;
  final bool isBot;
  _Msg({required this.text, required this.isBot});
}
