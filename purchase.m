% Purchases a single vulnerability, if its value is better than our future
% value. Otherwise doesn't purchase anything (check if purchased == 0).
function [purchased, purchasedValue, newActor, newMarket] = purchase(actor, eFuture, services, market)
    bestVal = 0;
    bestIdx = 0;
    purchased = 0;
    purchasedValue = 0;
    budget = actor.budget;
    atkWgt = actor.attack_weight;
    defWgt = actor.defense_weight;
    catWgts = actor.category_weights;
    for i = 1:numel(market)
        % select the vuln with the best value and buy it, as long as its
        % value is higher than eFuture. Purchasing removes the vuln from
        % the market.
        svc = market(i).service;
        atkVal = calculateValue(atkWgt, market(i).cvss, catWgts(svc), services(svc).popularity);
        defVal = calculateValue(defWgt, market(i).cvss, catWgts(svc), services(svc).popularity);
        val = max(atkVal, defVal);
        if val > bestVal && market(i).price <= budget
            bestVal = val;
            bestIdx = i;
        end
    end
    
    if bestIdx > 0 && bestVal > eFuture
        market(bestIdx).purchased = 1;
        actor.budget = actor.budget - market(bestIdx).price;
        actor.spent = market(bestIdx).price;
        purchased = market(bestIdx);
        purchasedValue = bestVal;
    end
    
    newMarket = market;
    newActor = actor;
end