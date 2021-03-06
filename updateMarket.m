% Updates the list of vulnerabilities. Each list entry has a default
% 5% chance of going away, and there is another 5% chance per entry to
% generate a new vulnerability in the list for that service.
function [newMarket, newState] = updateMarket(market, services, addVulns, removeChance, state)
    rng(state);
    
    j = 1;
    numServices = numel(services);
    newMarket = market;
    newState = state;
    for i = 1:addVulns
        cvss = randi(100) / 10;
        service = randi(numServices);
        [price, newState] = vulnPrice(cvss, services(service).popularity, rng);
        newMarket(j).cvss = cvss;
        newMarket(j).service = service;
        newMarket(j).price = price;
        newMarket(j).purchased = 0;
        j = j + 1;
    end
    
    for i = 1:numel(market)
        if rand > removeChance && market(i).purchased == 0
            % this means we are *not* removing the current element,
            % so copy it over to the returned list
            newMarket(j).cvss = market(i).cvss;
            newMarket(j).service = market(i).service;
            newMarket(j).price = market(i).price;
            newMarket(j).purchased = market(i).purchased;
            j = j + 1;
        end
    end
end
