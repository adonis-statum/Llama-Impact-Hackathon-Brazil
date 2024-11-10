import 'dart:convert';
import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();

  ApiService() {
    // Configura o Dio com os headers padrão
    _dio.options.headers = {
      'accept': 'application/json',
      'content-type': 'application/json',
      'authorization': 'Bearer sk-66cbb2f9-9c14-4ea0-97d9-79c72285efd2',
    };
  }

  // Método para fazer a requisição POST com streaming
  Future<void> sendChatCompletionRequest(
      Function(String) onDataReceived) async {
    String url = 'https://api.codegpt.co/api/v1/chat/completions';

    // Corpo da requisição
    Map<String, dynamic> body = {
      "agentId": "6104d845-a599-4f6e-aa39-b6936c1ea9fc",
      "messages": [
        {
          "content":
              "{\"Contexto\": \"Abaixo temos as perguntas e respostas até agora. Qual será a próxima pergunta?\",\"perguntasRespostas\": []}",
          "role": "user"
        }
      ],
      "format": "json",
      "stream": true
    };

    try {
      final response = await _dio.post(
        url,
        data: jsonEncode(body),
        options: Options(responseType: ResponseType.stream),
      );

      // Processa o stream de dados
      response.data.stream.listen((chunk) {
        // Converte o chunk de bytes para string
        String data = utf8.decode(chunk);

        // Divide o stream em linhas separadas por "data: "
        data.split("data: ").forEach((element) {
          if (element.isNotEmpty) {
            try {
              // Converte cada linha em JSON e extrai o conteúdo
              final jsonData = json.decode(element);
              final content = jsonData['choices']?[0]['delta']?['content'];
              if (content != null) {
                // Chama o callback para processar cada conteúdo recebido
                onDataReceived(content);
              }
            } catch (e) {
              print("Erro ao processar o chunk: $e");
            }
          }
        });
      });
    } catch (e) {
      print('Erro na requisição: $e');
    }
  }
}
