function value = calculateValue(weight, cvss, category, impacted)
    % CALCULATEVALUE caluculates the attack or defense value for a single
    % vulnerability
    %
    % weight - nonnegative weight for this particular vulnerability
    %
    % cvss - cvss score of this vulnerability (1-10)
    %
    % category - nonnegative category weight of this vulnerability
    %
    % impacted - number of machines impacted by this vulnerability
    value = weight*cvss*category*impacted;