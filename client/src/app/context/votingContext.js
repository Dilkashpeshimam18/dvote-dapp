'use client';
import { createContext } from 'react'

const VotingContext = createContext({
    account: null,
    isConnected: false,
    connectWallet:()=>{},
    registerCandidate:(name,age)=>{},
    registerVoter:(name,bio,age)=>{},
    getApproveCandidate:()=>{},
    allCandidates:[],
    approveCandidate:(id)=>{},
    voteCandidate:(id)=>{},
    getVoterData:(voterId)=>{},
    getCandidateData  :(candidateId)=>{}
})

export default VotingContext