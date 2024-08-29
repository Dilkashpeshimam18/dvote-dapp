'use client'
import React,{useContext,useEffect} from 'react'
import VotingContext from '@/app/context/votingContext'

const ApproveCandidate = () => {
  const {getAllCandidates, allCandidates,approveCandidate}=useContext(VotingContext)

  handleApproveCandidate=async(id)=>{
   try{

    await approveCandidate(id)
    alert('Successfully approved candidate!')

   }catch(err){
    console.log(err)
   }
  }

  useEffect(()=>{
   getAllCandidates()
  },[])
  return (
    <div>     {
      allCandidates?.length != 0 && allCandidates?.map((candidate, index) => {
          return (
              <div key={index}>
                  <h2>Candidate name: {candidate.name}</h2>
                  <h4>Candidate bio: {candidate.bio}</h4>
                  <h4>Candidate age: {candidate.age}</h4>
                  <button onClick={() => handleApproveCandidate(candidate.candidateId)}>Approve</button>
              </div>
          )
      })
  }</div>
  )
}

export default ApproveCandidate