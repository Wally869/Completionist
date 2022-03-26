?- style_check(-discontiguous).

% requires the world to be defined by a set of locations.  
% location/3
% location(name, items at location, required items)  

% could also define contains/2 and requires/2  
% location(Name, ItemsContained, ItemsRequired) :- contains(Name, ItemsContained), requires(Name, ItemsRequired).

can_visit(Node, Equipment) :-
    location(Node, _, REQUIRED),
    forall(member(R, REQUIRED), member(R, Equipment)).

contains(Node, Items) :- location(Node, Items, _).


find_new_to_visit(Visited, Equipment, NewToVisit) :-
    findall(L, (location(L, _,_), can_visit(L, Equipment), \+ member(L, Visited)), NewToVisit).


visit_multiple(Visited, Equipment, [ToVisit], NewVisited, NewEquipment) :-
    contains(ToVisit, Items),
    NewVisited = [ToVisit|Visited],
    append(Equipment, Items, NewEquipment).


visit_multiple(Visited, Equipment, [H|T], NewVisited, NewEquipment) :-
    contains(H, Items),
    TempToVisit = [H|Visited],
    append(Equipment, Items, TempEquipment),
    visit_multiple(TempToVisit, TempEquipment, T, NewVisited, NewEquipment).


completable(Target) :-
    completable([], [], Target),
    !.

completable(Visited, _, Target) :-
    member(Target, Visited),
    !.

completable(Visited, Equipment, Target) :-
    find_new_to_visit(Visited, Equipment, NewToVisit),
    length(NewToVisit, L),
    L =\= 0,
    member(Target, NewToVisit),
    !.

completable(Visited, Equipment, Target) :-
    find_new_to_visit(Visited, Equipment, NewToVisit),
    length(NewToVisit, L),
    L =\= 0,
    visit_multiple(Visited, Equipment, NewToVisit, NewVisited, NewEquipment),
    completable(NewVisited, NewEquipment, Target),
    !.

