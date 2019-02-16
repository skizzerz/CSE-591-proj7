% Script to run through the game.

rounds = 24;
roundsPerLoop = 12; % budget refreshes after this many rounds
num_svc = 20;
ourBudget = 1000000;
oppBudget = 1000000;

eMonth = 0.2; % average value of a vulnerability
% call initialize to setup the initial game conditions
% including the vulnerability market
[services, market, state] = initialize(num_svc);
% initialize two actors using the normalActor function.
us = normalActor(num_svc, ourBudget, rounds);
opp = normalActor(num_svc, oppBudget, rounds);

% Do the following for each round of the game
for rnd = 1:rounds
    fprintf('ROUND %d\n', rnd);
    
    if mod(rnd - 1, roundsPerLoop) == 0
        fprintf('NEW ITERATION: RESET BUDGETS\n')
        us.budget = us.total_budget;
        opp.budget = opp.total_budget;
    end
    
    bu = 0;
    bo = 0;
    % buy some vulns; we go first
    [usPurchased, usValue, us, market] = purchase(us, 0, services, market, rnd, roundsPerLoop);
    [oppPurchased, oppValue, opp, market] = purchase(opp, 0, services, market, rnd, roundsPerLoop);
    while isstruct(usPurchased) || isstruct(oppPurchased)
        if isstruct(usPurchased)
            bu = bu + 1;
            fprintf('We purchased vuln with efficiency %.4f for $%.2f.\n', usValue, usPurchased.price);
            %eFuture = calculateFutureValue(eMonth, rounds - r, us);
            [usPurchased, usValue, us, market] = purchase(us, eMonth, services, market, rnd, roundsPerLoop);
        end
        
        if isstruct(oppPurchased)
            bo = bo + 1;
            fprintf('Opponent purchased vuln with efficiency %.4f for $%.2f.\n', oppValue, oppPurchased.price);
            %eFuture = calculateFutureValue(eMonth, rounds - r, opp);
            [oppPurchased, oppValue, opp, market] = purchase(opp, eMonth, services, market, rnd, roundsPerLoop);
        end
    end

    fprintf('---------------\n');
    fprintf('We purchased $%.2f of vulns for total value %.4f.\n', us.spent(rnd), us.value(rnd));
    fprintf('Opponent purchased $%.2f of vulns for total value %.4f.\n', opp.spent(rnd), opp.value(rnd));
    fprintf('\n\n===============\n');
    
    % finally update market state and reset spent
    [market, state] = updateMarket(market, services, state);
end
fprintf('---------------\n');
fprintf('We purchased $%.2f of vulns for total value %.4f.\n', sum([us.spent]),sum([us.value]));
fprintf('We purchased $%.2f of vulns for total value %.4f.\n', sum([opp.spent]),sum([opp.value]));

numIters = rounds / roundsPerLoop;
totBudget = max([us.total_budget opp.total_budget]) * numIters;

r = [1:1:rounds];
figure(1)
plot(r, us.value, r, opp.value)
title('Value Gained Over Each Month');
xlabel("Month");
ylabel("Value");
legend("Our Value","Opponents Value",'Location','southeast');
% change the exponent to remove scientific notation
ax = gca;
ax.YAxis.Exponent = 0;
xlim([1 rounds]);
ylim([0 inf]);
set(gca,'xtick',1:rounds,'xticklabel',{'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'});

figure(2)
plot(r,us.spent,r,opp.spent)
title('Money Spent Over Each Month');
xlabel("Month");
ylabel("Spending");
legend("Our Spending","Opponents Spending",'Location','southeast');
% change the exponent to remove scientific notation
ax = gca;
ax.YAxis.Exponent = 0;
ytickformat('usd')
xlim([1 rounds]);
ylim([0 inf]);
set(gca,'xtick',1:rounds,'xticklabel',{'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'});

figure(3)
plot(r,cumsum(us.value),r,cumsum(opp.value))
title('Cumulative Value Gained Over Each Month');
xlabel("Month");
ylabel("Value");
legend("Our Value","Opponents Value",'Location','southeast');
% change the exponent to remove scientific notation
ax = gca;
ax.YAxis.Exponent = 0;
xlim([1 rounds]);
ylim([0 inf]);
set(gca,'xtick',1:rounds,'xticklabel',{'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'}); 

figure(4)
plot(r,cumsum(us.spent),r,cumsum(opp.spent))
title('Cumulative Money Spent Over Each Month');
xlabel("Month");
ylabel("Spending");
legend("Our Spending","Opponents Spending",'Location','southeast');
% change the exponent to remove scientific notation
ax = gca;
ax.YAxis.Exponent = 0;
ytickformat('usd');
xlim([1 rounds]);
ylim([0 totBudget]);
set(gca,'xtick',1:rounds,'xticklabel',{'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'});
