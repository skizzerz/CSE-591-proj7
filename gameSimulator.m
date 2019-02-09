% Script to run through the game.

rounds = 12;

TotalVuln = [];

vuln = generateList(10,1);

TotalVuln = vuln;

for r = 1:rounds
    % players purchasing logic here
    % possibly may involve modifying the existing vuln list
    % this modified list will then be updated prior to starting
    % the next round
    vuln_u = updateList(vuln, .05, .05, 1);
    %TotalVuln(
end