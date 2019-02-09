function actor = aggressiveActor()
    % AGGRESSIVEATCOR returns a structure of a actor who prefers to attack
    % rather than defend
    actor.attack_weight = 1.5;
    actor.defense_weight = .5;
    actor.category_weights = ones(20);
    actor.budget = 10000000;
    actor.spent = 0;