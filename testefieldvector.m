clear;
clc;

[x,y] = meshgrid(-200:10:200,-200:10:200);

reference = [0;0];

Kn = 0.006 ;
path_radius = 1000; % Defines how far from the target the drone should circle
alfa_t = 0; % Constant value

R = [cos(alfa_t) -sin(alfa_t); sin(alfa_t) cos(alfa_t)]; % Rotation matrix from inertial to reference

E = [0 1; -1 0]; % Given

for i = 1:length(x)
    
    for j = 1:length(y)

        r = R'*([x(i,j);y(i,j)] - reference);

        phi = r'*r; % It is also = rx^2 + ry^2

        grad_phi = [2*r(1) ; 2*r(2)];%[2*r(1); 2*r(2)]; % Gradient is the vector [dphi/dx; dphi/dy]

        e = phi - path_radius;

        v = E*grad_phi - Kn*e*grad_phi; % Vector field in the UAV position

        md = v/norm(v); % Unit orientation value for the vector field in the UAV position
        
        V(i,j) = md(2); 
        U(i,j) = md(1);
    end      
end

quiver(x,y,5*U,5*V,0);