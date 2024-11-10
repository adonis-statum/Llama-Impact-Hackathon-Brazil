import 'package:conecta_ai_app/src/service/api_service.dart';
import 'package:flutter/material.dart';

class FormularioScreen extends StatefulWidget {
  const FormularioScreen({super.key});

  @override
  State<FormularioScreen> createState() => _FormularioScreenState();
}

class _FormularioScreenState extends State<FormularioScreen> {
  final ApiService _apiService = ApiService();
  String receivedText = ""; // Variável para exibir o conteúdo recebido

  @override
  void initState() {
    super.initState();
  }

  // Função para iniciar a requisição e processar os dados recebidos
  void generateResume() {
    setState(() {
      receivedText = ""; // Limpa o texto antes de iniciar a nova requisição
    });

    _apiService.sendChatCompletionRequest((String content) {
      setState(() {
        // Atualiza o texto exibido ao receber cada parte do conteúdo
        receivedText += content;
      });
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
            ElevatedButton(
              onPressed: generateResume,
              child: const Text("Gerar Currículo"),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  receivedText, // Exibe o conteúdo recebido
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
