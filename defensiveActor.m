function actor = defensiveActor()
    % DEFENSIVEACTOR returns a structure of an actor who prefers to defend
    % rather than attack
    actor.attack_weight = .5;
    actor.defense_weight = 1.5;
    actor.category_weights = ones(20);
    actor.budget = 10000000;
    actor.spent = 0;