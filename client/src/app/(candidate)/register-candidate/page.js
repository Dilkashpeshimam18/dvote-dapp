'use client';
import React, { useContext, useState } from 'react'
import VotingContext from '@/app/context/votingContext'

const RegisterCandidate = () => {
  const [name, setName] = useState('')
  const [age, setAge] = useState(0)
  const { registerCandidate } = useContext(VotingContext)

  const handleRegisterCandidate = async (e) => {
    e.preventDefault();
    try {
      await registerCandidate(name, age)
      alert('Successfully registered candidate!')
      setName('')
      setAge(0)
    } catch (err) {
      console.log(err)
    }
  }

  return (
    <div>
      <h1> Register Candidate for DVote</h1>
      <form onSubmit={handleRegisterCandidate}>
        <div>
          <h2>Name:</h2> <input type='text' onChange={(e) => setName(e.target.value)} value={name} placeholder='Enter name' />
        </div>
        <div>
          <h2>Age:</h2> <input type='number' onChange={(e) => setAge(e.target.value)} value={age} />
        </div>

        <button>Register</button>

      </form>
    </div>
  )
}

export default RegisterCandidate