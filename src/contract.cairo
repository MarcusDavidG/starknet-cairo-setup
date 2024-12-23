#[starknet::contract]
mod StarklingsContract {
    #[storage]
    struct Storage {
        balance: felt252,
        owner: felt252,
    }

    #[constructor]
    fn constructor(ref self: ContractState, initial_balance: felt252) {
        self.balance.write(initial_balance);
        self.owner.write(get_caller_address());
    }

    #[external(v0)]
    fn get_balance(self: @ContractState) -> felt252 {
        self.balance.read()
    }

    #[external(v0)]
    fn update_balance(ref self: ContractState, new_balance: felt252) {
        assert(get_caller_address() == self.owner.read(), 'Not authorized');
        self.balance.write(new_balance);
    }
}
