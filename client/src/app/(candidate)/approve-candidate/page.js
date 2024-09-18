'use client'
import React, { useContext, useEffect } from 'react'
import VotingContext from '@/app/context/votingContext'

const ApproveCandidate = () => {
  const { getAllCandidates, allCandidates, approveCandidate } = useContext(VotingContext)

  const handleApproveCandidate = async (id) => {
    try {
      console.log('candidate id>>>', id)
      await approveCandidate(id)
      alert('Successfully approved candidate!')

    } catch (err) {
      console.log(err)
    }
  }
  const handleGetCandidates = async () => {
    try {
      await getAllCandidates()
    } catch (err) {
      console.log(err)
    }
  }
  useEffect(() => {
    handleGetCandidates()
  }, [])


  return (
    <div>     {
      allCandidates?.length != 0 && allCandidates?.map((candidate, index) => {
        return (
          <div key={index}>
            <h2>Candidate name: {candidate?.name}</h2>
            <h4>Candidate address: {candidate?.account}</h4>
            <h4>isApproved: {candidate?.isApproved?.toString()}</h4>


            {
              candidate?.isApproved==false && <button onClick={() => handleApproveCandidate(candidate?.candidateId)}>Approve</button>

            }

          </div>
        )
      })
    }</div>
  )
}

export default ApproveCandidate