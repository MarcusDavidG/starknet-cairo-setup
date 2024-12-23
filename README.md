# Quadratic Voting System on Starknet

## Overview
This project implements a decentralized Quadratic Voting system on Starknet using Cairo. The system allows for fair project funding through a quadratic funding mechanism, where the impact of contributions is calculated as the square root of the amount contributed.

## Key Features

### Quadratic Funding Mechanism
- Contributions have diminishing returns through quadratic calculation
- Impact = √(contribution amount)
- Prevents whale dominance in voting
- Promotes broader participation

### Smart Contract Functionality
- Create new projects for funding
- Make contributions with quadratic impact
- Automatic matching fund calculations
- Real-time contribution tracking
- Event emission for transparency

## Technical Implementation

### Core Components

1. **Project Management**
```cairo
#[derive(Drop, Serde)]
struct Project {
    id: felt252,
    name: felt252,
    description: felt252,
    matched_funds: u256,
}
```

2. **Quadratic Contribution**
```cairo
fn contribute(ref self: ContractState, project_id: felt252, amount: u256) {
    // Calculate quadratic impact
    let impact = u256_sqrt(new_total);
    // ... contribution logic
}
```

3. **Matching Pool Distribution**
```cairo
fn calculate_matching(ref self: ContractState, project_id: felt252, matching_pool: u256) {
    // Matching calculation based on square root of contributions
    let matched_amount = (sqrt_total * matching_pool) / total_contribution;
    // ... matching logic
}
```

## How It Works

1. **Project Creation**
   - Projects are registered with name and description
   - Each project gets a unique ID

2. **Contribution Phase**
   - Users contribute funds to projects
   - Impact is calculated using quadratic formula
   - Events are emitted for transparency

3. **Matching Phase**
   - Matching funds are distributed based on quadratic calculations
   - Prevents manipulation by large contributors
   - Promotes fair distribution

## Mathematical Model

The system uses the following formulas:
- Contribution Impact = √(total_contribution)
- Matching Amount = (√total_contributions * matching_pool) / total_contributions

This creates a more democratic funding mechanism where:
- Small contributions have proportionally larger impact
- Large contributions face diminishing returns
- Broad support is rewarded more than a few large donations

## Usage

1. Deploy the contract
2. Create projects for funding
3. Contributors can fund projects
4. Owner can trigger matching calculations
5. View results through getter functions

## Events

The contract emits events for:
- Project creation
- Contributions
- Matching calculations

This provides full transparency and allows for off-chain tracking of all activities.

## Security Features

- Owner authentication for critical functions
- Period controls for voting phases
- Input validation
- Arithmetic overflow protection

## Future Improvements

- Multi-round funding periods
- Token-based voting
- Governance mechanisms
- Advanced matching algorithms

## License
MIT License
