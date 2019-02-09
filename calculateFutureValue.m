function value = calculateFutureValue(e_month,month,actor)
    % CALCULATEFUTUREVALUE caluculates the expected value of saving money
    % for the next round of the simulation
    %
    % e_month - expected value we expect to gain a month via purchases
    %
    % month - months remaining
    %
    % actor - actor
    save = actor.save_weight;
    budget = actor.budget;
    spent = actor.spent;
    value = save*e_month*month/((budget/(month+1))/spent);
    