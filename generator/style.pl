% Stylistic preference for Swappy levels

% walls have exactly-two neighboring walls
2 { sprite(T2,wall, none) : adj(T1,T2) } 2 :- sprite(T1,wall, none).

% Doors have two walls on their sides
2 { sprite(T2, wall, none) : adj(T1,T2) } 2 :- sprite(T1, door, C).

% Doors are never next to each other
:- sprite(T1, door, C1), sprite(T2, door, C2), adj(T1, T2).
