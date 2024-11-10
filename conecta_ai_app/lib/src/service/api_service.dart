import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();

  ApiService() {
    _dio.options.headers = {
      'accept': 'application/json',
      'content-type': 'application/json',
      'authorization': 'Bearer sk-0ff2b30e-31b6-4750-998c-ba353bfeaddf',
    };
  }

  // Método para fazer a requisição POST com streaming
  Future<void> sendChatCompletionRequest(
      String messageContent, Function(String) onDataReceived) async {
    String url = 'https://api.codegpt.co/api/v1/chat/completions';

    // Corpo da requisição
    Map<String, dynamic> body = {
      "agentId": "9edb0d47-3554-4bbf-b10d-b61ac17dd84b",
      "messages": [
        {"content": messageContent, "role": "user"}
      ],
      "format": "json",
      "stream": true
    };

    final StringBuffer completeContent = StringBuffer();

    try {
      final response = await _dio.post(
        url,
        data: jsonEncode(body),
        options: Options(responseType: ResponseType.stream),
      );

      // Processa o stream de dados e acumula o conteúdo em completeContent
      response.data.stream.listen((chunk) {
        String data = utf8.decode(chunk);

        // Divide o stream em linhas separadas por "data: "
        data.split("data: ").forEach((element) {
          if (element.isNotEmpty) {
            try {
              final jsonData = json.decode(element);
              final content = jsonData['choices']?[0]['delta']?['content'];

              if (content != null) {
                completeContent.write(content);
              }
            } catch (e) {
              log("Erro ao processar o fragmento JSON: $e");
            }
          }
        });
      }, onDone: () {
        // Chama o callback apenas quando o stream é concluído
        onDataReceived(completeContent.toString());
      });
    } catch (e) {
      log('Erro na requisição: $e');
    }
  }
}
