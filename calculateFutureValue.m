function value = calculateFutureValue(e_month, rnd, month, actor, cost)
    % CALCULATEFUTUREVALUE caluculates the expected value of saving money
    % for the next round of the simulation
    %
    % e_month - expected value we expect to gain a month via purchases
    %
    % rnd - current overall round
    % 
    % month - months remaining (rounds remaining in iteration)
    %
    % actor - actor

    save = actor.save_weight;
    budget = actor.budget;
    spent = actor.spent(rnd);
    value = save*e_month/((budget+spent)/(month+1)/(spent+cost));
    if month == 0
        value = 0;
    end
    