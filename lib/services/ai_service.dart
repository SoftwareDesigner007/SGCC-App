import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/course_model.dart';

class AIService {
  // Gemini API Key from Google AI Studio
  static const String _apiKey = "AIzaSyDSeVGFEjEiBZkzKyTTBMRgaa0Wtt-GB_Q";
  
  static bool get isConfigured => _apiKey.isNotEmpty && !_apiKey.contains("YOUR_GEMINI_API_KEY");

  static GenerativeModel? _model;
  static ChatSession? _chatSession;

  static void _initModel() {
    if (_model != null) return;
    
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: _apiKey,
      systemInstruction: Content.system(_buildSystemPrompt()),
    );
    
    _chatSession = _model!.startChat();
  }

  static String _buildSystemPrompt() {
    final courseData = allCourses.map((c) => {
      "name": c.name,
      "simple": c.simpleExplanation,
      "admission": c.admissionProcess,
      "material": c.studyMaterials,
      "duration": c.duration,
    }).toList();

    return """
You are the "SGCC Smart Guide" – a high-IQ, compassionate, and expert Tech Tutor for Shree Ganesh Computer Classes (SGCC).

CORE DIRECTIVES:
1. MENTORSHIP: Act as a wise mentor. Don't just answer; guide. If a user is confused, ask about their career dreams or interests to recommend the perfect SGCC course.
2. OUT-OF-THE-BOX: You are an expert in all things tech. Answer ANY question (e.g., "What is coding?", "How to make a website?", "Latest AI trends") expertly and simply.
3. MULTILINGUAL: Detect the user's language. If they speak Marathi or Hindi, reply with 100% fluency and warmth in that SAME language.
4. NO REPETITION: Never give generic, repetitive "Hello" loops. Provide specific, helpful advice tailored to the user's specific doubt immediately.
5. PIVOT: While you answer general questions, gently bring the conversation back to how SGCC can help them master those skills.

SGCC KNOWLEDGE:
- Location: Near Cardinal School, Bandra East, Mumbai 400051.
- Contact: +91 88989 19457.
- Fees: MS-CIT (₹4,500), Professional courses (from ₹5,000). Installments available.
- Courses: $courseData

Structure your replies with clarity, using bullet points or bold text where helpful. Always end with an encouraging follow-up question.
""";
  }

  static Future<String> getAIResponse(String userQuery) async {
    if (!isConfigured) {
      return ""; // Triggers local fallback
    }

    try {
      _initModel();
      
      final response = await _chatSession!.sendMessage(Content.text(userQuery));
      return response.text ?? "I'm sorry, I couldn't process that. Please try again or call us!";
    } catch (e) {
      print("Gemini AI Error: $e");
      return ""; // Fallback
    }
  }
  
  static void resetChat() {
    _chatSession = _model?.startChat();
  }
}
