# Aptos-Bootcamp-by-Aayan-Srivastwa
# Simple Voting Smart Contract

A basic voting smart contract built on the Aptos blockchain using Move language. This contract allows users to create polls and vote on them with duplicate vote prevention.

## Features

- ✅ Create voting polls with custom questions
- ✅ Vote Yes/No on existing polls
- ✅ Prevent duplicate voting from the same address
- ✅ Track vote counts and poll status
- ✅ Simple and gas-efficient design

## Contract Structure

### Structs

**Poll**
```move
struct Poll has store, key {
    question: String,     // The voting question
    yes_votes: u64,      // Number of yes votes
    no_votes: u64,       // Number of no votes
    is_active: bool,     // Whether the poll is still active
}
```

**VoteRecord**
```move
struct VoteRecord has store, key {
    has_voted: bool,     // Tracks if address has voted
}
```

### Functions

#### `create_poll(owner: &signer, question: String)`
Creates a new voting poll with the specified question.

**Parameters:**
- `owner`: The signer who creates the poll
- `question`: The voting question as a String

**Usage:**
```move
create_poll(&signer, string::utf8(b"Should we implement feature X?"));
```

#### `cast_vote(voter: &signer, poll_owner: address, vote: bool)`
Allows users to cast their vote on an existing poll.

**Parameters:**
- `voter`: The signer casting the vote
- `poll_owner`: Address of the poll creator
- `vote`: Boolean value (true for Yes, false for No)

**Usage:**
```move
cast_vote(&signer, @0x123..., true);  // Vote Yes
cast_vote(&signer, @0x123..., false); // Vote No
```

## Error Codes

- **Error 1**: User has already voted on this poll
- **Error 2**: Poll is not active

## Deployment Instructions

### Prerequisites
- Aptos CLI installed
- Move compiler set up
- Aptos account with sufficient gas

### Steps

1. **Initialize Move project**
```bash
aptos move init --name SimpleVoting
```

2. **Add the contract**
- Place the contract code in `sources/SimpleVoting.move`
- Update `Move.toml` with dependencies

3. **Compile the contract**
```bash
aptos move compile
```

4. **Deploy to testnet**
```bash
aptos move publish --profile testnet
```

5. **Deploy to mainnet**
```bash
aptos move publish --profile mainnet
```

## Usage Examples

### Creating a Poll
```bash
aptos move run \
  --function-id 'YOUR_ADDRESS::SimpleVoting::create_poll' \
  --args 'string:Should we increase the block size limit?' \
  --profile your-profile
```

### Casting a Vote
```bash
aptos move run \
  --function-id 'YOUR_ADDRESS::SimpleVoting::cast_vote' \
  --args 'address:POLL_OWNER_ADDRESS' 'bool:true' \
  --profile your-profile
```

## Contract Limitations

- Each address can only vote once per poll
- No vote withdrawal mechanism
- No poll closing functionality
- No vote delegation features
- Fixed Yes/No voting format

## Security Considerations

- Contract prevents double voting through VoteRecord tracking
- Poll ownership is tied to the creator's address
- No admin functions to manipulate votes
- Simple assertion-based error handling

## Testing

Recommended test scenarios:
1. Create multiple polls from different accounts
2. Vote on polls with different addresses
3. Attempt duplicate voting (should fail)
4. Verify vote counts are accurate
5. Test with various question lengths and formats

## License

This contract is provided as-is for educational and development purposes.

## Contributing

Feel free to submit issues and enhancement requests!

---

**Note:** This is a basic implementation. For production use, consider adding features like poll expiration, vote privacy, admin controls, and more sophisticated error handling.
