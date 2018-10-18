% Tile adjacency definition
adj((X1,Y1),(X2,Y2)) :-
    tile((X1,Y1)),
    tile((X2,Y2)),
    |X1-X2| + |Y1-Y2| == 1.

% Players start
{ start(T, C) : color(C) } :- sprite(T, player, C).

% Players touch the first tile they start on
{ touch(T, C) : color(C) } :- sprite(T, player, C).

% The players finish is wherever their same-colored goal is
{ finish(T, C) : color(C) } :- sprite(T, goal, C).

% ------ possible navigation paths -------

% Walking rules:

% You can walk on adjacent tiles
{ touch(T2, C): adj(T1,T2) } :- touch(T1, C).

% You can never walk through a wall
:- sprite(T, wall, none), touch(T, C).

% Door rules:
% You can never walk through a different colored door
% I love that doors are a special case of a wall. Doorwall ;) 
:- sprite(T, door, C1), touch(T, C2), C1 != C2.

% Swapping rules:
% This is too broad! It doesn't really capture the temporal nature of swapping.
% That is, just because I have ever been able to get to my goal
% doesn't mean that I can end up there at the same time as every other player
% { touch((X2, Y2), C1) } :- 
%     touch((X1, Y1), C1), touch((X2, Y2), C2), X1=X2, Y1!=Y2, C1!=C2.

% { touch((X2, Y2), C2) } :- 
%     touch((X1, Y1), C1), touch((X2, Y2), C2), Y1=Y2, X1!=X2, C1!=C2.

% move(T, C) :- touch(T, C).

% swap(X1, Y1, C1, X2, Y2, C2) :- touch((X1, Y1), C1), 
%                                 touch((X2, Y2), C2), 
%                                 Y1=Y2, 
%                                 X1!=X2, 
%                                 C1!=C2.

% swap(X1, Y1, C1, X2, Y2, C2) :- touch((X1, Y1), C1), 
%                                 touch((X2, Y2), C2), 
%                                 Y1!=Y2, 
%                                 X1=X2, 
%                                 C1!=C2.
% -----------------------------------------

% There has to exist a DAG for this level
% That is, there is some 
% start -> { move;swap } -> finish for every player
% path(C) :- start(T, C),
%             { move(T, C); swap(X1, Y1, C, X2, Y2, C2) }, % some number of moves and swaps
%             finish(T, C).

% This is the problem. Completion isn't merely touching your goal
% Completion should be touching your goal at the same time as everyone else
completed(C) :- finish(T, C), touch(T, C).

% Reject any level where the finish tile was not touched by each color token
:- not number_of_players { completed(C) : color(C), player(C, player) }.

% The number of spaces touched by every player must equal number_of_moves -- BUG: counts overall total num moves
:- not {touch(T,C): player(C, player)} == number_of_moves * number_of_players.

#show touch/2.
