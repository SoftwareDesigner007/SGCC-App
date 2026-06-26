import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String title;
  final String icon;
  final IconData iconData;
  final Color accentColor;
  final String definition;
  final String example;
  final List<String> courses;

  const CategoryModel({
    required this.id,
    required this.title,
    required this.icon,
    required this.iconData,
    required this.accentColor,
    required this.definition,
    required this.example,
    required this.courses,
  });
}

final List<CategoryModel> learningCategories = [
  CategoryModel(
    id: 'programming',
    title: 'Programming',
    icon: 'code',
    iconData: Icons.code_rounded,
    accentColor: const Color(0xFFFF2D78),
    definition:
        'Programming is the process of creating instructions that tell a computer how to perform a task. It involves writing code in languages like C, Java, or Python to build software, websites, apps, and automation tools.',
    example:
        'Example: Writing a Python script to automate data entry, or building an Android app using Kotlin.',
    courses: [
      'Basics of C, C++, Java, Python, Kotlin',
      'Advance Programming (OOP, DSA, Projects)',
      'Web Designing & Web Development',
      'Prompt Engineering & Generative AI',
    ],
  ),
  CategoryModel(
    id: 'designing',
    title: 'Designing',
    icon: 'draw',
    iconData: Icons.draw_rounded,
    accentColor: const Color(0xFF00FFCC),
    definition:
        'Designing is the art of creating visual solutions that communicate ideas effectively. It covers graphic design, UI/UX, branding, typography, and digital illustrations using professional tools like Figma and Photoshop.',
    example:
        'Example: Designing a logo for a startup, or creating wireframes for a mobile banking app.',
    courses: [
      'Graphic Designing (Photoshop, Illustrator)',
      'UI UX Designing (Figma, Adobe XD)',
      'Digital Marketing with AI',
      'Web Designing & Web Development',
    ],
  ),
  CategoryModel(
    id: 'database',
    title: 'Database',
    icon: 'database',
    iconData: Icons.storage_rounded,
    accentColor: const Color(0xFFFFE04A),
    definition:
        'A database is an organized collection of structured information. Database management involves storing, retrieving, and manipulating data efficiently using systems like MySQL, Oracle, or Tally for business records.',
    example:
        "Example: Managing a company's inventory records using Tally ERP, or querying a student database using SQL.",
    courses: [
      'Financial Accounting with Tally ERP 9',
      'Office Automation (Excel Advanced)',
      'MS-CIT (Data Management Modules)',
      'Computer Fundamentals with Database Basics',
    ],
  ),
  CategoryModel(
    id: 'cybersecurity',
    title: 'Cyber Security',
    icon: 'shield',
    iconData: Icons.shield_rounded,
    accentColor: const Color(0xFF78B4FF),
    definition:
        'Cyber Security is the practice of protecting computers, servers, networks, and data from digital attacks. It involves understanding threats, encryption, firewalls, ethical hacking, and safe internet practices.',
    example:
        'Example: Setting up a firewall on a corporate network, or learning to identify phishing emails and prevent identity theft.',
    courses: [
      'Diploma in IT Hardware & Networking',
      'Basics of Computer (Internet Safety Module)',
      'MS-CIT (Cybersecurity Awareness)',
      'Advanced Networking & Server Management',
    ],
  ),
];
