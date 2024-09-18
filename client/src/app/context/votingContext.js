'use client';
import { createContext } from 'react'

const VotingContext = createContext({
    account: null,
    isConnected: false,
    connectWallet: () => { },
    registerCandidate: (name, age) => { },
    registerVoter: (name, bio, age) => { },
    getApproveCandidate: () => { },
    allApproveCandidates: [],
    allCandidates: [],
    approveCandidate: (id) => { },
    voteCandidate: (id) => { },
    getVoterData: (address) => { },
    getCandidateData: (candidateId) => { },
    getAllCandidates:()=>{},
    transferTokenToWinner:()=>{},
})

export default VotingContext