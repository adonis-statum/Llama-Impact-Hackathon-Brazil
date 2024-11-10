'use client';

import { SendIcon } from 'lucide-react';
import { useEffect, useRef, useState } from 'react';
import useAutoResizeTextArea from '../../../lib/utils';
import { Textarea } from '../../../components/ui/textarea';

export default function NovoCurriculoPage() {
  const [fulltext, setFulltext] = useState('');
  // const [isLoading, setIsLoading] = useState(false);
  // const [errorMessage, setErrorMessage] = useState('');
  // const [showEmptyChat, setShowEmptyChat] = useState(true);
  // const [conversation, setConversation] = useState<any[]>([]);
  const [message, setMessage] = useState('');
  const [perguntasRespostasJson, setPerguntasRespostasJson] = useState<
    {
      pergunta: string;
      exemploResposta: string;
      resposta: string;
    }[]
  >([]);
  const textAreaRef = useAutoResizeTextArea();
  const bottomOfChatRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const options = {
      method: 'POST',
      headers: {
        accept: 'application/json',
        'content-type': 'text/event-stream',
        authorization: 'Bearer sk-66cbb2f9-9c14-4ea0-97d9-79c72285efd2',
      },
      body: JSON.stringify({
        agentId: '6104d845-a599-4f6e-aa39-b6936c1ea9fc',
        stream: true,
        format: 'text',
        messages: [
          {
            content: JSON.stringify({
              Contexto: 'Abaixo temos as perguntas e respostas até agora. Qual será a próxima pergunta?',
              perguntasRespostas: [
                {
                  pergunta: 'Como chamaremos essa nova oportunidade? Qual é o título do trabalho?',
                  exemploResposta: 'Garçom',
                  resposta: message,
                },
              ],
            }),
            role: 'user',
          },
        ],
      }),
    };

    const fetchStream = async () => {
      try {
        const response = await fetch('https://api.codegpt.co/api/v1/chat/completions', options);
        const reader = response.body?.getReader();
        const decoder = new TextDecoder();

        if (reader) {
          // Read and update state with each chunk
          let chunk;
          let fimPergunta = false;
          let accumulatedText = '';
          while (!(chunk = await reader.read()).done) {
            const chunkString = decoder.decode(chunk.value);
            if (!fimPergunta) {
              if (chunkString.includes('|')) {
                setFulltext((prev) => prev + chunkString.split('|')[0].trim());
                accumulatedText += chunkString.split('|')[1].trim();
                fimPergunta = true;
              } else {
                setFulltext((prev) => prev + chunkString);
              }
            } else {
              accumulatedText += chunkString;
            }
          }
          const parseAcumulado: { pergunta: string; exemploResposta: string; resposta: string } =
            JSON.parse(accumulatedText);
          const newRespostaAcumuladaJson = {
            pergunta: parseAcumulado.pergunta,
            exemploResposta: parseAcumulado.exemploResposta,
            resposta: parseAcumulado.resposta,
          };

          setPerguntasRespostasJson([...perguntasRespostasJson, newRespostaAcumuladaJson]);
        }
      } catch (error) {
        console.error('Streaming error:', error);
      }
    };

    fetchStream();
  }, []); // Empty dependency array to ensure this only runs on mount

  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  const handleKeypress = (e: any) => {
    // It's triggers by pressing the enter key
    if (e.keyCode == 13 && !e.shiftKey) {
      // sendMessage(e);
      e.preventDefault();
    }
  };

  return (
    <div className='flex max-w-full flex-1 flex-col h-[100vh] dark:bg-gray-800'>
      <div className='relative h-full w-full transition-width flex flex-col overflow-hidden items-stretch flex-1 dark:bg-gray-800'>
        <div className='flex-1 overflow-hidden'>
          <div className=' h-full dark:bg-gray-800'>
            <div className=''>
              {/* {!showEmptyChat && fulltext.length > 0 ? ( */}
              <div className='flex flex-col items-center bg-gray-800 text-white text-xl'>
                {fulltext}
                <div className='w-full h-32 md:h-48 flex-shrink-0'></div>
                <div ref={bottomOfChatRef}></div>
              </div>
              {/* ) : null} */}
              <div className='flex flex-col items-center text-sm dark:bg-gray-800'></div>
            </div>
          </div>
        </div>
        <div className='absolute bottom-0 left-0 w-full border-t md:border-t-0 dark:border-white/20 md:border-transparent md:dark:border-transparent md:bg-vert-light-gradient bg-gray-800 dark:bg-gray-800 pt-2 '>
          <form className='stretch mx-2 flex flex-row gap-3 last:mb-2 md:mx-4 md:last:mb-6 lg:mx-auto lg:max-w-2xl xl:max-w-3xl dark:bg-gray-800'>
            <div className='relative flex flex-col h-full flex-1 items-stretch md:flex-col dark:bg-gray-800'>
              {/* {errorMessage ? (
                <div className='mb-2 md:mb-0'>
                  <div className='h-full flex ml-1 md:w-full md:m-auto md:mb-2 gap-0 md:gap-2 justify-center'>
                    <span className='text-red-500 text-sm'>{errorMessage}</span>
                  </div>
                </div>
              ) : null} */}
              <div className='flex flex-col w-full py-2 flex-grow md:py-3 md:pl-4 relative border border-black/10 bg-white dark:border-gray-900/50 dark:text-white dark:bg-gray-700 rounded-md shadow-[0_0_10px_rgba(0,0,0,0.10)] dark:shadow-[0_0_15px_rgba(0,0,0,0.10)] '>
                <Textarea
                  ref={textAreaRef}
                  value={message}
                  tabIndex={0}
                  data-id='root'
                  style={{
                    height: '24px',
                    maxHeight: '200px',
                    overflowY: 'hidden',
                  }}
                  // rows={1}
                  placeholder='Send a message...'
                  className='m-0 w-full resize-none border-0 bg-transparent p-0 pr-7 focus:ring-0 focus-visible:ring-0 dark:bg-transparent pl-2 md:pl-0'
                  onChange={(e) => setMessage(e.target.value)}
                  onKeyDown={handleKeypress}
                ></Textarea>
                <button
                  // disabled={isLoading || message?.length === 0}
                  // onClick={sendMessage}
                  className='absolute p-1 rounded-md bottom-1.5 md:bottom-2.5 bg-transparent disabled:bg-gray-500 right-1 md:right-2 disabled:opacity-40 dark:bg-gray-800 dark:text-gray-800'
                >
                  <SendIcon className='h-4 w-4 mr-1 text-gray-800 ' />
                </button>
              </div>
            </div>
          </form>
        </div>
      </div>
    </div>
  );
}
