function actor = defensiveActor(categories,budget,r)
    % DEFENSIVEACTOR returns a structure of an actor who prefers to defend
    % rather than attack
    %
    % categories - number of categories in this particular game
    %
    % budget - the budget of the actor for this particular game
    actor.save_weight = 2;
    actor.attack_weight = 1;
    actor.defense_weight = 1;
    actor.category_weights = ones(categories);
    actor.total_budget = budget;
    actor.budget = budget;
    actor.spent = zeros(1,r);
    actor.value = zeros(1,r);
