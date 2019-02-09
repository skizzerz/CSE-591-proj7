function actor = selectiveActor()
    % SELECTIVEACTOR returns a structure of an actor who randomly prefers
    % certain vulnerabilities and dislikes others
    %
    % categories - number of categories in this particular game
    %
    % budget - the budget of the actor for this particular game
    actor.attack_weight = 1;
    actor.defense_weight = 1;
    actor.category_weights = 2*rand(20,1);
    actor.budget = 10000000;
    actor.spent = 0;