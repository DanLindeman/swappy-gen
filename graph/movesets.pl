% Generate
1 { move(Tile,Color,Turn) : tile(Tile) : player(Color, player) } 1 :- moves(M), Turn = 1..M.

% Define
move(Tile, Color) :- move(Tile,_,Turn).

% https://www.cs.uni-potsdam.de/~torsten/Lehre/ASP/Folien/asp-handout.pdf
% on(D,P,0) :- init on(D,P).
% 1 { move(D,P,T) : disk(D) : peg(P) } 1 :- moves(M), T = 1..M.
% move(D,T) :- move(D, ,T).
% on(D,P,T) :- move(D,P,T).
% on(D,P,T+1) :- on(D,P,T), not move(D,T+1), not moves(T).
% blocked(D-1,P,T+1) :- on(D,P,T), not moves(T).
% blocked(D-1,P,T) :- blocked(D,P,T), disk(D).
% :- move(D,P,T), blocked(D-1,P,T).
% :- move(D,T), on(D,P,T-1), blocked(D,P,T).
% :- not 1 { on(D,P,T) } 1, disk(D), moves(M), T = 1..M.
% :- goal on(D,P), not on(D,P,M), moves(M).
% door_traversable(T, C) :- touch(T, C), sprite(T, door, C).

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