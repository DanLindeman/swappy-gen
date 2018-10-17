% Stylistic preference for Swappy levels

% 2 { sprite(T1, door, C): adj(T1, T2), color(C) } 2 :- sprite(T2, wall, none).
{ sprite(T1, door, C): adj(T1, T2), adj(T1, T3), color(C) } :- sprite(T2, wall, none), sprite(T3, wall, none).