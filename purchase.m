% Purchases a single vulnerability, if its value is better than our future
% value. Otherwise doesn't purchase anything (check if purchased == 0).
function [purchased, purchasedValue, newActor, newMarket] = purchase(actor, eMonth, services, market, rnd, roundsPerLoop)
    bestInflatedVal = 0;
    bestBaseVal = 0;
    bestIdx = 0;
    purchased = 0;
    purchasedValue = 0;
    budget = actor.budget;
    atkWgt = actor.attack_weight;
    defWgt = actor.defense_weight;
    catWgts = actor.category_weights;
    
    for i = 1:numel(market)
        svc = market(i).service;
        impact = services(svc).popularity * 1000;
        atkVal = calculateValue(atkWgt, market(i).cvss, catWgts(svc), impact) / market(i).price;
        defVal = calculateValue(defWgt, market(i).cvss, catWgts(svc), impact) / market(i).price;
        values(i) = max(atkVal, defVal);
    end
    
    avgMarketValue = mean(values);
    maxMarketValue = max(values);
    % when inflating vulnerabilities, this is the maximum amount we inflate
    % by.
    clampFactor = 1.1;
    clamp = (clampFactor - 1)/(maxMarketValue/avgMarketValue - 1);
    
    % select the vuln with the best value and buy it, as long as its
    % value is higher than eFuture. Purchasing removes the vuln from
    % the market.
    for i = 1:numel(market)
        baseVal = values(i);
        % We overvalue more expensive vulns, because vuln authors are
        % usually good at pricing, so more expensive = more impact in
        % general.
        inflatedVal = clamp * baseVal / avgMarketValue + 1 - clamp;
        % keep track of the vulnerability of the highest value. As long as
        % that vulnerability is available for purchase and within our
        % budget.
        if inflatedVal > bestInflatedVal && market(i).price <= budget && market(i).purchased == 0
            bestInflatedVal = inflatedVal;
            bestBaseVal = baseVal;
            bestIdx = i;
        end
    end
    r = mod(rnd - 1, roundsPerLoop) + 1;
    input = roundsPerLoop - r;
    if bestIdx ~= 0
        eFuture = calculateFutureValue(eMonth, rnd, input, actor, market(bestIdx).price);
        fprintf('eFuture = %.4f; value = %.4f\n', eFuture, bestBaseVal);
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
        actor.spent(rnd) = actor.spent(rnd) + purchased.price;
        actor.value(rnd) = actor.value(rnd) + (bestBaseVal * purchased.price);
    end
    
    newMarket = market;
    newActor = actor;
end