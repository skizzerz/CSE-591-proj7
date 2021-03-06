% Generates a list of vulnerabilities to use for our initial game state.
function [market, newState] = generateMarket(services, numVulns, state)
    rng(state);

    % initialize a list of numServices * 10 random vulnerabilities
    numServices = numel(services);
    for i = 1:numVulns
        cvss = randi(100) / 10;
        service = randi(numServices);
        [price, newState] = vulnPrice(cvss, services(service).popularity, rng);
        market(i).cvss = cvss;
        market(i).service = service;
        market(i).price = price;
        market(i).purchased = 0;
    end
end