'use client';

import { useState, useEffect } from 'react';
import VotingContext from './votingContext';
import { Web3 } from 'web3';
import votingAbi from '../abis/voting.json'
import candidateAbi from '../abis/candidate.json'
import dvCoinAbi from '../abis/dvcoin.json'

const VotingProvider = (props) => {
    const [account, setAccount] = useState(null)
    const [isConnected, setIsConnected] = useState(false)
    const [allApproveCandidates, setAllApproveCandidates] = useState([])
    const [allCandidates, setAllCandidates] = useState([])


    const votingAddress = '0x6735Bf4aB06EF02f9DCE003656dc0Df623a10811'
    const candidateAddress = '0xF1d0dE2a4DF76e5F585d54427c9549a7dC42302e'
    const dvCoinAddress = '0xd8a7d96e40649462ff8A7BE372E615625D8719a3'

    const web3 = new Web3(window.ethereum)
    const voting = new web3.eth.Contract(votingAbi, votingAddress)
    const candidate = new web3.eth.Contract(candidateAbi, candidateAddress)
    const dvcoin = new web3.eth.Contract(dvCoinAbi, dvCoinAddress)

    const connectWallet = async () => {
        try {
            if (window.ethereum) {
                const accounts = await window.ethereum.request({
                    method: 'eth_requestAccounts'
                }).catch((err) => {
                    if (err.code == 4001) {
                        console.log('Please connect to Metamask')
                    } else {
                        console.log(err)
                    }
                })
                setAccount(accounts[0])
                console.log('Connect to metammask account:', accounts[0])
                setIsConnected(true)


            } else {
                console.log('No web3 provider detected')
                setIsConnected(false)

            }
        } catch (err) {
            console.log(err)
            setIsConnected(false)
        }

    }


    const registerVoter = async (name, bio, age) => {
        try {
            if (name != '' && bio != '' && age >= 18) {
                const accounts = await web3.eth.getAccounts();

                if (accounts.length === 0) {
                    console.log('No accounts found');
                    return;
                }

                const newVoter = await voting.methods.registerVoter(name, bio, age).send({
                    from: accounts[0],
                })
                console.log('Transaction result:', newVoter);

            } else {
                console.log('Data is not valid')
            }

        } catch (err) {
            console.log(err)
        }
    }

    const registerCandidate = async (name, age) => {

        try {

            if (name !== '' && age >= 18) {
                // Convert 0.01 Ether to Wei
                const valueInWei = web3.utils.toWei('0.001', 'ether');

                // Get the list of accounts from MetaMask
                const accounts = await web3.eth.getAccounts();

                if (accounts.length === 0) {
                    console.log('No accounts found');
                    return;
                }

                const newCandidate = await candidate.methods.createCandidate(name, age,votingAddress).send({
                    from: accounts[0],
                    value: valueInWei
                });

                console.log('Transaction result:', newCandidate);

            } else {
                console.log('Data is not valid');
            }
        } catch (err) {
            console.log('Error:', err);
        }
    };

    const getApproveCandidates = async () => {
        try {

            const allCandidates = await candidate.methods.getApprovedCandidates().call()
            console.log(allCandidates)
            setAllApproveCandidates(allCandidates)
        } catch (err) {
            console.log(err)
        }
    }
    const getAllCandidates = async () => {
        try {

            const allCandidates = await candidate.methods.getCandidates().call()
            console.log(allCandidates)
            setAllCandidates(allCandidates)
        } catch (err) {
            console.log(err)
        }
    }

    const approveCandidate = async (id) => {
        try {
            const accounts = await web3.eth.getAccounts();

            if (accounts.length === 0) {
                console.log('No accounts found');
                return;
            }

            const approve = await voting.methods.approveCandidate(id).send({
                from: accounts[0]
            })
            console.log(approve)
        } catch (err) {
            console.log(err)
        }
    }

    const voteCandidate = async (id) => {
        try {
            const accounts = await web3.eth.getAccounts();

            if (accounts.length === 0) {
                console.log('No accounts found');
                return;
            }

            const voted = await voting.methods.voteCandidate(id).send({
                from: accounts[0]
            })
            console.log(voted)
        } catch (err) {
            console.log(err)
        }
    }
    const getVoterData = async (address) => {
        try {

            const voterData = await voting.methods.getVoterData(address).call()
            console.log(voterData)
        } catch (err) {
            console.log(err)
        }
    }

    const getCandidateData = async (id) => {
        try {

            const candidateData = await candidate.methods.getCandidateData(id).call()
            console.log(candidateData)
        } catch (err) {
            console.log(err)
        }
    }

    const transferTokenToWinner = async () => {
        try {

            const accounts = await web3.eth.getAccounts();
            const organizer = accounts[0];

            await voting.methods.transferTokenToTopCandidate().send({ from: organizer });
            console.log("Tokens successfully transferred to the top candidate.");

        } catch (err) {
            console.log(err)
        }
    }

    const votingValue = {
        account,
        isConnected,
        connectWallet,
        registerCandidate,
        registerVoter,
        getApproveCandidates,
        allApproveCandidates,
        allCandidates,
        approveCandidate,
        voteCandidate,
        getVoterData,
        getCandidateData,
        getAllCandidates,
        transferTokenToWinner
    }

    return (
        <VotingContext.Provider value={votingValue}>
            {props.children}
        </VotingContext.Provider>
    )
}

export default VotingProvider