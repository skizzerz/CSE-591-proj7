function actor = aggressiveActor()
    % AGGRESSIVEATCOR returns a structure of a actor who prefers to attack
    % rather than defend
    %
    % categories - number of categories in this particular game
    %
    % budget - the budget of the actor for this particular game
    actor.attack_weight = 1.5;
    actor.defense_weight = .5;
    actor.category_weights = ones(20);
    actor.budget = 10000000;
    actor.spent = 0;