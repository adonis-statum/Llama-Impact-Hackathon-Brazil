'use client';

import { useState } from 'react';

interface CodeGPTRequestData {
  agentId: string;
  stream: boolean;
  format: string;
  messages: {
    content: string;
    role: string;
  }[];
}

const CodeGPTPage = () => {
  const [question, setQuestion] = useState<string>('');
  const [response, setResponse] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState<boolean>(false);

  // Função para fazer a requisição à API
  const fetchCodeGPTResponse = async () => {
    if (!question) return;

    setLoading(true);
    setError(null);
    setResponse(null);

    const requestData: CodeGPTRequestData = {
      agentId: 'b3c75888-f64a-4615-80ab-361fd0fb0e34',
      stream: false,
      format: 'text',
      messages: [{ content: question, role: "user" }],
    };

    try {
      const res = await fetch('/api/codegpt-completions', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(requestData),
      });

      if (!res.ok) {
        const errorData = await res.json();
        console.log('Erro na resposta da API:', errorData);  // Log detalhado do erro
        setError(errorData.error || 'Erro desconhecido');
      } else {
        // Se o corpo da resposta não estiver vazio, tente obter o JSON
        const responseData = await res.text();
        if (responseData) {
          setResponse(responseData);
        } else {
          setError('Resposta vazia da API');
        }
      }
    } catch (err) {
      console.log('Erro no frontend:', err);
      setError('Ocorreu um erro ao consultar a API: ' + err);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div style={{ padding: '20px' }}>
      <h1>Consultar API do CodeGPT</h1>
      <div>
        <input
          type="text"
          placeholder="Digite sua pergunta"
          value={question}
          onChange={(e) => setQuestion(e.target.value)}
          style={{ padding: '10px', width: '300px', marginBottom: '10px' }}
        />
        <button
          onClick={fetchCodeGPTResponse}
          disabled={loading || !question}
          style={{ padding: '10px', cursor: loading || !question ? 'not-allowed' : 'pointer' }}
        >
          {loading ? 'Carregando...' : 'Enviar'}
        </button>
      </div>

      {error && (
        <div style={{ marginTop: '20px', color: 'red' }}>
          <strong>Erro:</strong> {error}
        </div>
      )}

      {response && (
        <div style={{ marginTop: '20px' }}>
          <h3>Resposta da API:</h3>
          <p>{response}</p>
        </div>
      )}
    </div>
  );
};

export default CodeGPTPage;
