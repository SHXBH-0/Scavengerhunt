module scavenger_addr::ScavengerHunt {

    use aptos_framework::signer;
    use aptos_framework::vector;

    struct Clue has store, key {
        description: vector<u8>, // Description of the clue
        claimed: bool,           // Whether the clue has been claimed
    }

    struct Hunt has store, key {
        clues: vector<Clue>,     // List of clues in the scavenger hunt
        owner: address,          // Owner of the scavenger hunt
    }

    /// Function to create a new scavenger hunt with a list of clues.
    public fun create_hunt(owner: &signer, clues_desc: vector<vector<u8>>) {
        let clues = vector::empty<Clue>();
        for (i in 0..vector::length(&clues_desc)) {
            let desc = *vector::borrow_mut(&mut clues_desc, i);
            let clue = Clue {
                description: desc,
                claimed: false,
            };
            vector::push_back(&mut clues, clue);
        };
        let hunt = Hunt {
            clues,
            owner: signer::address_of(owner),
        };
        move_to(owner, hunt);
    }

    /// Function for a participant to claim a clue.
    public fun claim_clue(participant: &signer, hunt_owner: address, clue_index: u64) acquires Hunt {
        let hunt = borrow_global_mut<Hunt>(hunt_owner);
        assert!(clue_index < vector::length(&hunt.clues), 1); // Ensure valid clue index
        let clue = vector::borrow_mut(&mut hunt.clues, clue_index);
        assert!(!clue.claimed, 2); // Ensure the clue hasn't been claimed yet
        clue.claimed = true; // Mark the clue as claimed
    }
}