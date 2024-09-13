function plot_all_mics(horizontal_angles, vertical_angles, horizontal_std, vertical_std)
    % Old microphone positions
    % mic_positions = {
    %     [0, 0, 0], [1.02, 0, 0];           % Mic 1 (horizontal)
    %     [0, 0, 0], [0, 0, 1.02];           % Mic 2 (vertical)
    %     [4.34, 0, 0], [5.36, 0, 0];        % Mic 3 (horizontal)
    %     [4.34, 0, 0], [4.26, 0, 1.02];     % Mic 4 (vertical)
    %     [0.96, 6.15, 0], [-0.05, 6.15, 0]; % Mic 5 (horizontal)
    %     [0.96, 6.15, 0], [0.96, 6.15, 1.02]; % Mic 6 (vertical)
    %     [3.93, 6.15, -0.25], [2.91, 6.15, -0.25]; % Mic 7 (horizontal)
    %     [3.93, 6.15, -0.25], [3.93, 6.15, 0.77];  % Mic 8 (vertical)
    % };
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

    source = [2.9,3,1.24];
    % Plot the source and microphone points
    figure;
    hold on;
    grid on;
    axis equal;
    
    plot3(source(1), source(2), source(3), 'go', 'MarkerFaceColor', 'g');

    % Plot each mic pair
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
    plot3([mic_positions{1,1}(1), mic_positions{2,2}(1)], [mic_positions{1,1}(2), mic_positions{2,2}(2)], [mic_positions{1,1}(3), mic_positions{2,2}(3)], 'k--', 'LineWidth', 0.5, 'Color', [0, 0, 0, 0.5]);
    plot3([mic_positions{1,2}(1), mic_positions{2,1}(1)], [mic_positions{1,2}(2), mic_positions{2,1}(2)], [mic_positions{1,2}(3), mic_positions{2,1}(3)], 'k--', 'LineWidth', 0.5, 'Color', [0, 0, 0, 0.5]);
    plot3([mic_positions{1,2}(1), mic_positions{1,2}(1)], [mic_positions{1,2}(2), 0], [mic_positions{1,2}(3), mic_positions{2,2}(3)], 'k--', 'LineWidth', 0.5, 'Color', [0, 0, 0, 0.5]);
    plot3([mic_positions{2,2}(1), mic_positions{1,2}(1)], [mic_positions{2,2}(2), 0], [mic_positions{2,2}(3), mic_positions{2,2}(3)], 'k--', 'LineWidth', 0.5, 'Color', [0, 0, 0, 0.5]);

    % Frame 2 connections
    text(mic_positions{3, 1}(1),mic_positions{3, 1}(2),mic_positions{3, 1}(3), 'Frame 2', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    plot3([mic_positions{3,1}(1), mic_positions{4,2}(1)], [mic_positions{3,1}(2), mic_positions{4,2}(2)], [mic_positions{3,1}(3), mic_positions{4,2}(3)], 'k--', 'LineWidth', 0.5, 'Color', [0, 0, 0, 0.5]);
    plot3([mic_positions{3,2}(1), mic_positions{4,1}(1)], [mic_positions{3,2}(2), mic_positions{4,1}(2)], [mic_positions{3,2}(3), mic_positions{4,1}(3)], 'k--', 'LineWidth', 0.5, 'Color', [0, 0, 0, 0.5]);
    plot3([mic_positions{3,2}(1), mic_positions{3,2}(1)], [mic_positions{3,2}(2), 0.22], [mic_positions{3,2}(3), mic_positions{4,2}(3)], 'k--', 'LineWidth', 0.5, 'Color', [0, 0, 0, 0.5]);
    plot3([mic_positions{4,2}(1), mic_positions{3,2}(1)], [mic_positions{4,2}(2), 0.22], [mic_positions{4,2}(3), mic_positions{4,2}(3)], 'k--', 'LineWidth', 0.5, 'Color', [0, 0, 0, 0.5]);

    % Frame 3 connections
    text(mic_positions{5, 1}(1),mic_positions{5, 1}(2),mic_positions{5, 1}(3), 'Frame 3', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');    
    plot3([mic_positions{5,1}(1), mic_positions{6,2}(1)], [mic_positions{5,1}(2), mic_positions{6,2}(2)], [mic_positions{5,1}(3), mic_positions{6,2}(3)], 'k--', 'LineWidth', 0.5, 'Color', [0, 0, 0, 0.5]);
    plot3([mic_positions{5,2}(1), mic_positions{6,1}(1)], [mic_positions{5,2}(2), mic_positions{6,1}(2)], [mic_positions{5,2}(3), mic_positions{6,1}(3)], 'k--', 'LineWidth', 0.5, 'Color', [0, 0, 0, 0.5]);
    plot3([mic_positions{5,2}(1), mic_positions{5,2}(1)], [mic_positions{5,2}(2), mic_positions{5,2}(2)], [mic_positions{5,2}(3), mic_positions{6,2}(3)], 'k--', 'LineWidth', 0.5, 'Color', [0, 0, 0, 0.5]);
    plot3([mic_positions{6,2}(1), mic_positions{5,2}(1)], [mic_positions{6,2}(2), mic_positions{5,2}(2)], [mic_positions{6,2}(3), mic_positions{6,2}(3)], 'k--', 'LineWidth', 0.5, 'Color', [0, 0, 0, 0.5]);

    % Frame 4 connections
    text(mic_positions{7, 1}(1),mic_positions{7, 1}(2),mic_positions{7, 1}(3), 'Frame 4', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    plot3([mic_positions{7,1}(1), mic_positions{8,2}(1)], [mic_positions{7,1}(2), mic_positions{8,2}(2)], [mic_positions{7,1}(3), mic_positions{8,2}(3)], 'k--', 'LineWidth', 0.5, 'Color', [0, 0, 0, 0.5]);
    plot3([mic_positions{7,2}(1), mic_positions{8,1}(1)], [mic_positions{7,2}(2), mic_positions{8,1}(2)], [mic_positions{7,2}(3), mic_positions{8,1}(3)], 'k--', 'LineWidth', 0.5, 'Color', [0, 0, 0, 0.5]);
    plot3([mic_positions{7,2}(1), mic_positions{7,2}(1)], [mic_positions{7,2}(2), mic_positions{7,2}(2)], [mic_positions{7,2}(3), mic_positions{8,2}(3)], 'k--', 'LineWidth', 0.5, 'Color', [0, 0, 0, 0.5]);
    plot3([mic_positions{8,2}(1), mic_positions{7,2}(1)], [mic_positions{8,2}(2), mic_positions{7,2}(2)], [mic_positions{8,2}(3), mic_positions{8,2}(3)], 'k--', 'LineWidth', 0.5, 'Color', [0, 0, 0, 0.5]);
    % P0 = {[0.5; 0; 0.5];
    %         [4.9; 0; 0.5];
    %         [0.45; 6.15; 0.5];
    %         [3.55; 6.15; 0.25]};
    P0 = {[0.5; 0; 0.5];
            [4.5; 0; 0.5];
            [0.1; 6.34; 0.5];
            [3.85; 6.34; 0.29]};
    % Plot lines of intersection based on AoA estimations
    for i = 1:length(mic_positions)/2
        % Get the angles in radians
        theta_V = deg2rad(vertical_angles(2*i));
        if i>2
            theta_V = theta_V*-1;
        end
        theta_H = deg2rad(horizontal_angles(2*i -1));
        
        % Define normal vectors for the planes
        nV = [0; cos(theta_V); -sin(theta_V)];
        nH = [-sin(theta_H); cos(theta_H); 0];
        
        % Calculate the direction vector of the line of intersection
        d = cross(nV, nH);
        
        % Assume the line passes through the center of the frame
        center_point = P0{i};
        
        % Define a range for the parameter t to plot the line
        t = linspace(-5, 5, 100);
        
        % Calculate points on the line of intersection
        line_points = center_point + d * t;
        
        % Plot the line of intersection
        plot3(line_points(1, :), line_points(2, :), line_points(3, :), 'k', 'LineWidth', 1.2);
    end

    % Set labels and title
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    title('Intersection of AoA estimations');

    % Adjust axis directions
    set(gca, 'XDir', 'normal'); % x-axis to the right
    set(gca, 'YDir', 'reverse'); % y-axis towards the observer
    set(gca, 'ZDir', 'reverse'); % z-axis down

    view(3); % Set the view to 3D

    prepare_latex_table(mic_positions, source, horizontal_angles, vertical_angles, horizontal_std, vertical_std)
    hold off;
end


function prepare_latex_table(mic_positions, src_pos, horizontal_angles, vertical_angles, std_values_horizontal, std_values_vertical)

    middle_points = zeros(size(mic_positions,1),3);
    for i = 1:size(mic_positions,1)
        mic1 = mic_positions{i,1};
        mic2 = mic_positions{i,2};
        middle_points(i,:) = mean([mic1;mic2]);
    end
    fprintf("NOTE: The following ground truth values are only valid for source positions \n" + ...
         " in the range x = [0.51,4.55], y=[0,6.34], z=[0.51, 4 (the floor of the room is the limit)]\n");

    % Define variables for LaTeX table
    latex_table = "\\begin{table}[htb!]\n\\centering\n\\resizebox{\\columnwidth}{!}{\n\\begin{tabular}{|l|l|l|l|l|}\n\\hline\n";
    latex_table = strcat(latex_table, "\\textbf{AOA Frame} & \\textbf{Horizontal GT [\\textdegree]} & \\textbf{Horizontal AOA [\\textdegree]} & \\textbf{Vertical GT [\\textdegree]} & \\textbf{Vertical AOA [\\textdegree]} \\\\ \\hline\n");
    
    % Calculate ground truth and measured AOA for each sensor
    for i = 1:4
        switch i
            case 1
                aoa_h = rad2deg(atan((src_pos(2) - middle_points(1,2)) / (src_pos(1) - middle_points(1,1))));
                aoa_v = rad2deg(atan((src_pos(2) - middle_points(2,2)) / (src_pos(3) - middle_points(2,3))));
                gt_h = aoa_h;
                gt_v = aoa_v;
                measured_h = horizontal_angles(1);
                measured_v = vertical_angles(2);
                std_h = std_values_horizontal(1);
                std_v = std_values_vertical(2);
            case 2
                aoa_h = 180 - rad2deg(atan(abs(src_pos(2) - middle_points(3,2)) / abs(src_pos(1) - middle_points(3,1))));
                aoa_v = rad2deg(atan((src_pos(2) - middle_points(4,2)) / (src_pos(3) - middle_points(4,3))));
                gt_h = aoa_h;
                gt_v = aoa_v;
                measured_h = horizontal_angles(3);
                measured_v = vertical_angles(4);
                std_h = std_values_horizontal(3);
                std_v = std_values_vertical(4);
            case 3
                aoa_h = 90 + rad2deg(atan(abs(src_pos(1) - middle_points(5,1)) / abs(src_pos(2) - middle_points(5,2))));
                aoa_v = rad2deg(atan(abs(src_pos(2) - middle_points(6,2)) / abs(src_pos(3) - middle_points(6,3))));
                gt_h = aoa_h;
                gt_v = aoa_v;
                measured_h = horizontal_angles(5);
                measured_v = vertical_angles(6);
                std_h = std_values_horizontal(5);
                std_v = std_values_vertical(6);
            case 4
                aoa_h = rad2deg(atan(abs(src_pos(2) - middle_points(7,2)) / abs(src_pos(1) - middle_points(7,1))));
                aoa_v = rad2deg(atan(abs(src_pos(2) - middle_points(8,2)) / abs(src_pos(3) - middle_points(8,3))));
                gt_h = aoa_h;
                gt_v = aoa_v;
                measured_h = horizontal_angles(7);
                measured_v = vertical_angles(8);
                std_h = std_values_horizontal(7);
                std_v = std_values_vertical(8);
        end

        % Append values to LaTeX table string
        latex_table = strcat(latex_table, sprintf("%d & %.2f & %.2f $\\\\pm$ %.2f & %.2f & %.2f $\\\\pm$ %.2f\\\\\\\\ \n", ...
                    i, gt_h, measured_h, std_h, gt_v, measured_v, std_v));
    end
    
    % Close the table
    latex_table = strcat(latex_table, "\\hline \n\\end{tabular}\n}\n\\caption{Quantitative AOA estimation results.}\n\\label{tab:aoaresults}\n\\end{table}");
    
    % Save to a .txt file
    fileID = fopen('aoa_results_table.txt', 'w');
    fprintf(fileID, latex_table);
    fclose(fileID);
    
    % Output the LaTeX table to the MATLAB terminal (optional)
    fprintf("\n Results are automatically inserted into a latex table with \n" + ...
        " the Latex code in the file aoa_results_table.txt in this direcotry.\n" + ...
        " Just copy the code into Overleaf and your table is ready.\n");
    %fprintf('%s\n', latex_table);
end