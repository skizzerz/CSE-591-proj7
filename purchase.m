% Purchases a single vulnerability, if its value is better than our future
% value. Otherwise doesn't purchase anything (check if purchased == 0).
function [purchased, purchasedValue, newActor, newMarket] = purchase(actor, eFuture, services, market,r)
    bestVal = 0;
    bestIdx = 0;
    purchased = 0;
    purchasedValue = 0;
    budget = actor.budget;
    atkWgt = actor.attack_weight;
    defWgt = actor.defense_weight;
    catWgts = actor.category_weights;
    avgMarketPrice = mean([market.price]);
    for i = 1:numel(market)
        % select the vuln with the best value and buy it, as long as its
        % value is higher than eFuture. Purchasing removes the vuln from
        % the market.
        svc = market(i).service;
        impact = services(svc).popularity * 1000;
        % calculate the attack and defense value of this vulnerability for
        % our actor to purchase.
        atkVal = calculateValue(atkWgt, market(i).cvss, catWgts(svc), impact) / market(i).price;
        defVal = calculateValue(defWgt, market(i).cvss, catWgts(svc), impact) / market(i).price;
        val = max(atkVal, defVal)*(market(i).price / avgMarketPrice);
        % keep track of the vulnerability of the highest value. As long as
        % that vulnerability is available for purchase and within our
        % budget.
        if val > bestVal && market(i).price <= budget && market(i).purchased == 0
            bestVal = val;
            bestIdx = i;
        end
    end
    
    % bestIdx is the index in which the highest valued vulnerability is
    % held. If the value of that is greater than our expected future value
    % then we purchase that vulnerability.
    if bestIdx > 0 && bestVal > eFuture
        market(bestIdx).purchased = 1;
        purchased = market(bestIdx);
        purchasedValue = bestVal;
        % Remove from the actor's budget the price of the vulnerability
        % purchased. Add to the actor's spent value the price of the
        % vulnerability purchased and increment the value the actor has
        % received in the game by the value of the vulnerability purchased.
        actor.budget = actor.budget - purchased.price;
        actor.spent(r) = actor.spent(r)+ purchased.price;
        actor.value(r) = actor.value(r) + (bestVal * purchased.price);
    end
    
    newMarket = market;
    newActor = actor;
end