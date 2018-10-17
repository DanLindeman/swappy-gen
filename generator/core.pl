% https://users.soe.ucsc.edu/~amsmith/papers/tciaig-asp4pcg.pdf
#const width=10.
#const number_of_moves=4.
#const number_of_players=2.
dim(1..width).
tile((X,Y)) :- dim(X), dim(Y).

number_of_players { color(green;blue) } number_of_players.
goal(C, goal) :- color(C).
door(C, door) :- color(C).
player(C, player) :- color(C).
wall(none, wall).

% tiles have at most one non-floor type 
0 { sprite(T, S, C) : goal(C, S)} 1 :- tile(T).
0 { sprite(T, S, C) : door(C, S)} 1 :- tile(T).
0 { sprite(T, S, C) : wall(C, S)} 1 :- tile(T).

% are players special cases where having many types is okay?
0 { sprite(T, S, C) : player(C, S)} 1 :- tile(T).

% DEBUG Swapping -- make a wall at y=5
:- not width {sprite((X, 5), wall, none): dim(5)} width.
:- not sprite((1,1), player, green).
:- not sprite((9,10), goal, green).
:- not sprite((10,10), player, blue).
:- not sprite((1,2), goal, green).

% There is one goal and one player token for every color
:- not number_of_players { sprite(T, goal, C) } number_of_players.
:- not number_of_players { sprite(T, player, C) } number_of_players.

% Walls don't overlap goals and characters
:- sprite(T, wall, C), sprite(T, player, C).
:- sprite(T, wall, C), sprite(T, player, C).
:- sprite(T, wall, C), sprite(T, goal, C).
:- sprite(T, wall, C), sprite(T, door, C).

% players do not start on goals -- DEBUG feature
:- sprite(T, player, C1), sprite(T, goal, C2).

% % These might be non-constraints ------------

% % Players are not adjacent to goals
% 0 { sprite(T1,green_character) : adj(T1,T2) } 0 :- sprite(T2,green_goal).
% 0 { sprite(T1,blue_character) : adj(T1,T2) } 0 :- sprite(T2,blue_goal).

% % Players are not adjacent to each other
% 0 { sprite(T1,green_character) : adj(T1,T2) } 0 :- sprite(T2,blue_character).

% % Goals are not adjacent to each other
% 0 { sprite(T1,green_goal) : adj(T1,T2) } 0 :- sprite(T2,blue_goal).

% There are wall sprites in 50% of tiles, doors in 10%
:- not width*width/2 { sprite(T, wall, C)} width*width/2.
:- not width*width/2 { sprite(T, door, C)} width*width/2.
% :- 1 { sprite(T, door, C)} 1.

% --------------------------------------------

#show sprite/3.