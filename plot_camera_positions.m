function plot_camera_positions()

    mic_positions = {
        [0, 0, 0], [1.02, 0, 0];           % Mic 1 (horizontal)
        [0, 0, 0], [0, 0, 1.02];           % Mic 2 (vertical)
        [4.06, 0.22, 0], [5.05, 0.22, 0];        % Mic 3 (horizontal)
        [4.06, 0.22, 0], [4.03, 0.22, 1.02];     % Mic 4 (vertical)
        [0.62, 6.34, 0], [-0.4, 6.34, 0]; % Mic 5 (horizontal)
        [0.62, 6.34, 0], [0.62, 6.34, 1.02]; % Mic 6 (vertical)
        [4.36, 6.34, -0.22], [3.34, 6.34, -0.22]; % Mic 7 (horizontal)
        [4.36, 6.34, -0.22], [4.36, 6.34, 0.79];  % Mic 8 (vertical)
    };
    
    % rocne meritve

    kamera_A = [0,0,0];
    kamera_B = [3.72, 0.04, 0.024];
    kamera_C = [0.6,6.045,0];
    kamera_D = [4.82, 5.925, -0.213];

    % rezultati vision-based kalibracije 

    kamera_A_vision = [0,0,0];
    kamera_B_vision = [4.57, 0.35, -0.09];
    kamera_C_vision = [0.28,6.62,-0.08];
    kamera_D_vision = [4.54, 6.73, -0.35];
    
    
    % Plot the microphone points
    figure;
    hold on;
    grid on;
    axis equal;
    
    h1 = plot3(kamera_A(1), kamera_A(2), kamera_A(3), 'ro', 'MarkerFaceColor', 'g');
    text(kamera_A(1), kamera_A(2), kamera_A(3), 'Camera 1', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    plot3(kamera_B(1), kamera_B(2), kamera_B(3), 'ro', 'MarkerFaceColor', 'g');
    text(kamera_B(1), kamera_B(2), kamera_B(3), 'Camera 2', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    plot3(kamera_C(1), kamera_C(2), kamera_C(3), 'ro', 'MarkerFaceColor', 'g');
    text(kamera_C(1), kamera_C(2), kamera_C(3), 'Camera 3', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    plot3(kamera_D(1), kamera_D(2), kamera_D(3), 'ro', 'MarkerFaceColor', 'g');
    text(kamera_D(1), kamera_D(2), kamera_D(3), 'Camera 4', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');

    h2 = plot3(kamera_A_vision(1), kamera_A_vision(2), kamera_A_vision(3), 'ro', 'MarkerFaceColor', 'b');
    text(kamera_A_vision(1), kamera_A_vision(2), kamera_A_vision(3), 'Camera 1', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    plot3(kamera_B_vision(1), kamera_B_vision(2), kamera_B_vision(3), 'ro', 'MarkerFaceColor', 'b');
   % text(kamera_B_vision(1), kamera_B_vision(2), kamera_B_vision(3), 'Camera 2', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    plot3(kamera_C_vision(1), kamera_C_vision(2), kamera_C_vision(3), 'ro', 'MarkerFaceColor', 'b');
   % text(kamera_C_vision(1), kamera_C_vision(2), kamera_C_vision(3), 'Camera 3', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    plot3(kamera_D_vision(1), kamera_D_vision(2), kamera_D_vision(3), 'ro', 'MarkerFaceColor', 'b');
   % text(kamera_D_vision(1), kamera_D_vision(2), kamera_D_vision(3), 'Camera 4', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
 
 

    % Set labels and title
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    title('Spatial arrangement of all used hardware');

    % Adjust axis directions
    set(gca, 'XDir', 'normal'); % x-axis to the right
    set(gca, 'YDir', 'reverse'); % y-axis towards the observer
    set(gca, 'ZDir', 'reverse'); % z-axis down

    % Add a legend
    legend([h1 h2], {'Manual Measurement', 'Vision-based Calibration'});
    
    view(3); % Set the view to 3D
    hold off;
end

