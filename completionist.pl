?- style_check(-discontiguous).

:- [dynamics].


can_visit_branch(Equipment, [H|T]) :-
    (forall(member(R, H), member(R, Equipment))), !;
    (can_visit_branch(Equipment, T)).


can_visit(Location, Equipment) :-
    requires(Location, REQUIREDS),
    length(REQUIREDS, L),
    (L == 0 -> (
            true
        );
        (
            can_visit_branch(Equipment, REQUIREDS)    
        )).


find_new_to_visit(Visited, Equipment, NewToVisit) :-
    findall(L, (location(L), can_visit(L, Equipment), \+ member(L, Visited)), NewToVisit).


visit_multiple(Visited, Equipment, [], NewVisited, NewEquipment) :-
    NewVisited = Visited,
    NewEquipment = Equipment.


visit_multiple(Visited, Equipment, [H|T], NewVisited, NewEquipment) :-
    contains(H, Item),
    UpdatedVisited = [H|Visited],
    append(Equipment, [Item], TempEquipment),
    visit_multiple(UpdatedVisited, TempEquipment, T, NewVisited, NewEquipment).


completable(Target) :-
    completable([], [], Target),
    !.


completable(Visited, Equipment, Target) :- 
    find_new_to_visit(Visited, Equipment, NewToVisit),
    (
        member(Target, NewToVisit);         
        length(NewToVisit, L),
        L == 0 -> (
            false
        ); 
        (
            visit_multiple(Visited, Equipment, NewToVisit, NewVisited, NewEquipment),      
            completable(NewVisited, NewEquipment, Target)
        )
    ).
