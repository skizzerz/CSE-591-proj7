% Script to run through the game.

rounds = 12;
num_svc = 20;
budget = 1000000;
avgVal = 0.2; % average value of a vulnerability
%eMonth = budget / 12 * avgVal;
eMonth = avgVal;
% call initialize to setup the initial game conditions
% including the vulnerability market
[services, market, state] = initialize(num_svc, 2);
% initialize two actors using the normalActor function.
us = normalActor(num_svc, budget, rounds);
opp = normalActor(num_svc, budget, rounds);

% Do the following for each round of the game
for r = 1:rounds
    fprintf('ROUND %d\n', r);
    bu = 0;
    bo = 0;
    % buy some vulns; we go first
    [usPurchased, usValue, us, market] = purchase(us, 0, services, market,r);
    [oppPurchased, oppValue, opp, market] = purchase(opp, 0, services, market,r);
    while isstruct(usPurchased) || isstruct(oppPurchased)
        if isstruct(usPurchased)
            bu = bu + 1;
            fprintf('We purchased vuln with value/$ %.4f for $%.2f.\n', usValue, usPurchased.price);
            eFuture = calculateFutureValue(eMonth, rounds - r, us);
            [usPurchased, usValue, us, market] = purchase(us, eFuture, services, market,r);
        end
        
        if isstruct(oppPurchased)
            bo = bo + 1;
            fprintf('Opponent purchased vuln with value/$ %.4f for $%.2f.\n', oppValue, oppPurchased.price);
            eFuture = calculateFutureValue(eMonth, rounds - r, opp);
            [oppPurchased, oppValue, opp, market] = purchase(opp, eFuture, services, market,r);
        end
    end

    fprintf('---------------\n');
    fprintf('We purchased $%.2f of vulns for total value %.4f.\n', us.spent(r), us.value(r));
    fprintf('Opponent purchased $%.2f of vulns for total value %.4f.\n', opp.spent(r), opp.value(r));
    fprintf('\n\n===============\n');
    
    % finally update market state and reset spent
    [market, state] = updateMarket(market, services, state);
end
r= [1:1:12];
figure(1)
plot(r,us.value,r,opp.value)
title('Value Gained Over Each Round');
xlabel("Round");
ylabel("Value");
legend("Our Value","Opponents Value");
% change the exponent to remove scientific notation
ax = gca;
ax.YAxis.Exponent = 0;
ytickformat('usd')

figure(2)
plot(r,us.spent,r,opp.spent)
title('Money Spent Over Each Round');
xlabel("Round");
ylabel("Spending");
legend("Our Spending","Opponents Spending");
% change the exponent to remove scientific notation
ax = gca;
ax.YAxis.Exponent = 0;
ytickformat('usd')

figure(3)
plot(r,cumsum(us.value),r,cumsum(opp.value))
title('Cumulative Value Gained Over Each Round');
xlabel("Round");
ylabel("Value");
legend("Our Value","Opponents Value");
% change the exponent to remove scientific notation
ax = gca;
ax.YAxis.Exponent = 0;
ytickformat('usd')

figure(4)
plot(r,cumsum(us.spent),r,cumsum(opp.spent))
title('Cumulative Money Spent Over Each Round');
xlabel("Round");
ylabel("Spending");
legend("Our Spending","Opponents Spending");
% change the exponent to remove scientific notation
ax = gca;
ax.YAxis.Exponent = 0;
ytickformat('usd')
