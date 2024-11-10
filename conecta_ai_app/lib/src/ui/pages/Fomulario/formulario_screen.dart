import 'dart:convert';
import 'package:conecta_ai_app/src/service/api_service.dart';
import 'package:flutter/material.dart';

class FormularioScreen extends StatefulWidget {
  const FormularioScreen({super.key});

  @override
  State<FormularioScreen> createState() => _FormularioScreenState();
}

class _FormularioScreenState extends State<FormularioScreen> {
  final ApiService _apiService = ApiService();
  String pergunta = ""; // Exibe a pergunta
  String hintText = ""; // Exibe o exemplo de resposta
  final TextEditingController _respostaController = TextEditingController();
  List<Map<String, String>> perguntasRespostas =
      []; // Lista de perguntas e respostas para o messageContent

  @override
  void initState() {
    super.initState();
    generateResume(); // Inicia a primeira requisição ao carregar a tela
  }

  // Função para iniciar a requisição e processar os dados recebidos
  void generateResume() {
    _apiService.sendChatCompletionRequest("Iniciar", (String content) {
      final parts = content.split('|');
      if (parts.length > 1) {
        setState(() {
          pergunta = parts[0].trim(); // Pega a parte antes do "|"
          String jsonPart = parts[1].trim(); // Pega a parte JSON

          try {
            final Map<String, dynamic> jsonData = json.decode(jsonPart);
            pergunta = jsonData['proximaPergunta'] ?? pergunta;
            hintText = jsonData['exemploResposta'] ?? "";
          } catch (e) {
            print("Erro ao processar JSON: $e");
          }
        });
      }
    });
  }

  // Função para avançar para a próxima pergunta com base na resposta atual
  void proximaPergunta() {
    if (_respostaController.text.isNotEmpty) {
      // Adiciona a pergunta atual e a resposta preenchida ao modelo
      perguntasRespostas.add({
        "pergunta": pergunta,
        "exemploResposta": hintText,
        "resposta": _respostaController.text,
      });

      // Monta o novo messageContent
      final messageContent = jsonEncode({
        "Contexto":
            "Abaixo temos as perguntas e respostas até agora. Qual será a próxima pergunta?",
        "perguntasRespostas": perguntasRespostas,
      });

      // Limpa o campo de resposta e realiza a próxima requisição com o novo contexto
      _respostaController.clear();
      generateResume();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulário'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (pergunta.isNotEmpty)
              Text(
                pergunta,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 10),
            if (hintText.isNotEmpty)
              TextField(
                controller: _respostaController,
                decoration: InputDecoration(
                  labelText: 'Sua Resposta',
                  hintText: hintText,
                  border: const OutlineInputBorder(),
                ),
              ),
            const SizedBox(height: 20),
            if (hintText.isNotEmpty)
              ElevatedButton(
                onPressed: proximaPergunta,
                child: const Text("Próximo"),
              ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  jsonEncode({
                    "Contexto":
                        "Abaixo temos as perguntas e respostas até agora. Qual será a próxima pergunta?",
                    "perguntasRespostas": perguntasRespostas,
                  }),
                  style: const TextStyle(fontSize: 16),
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
