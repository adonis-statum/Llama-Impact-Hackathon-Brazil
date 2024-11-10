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
  String messageContent = ""; // Variável para enviar o conteúdo inicial
  String pergunta = ""; // Variável para a pergunta extraída antes do "|"
  String hintText = ""; // Variável para o exemplo de resposta

  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  // Função para iniciar a requisição e processar os dados recebidos
  void generateResume() {
    setState(() {
      pergunta = ""; // Limpa a pergunta
      hintText = ""; // Limpa o hintText
      messageContent = _messageController.text; // Define o conteúdo da mensagem
    });

    _apiService.sendChatCompletionRequest(messageContent, (String content) {
      // Processa o conteúdo para atualizar pergunta e JSON do retorno
      final parts = content.split('|');
      if (parts.length > 1) {
        pergunta = parts[0].trim(); // Pega a parte à esquerda do "|"
        String jsonPart = parts[1].trim(); // Pega a parte JSON

        try {
          // Converte a string JSON em um Map para extrair as informações
          final Map<String, dynamic> jsonData = json.decode(jsonPart);
          final proximaPergunta = jsonData['proximaPergunta'] ?? "";
          final exemploResposta = jsonData['exemploResposta'] ?? "";

          setState(() {
            pergunta = proximaPergunta;
            hintText = exemploResposta;
          });
        } catch (e) {
          print("Erro ao processar JSON: $e");
        }
      }
    });
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
          children: [
            TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                labelText: 'Digite o conteúdo da mensagem',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: generateResume,
              child: const Text("Gerar Currículo"),
            ),
            const SizedBox(height: 20),
            Text(
              pergunta,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              hintText,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
