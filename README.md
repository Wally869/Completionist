# Completionist  

Inspired by the development of Randomizers for retro games (Legend of Zelda, Metroid...). 

Completionist requires a knowledge base defining a upon 2 predicates: 
- contains/2, which takes the name of the location and the item contained there
- rq/2, which also takes the name of the location, and the items required to access this location. This is short-hand for requires which is used in the generation process described below. 

A big improvement on the initial version of Completionist is the added support for alternative access conditions: you can specify multiple sets of items to access a given location.  
This is inspired by Ocarina of Time where, for example, a location might be accessible by destroying a boulder either with bombs or with the hammer.  

Specifying such location would look like this:  
```prolog
rq(grotto_under_boulder, [[bombs], [hammer]]).
```

Another big difference from the initial version is the addition of world generation.   
I've introduced a generator that takes the list of items and locations, and sets these items randomly by using assertz. 
Then, it runs the completable predicate to check if the target location can be reached with the current positioning of items.  
If it doesn't work, it removes all items from where they were positioned and tries another configuration.  

A side effect from this process is that the "contains" predicate is defined as dynamic, to be imported from "dynamics.pl".


## Example  

I have included a small example. The "world_def.pl" file contains the definition of a few items and locations reminiscent of Ocarina of Time.  
This file is imported in generator and can be modified to suit your own world generation in a simple manner. 

Using swipl or other prolog interpreter:   
```prolog    
% we import generator, which imports the dynamics, completionist and world_def knowledge bases
1 ?- [generator].
true.

% then run generate, which sets items at locations and check if the generated seed is completeable
2 ?- generate().
true.

% generation was successful, we check where the items have been set.
3 ?- contains(L, I).
L = mido_house,
I = sword ;
L = sword_chest,
I = bow ;
L = hyrule_castle,
I = light_arrows ;
L = deku_tree,
I = ocarina.
```