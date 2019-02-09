function value = calculateTotalValue(attack, defense)
    % CALCULATETOTALVALUE calculates the total valuation of a vulnerability
    %
    % attack - attack score of vulnerability
    %
    % defense - defense score of vulnerability

    value = max(attack,defense)

    