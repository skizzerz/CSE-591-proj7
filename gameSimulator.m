% Script to run through the game.

rounds = 12;

vuln = generateList(10,1);

for r = 1:rounds
    r
    % players purchasing logic here
    % possibly may involve modifying the existing vuln list
    % this modified list will then be updated prior to starting
    % the next round
    vuln_u = updateList(vuln, .05, .05, 1);
    vuln_uCell = struct2cell(vuln_u);
    % remove comment below to view output for eachround
    %vuln_uCell
end
