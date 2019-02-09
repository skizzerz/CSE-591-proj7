% Generates a list of vulnerabilities to use for our initial game state.
% numServices = number of services that we generate vulns for. Initially
%     we generate 5 times this number of vulnerabilities.
% seed = A seed to give repeatable results with the RNG; useful to keep
%     vulnerability list state constant while tweaking other variables in
%     the model to more accurately compare results of those tweaks.
function [list, next] = generateList(numServices, seed)
    if nargin > 1
        rng(seed);
    end
    
    % initialize a list of numServices * 5 random vulnerabilities
    numVulns = numServices * 5;
    for i = 1:numVulns
        list(i).cvss = randi(10);
        list(i).service = randi(numServices);
        % likely not accurate in the slightest, but we need some sort of
        % pricing for the vuln, and setting a fixed price per severity
        % means that our model may have unintended holes in it when applied
        % to a more real-world scenario.
        list(i).price = (list(i).cvss * 5000) + (randi(50) * 1000);
    end
    
    if nargout > 1
        % snapshot RNG state for repeatable results
        next = rng;
    end
end