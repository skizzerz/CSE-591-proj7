function [price, state] = vulnPrice(cvss, popularity, state)
    % vulnPrice returns the price and state of a vulnerability 
    %
    rng(state);
    price = cvss * popularity * (1 + randn / 10) * 5000;
    state = rng;
end