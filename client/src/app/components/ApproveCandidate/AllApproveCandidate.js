'use client'
import React, { useContext, useEffect } from 'react'
import VotingContext from '@/app/context/votingContext'

const AllApproveCandidate = ({ account }) => {
    const { getApproveCandidates, allApproveCandidates, voteCandidate } = useContext(VotingContext)

    const handleVoteCandidate = async (id) => {
        console.log('candidate id>>', id)
        try {

            await voteCandidate(id)
            alert('Successfully voted to candidate!')

        } catch (err) {
            console.log(err)
        }
    }

    useEffect(() => {
        getApproveCandidates()
    }, [account])

    return (
        <div>
            {
                allApproveCandidates?.length != 0 && allApproveCandidates?.map((candidate, index) => {
                    return (
                        <div key={index}>
                            <h2>Candidate name: {candidate?.name}</h2>
                            <h4>Candidate address: {candidate?.account}</h4>
                            <h4>Votes: {candidate?.votes?.toString()}</h4>
                            <button onClick={() => handleVoteCandidate(candidate?.candidateId)}>Vote Candidate</button>
                        </div>
                    )
                })
            }</div>
    )
}

export default AllApproveCandidate