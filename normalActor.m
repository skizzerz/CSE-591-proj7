function actor = normalActor(categories,budget,r)
    % NORMALACTOR returns a structure of a really boring actors parameters
    %
    % categories - number of categories in this particular game
    %
    % budget - the budget of the actor for this particular game
    actor.save_weight = 1;
    actor.attack_weight = 1;
    actor.defense_weight = 1;
    actor.category_weights = ones(categories);
    actor.budget = budget;
    actor.spent = zeros(1,r);
    actor.value = zeros(1,r);

