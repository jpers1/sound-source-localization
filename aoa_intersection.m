
theta_V_deg = 50.209670461576370; % vertical angle
theta_H_deg = 110.009779358049; % horizontal angle

theta_V = deg2rad(theta_V_deg);
theta_H = deg2rad(theta_H_deg);

nV = [0; cos(theta_V); -sin(theta_V)]; % normal vector for vertical plane (yz-plane)
nH = [-sin(theta_H); cos(theta_H); 0]; % normal vector for horizontal plane (xy-plane)

% Calculate the direction vector of the line of intersection (cross product)
d = cross(nV, nH);

P0 = [0.5; 0; 0.5];

% Define a range for the parameter t to plot the line
t = linspace(-10, 5, 100);

% Calculate points on the line of intersection
line_points = P0 + d * t;

% Define a grid for the planes
[x, y] = meshgrid(linspace(-10, 5, 100), linspace(-10,5, 100));

% Define the planes
% Plane 1 (Vertical plane, yz-plane)
z1 = (nV(2) * y + nV(1) * x) / -nV(3);
% Plane 2 (Horizontal plane, xy-plane)
z2 = (nH(2) * y + nH(1) * x) / -nH(3);


% Define microphone positions
Mic1 = [0, 0, 0];
Mic2 = [1, 0, 0];
Mic3 = [-0.02, 0, 0];
Mic4 = [0, 0, 1];
mic_positions = [Mic1; Mic2; Mic3; Mic4];
% Plot the planes
figure;
hold on;
% surf(x, y, z1, 'FaceAlpha', 0.5, 'EdgeColor', 'none');
% surf(x, y, z2, 'FaceAlpha', 0.5, 'EdgeColor', 'none');
% surf(x, y, z1, 'FaceAlpha', 0.5, 'EdgeColor', 'none', 'FaceColor', 'r'); % Plane 1 in red
% surf(x, y, z2, 'FaceAlpha', 0.5, 'EdgeColor', 'none', 'FaceColor', 'b'); % Plane 2 in blue

% Plot the line of intersection
plot3(line_points(1, :), line_points(2, :), line_points(3, :), 'k', 'LineWidth', 2);
zlim([0,4]);

% Plot the microphone points
plot3(Mic1(1), Mic1(2), Mic1(3), 'ro', 'MarkerFaceColor', 'r'); % Mic1 in green
plot3(Mic2(1), Mic2(2), Mic2(3), 'ro', 'MarkerFaceColor', 'r'); % Mic2 in red
plot3(Mic3(1), Mic3(2), Mic3(3), 'ro', 'MarkerFaceColor', 'r'); % Mic3 in blue
plot3(Mic4(1), Mic4(2), Mic4(3), 'ro', 'MarkerFaceColor', 'r'); % Mic4 in magenta

% Add text labels to the microphone points
text(Mic1(1), Mic1(2), Mic1(3)+0.05, 'Mic1', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
text(Mic2(1), Mic2(2), Mic2(3), 'Mic2', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
text(Mic3(1), Mic3(2), Mic3(3)+0.25, 'Mic3', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
text(Mic4(1), Mic4(2), Mic4(3), 'Mic4', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');

% Connect the microphone points into a square with one missing edge
plot3([Mic1(1), Mic2(1)], [Mic1(2), Mic2(2)], [Mic1(3), Mic2(3)], 'k--', 'LineWidth', 0.5, 'Color', [0, 0, 0, 0.5]);
%plot3([Mic1(1), Mic3(1)], [Mic1(2), Mic3(2)], [Mic1(3), Mic3(3)], 'k--', 'LineWidth', 0.5, 'Color', [0, 0, 0, 0.5]);
plot3([Mic1(1), Mic4(1)], [Mic1(2), Mic4(2)], [Mic1(3), Mic4(3)], 'k--', 'LineWidth', 0.5, 'Color', [0, 0, 0, 0.5]);
plot3([Mic2(1), 1], [Mic2(2), 0], [Mic2(3), 1], 'k--', 'LineWidth', 0.5, 'Color', [0, 0, 0, 0.5]);
%plot3([Mic3(1), Mic4(1)], [Mic3(2), Mic4(2)], [Mic3(3), Mic4(3)], 'k--', 'LineWidth', 0.5, 'Color', [0, 0, 0, 0.5]);
plot3([Mic4(1), 1], [Mic4(2), 0], [Mic4(3),1], 'k--', 'LineWidth', 0.5, 'Color', [0, 0, 0, 0.5]);

% Set labels and title
xlabel('X');
ylabel('Y');
zlabel('Z');
title('Intersection of Two AoA Planes');

% Adjust axis directions
set(gca, 'XDir', 'normal'); % x-axis to the right
set(gca, 'YDir', 'reverse'); % y-axis towards the observer
set(gca, 'ZDir', 'reverse'); % z-axis down

grid on;
axis equal;
view([45, 45]); % Adjust the view for better visualization
hold off;