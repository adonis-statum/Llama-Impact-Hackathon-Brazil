const CODEGPT_API_URL = process.env.CODEGPT_API_URL;
const CODEGPT_API_KEY = process.env.CODEGPT_API_KEY;
const CODEGPT_ORG_KEY = process.env.CODEGPT_ORG_KEY;

export async function POST(request: Request) {
    try {
      // Obtendo os dados do corpo da requisição
      const body = await request.json();
          
      // Fazendo a requisição para a API externa
      const response = await fetch(`${CODEGPT_API_URL}chat/completions`, {
        method: 'POST',
        headers: {
            accept: 'application/json',
            'CodeGPT-Org-Id': `${CODEGPT_ORG_KEY}`,
            'content-type': 'application/json',
            Authorization: `Bearer ${CODEGPT_API_KEY}`,
        },
        body: JSON.stringify(body),
      });
      // Verificando o status code da resposta
      if (response.ok) {
        // Se status code 200, retorna o JSON de sucesso
        const data = await response.json();
        return new Response(JSON.stringify(data), { status: 200 });
      } else if (response.status === 400) {
        // Se status code 400, retorna o JSON de erro com detalhes de validação
        const error = await response.json();
        return new Response(
          JSON.stringify({
            detail: error.detail || 'Invalid request',
          }),
          { status: 400 }
        );
      } else if (response.status === 422) {
        // Se status code 422, retorna o JSON de erro específico de validação
        const error = await response.json();
        return new Response(
          JSON.stringify({
            detail: error.detail || 'Unprocessable Entity',
          }),
          { status: 422 }
        );
      } else {
        // Para outros status code, retorna o erro genérico
        const error = await response.json();
        return new Response(
          JSON.stringify({ detail: `An error occurred - ${error}` }),
          { status: response.status }
        );
      }
    } catch (error) {
      // Tratamento de erros gerais
      return new Response(
        JSON.stringify({ detail: `Internal Server Error-  ${error}` }),
        { status: 500 }
      );
    }
  }
  