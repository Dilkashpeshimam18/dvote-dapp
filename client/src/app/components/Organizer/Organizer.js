'use client'
import VotingContext from '@/app/context/votingContext'
import React, { useContext } from 'react'

const Organizer = () => {
    const { transferToken } = useContext(VotingContext)

    const handleTransfer = async () => {
        try {
            await transferToken()
        } catch (err) {
            console.log(err)
        }
    }
    return (
        <div>
            <div>
                <h1>Transfer Token To Top Candidate</h1>
                <p>Select the top voted candidate as winner & transfer 10 dvote coin.</p>
                <button onClick={handleTransfer}>Transfer</button>
            </div>
            <div>
                <h1>End Voting Contract</h1>
                <p>This will reset candidate & voting contract.</p>
                <button>End Voting</button>
            </div>

        </div>
    )
}

export default Organizer