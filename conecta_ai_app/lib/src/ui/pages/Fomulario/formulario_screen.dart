import 'dart:convert';
import 'dart:developer';
import 'package:conecta_ai_app/src/service/api_service.dart';
import 'package:flutter/material.dart';

class FormularioScreen extends StatefulWidget {
  const FormularioScreen({super.key});

  @override
  State<FormularioScreen> createState() => _FormularioScreenState();
}

class _FormularioScreenState extends State<FormularioScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _respostaController = TextEditingController();
  List<Map<String, String>> perguntasRespostas =
      []; // Lista de perguntas e respostas
  String pergunta = "";
  String hintText = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    generateResume("Inicio"); // Inicia a primeira requisição ao carregar a tela
  }

  Future<void> generateResume(String messageContent) async {
    setState(() {
      isLoading = true;
    });

    await _apiService.sendChatCompletionRequest(messageContent,
        (String content) {
      // Agora, 'content' é o JSON completo acumulado
      final parts = content.split('|');
      if (parts.length > 1) {
        setState(() {
          pergunta = parts[0].trim();
          String jsonPart = parts[1].trim();
          try {
            final Map<String, dynamic> jsonData = json.decode(jsonPart);
            pergunta = jsonData['proximaPergunta'] ?? pergunta;
            hintText = jsonData['exemploResposta'] ?? "";
          } catch (e) {
            log("Erro ao processar JSON: $e");
          } finally {
            isLoading = false;
          }
        });
      }
    });
  }

  void proximaPergunta() {
    if (_respostaController.text.isNotEmpty) {
      perguntasRespostas.add({
        "pergunta": pergunta,
        "exemploResposta": hintText,
        "resposta": _respostaController.text,
      });

      final messageContent = jsonEncode({
        "Contexto":
            "Abaixo temos as perguntas e respostas até agora. Qual será a próxima pergunta?",
        "perguntasRespostas": perguntasRespostas,
      });

      _respostaController.clear();
      generateResume(messageContent);
    }
  }

  String formatPerguntasRespostas() {
    final buffer = StringBuffer();
    buffer.write("{\n");
    buffer.write(
        '  "Contexto": "Abaixo temos as perguntas e respostas até agora. Qual será a próxima pergunta?",\n');
    buffer.write('  "perguntasRespostas": [\n');

    for (var i = 0; i < perguntasRespostas.length; i++) {
      final perguntaResposta = perguntasRespostas[i];
      buffer.write('    {\n');
      buffer.write('      "pergunta": "${perguntaResposta['pergunta']}",\n');
      buffer.write(
          '      "exemploResposta": "${perguntaResposta['exemploResposta']}",\n');
      buffer.write('      "resposta": "${perguntaResposta['resposta']}"\n');
      buffer.write(i == perguntasRespostas.length - 1
          ? '    }\n'
          : '    },\n'); // Condição para não adicionar vírgula no último item
    }

    buffer.write('  ]\n');
    buffer.write("}");

    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulário'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(pergunta,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _respostaController,
                    decoration: InputDecoration(
                      hintText: hintText,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: proximaPergunta,
                    child: const Text('Próximo'),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        formatPerguntasRespostas(),
                        style: const TextStyle(
                            fontSize: 16, fontFamily: 'monospace'),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  @override
  void dispose() {
    _respostaController.dispose();
    super.dispose();
  }
}
