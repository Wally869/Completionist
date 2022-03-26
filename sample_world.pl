% location(name, items at location, requires)
location(house, [sword], []).
location(hidden_path, [bow], []).
location(palace, [ocarina], []).
location(forest, [light_arrows], [bow]).
location(ganon, [], [light_arrows, bow, sword]).

% add unreachable location 
location(shadow_temple, [], [magic]).