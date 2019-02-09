% Script to run through the game.

rounds = 12;
num_svc = 20;
budget = 1000000;
avgVal = 0.2200; % average value of a vulnerability
eMonth = budget / 12 * avgVal;
[services, market, state] = initialize(num_svc, 1);
us = normalActor(num_svc, budget);
opp = normalActor(num_svc, budget);

for r = 1:rounds
    r
    % buy some vulns; we go first
    [purchased, value, us, market] = purchase(us, 0, services, market);
    value
    while isstruct(purchased)
         eFuture = calculateFutureValue(eMonth, rounds - r, us);
         [purchased, value, us, market] = purchase(us, eFuture, services, market);
         value
    end
    
    % now our opponent goes
    [purchased, value, opp, market] = purchase(opp, 0, services, market);
    value
    while isstruct(purchased)
         eFuture = calculateFutureValue(eMonth, rounds - r, opp);
         [purchased, value, opp, market] = purchase(opp, eFuture, services, market);
         value
    end
    
    % finally update market state
    [market, state] = updateMarket(market, services, state);
    % players purchasing logic here
    % possibly may involve modifying the existing vuln list
    % this modified list will then be updated prior to starting
    % the next round
    %vuln_u = updateList(vuln, .05, .05, 1);
    %vuln_uCell = struct2cell(vuln_u);
    % remove comment below to view output for eachround
    %vuln_uCell
end
