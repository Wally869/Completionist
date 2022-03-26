# Completionist  

Inspired by the development of Randomizers for retro games (Legend of Zelda, Metroid...). 

Completionist requires a knowledge base defining a predicate location/3.  
Location acts like a struct with following fields:  
- Name  
- Items at location  
- Items required  

Once the knowledge base is defined and imported, you can call the predicate completable/1 from completionist.pl.    
completable/1 takes the name of the target final location and checks if it possible to reach it, starting with no items and no location visited. The user could also specify a starting equipment using completable/3.   

This works by finding all new locations to visit, i.e. all locations which are accessible with the given inventory and which have not been visited yet, getting all the new items and use these new items to find newly accessible locations.   

Location is defined location/3 but its actual implementation is left to the user.   
You can define it as I have in the sample_world example (all data directly in location), but I think it could be better to define location, items at location and items required separately.  
This would mean the following rule:   
```prolog   
location(Name, ItemsAtLocation, ItemsRequired) :- contains(Name, ItemsAtLocation), requires(Name, ItemsRequired).  

```

This would allow to seperate varyings from invariants for simpler/faster generation: the requirements to access a particular ingame location are unlikely to change, while we may have to check several combinations of item-location to find a valid seed.  


## Example  

I have included a small example. The "sample_world.pl" file contains the definition of a few items and locations reminiscent of Ocarina of Time and enable us to check if a valid path exists to go fight Ganon.       

Using swipl or other prolog interpreter:   
```prolog    
?- ['sample_world.pl'].
?- ['completionist.pl'].  

?- completable(ganon).   

```