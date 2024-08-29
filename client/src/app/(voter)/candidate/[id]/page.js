import React, { useContext } from 'react'
import { useParams } from "next/navigation";
import VotingContext from '@/app/context/votingContext';

const CandidateData = () => {
    const params = useParams();
    const { id } = params;
    const { getCandidateData } = useContext(VotingContext)


    useEffect(() => {
        getCandidateData()
    }, [])
    return (
        <div>page</div>
    )
}

export default CandidateData