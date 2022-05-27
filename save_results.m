function [] = save_results(input)
%S Summary of this function goes here
%   Detailed explanation goes here

global Ts x1 x2 x3 y1 y2 y3 psi1 psi2 psi3 err1 err2 err3 radius

time = input(16)/Ts + 1;

reference = [input(1);input(2)];

x1 = input(3);
y1 = input(4);
psi1 = input(5);

x2 = input(8);
y2 = input(9);
psi2 = input(10);

x3 = input(13);
y3 = input(14);
psi3 = input(15);

err1(time) = norm([x1;y1] - reference) - radius;

err2(time) = norm([x2;y2] - reference) - radius;

err3(time) = norm([x3;y3] - reference) - radius;

err1(err1 == 0) = [];
err2(err2 == 0) = [];
err3(err3 == 0) = [];



end

