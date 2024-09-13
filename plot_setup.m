function plot_setup()

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
   
    % mikrofoni na stropu
    mic_18 = [0,-0.6,-1.13];
    mic_17 = [5.4,-0.6,-1.13];
    mic_19 = [0,5.4,-1.1];
    mic_20 = [5.4,5.4,-1.1];
    
    
    % Plot the microphone points
    figure;
    hold on;
    grid on;
    axis equal;
    
    % plot ceiling mics
    plot3(mic_18(1), mic_18(2), mic_18(3), 'ro', 'MarkerFaceColor', 'r');
    text(mic_18(1),mic_18(2),mic_18(3), 'Ceiling Mic 1', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    plot3(mic_17(1), mic_17(2), mic_17(3), 'ro', 'MarkerFaceColor', 'r');
    text(mic_17(1),mic_17(2),mic_17(3), 'Ceiling Mic 2', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    plot3(mic_19(1), mic_19(2), mic_19(3), 'ro', 'MarkerFaceColor', 'r');
    text(mic_19(1),mic_19(2),mic_19(3), 'Ceiling Mic 3', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    plot3(mic_20(1), mic_20(2), mic_20(3), 'ro', 'MarkerFaceColor', 'r');
    text(mic_20(1),mic_20(2),mic_20(3), 'Ceiling Mic 4', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
   
    % Plot each mic pair on the AOA frames
    for i = 1:length(mic_positions)
        mic_left = mic_positions{i, 1};
        mic_right = mic_positions{i, 2};
        
        % Plot the microphone points
        plot3(mic_left(1), mic_left(2), mic_left(3), 'ro', 'MarkerFaceColor', 'r');
        plot3(mic_right(1), mic_right(2), mic_right(3), 'ro', 'MarkerFaceColor', 'r');

        % Add text labels to the microphone points
        % text(mic_left(1), mic_left(2), mic_left(3)+0.05, ['Mic', num2str(2*i-1)], 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
        % text(mic_right(1), mic_right(2), mic_right(3), ['Mic', num2str(2*i)], 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');

        % Connect the microphones in the pair
        plot3([mic_left(1), mic_right(1)], [mic_left(2), mic_right(2)], [mic_left(3), mic_right(3)], 'k--', 'LineWidth', 0.5, 'Color', [0, 0, 0, 0.5]);
    end
    
    % Additional connections to form frames
    % Frame 1 connections    
    text(mic_positions{1, 1}(1),mic_positions{1, 1}(2),mic_positions{1, 1}(3), 'Frame 1', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    plot3([mic_positions{1,1}(1), mic_positions{2,2}(1)], [mic_positions{1,1}(2), mic_positions{2,2}(2)], [mic_positions{1,1}(3), mic_positions{2,2}(3)],  'LineWidth', 1, 'Color', [0, 0, 0, 0.5]);
    plot3([mic_positions{1,2}(1), mic_positions{2,1}(1)], [mic_positions{1,2}(2), mic_positions{2,1}(2)], [mic_positions{1,2}(3), mic_positions{2,1}(3)],  'LineWidth', 1, 'Color', [0, 0, 0, 0.5]);
    plot3([mic_positions{1,2}(1), mic_positions{1,2}(1)], [mic_positions{1,2}(2), 0], [mic_positions{1,2}(3), mic_positions{2,2}(3)],  'LineWidth', 1, 'Color', [0, 0, 0, 0.5]);
    plot3([mic_positions{2,2}(1), mic_positions{1,2}(1)], [mic_positions{2,2}(2), 0], [mic_positions{2,2}(3), mic_positions{2,2}(3)], 'LineWidth', 1, 'Color', [0, 0, 0, 0.5]);

    % Frame 2 connections
    text(mic_positions{3, 1}(1),mic_positions{3, 1}(2),mic_positions{3, 1}(3), 'Frame 2', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    plot3([mic_positions{3,1}(1), mic_positions{4,2}(1)], [mic_positions{3,1}(2), mic_positions{4,2}(2)], [mic_positions{3,1}(3), mic_positions{4,2}(3)],  'LineWidth', 1, 'Color', [0, 0, 0, 0.5]);
    plot3([mic_positions{3,2}(1), mic_positions{4,1}(1)], [mic_positions{3,2}(2), mic_positions{4,1}(2)], [mic_positions{3,2}(3), mic_positions{4,1}(3)], 'LineWidth', 1, 'Color', [0, 0, 0, 0.5]);
    plot3([mic_positions{3,2}(1), mic_positions{3,2}(1)], [mic_positions{3,2}(2), 0.22], [mic_positions{3,2}(3), mic_positions{4,2}(3)],  'LineWidth', 1, 'Color', [0, 0, 0, 0.5]);
    plot3([mic_positions{4,2}(1), mic_positions{3,2}(1)], [mic_positions{4,2}(2), 0.22], [mic_positions{4,2}(3), mic_positions{4,2}(3)], 'LineWidth', 1, 'Color', [0, 0, 0, 0.5]);

    % Frame 3 connections
    text(mic_positions{5, 1}(1),mic_positions{5, 1}(2),mic_positions{5, 1}(3), 'Frame 3', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');    
    plot3([mic_positions{5,1}(1), mic_positions{6,2}(1)], [mic_positions{5,1}(2), mic_positions{6,2}(2)], [mic_positions{5,1}(3), mic_positions{6,2}(3)],  'LineWidth', 1, 'Color', [0, 0, 0, 0.5]);
    plot3([mic_positions{5,2}(1), mic_positions{6,1}(1)], [mic_positions{5,2}(2), mic_positions{6,1}(2)], [mic_positions{5,2}(3), mic_positions{6,1}(3)],  'LineWidth', 1, 'Color', [0, 0, 0, 0.5]);
    plot3([mic_positions{5,2}(1), mic_positions{5,2}(1)], [mic_positions{5,2}(2), mic_positions{5,2}(2)], [mic_positions{5,2}(3), mic_positions{6,2}(3)],  'LineWidth', 1, 'Color', [0, 0, 0, 0.5]);
    plot3([mic_positions{6,2}(1), mic_positions{5,2}(1)], [mic_positions{6,2}(2), mic_positions{5,2}(2)], [mic_positions{6,2}(3), mic_positions{6,2}(3)],  'LineWidth', 1, 'Color', [0, 0, 0, 0.5]);

    % Frame 4 connections
    text(mic_positions{7, 1}(1),mic_positions{7, 1}(2),mic_positions{7, 1}(3), 'Frame 4', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    plot3([mic_positions{7,1}(1), mic_positions{8,2}(1)], [mic_positions{7,1}(2), mic_positions{8,2}(2)], [mic_positions{7,1}(3), mic_positions{8,2}(3)],  'LineWidth',1, 'Color', [0, 0, 0, 0.5]);
    plot3([mic_positions{7,2}(1), mic_positions{8,1}(1)], [mic_positions{7,2}(2), mic_positions{8,1}(2)], [mic_positions{7,2}(3), mic_positions{8,1}(3)],  'LineWidth',1, 'Color', [0, 0, 0, 0.5]);
    plot3([mic_positions{7,2}(1), mic_positions{7,2}(1)], [mic_positions{7,2}(2), mic_positions{7,2}(2)], [mic_positions{7,2}(3), mic_positions{8,2}(3)],  'LineWidth',1, 'Color', [0, 0, 0, 0.5]);
    plot3([mic_positions{8,2}(1), mic_positions{7,2}(1)], [mic_positions{8,2}(2), mic_positions{7,2}(2)], [mic_positions{8,2}(3), mic_positions{8,2}(3)],  'LineWidth',1, 'Color', [0, 0, 0, 0.5]);


    % Set labels and title
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    title('Spatial arrangement of all used hardware');

    % Adjust axis directions
    set(gca, 'XDir', 'normal'); % x-axis to the right
    set(gca, 'YDir', 'reverse'); % y-axis towards the observer
    set(gca, 'ZDir', 'reverse'); % z-axis down

    view(3); % Set the view to 3D
    hold off;
end

