import React,{useEffect,useContext} from 'react'
import { useParams } from "next/navigation";
import VotingContext from '@/app/context/votingContext';

const VoterData = () => {
    const params = useParams();
    const { id } = params;
    const {getVoterData}=useContext(VotingContext)


    useEffect(()=>{
        getVoterData()
    },[])
  return (
    <div>VoterData</div>
  )
}

export default VoterData