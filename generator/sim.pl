% Tile adjacency
adj((X1,Y1),(X2,Y2)) :-
    tile((X1,Y1)),
    tile((X2,Y2)),
    |X1-X2| + |Y1-Y2| == 1.

% Players can reach their goal
{ touch(T, C) : color(C) } :- sprite(T, player, C).
{ finish(T, C) : color(C) } :- sprite(T, goal, C).

% ------ possible navigation paths -------

% Basic movement reachability
{ touch(T2, C): adj(T1,T2) } :- touch(T1, C).

% You can never walk through a different colored door
% I love that doors are a special case of a wall. Doorwall ;) 
:- sprite(T,door, C1), touch(T, C2), C1 != C2.

% you can never walk through a wall
:- sprite(T,wall, none), touch(T, C).

% TODO Touching is possible if a tile I have touched
% and a tile another player has touch share an X or Y.
{ touch((X1, Y1), C1);touch((X2, Y2), C2) } :- 
    touch((X1, Y1), C1), touch((X2, Y2), C2), X1=X2.

{ touch((X1, Y1), C1);touch((X2, Y2), C2) } :- 
    touch((X1, Y1), C1), touch((X2, Y2), C2), Y1=Y2.

% { touch((X2, Y2), C1) } :- 
%     touch((X1, Y1), C1), touch((X2, Y2), C2), X1=X2.

% { touch((X2, Y2), C1) } :- 
%     touch((X1, Y1), C1), touch((X2, Y2), C2), Y1=Y2.
% -----------------------------------------


completed(C) :- finish(T, C), touch(T, C).

% the finish tile must be touched by each color token
:- not number_of_players { completed(C) : color(C) } number_of_players.
:- number_of_moves {touch(T,C): color(C)} number_of_moves.

#show touch/2.