% Updates the list of vulnerabilities. Each list entry has a default
% 5% chance of going away, and there is another 5% chance per entry to
% generate a new vulnerability in the list for that service.
function [newList, next] = updateList(list, removeChance, addChance, seed)
    add = 0.05;
    rem = 0.05;
    switch nargin
        case 4
            rng(seed)
            add = addChance;
            rem = removeChance;
        case 3
            add = addChance;
            rem = removeChance;
        case 2
            add = removeChance;
            rem = removeChance;
    end
    
    j = 1;
    for i = 1:numel(list)
        if rand < add
            newList(j).cvss = randi(10);
            newList(j).service = list(i).service;
            newList(j).price = (newList(j).cvss * 5000) + (randi(50) * 1000);
            j = j + 1;
        end
        
        if rand > rem
            % this means we are *not* removing the current element,
            % so copy it over to the returned list
            newList(j).cvss = list(i).cvss;
            newList(j).service = list(i).service;
            newList(j).price = list(i).price;
            j = j + 1;
        end
    end
    
    if nargout > 1
        next = rng;
    end
end