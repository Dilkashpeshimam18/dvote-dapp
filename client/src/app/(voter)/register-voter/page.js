'use client'
import React from 'react'
import VotingContext from '@/app/context/votingContext'

const RegisterVoter = () => {
  const [name, setName] = useState('')
  const [bio, setBio] = useState('')

  const [age, setAge] = useState(0)
  const { registerVoter } = useContext(VotingContext)

  const handleRegisterVoter = async (e) => {
    e.preventDefault();
    try {
      await registerVoter(name, bio, age)
      alert('Successfully registered voter!')
      setName('')
      setBio('')
      setAge(0)
    } catch (err) {
      console.log(err)
    }
  }
  return (
    <div>
      <h1> Register Voter for DVote</h1>
      <form onSubmit={handleRegisterVoter}>
        <div>
          <h2>Name:</h2> <input type='text' onChange={(e) => setName(e.target.value)} value={name} placeholder='Enter name' />
        </div>
        <div>
          <h2>Bio:</h2> <input type='text' onChange={(e) => setBio(e.target.value)} value={bio} placeholder='Enter bio' />
        </div>
        <div>
          <h2>Age:</h2> <input type='number' onChange={(e) => setAge(e.target.value)} value={age} />
        </div>

        <button>Register</button>

      </form>
    </div>
  )
}

export default RegisterVoter