function [services, market, state] = initialize(numServices, numVulns, seed)
    % RNG state for repeatable results across runs
    if nargin > 2
        rng(seed);
    else
        rng('shuffle');
        seed = randi(intmax);
        rng(seed)
    end
    fprintf('Seeding with %d\n', seed);
    state = rng;
    
    for i = 1:numServices
        % how popular this service is, where 1 is average popularity
        % more popular = us/opp runs more of this service, and cost is also
        % higher.
        services(i).popularity = (randn + 5) / 5;
    end
    
    % generate initial market
    [market, state] = generateMarket(services, numVulns, state);
end