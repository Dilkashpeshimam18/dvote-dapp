import { Inter } from "next/font/google";
import "./globals.css";
import VotingProvider from "./context/votingProvider";

const inter = Inter({ subsets: ["latin"] });

export const metadata = {
  title: "Voting Dapp",
  description: "Voting Dapp",
};

export default function RootLayout({ children }) {
  return (
    <html lang="en">
      <VotingProvider>
        <body className={inter.className}>{children}</body>
      </VotingProvider>
    </html>
  );
}
