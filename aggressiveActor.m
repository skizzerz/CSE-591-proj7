function actor = aggressiveActor(categories,budget,r)
    % AGGRESSIVEATCOR returns a structure of a actor who prefers to attack
    % rather than defend
    %
    % categories - number of categories in this particular game
    %
    % budget - the budget of the actor for this particular game
    actor.save_weight = .8;
    actor.attack_weight = 1.5;
    actor.defense_weight = .5;
    actor.category_weights = ones(categories);
    actor.budget = budget;
    actor.spent = zeros(1,r);
    actor.value = zeros(1,r);

