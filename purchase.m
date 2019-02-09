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
        impact = services(svc).popularity * 1000;
        atkVal = calculateValue(atkWgt, market(i).cvss, catWgts(svc), impact) / market(i).price;
        defVal = calculateValue(defWgt, market(i).cvss, catWgts(svc), impact) / market(i).price;
        val = max(atkVal, defVal);
        if val > bestVal && market(i).price <= budget && market(i).purchased == 0
            bestVal = val;
            bestIdx = i;
        end
    end
    
    if bestIdx > 0 && bestVal > eFuture
        market(bestIdx).purchased = 1;
        purchased = market(bestIdx);
        purchasedValue = bestVal;
        
        actor.budget = actor.budget - purchased.price;
        actor.spent = actor.spent + purchased.price;
        actor.value = actor.value + (bestVal * purchased.price);
    end
    
    newMarket = market;
    newActor = actor;
end