% Tile adjacency definition
adj((X1,Y1),(X2,Y2)) :-
    tile((X1,Y1)),
    tile((X2,Y2)),
    |X1-X2| + |Y1-Y2| == 1.

% Players start
{ start(T, C) : color(C) } :- sprite(T, player, C).

% Players touch the first tile they start on
{ touch(T, C) : color(C) } :- sprite(T, player, C).

% Players see the first tile they start on
{ see(T, C) : color(C) } :- sprite(T, player, C).

% The players finish is wherever their same-colored goal is
{ finish(T, C) : color(C) } :- sprite(T, goal, C).

% ------ possible navigation paths -------

% Walking rules:

% You can walk on adjacent tiles
{ touch(T2, C) : adj(T1,T2) } :- touch(T1, C).

% You can never walk through a wall
:- sprite(T, wall, none), touch(T, C).

% Door rules:
% You can never walk through a different colored door
% I love that doors are a special case of a wall. Doorwall ;) 
:- sprite(T, door, C1), touch(T, C2), C1 != C2.

% Swapping rules
{ touch((X2, Y2), C1) } :-
    touch((X1, Y1), C1), 
    touch((X2, Y2), C2), 
    X1=X2, 
    Y1!=Y2, 
    C1!=C2.

{ touch((X2, Y2), C2) } :-
    touch((X1, Y1), C1), 
    touch((X2, Y2), C2), 
    Y1=Y2, 
    X1!=X2, 
    C1!=C2.

% You can see anything adjacent to you, regardless of doors between you.
{ see(T2, C): adj(T1,T2) } :- see(T1, C).

% You still can't see through walls.
:- sprite(T, wall, none), see(T, C).

% Don't generate a level where every player can't see a goal.
see_a_goal(C1) :- finish(T, C1), see(T, C2), C1 != C2.
:- player(C, player), not see_a_goal(C).
:- not number_of_players { see_a_goal(C) : color(C), player(C, player) }.

% This is the problem. Completion isn't merely touching your goal
% Completion should be touching your goal at the same time as everyone else
completed(C) :- finish(T, C), touch(T, C).

% Reject any level where the finish tile was not touched by each color token
:- not number_of_players { completed(C) : color(C), player(C, player) }.

% The number of spaces touched by every player must equal number_of_moves -- BUG: counts overall total num moves
% :- not {touch(T,C): player(C, player)} == number_of_moves * number_of_players.

#show touch/2.