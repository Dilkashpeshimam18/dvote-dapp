'use client'
import React, { useContext, useEffect } from 'react'
import VotingContext from '@/app/context/votingContext'

const AllApproveCandidate = () => {
    const { getApproveCandidates, allApproveCandidates, voteCandidate } = useContext(VotingContext)

    const handleVoteCandidate = async (id) => {
        try {

            await voteCandidate(id)
            alert('Successfully voted to candidate!')

        } catch (err) {
            console.log(err)
        }
    }

    useEffect(() => {
        getApproveCandidates()
    }, [])

    return (
        <div>
            {
                allApproveCandidates?.length != 0 && allApproveCandidates?.map((candidate, index) => {
                    return (
                        <div key={index}>
                            <h2>Candidate name: {candidate.name}</h2>
                            <h4>Candidate bio: {candidate.bio}</h4>
                            <h4>Candidate age: {candidate.age}</h4>
                            <button onClick={() => handleVoteCandidate(candidate.candidateId)}>Vote</button>
                        </div>
                    )
                })
            }</div>
    )
}

export default AllApproveCandidate