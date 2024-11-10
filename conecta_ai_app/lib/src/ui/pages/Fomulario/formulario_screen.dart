import 'dart:convert';
import 'dart:developer';
import 'package:conecta_ai_app/src/service/api_service.dart';
import 'package:conecta_ai_app/src/ui/components/custom_colors.dart';
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
  String response = "";
  String mensagemFinal = "";
  String resumo = "";
  String mensagemConfirmacao = "";
  bool isLoading = true;
  bool emAndamento = true;

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
            response = jsonPart;
            emAndamento = jsonData['emAndamento'] ?? "";
            mensagemFinal = jsonData['mensagemFinal'] ?? "";
            resumo = jsonData['resumo'] ?? "";
            mensagemConfirmacao = jsonData['mensagemConfirmacao'] ?? "";
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
      log(generateResume(messageContent).toString());
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

    log(buffer.toString());
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Cor.white, size: 28),
        title: const Text('Formulário', style: TextStyle(color: Cor.white)),
        backgroundColor: Cor.darkBlue,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Cor.hardBlue, // Cor inicial do gradiente
              Cor.lightBlue, // Cor final do gradiente
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : emAndamento
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 6,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Cor.darkBlue,
                                    Cor.hardBlue,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    pergunta,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  TextField(
                                    controller: _respostaController,
                                    decoration: InputDecoration(
                                      hintText: hintText,
                                      hintStyle: const TextStyle(
                                          color: Colors.white70),
                                      filled: true,
                                      fillColor: Colors.white12,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.white70, width: 2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      contentPadding: const EdgeInsets.all(16),
                                    ),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  const SizedBox(height: 16),
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: ElevatedButton(
                                        onPressed: proximaPergunta,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white24,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 20),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        child: const Text(
                                          'Próximo',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Text(
                                response,
                                style: const TextStyle(
                                    fontSize: 16, fontFamily: 'monospace'),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mensagemFinal,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            mensagemConfirmacao,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Abaixo temos as perguntas e respostas até agora:',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Text(
                                    formatPerguntasRespostas(),
                                    style: const TextStyle(
                                        fontSize: 16, fontFamily: 'monospace'),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    resumo,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )),
      ),
    );
  }

  @override
  void dispose() {
    _respostaController.dispose();
    super.dispose();
  }
}
