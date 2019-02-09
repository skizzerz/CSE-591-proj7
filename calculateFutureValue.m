function value = calculateFutureValue(save,e_month,month,spent,budget)
    % CALCULATEFUTUREVALUE caluculates the expected value of saving money
    % for the next round of the simulation
    %
    % save - nonnegative weight that describes how much saving is valued
    %
    % e_month - expected value we expect to gain a month via purchases
    %
    % spent - amount of money spent this month
    %
    % budget - total amount of money left to spend
    value = save*e_month*(month-1)/((budget)/month*spent);
    