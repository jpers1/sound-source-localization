% okvir 1
mic_1 = [0.015,0,0]; % horizontalni stereo par
mic_2 = [1.01,0,0];
mic_3 = [0,0,0]; % vertikalni stereo par
mic_4 = [0,0,1.01];

% okvir 2 
mic_5 = [4.07,0.22,0];
mic_6 = [5.05,0.22,0];
mic_7 = [4.06,0.22,0];
mic_8 = [4.02,0.22,1.01];

% okvir 3 
mic_9 = [0.62 , 6.34, 0 ];
mic_10 = [-0.4, 6.34, 0];
mic_11 = [0.63, 6.34, 0];
mic_12 = [0.63,6.34,1.01];

%okvir 4 
mic_13 = [4.35, 6.34, -0.22];
mic_14 = [3.34, 6.34, -0.22];
mic_15 = [4.36, 6.34, -0.22];
mic_16 = [4.36, 6.34, 0.79];

% mikrofoni na stropu
mic_18 = [0,-0.6,-1.13];
mic_17 = [5.4,-0.6,-1.13];
mic_19 = [0,5.4,-1.1];
mic_20 = [5.4,5.4,-1.1];

mic_positions = [ ...
    mic_17; mic_18; mic_19; mic_20; % mikrofoni na stropu
    mic_1; mic_2; mic_3; mic_4; ... % Frame 1
    mic_5; mic_6; mic_7; mic_8; ... % Frame 2
    mic_9; mic_10; mic_11; mic_12; ... % Frame 3
    mic_13; mic_14; mic_15; mic_16 ... % Frame 4
];

% Input file 
timestamp_dir = '20240805145919';
fprintf("Calculating the delay matrices via GCC-PHAT...\n");
delay_matrices = ssl_clap_automated_experiment_gcc_phat_more_mics(timestamp_dir);

% =============================
% AoA-based initialization (NEW)
% =============================
USE_AOA_INIT   = true;                 % <--- set to true to use AoA seeds
AOAINIT_FILE   = 'AoAintersect.txt';    % written earlier by provide_article_results
AOA_MIN_FRAMES = 2;                     % require at least this many rays used
AOA_MAX_RESID  = Inf;                   % optional gate on RMS residual (m)

aoa_xyz = []; aoa_frames = []; aoa_resid = [];
if USE_AOA_INIT
    [aoa_xyz, aoa_frames, aoa_resid] = load_aoa_inits(AOAINIT_FILE);
    if isempty(aoa_xyz)
        warning('AoA init enabled, but %s not found/empty. Falling back to fixed init.', AOAINIT_FILE);
    else
        fprintf('AoA init: using seeds from %s when available.\n', AOAINIT_FILE);
    end
end

% Optimization parameters
loc_source_init = [2.5, 3.03, 1.1]; % Fallback initial guess for source location
loc_source_gt   = [2.9, 3, 1.24];
max_iter = 100;      % Maximum number of iterations
tol      = 1e-6;     % Convergence tolerance

estimated_src_locations = [];
avg_times = [];

figure;
% Initialize an array to store plot handles for the legend
plot_handles = [];
colors = lines(length(delay_matrices)); % 'lines' colormap gives distinct colors
number_of_iterations = []; % number of iterations the algorithm took to converge

fprintf("Running the optimization algorithm...\n")
for i = 1:length(delay_matrices)

    % Select initializer: AoA seed if valid, else fallback
    loc0 = loc_source_init;
    if USE_AOA_INIT && ~isempty(aoa_xyz) && i <= size(aoa_xyz,1)
        xyz_i   = aoa_xyz(i, :);
        f_i     = [];
        r_i     = [];
        if ~isempty(aoa_frames), f_i = aoa_frames(i); end
        if ~isempty(aoa_resid),  r_i = aoa_resid(i);  end
        if all(isfinite(xyz_i)) && (isempty(f_i) || f_i >= AOA_MIN_FRAMES) ...
                && (isempty(r_i) || isnan(r_i) || r_i <= AOA_MAX_RESID)
            loc0 = xyz_i;
        end
    end

    delay_matrix = delay_matrices{i};
    [loc_source_est, residuals, average_iter_time] = ...
        gauss_newton_localization_single(delay_matrix, mic_positions, loc0, max_iter, tol);

    estimated_src_locations = [estimated_src_locations; loc_source_est];
    avg_times = [avg_times; average_iter_time];

    % Plot each residual series and store the plot handle
    hold on;
    h = plot(residuals, '-o', 'LineWidth', 2, 'MarkerSize', 6, ...
             'MarkerFaceColor', colors(i,:), 'Color', colors(i,:));
    plot_handles = [plot_handles, h];  % Store the plot handle for the legend
    hold off;

    number_of_iterations = [number_of_iterations; length(residuals)];
end

xlabel('Iteration', 'FontSize', 12);
ylabel('Residual Norm', 'FontSize', 12);
title('TDOA-based localization via Gauss-Newton');
grid on;
set(gca, 'FontSize', 12, 'LineWidth', 1.5);

legend_text = arrayfun(@(x) sprintf('Transient %d', x), 1:length(delay_matrices), 'UniformOutput', false);
legend(plot_handles, legend_text, 'Location', 'Best');

mean_loc = mean(estimated_src_locations); %(1:end-2,:)
fprintf('Mean of Gauss-Newton estimates of source location for all files: ( x = %.2f, y = %.2f, z = %.2f)\n', mean_loc(1), mean_loc(2), mean_loc(3));
rmse = get_rmse(loc_source_gt, estimated_src_locations);
fprintf('Average duration of one iteration: %f +- %f\n', mean(avg_times), std(avg_times));
save(sprintf('gauss_newton_tdoa_%s.mat', timestamp_dir), 'estimated_src_locations', 'rmse', 'mean_loc','avg_times');
fprintf('Mean of iterations: %f +- %f\n', mean(number_of_iterations), std(number_of_iterations));


function RMSE = get_rmse(gt, estimated_locations)
    squared_error_sum = 0;
    n = size(estimated_locations, 1);
    for i = 1:n
        estimated_loc = estimated_locations(i, :);
        squared_error = (estimated_loc(1) - gt(1))^2 + ...
                        (estimated_loc(2) - gt(2))^2 + ...
                        (estimated_loc(3) - gt(3))^2;
        squared_error_sum = squared_error_sum + squared_error;
    end
    RMSE = sqrt(squared_error_sum / n);
    fprintf('The RMSE for this experiment is: %.4f m\n', RMSE);
end

% ============== NEW helper ==============
function [xyz, frames_used, residual] = load_aoa_inits(filename)
    xyz = []; frames_used = []; residual = [];
    if ~isfile(filename), return; end
    try
        T = readtable(filename, 'FileType','text', 'Delimiter', '\t');
    catch
        warning('Failed reading %s. Falling back to default initializations.', filename);
        return;
    end
    if ~all(ismember({'x','y','z'}, T.Properties.VariableNames))
        warning('File %s missing columns x,y,z. Ignoring AoA seeds.', filename);
        return;
    end
    xyz = [T.x, T.y, T.z];
    if ismember('frames_used', T.Properties.VariableNames), frames_used = T.frames_used; end
    if ismember('residual',    T.Properties.VariableNames), residual    = T.residual;    end
end
