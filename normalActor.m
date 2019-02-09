function actor = normalActor()
    % NORMALACTOR returns a structure of a really boring actors parameters
    actor.attack_weight = 1;
    actor.defense_weight = 1;
    actor.category_weights = ones(20);
    actor.budget = 10000000;
    actor.spent = 0;