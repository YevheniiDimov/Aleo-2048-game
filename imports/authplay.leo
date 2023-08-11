program authplay.aleo {
    struct Account {
        owner: address,
        microcredits: u64,
        id: u128,
        password_hash: u128,
    }

    mapping accounts: address => Account;
}