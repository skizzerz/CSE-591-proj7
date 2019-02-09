% Script to run through the game.

rounds = 12;
num_svc = 20;
budget = 1000000;
avgVal = 0.2; % average value of a vulnerability
%eMonth = budget / 12 * avgVal;
eMonth = avgVal;
[services, market, state] = initialize(num_svc, 1);
us = normalActor(num_svc, budget);
opp = normalActor(num_svc, budget);

for r = 1:rounds
    bu = 0;
    bo = 0;
    % buy some vulns; we go first
    [purchased, value, us, market] = purchase(us, 0, services, market);
    while isstruct(purchased)
         bu = bu + 1;
         eFuture = calculateFutureValue(eMonth, rounds - r, us);
         dbg.efuture = eFuture;
         dbg.budget = us.budget;
         dbg.spent = us.spent;
         dbg.value = value;
         dbg
         [purchased, value, us, market] = purchase(us, eFuture, services, market);
    end
    
    % now our opponent goes
    [purchased, value, opp, market] = purchase(opp, 0, services, market);
    while isstruct(purchased)
         bo = bo + 1;
         eFuture = calculateFutureValue(eMonth, rounds - r, opp);
         [purchased, value, opp, market] = purchase(opp, eFuture, services, market);
    end
    [r, bu, bo]
    
    % finally update market state and reset spent
    [market, state] = updateMarket(market, services, state);
    us.spent = 0;
    opp.spent = 0;
    us.value = 0;
    opp.value = 0;

    % players purchasing logic here
    % possibly may involve modifying the existing vuln list
    % this modified list will then be updated prior to starting
    % the next round
    %vuln_u = updateList(vuln, .05, .05, 1);
    %vuln_uCell = struct2cell(vuln_u);
    % remove comment below to view output for eachround
    %vuln_uCell
    figure(1)
    plot(r,us.value,r,opp.value)
    figure(2)
    plot(r,us.spent,r,opp.value)
end
