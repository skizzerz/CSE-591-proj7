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
        atkVal = calculateValue(atkWgt, market(i).cvss, catWgts(svc), impact);
        defVal = calculateValue(defWgt, market(i).cvss, catWgts(svc), impact);
        val = max(atkVal, defVal);
        if val > bestVal && market(i).price <= budget && market(i).purchased == 0
            bestVal = val;
            bestIdx = i;
        end
    end
    
    eVuln = 0;
    if bestIdx > 0
        eVuln = bestVal / market(bestIdx).price;
    end
    
    if bestIdx > 0 && eVuln > eFuture
        market(bestIdx).purchased = 1;
        purchased = market(bestIdx);
        purchasedValue = eVuln;
        
        actor.budget = actor.budget - purchased.price;
        actor.spent = actor.spent + purchased.price;
        actor.value = actor.value + bestVal;
    end
    
    newMarket = market;
    newActor = actor;
end