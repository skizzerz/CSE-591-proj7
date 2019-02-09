function actor = selectiveActor(categories,budget)
    % SELECTIVEACTOR returns a structure of an actor who randomly prefers
    % certain vulnerabilities and dislikes others
    %
    % categories - number of categories in this particular game
    %
    % budget - the budget of the actor for this particular game
    actor.save_weight = 1;
    actor.attack_weight = 1;
    actor.defense_weight = 1;
    actor.category_weights = 2*rand(categories,1);
    actor.budget = budget;
    actor.spent = 0;