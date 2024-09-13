function [loc_source_est, residuals,avg_iter_time] = gauss_newton_localization_single(delay_matrix, mic_positions, loc_source_init, max_iter, tol)
    % Parameters
    c = 343; % Speed of sound in m/s
    loc_source_est = loc_source_init;
    num_mics = size(mic_positions, 1);

    % Initialize residuals
    residuals = [];
    total_time = 0;
    for iter = 1:max_iter

        % Start timing the iteration
        iter_start = tic;

        % Initialize the residual vector and Jacobian matrix
        f = [];
        J = [];

        % Loop through all mic pairs to compute residuals and Jacobian
        for i = 1:num_mics
            for j = i+1:num_mics
                if ~isnan(delay_matrix(i, j))
                    % Calculate TDOA estimated
                    tdoa_measured = delay_matrix(i, j);
                    mic_x_pos = mic_positions(i, :);
                    mic_y_pos = mic_positions(j, :);

                    % Estimated TDOA based on current source estimate
                    dist_x = norm(loc_source_est - mic_x_pos);
                    dist_y = norm(loc_source_est - mic_y_pos);
                    tdoa_estimated = (dist_x - dist_y) / c;

                    % Residual
                    f = [f; tdoa_estimated - tdoa_measured];

                    % Jacobian
                    Jx = -(mic_x_pos(1) - loc_source_est(1)) / (c * dist_x) + (mic_y_pos(1) - loc_source_est(1)) / (c * dist_y);
                    Jy = -(mic_x_pos(2) - loc_source_est(2)) / (c * dist_x) + (mic_y_pos(2) - loc_source_est(2)) / (c * dist_y);
                    Jz = -(mic_x_pos(3) - loc_source_est(3)) / (c * dist_x) + (mic_y_pos(3) - loc_source_est(3)) / (c * dist_y);
                    J = [J; Jx Jy Jz];
                end
            end
        end

        % Update source estimate
        delta = -pinv(J' * J) * J' * f;
        loc_source_est = loc_source_est + delta';

        % Store residual norm
        f = norm(f);
        residuals = [residuals; f];

        % Measure the time for this iteration
        iter_time = toc(iter_start);
        total_time = total_time + iter_time;
        % Check for convergence
        if norm(delta) < tol
            break;
        end
    end
    % Calculate average iteration time
    avg_iter_time = total_time / iter;
end