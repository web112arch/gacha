export const metadata = {
  title: "Gacha on Base",
  description: "On-chain gacha system built for Base",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="pt-br">
      <body style={{ margin: 0, background: "#050505", color: "white" }}>
        {children}
      </body>
    </html>
  );
}
