#[starknet::contract]
mod QuadraticVoting {
    use starknet::get_caller_address;
    use starknet::ContractAddress;
    use integer::u256;
    use integer::u256_sqrt;
    use array::ArrayTrait;
    use option::OptionTrait;

    #[storage]
    struct Storage {
        // Mapping of project_id to project details
        projects: LegacyMap<felt252, Project>,
        // Mapping of voter to their contribution amount
        contributions: LegacyMap<(ContractAddress, felt252), u256>,
        // Total contributions per project
        total_contributions: LegacyMap<felt252, u256>,
        // Number of projects
        project_count: felt252,
        // Voting period status
        is_active: bool,
        // Project owner
        owner: ContractAddress,
    }

    #[derive(Drop, Serde)]
    struct Project {
        id: felt252,
        name: felt252,
        description: felt252,
        matched_funds: u256,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        ProjectCreated: ProjectCreated,
        ContributionMade: ContributionMade,
        MatchingCompleted: MatchingCompleted,
    }

    #[derive(Drop, starknet::Event)]
    struct ProjectCreated {
        id: felt252,
        name: felt252,
    }

    #[derive(Drop, starknet::Event)]
    struct ContributionMade {
        voter: ContractAddress,
        project_id: felt252,
        amount: u256,
        impact: u256,
    }

    #[derive(Drop, starknet::Event)]
    struct MatchingCompleted {
        project_id: felt252,
        matched_amount: u256,
    }

    #[constructor]
    fn constructor(ref self: ContractState) {
        self.owner.write(get_caller_address());
        self.is_active.write(true);
        self.project_count.write(0);
    }

    #[external(v0)]
    fn create_project(ref self: ContractState, name: felt252, description: felt252) {
        assert(self.is_active.read(), 'Voting period ended');
        let project_id = self.project_count.read() + 1;
        
        let project = Project {
            id: project_id,
            name: name,
            description: description,
            matched_funds: u256 { low: 0, high: 0 },
        };
        
        self.projects.write(project_id, project);
        self.project_count.write(project_id);
        
        self.emit(Event::ProjectCreated(ProjectCreated { id: project_id, name }));
    }

    #[external(v0)]
    fn contribute(ref self: ContractState, project_id: felt252, amount: u256) {
        assert(self.is_active.read(), 'Voting period ended');
        assert(project_id <= self.project_count.read(), 'Invalid project');
        
        let voter = get_caller_address();
        let prev_contribution = self.contributions.read((voter, project_id));
        let new_total = prev_contribution + amount;
        
        // Calculate quadratic impact
        let impact = u256_sqrt(new_total);
        
        self.contributions.write((voter, project_id), new_total);
        self.total_contributions.write(project_id, self.total_contributions.read(project_id) + amount);
        
        self.emit(Event::ContributionMade(ContributionMade { 
            voter, 
            project_id, 
            amount, 
            impact 
        }));
    }

    #[external(v0)]
    fn calculate_matching(ref self: ContractState, project_id: felt252, matching_pool: u256) {
        assert(get_caller_address() == self.owner.read(), 'Not authorized');
        assert(project_id <= self.project_count.read(), 'Invalid project');
        
        let total_contribution = self.total_contributions.read(project_id);
        let sqrt_total = u256_sqrt(total_contribution);
        
        // Simple matching calculation: matched_amount = sqrt(total_contributions) * matching_pool / total_contributions
        let matched_amount = (sqrt_total * matching_pool) / total_contribution;
        
        let mut project = self.projects.read(project_id);
        project.matched_funds = matched_amount;
        self.projects.write(project_id, project);
        
        self.emit(Event::MatchingCompleted(MatchingCompleted { 
            project_id, 
            matched_amount 
        }));
    }

    #[external(v0)]
    fn end_voting(ref self: ContractState) {
        assert(get_caller_address() == self.owner.read(), 'Not authorized');
        self.is_active.write(false);
    }

    // View functions
    #[external(v0)]
    fn get_project(self: @ContractState, project_id: felt252) -> Project {
        self.projects.read(project_id)
    }

    #[external(v0)]
    fn get_contribution(self: @ContractState, voter: ContractAddress, project_id: felt252) -> u256 {
        self.contributions.read((voter, project_id))
    }

    #[external(v0)]
    fn get_total_contributions(self: @ContractState, project_id: felt252) -> u256 {
        self.total_contributions.read(project_id)
    }

    #[external(v0)]
    fn is_voting_active(self: @ContractState) -> bool {
        self.is_active.read()
    }
}
