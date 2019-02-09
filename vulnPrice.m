function [price, state] = vulnPrice(cvss, popularity, state)
    rng(state);
    price = cvss * popularity * (1 + randn / 10) * 5000;
    state = rng;
end