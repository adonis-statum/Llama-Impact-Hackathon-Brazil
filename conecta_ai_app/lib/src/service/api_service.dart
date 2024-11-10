import 'dart:convert';
import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();

  ApiService() {
    // Configura o Dio com os headers padrão
    _dio.options.headers = {
      'accept': 'application/json',
      'content-type': 'application/json',
      'authorization': 'Bearer sk-1c2d5bbd-40c6-4119-a05c-aa718e92cf3a',
    };
  }

  // Método para fazer a requisição POST com streaming
  Future<void> sendChatCompletionRequest(
      String messageContent, Function(String) onDataReceived) async {
    String url = 'https://api.codegpt.co/api/v1/chat/completions';

    // Corpo da requisição
    Map<String, dynamic> body = {
      "agentId": "cea6f69b-1a54-4ddf-b8e6-e88031e98adf",
      "messages": [
        {"content": messageContent, "role": "user"}
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
