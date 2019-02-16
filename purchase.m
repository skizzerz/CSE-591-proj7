% Purchases a single vulnerability, if its value is better than our future
% value. Otherwise doesn't purchase anything (check if purchased == 0).
function [purchased, purchasedValue, newActor, newMarket] = purchase(actor, eMonth, services, market,r,rounds)
    bestInflatedVal = 0;
    bestBaseVal = 0;
    bestIdx = 0;
    purchased = 0;
    purchasedValue = 0;
    budget = actor.budget;
    atkWgt = actor.attack_weight;
    defWgt = actor.defense_weight;
    catWgts = actor.category_weights;
    avgMarketPrice = mean([market.price]);
    maxMarketPrice = max([market.price]);
    % when inflating vulnerabilities, this is the maximum amount we inflate
    % by.
    clampFactor = 1.1 * avgMarketPrice / maxMarketPrice;
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
        baseVal = max(atkVal, defVal);
        % We overvalue more expensive vulns, because vuln authors are
        % usually good at pricing, so more expensive = more impact in
        % general.
        inflatedVal = baseVal * clampFactor * market(i).price / avgMarketPrice;
        % keep track of the vulnerability of the highest value. As long as
        % that vulnerability is available for purchase and within our
        % budget.
        if inflatedVal > bestInflatedVal && market(i).price <= budget && market(i).purchased == 0
            bestInflatedVal = inflatedVal;
            bestBaseVal = baseVal;
            bestIdx = i;
        end
    end
    input = rounds - r;
    if bestIdx ~= 0
        eFuture = calculateFutureValue(eMonth,input,actor,market(bestIdx).price);
    end
    % bestIdx is the index in which the highest valued vulnerability is
    % held. If the value of that is greater than our expected future value
    % then we purchase that vulnerability.
    if bestIdx > 0 && bestBaseVal > eFuture
        market(bestIdx).purchased = 1;
        purchased = market(bestIdx);
        purchasedValue = bestBaseVal;
        % Remove from the actor's budget the price of the vulnerability
        % purchased. Add to the actor's spent value the price of the
        % vulnerability purchased and increment the value the actor has
        % received in the game by the value of the vulnerability purchased.
        actor.budget = actor.budget - purchased.price;
        actor.spent(r) = actor.spent(r)+ purchased.price;
        actor.value(r) = actor.value(r) + (bestBaseVal * purchased.price);
    end
    
    newMarket = market;
    newActor = actor;
end