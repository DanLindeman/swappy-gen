#const width=10.
#const number_of_moves=4.
#const number_of_players=2.
dim(1..width).
tile((X,Y)) :- dim(X), dim(Y).

number_of_players { color(green;red;blue;yellow) } number_of_players.
door(C, door) :- color(C).
wall(none, wall).
goal(C, goal) :- color(C).
player(C, player) :- color(C).

% tiles have at most one non-floor type 
0 { sprite(T, S, C) : goal(C, S) } 1 :- tile(T).
0 { sprite(T, S, C) : door(C, S) } 1 :- tile(T).
0 { sprite(T, S, C) : wall(C, S) } 1 :- tile(T).
0 { sprite(T, S, C) : player(C, S)} 1 :- tile(T).

% Have correct player and goal count
:- { sprite(T, goal, C) } != number_of_players.
:- { sprite(T, player, C) } != number_of_players.

% No Duplicate players
:- sprite(T1, player, C1), sprite(T2, player, C2), C1==C2, T1!=T2.

% No Duplicate goals
:- sprite(T1, goal, C1), sprite(T2, goal, C2), C1==C2, T1!=T2.

% Walls don't overlap goals and characters
:- sprite(T, wall, C), sprite(T, player, C).
:- sprite(T, wall, C), sprite(T, goal, C).
:- sprite(T, wall, C), sprite(T, door, C).

% players do not start on goals
:- sprite(T, player, C1), sprite(T, goal, C2).

% Don't put players or goals on doors.
:- sprite(T, player, C1), sprite(T, door, C2).
:- sprite(T, goal, C1), sprite(T, door, C2).

% There are wall sprites in 50% of tiles, doors in 33-50%
:- not width*width/2 { sprite(T, wall, C)} width*width/2.
:- not width*width/3 { sprite(T, door, C)} width*width/2.

#show sprite/3.