'use client'
import Button from '@mui/material/Button';
import {useContext } from 'react'
import VotingContext from './context/votingContext';

export default function Home() {

  const {account,isConnected,connectWallet}=useContext(VotingContext)

  return (
    <main className="flex min-h-screen flex-col items-center p-24">
      <h1>Voting Dapp</h1>
      {
        isConnected ? <h2>Connected : {account}</h2> :
          <Button onClick={connectWallet} variant="contained">Connect Wallet</Button>
      }
    </main>
  );
}
