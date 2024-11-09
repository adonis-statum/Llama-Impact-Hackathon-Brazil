import Head from 'next/head';
import Link from 'next/link';

export default function Home() {
  return (
    <div>
      <Head>
        <title>Portal de Emprego</title>
      </Head>
      <h1>Bem-vindo ao Portal de Emprego!</h1>
      <p>Aqui você pode criar seu currículo.</p>
      <Link href="/novo-curriculo" legacyBehavior>
        <a>Criar Currículo</a>
      </Link>
      <p>Aqui você pode postar uma nova vaga.</p>
      <Link href="/vagas" legacyBehavior>
        <a>Postar Vaga</a>
      </Link>
    </div>
  );
}
