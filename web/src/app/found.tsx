export default function NotFound() {
  return (
    <div className="flex min-h-screen flex-col items-center justify-center bg-black text-white">
      <h1 className="text-4xl font-bold">404</h1>
      <p className="mt-2 text-white/60">Página não encontrada.</p>
      <a
        href="/"
        className="mt-6 rounded-xl bg-white px-5 py-2 text-sm font-semibold text-black"
      >
        Voltar para Home
      </a>
    </div>
  );
}
