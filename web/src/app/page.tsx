export default function Page() {
  return (
    <div className="min-h-screen bg-[#050505] text-white">
      <style>{`
        :root { color-scheme: dark; }
        .bgGlow {
          background:
            radial-gradient(1200px 600px at 20% 10%, rgba(0,82,255,.18), transparent 60%),
            radial-gradient(900px 500px at 85% 20%, rgba(20,241,149,.10), transparent 60%),
            radial-gradient(700px 400px at 70% 85%, rgba(255,255,255,.06), transparent 55%),
            #050505;
        }
      `}</style>

      {/* Topbar */}
      <div className="sticky top-0 z-50 border-b border-white/10 bg-black/60 backdrop-blur">
        <div className="mx-auto flex max-w-[1100px] items-center justify-between gap-4 px-5 py-3">
          <a href="#top" className="flex items-center gap-2 font-semibold tracking-tight">
            <span className="h-[10px] w-[10px] rounded-full bg-gradient-to-br from-[#0052FF] to-[#14F195] shadow-[0_0_22px_rgba(0,82,255,.35)]" />
            <span>
              Gacha <span className="text-white/55">on Base</span>
            </span>
          </a>

          <div className="flex items-center gap-2">
            <a href="#features" className="rounded-xl px-3 py-2 text-sm text-white/65 hover:bg-white/5 hover:text-white/90">
              Features
            </a>
            <a href="#dapp" className="rounded-xl px-3 py-2 text-sm text-white/65 hover:bg-white/5 hover:text-white/90">
              DApp
            </a>
            <a href="#architecture" className="rounded-xl px-3 py-2 text-sm text-white/65 hover:bg-white/5 hover:text-white/90">
              Arquitetura
            </a>

            <button
              onClick={() => window.open("https://github.com/SEU_USUARIO/SEU_REPO", "_blank")}
              className="rounded-xl border border-white/10 bg-white/5 px-4 py-2 text-sm text-white/90 hover:bg-white/10"
              type="button"
            >
              Repo
            </button>

            <a
              href="#dapp"
              className="rounded-xl bg-white px-4 py-2 text-sm font-semibold text-black hover:opacity-90"
            >
              Abrir App
            </a>
          </div>
        </div>
      </div>

      {/* Hero */}
      <main id="top" className="bgGlow">
        <div className="mx-auto max-w-[1100px] px-5 pb-14 pt-7">
          <div className="relative overflow-hidden rounded-[24px] border border-white/10 bg-gradient-to-b from-white/5 to-white/3 shadow-[0_16px_50px_rgba(0,0,0,.55)]">
            <div className="pointer-events-none absolute inset-0 opacity-55 [background:radial-gradient(900px_400px_at_20%_10%,rgba(0,82,255,.26),transparent_60%),radial-gradient(700px_360px_at_90%_20%,rgba(20,241,149,.14),transparent_60%)]" />

            <div className="relative grid gap-6 p-7 md:grid-cols-[1.2fr_.8fr] md:p-9">
              <div>
                <div className="flex flex-wrap gap-2">
                  <span className="rounded-full border border-white/10 bg-white/5 px-3 py-2 font-mono text-xs text-white/75">
                    Network: Base Mainnet
                  </span>
                  <span className="rounded-full border border-white/10 bg-white/5 px-3 py-2 font-mono text-xs text-white/75">
                    Solidity: 0.8.28
                  </span>
                  <span className="rounded-full border border-white/10 bg-white/5 px-3 py-2 font-mono text-xs text-white/75">
                    License: MIT
                  </span>
                </div>

                <h1 className="mt-4 text-4xl font-bold tracking-tight md:text-5xl">
                  On-chain gacha com <span className="text-white/80">raridade</span>,{" "}
                  <span className="text-white/80">reward pool</span> e <span className="text-white/80">SBT</span>.
                </h1>

                <p className="mt-4 max-w-2xl text-base leading-relaxed text-white/65">
                  Um scaffold pronto pra virar uma DApp real na Base. Pensado pra segurança, modularidade e evolução:
                  MainSecure → ItemNFT → RewardPool → SBT.
                </p>

                <div className="mt-5 flex flex-wrap items-center gap-3">
                  <a
                    href="#dapp"
                    className="rounded-xl bg-white px-5 py-2 text-sm font-semibold text-black hover:opacity-90"
                  >
                    Ver DApp
                  </a>
                  <a
                    href="#architecture"
                    className="rounded-xl border border-white/10 bg-white/5 px-5 py-2 text-sm text-white/90 hover:bg-white/10"
                  >
                    Ver arquitetura
                  </a>
                  <span className="inline-flex items-center gap-2 text-xs text-white/75">
                    <span className="h-2.5 w-2.5 rounded-full bg-[#14F195] shadow-[0_0_18px_rgba(20,241,149,.45)]" />
                    UI pronta pra integrar Web3
                  </span>
                </div>

                <div id="features" className="mt-6 grid gap-3 md:grid-cols-3">
                  <Feature title="🎲 RNG verificável" desc="Tipos premium podem usar randomness externa (ex.: Entropy)." />
                  <Feature title="💰 Reward-backed" desc="Venda itens (burn) e receba recompensa por raridade no pool." />
                  <Feature title="🏅 SBT de conquista" desc="Badge soulbound para usuários que atingirem milestones." />
                </div>
              </div>

              <aside className="rounded-[18px] border border-white/10 bg-black/20 p-4">
                <h3 className="mb-2 text-sm font-semibold text-white/90">Resumo rápido</h3>

                <KV k="Produto" v="Gacha System" />
                <KV k="Padrão" v="Modular contracts" />
                <KV k="Deploy target" v="Base (8453)" />
                <KV k="UI status" v="Ready to wire" />

                <div className="my-3 h-px bg-white/10" />

                <p className="text-xs leading-relaxed text-white/55">
                  Quando integrar Web3, você só troca os botões “placeholder” por chamadas reais (wagmi/viem) e coloca o
                  endereço do Main.
                </p>

                <div className="mt-4 flex flex-wrap gap-2">
                  <button
                    type="button"
                    className="rounded-xl border border-white/10 bg-white/5 px-4 py-2 text-sm text-white/90 hover:bg-white/10"
                    onClick={async () => {
                      const text =
                        "Gacha on Base: on-chain gacha com NFTs de raridade, reward pool e badge SBT. Modular, pensado pra segurança e pronto pra evoluir.";
                      try {
                        await navigator.clipboard.writeText(text);
                        alert("Pitch copiado ✅");
                      } catch {
                        alert(text);
                      }
                    }}
                  >
                    Copiar pitch
                  </button>

                  <a
                    href="#dapp"
                    className="rounded-xl border border-white/10 bg-white/5 px-4 py-2 text-sm text-white/90 hover:bg-white/10"
                  >
                    Ir para DApp
                  </a>
                </div>
              </aside>
            </div>
          </div>

          {/* DApp Section (UI only) */}
          <section id="dapp" className="mt-10">
            <div className="flex flex-wrap items-end justify-between gap-3">
              <div>
                <h2 className="text-lg font-semibold tracking-tight">🧩 DApp</h2>
                <p className="mt-1 text-sm text-white/55">
                  Layout pronto — aqui você pluga as chamadas do contrato depois.
                </p>
              </div>
              <span className="rounded-full border border-white/10 bg-white/5 px-3 py-2 font-mono text-xs text-white/75">
                Wallet: not connected
              </span>
            </div>

            <div className="mt-3 grid gap-3 md:grid-cols-2">
              <Panel title="Rodar Gacha" desc="Escolha um tipo e execute drawItem (placeholder).">
                <div className="mt-3 grid gap-3 md:grid-cols-2">
                  <div>
                    <label className="text-xs text-white/55">Tipo</label>
                    <select className="mt-2 w-full rounded-xl border border-white/10 bg-black/25 px-3 py-2 text-sm text-white outline-none">
                      <option value="0">NOOB (0)</option>
                      <option value="1">APE (1)</option>
                      <option value="2">HODLER (2)</option>
                      <option value="3">OG (3)</option>
                      <option value="4">WHALE (4) - Entropy</option>
                      <option value="5">DEGEN (5) - Entropy</option>
                    </select>
                  </div>
                  <div>
                    <label className="text-xs text-white/55">Deadline (min)</label>
                    <input
                      defaultValue={20}
                      type="number"
                      min={1}
                      className="mt-2 w-full rounded-xl border border-white/10 bg-black/25 px-3 py-2 text-sm text-white outline-none"
                    />
                  </div>
                </div>

                <div className="mt-3 grid gap-3 md:grid-cols-2">
                  <div>
                    <label className="text-xs text-white/55">Entropy fee (ETH) (opcional)</label>
                    <input
                      placeholder="ex: 0.0001"
                      className="mt-2 w-full rounded-xl border border-white/10 bg-black/25 px-3 py-2 text-sm text-white outline-none placeholder:text-white/35"
                    />
                  </div>
                  <div>
                    <label className="text-xs text-white/55">PermitSig</label>
                    <input
                      disabled
                      placeholder="0x (vazio por enquanto)"
                      className="mt-2 w-full rounded-xl border border-white/10 bg-black/25 px-3 py-2 text-sm text-white/60 outline-none placeholder:text-white/35"
                    />
                  </div>
                </div>

                <div className="mt-4 flex flex-wrap gap-2">
                  <button
                    className="rounded-xl bg-white px-4 py-2 text-sm font-semibold text-black opacity-70"
                    type="button"
                    onClick={() => alert("Draw (placeholder)")}
                  >
                    Draw (placeholder)
                  </button>
                  <button
                    className="rounded-xl border border-white/10 bg-white/5 px-4 py-2 text-sm text-white/90 hover:bg-white/10"
                    type="button"
                    onClick={() => alert("Connect wallet (placeholder)")}
                  >
                    Connect wallet (placeholder)
                  </button>
                </div>

                <p className="mt-3 text-xs text-white/45">
                  * Depois você troca os botões por chamadas reais (wagmi/viem).
                </p>
              </Panel>

              <Panel title="Mintar SBT" desc="Mintar o badge mintSBT (placeholder) se elegível.">
                <div className="mt-3 grid gap-3 md:grid-cols-2">
                  <div>
                    <label className="text-xs text-white/55">Status SBT</label>
                    <input
                      disabled
                      value="Minting: open (placeholder)"
                      className="mt-2 w-full rounded-xl border border-white/10 bg-black/25 px-3 py-2 text-sm text-white/60 outline-none"
                    />
                  </div>
                  <div>
                    <label className="text-xs text-white/55">Requisito</label>
                    <input
                      disabled
                      value="Unique history (placeholder)"
                      className="mt-2 w-full rounded-xl border border-white/10 bg-black/25 px-3 py-2 text-sm text-white/60 outline-none"
                    />
                  </div>
                </div>

                <div className="mt-4 flex flex-wrap items-center gap-3">
                  <button
                    className="rounded-xl bg-white px-4 py-2 text-sm font-semibold text-black opacity-70"
                    type="button"
                    onClick={() => alert("Mint SBT (placeholder)")}
                  >
                    Mint SBT (placeholder)
                  </button>
                  <span className="text-xs text-white/55">aguardando integração</span>
                </div>

                <p className="mt-3 text-xs text-white/45">
                  * Depois você lê sbtMintingOpened() no contrato Main.
                </p>
              </Panel>

              <div className="md:col-span-2">
                <Panel title="Vender Itens" desc="Enviar IDs para sellItemBatch (placeholder). Limite 50.">
                  <div className="mt-3 grid gap-3 md:grid-cols-2">
                    <div>
                      <label className="text-xs text-white/55">IDs (separados por vírgula)</label>
                      <input
                        placeholder="ex: 1,2,3"
                        className="mt-2 w-full rounded-xl border border-white/10 bg-black/25 px-3 py-2 text-sm text-white outline-none placeholder:text-white/35"
                      />
                    </div>
                    <div>
                      <label className="text-xs text-white/55">Resumo</label>
                      <input
                        disabled
                        value="0 ids (placeholder)"
                        className="mt-2 w-full rounded-xl border border-white/10 bg-black/25 px-3 py-2 text-sm text-white/60 outline-none"
                      />
                    </div>
                  </div>

                  <div className="mt-4 flex flex-wrap items-center gap-3">
                    <button
                      className="rounded-xl bg-white px-4 py-2 text-sm font-semibold text-black opacity-70"
                      type="button"
                      onClick={() => alert("Sell (placeholder)")}
                    >
                      Sell (placeholder)
                    </button>
                    <span className="text-xs text-white/55">IDs vazios serão ignorados.</span>
                  </div>

                  <p className="mt-3 text-xs text-white/45">
                    * Depois você mostra inventário lendo eventos do ItemNFT ou indexando.
                  </p>
                </Panel>
              </div>
            </div>
          </section>

          {/* Architecture */}
          <section id="architecture" className="mt-10">
            <div className="flex flex-wrap items-end justify-between gap-3">
              <div>
                <h2 className="text-lg font-semibold tracking-tight">🏗 Arquitetura</h2>
                <p className="mt-1 text-sm text-white/55">Modelo modular, fácil de auditar e evoluir.</p>
              </div>
              <span className="rounded-full border border-white/10 bg-white/5 px-3 py-2 font-mono text-xs text-white/75">
                MainSecure → ItemNFT → RewardPool → SBT
              </span>
            </div>

            <div className="mt-3 grid gap-3 md:grid-cols-3">
              <Feature title="MainSecure" desc="Orquestra gacha, callback RNG, sell em batch e mint do SBT." />
              <Feature title="ItemNFT" desc="Mint/burn, raridade, score e histórico de Unique." />
              <Feature title="RewardPool" desc="Liquidez em ERC20 com depósitos e saques controlados." />
            </div>

            <p className="mt-3 text-xs text-white/45">
              Próximo upgrade: integrar carteira, ler estado on-chain, mostrar inventário e histórico.
            </p>
          </section>

          <footer className="mt-10 flex flex-wrap items-center justify-between gap-3 border-t border-white/10 pt-5 text-xs text-white/45">
            <div>© {new Date().getFullYear()} Gacha on Base • UI scaffold</div>
            <div className="font-mono">Pronto pra subir no GitHub</div>
          </footer>
        </div>
      </main>
    </div>
  );
}

function Feature({ title, desc }: { title: string; desc: string }) {
  return (
    <div className="rounded-[18px] border border-white/10 bg-black/20 p-4">
      <h3 className="text-sm font-semibold">{title}</h3>
      <p className="mt-2 text-sm leading-relaxed text-white/55">{desc}</p>
    </div>
  );
}

function Panel({
  title,
  desc,
  children,
}: {
  title: string;
  desc: string;
  children: React.ReactNode;
}) {
  return (
    <div className="rounded-[18px] border border-white/10 bg-white/5 p-4">
      <h3 className="text-sm font-semibold">{title}</h3>
      <p className="mt-2 text-sm leading-relaxed text-white/55">{desc}</p>
      {children}
    </div>
  );
}

function KV({ k, v }: { k: string; v: string }) {
  return (
    <div className="flex items-center justify-between gap-3 border-b border-white/10 py-2 last:border-b-0">
      <span className="text-xs text-white/45">{k}</span>
      <span className="font-mono text-xs text-white/85">{v}</span>
    </div>
  );
}
