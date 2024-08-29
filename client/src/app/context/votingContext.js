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
    getVoterData: (voterId) => { },
    getCandidateData: (candidateId) => { },
    getAllCandidates:()=>{}
})

export default VotingContext