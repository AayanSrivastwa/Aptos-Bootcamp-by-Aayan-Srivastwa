module MyModule::SimpleVoting {
    use aptos_framework::signer;
    use std::string::String;
    
    /// Struct representing a voting poll.
    struct Poll has store, key {
        question: String,     // The voting question
        yes_votes: u64,      // Number of yes votes
        no_votes: u64,       // Number of no votes
        is_active: bool,     // Whether the poll is still active
    }
    
    /// Struct to track if an address has already voted
    struct VoteRecord has store, key {
        has_voted: bool,
    }
    
    /// Event emitted when a vote is cast
    struct VoteEvent has drop, store {
        voter: address,
        vote: bool,  // true for yes, false for no
        poll_owner: address,
    }
    
    /// Function to create a new voting poll.
    public fun create_poll(owner: &signer, question: String) {
        let poll = Poll {
            question,
            yes_votes: 0,
            no_votes: 0,
            is_active: true,
        };
        move_to(owner, poll);
    }
    
    /// Function for users to cast their vote on a poll.
    public fun cast_vote(
        voter: &signer, 
        poll_owner: address, 
        vote: bool
    ) acquires Poll, VoteRecord {
        let voter_addr = signer::address_of(voter);
        
        // Check if voter has already voted
        if (exists<VoteRecord>(voter_addr)) {
            let vote_record = borrow_global<VoteRecord>(voter_addr);
            assert!(!vote_record.has_voted, 1); // Error: Already voted
        } else {
            // Create vote record for first-time voter
            let vote_record = VoteRecord { has_voted: false };
            move_to(voter, vote_record);
        };
        
        // Update vote record
        let vote_record = borrow_global_mut<VoteRecord>(voter_addr);
        vote_record.has_voted = true;
        
        // Cast the vote
        let poll = borrow_global_mut<Poll>(poll_owner);
        assert!(poll.is_active, 2); // Error: Poll is not active
        
        if (vote) {
            poll.yes_votes = poll.yes_votes + 1;
        } else {
            poll.no_votes = poll.no_votes + 1;
        };
        

    }
}