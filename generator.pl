?- style_check(-discontiguous).

:- [dynamics, completionist, world_def].


requires(LOCATION, EQUIPMENT) :- rq(LOCATION, EQUIPMENT), !; EQUIPMENT = [].

set_items(LOCATIONS, ITEMS) :- 
    set_item(LOCATIONS, ITEMS, REMAINING_LOCATIONS, REMAINING_ITEMS),
    set_items(REMAINING_LOCATIONS, REMAINING_ITEMS).

set_items(_, []).

set_item([H_LOCATIONS|T_LOCATIONS], [H_ITEMS|T_ITEMS], REMAINING_LOCATIONS, REMAINING_ITEMS) :- 
    terminal_location(H_LOCATIONS) -> (
        REMAINING_LOCATIONS = T_LOCATIONS,
        REMAINING_ITEMS = [H_ITEMS|T_ITEMS]    
    );
    (
        assertz(contains(H_LOCATIONS, H_ITEMS)),
        REMAINING_LOCATIONS = T_LOCATIONS,
        REMAINING_ITEMS = T_ITEMS
    ).

reset_world(LOCATION) :- 
    contains(LOCATION, ITEM),
    retract(contains(LOCATION, ITEM)).

reset_world() :- 
    findall(Location, contains(Location, _), Locations),
    maplist(reset_world, Locations).

generate(TERMINAL_LOCATION) :- 
    reset_world(),
    findall(Location, location(Location), Locations),
    random_permutation(Locations, Shuffled),
    items(Items),
    set_items(Shuffled, Items),
    (
        completable(TERMINAL_LOCATION),
        !
    );
    generate().

generate() :- 
    terminal_location(Target),
    generate(Target).


