import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../config.dart';

class DiagnosticCard extends StatefulWidget {
  const DiagnosticCard({super.key});

  @override
  State<DiagnosticCard> createState() => _DiagnosticCardState();
}

class _DiagnosticCardState extends State<DiagnosticCard> {
  bool _loading = false;

  final List<String> _log = [];

  Future<void> _runDiagnostics() async {
    setState(() {
      _loading = true;
      _log.clear();
    });

    void add(String text) {
      _log.add(text);
      if (mounted) setState(() {});
    }

    add("========== DIAGNOSZTIKA ==========");
    add("");

    try {
      add("Base URL:");
      add(Config.baseUrl);
      add("");

      add("API kulcs betöltve:");
      add(Config.sportsDbApiKey.isNotEmpty ? "IGEN" : "NEM");
      add("");

      add("1. DNS - google.com");

      try {
        final result = await InternetAddress.lookup("google.com");
        add("OK (${result.first.address})");
      } catch (e) {
        add("HIBA");
        add(e.toString());
      }

      add("");

      add("2. DNS - www.thesportsdb.com");

      try {
        final result =
            await InternetAddress.lookup("www.thesportsdb.com");
        add("OK (${result.first.address})");
      } catch (e) {
        add("HIBA");
        add(e.toString());
      }

      add("");

      add("3. HTTPS Google");

      try {
        final response = await http
            .get(Uri.parse("https://www.google.com"))
            .timeout(const Duration(seconds: 10));

        add("Status: ${response.statusCode}");
      } catch (e) {
        add(e.toString());
      }

      add("");

      add("4. HTTPS TheSportsDB");

      try {
        final response = await http
            .get(Uri.parse(
                "${Config.baseUrl}/${Config.sportsDbApiKey}/livescore.php"))
            .timeout(const Duration(seconds: 10));

        add("Status: ${response.statusCode}");
        add("");

        if (response.body.isNotEmpty) {
          final json = jsonDecode(response.body);
          add(json.toString());
        }
      } catch (e) {
        add(e.toString());
      }
    } catch (e) {
      add("");
      add("Váratlan hiba:");
      add(e.toString());
    }

    add("");
    add("========== VÉGE ==========");

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.red.shade900,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Fejlesztői diagnosztika",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loading ? null : _runDiagnostics,
              child: Text(
                _loading
                    ? "Vizsgálat..."
                    : "Diagnosztika indítása",
              ),
            ),
            const SizedBox(height: 12),
            SelectableText(
              _log.join("\n"),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
