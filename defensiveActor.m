function actor = defensiveActor()
    % DEFENSIVEACTOR returns a structure of an actor who prefers to defend
    % rather than attack
    %
    % categories - number of categories in this particular game
    %
    % budget - the budget of the actor for this particular game
    actor.attack_weight = .5;
    actor.defense_weight = 1.5;
    actor.category_weights = ones(20);
    actor.budget = 10000000;
    actor.spent = 0;