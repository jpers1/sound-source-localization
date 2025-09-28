% This script outputs the results from the article and the master thesis. 
% The ground truth source position, the mic positions and the paths for the
% files are hard coded in the called files. 
function provide_article_results()
    
    fprintf("Plotting the setup...\n");
    plot_setup();
    plot_camera_positions();
    fprintf("Plotting the intersection of two AOA planes for one sensor frame...\n");
    aoa_intersection;

    timestamp_dir = '20240805145919'; % glavni eksperiment
     
    fprintf("\nAOA estimations\n");
    [horizontal_angle_estimations, vertical_angle_estimations, ...
        mean_values_vertical, std_values_vertical, ...
        mean_values_horizontal, std_values_horizontal] = ...
        ssl_clap_automated_experiment_aoa(timestamp_dir);

    % === NEW: AoA-only 3D via ray intersection (per transient) ===
    aoa_outfile = 'AoAintersect.txt';
    aoa_xyz = aoa_intersect_and_save(horizontal_angle_estimations, ...
                                     vertical_angle_estimations, aoa_outfile);
    fprintf('Saved %d AoA intersections to %s\n', size(aoa_xyz,1), aoa_outfile);

    plot_all_mics(mean_values_horizontal, mean_values_vertical, ...
                    std_values_horizontal, std_values_vertical);
    
    fprintf("\nTDOA-based localization:\n");
    %fprintf("Calculating the TDOA matrices for the 10 audio events...\n");
    gauss_newton_basis;

    fprintf("\nRSSI-based localization:\n");
    %fprintf("Calculating the power and distance ratios...\n");
    gauss_newton_basis_rssi;

    fprintf("\nFine grid search\n");
    addpath('loss_func_output');
    visualize_loss_function_all_mics;
    
    fprintf("\nPlotting the SNR experiments for TDOA and RSSI measurements...\n");

    files = {'gauss_newton_tdoa_20240805145919.mat',...
        'gauss_newton_tdoa_20240813155617.mat', ...
        'gauss_newton_tdoa_20240813153802.mat', ...
        'gauss_newton_tdoa_20240813150022.mat'};
    snr_experiment(files);
    files = {'gauss_newton_rssi_20240805145919.mat',...
        'gauss_newton_rssi_20240813155617.mat',...
        'gauss_newton_rssi_20240813153802.mat',...
        'gauss_newton_rssi_20240813150022.mat'};
    snr_experiment(files);
    
    fprintf("\nPlease wait for the figures to be displayed.\n");
end

% =========================
% Local helper (NEW)
% =========================
function aoa_xyz = aoa_intersect_and_save(hAng, vAng, outfile)
% Compute AoA-only 3D locations by intersecting 4 frame rays (per transient).
% IMPORTANT: Uses ONLY the 4 frames (not all mic pairs):
%   Horizontal columns: [1 3 5 7]
%   Vertical   columns: [2 4 6 8]
% Writes results to a tab-separated text file with header:
%   file_idx   x   y   z   frames_used   residual
%
% Inputs:
%   hAng: [num_files x >=8] horizontal AoA estimates (deg), valid at cols 1,3,5,7
%   vAng: [num_files x >=8] vertical   AoA estimates (deg), valid at cols 2,4,6,8
% Output:
%   aoa_xyz: [num_files x 3] best-fit 3D point per transient (NaN if <2 rays)

    % Indices of the four frames (DO NOT use all pairs!)
    H_idx = [1 3 5 7];   % frames 1..4 (horizontal)
    V_idx = [2 4 6 8];   % frames 1..4 (vertical)

    % --- Frame geometry for ray anchor points (centers) ---
    % These are the exact 8 pair endpoints used elsewhere in your code.
    mic_pairs = {
        [0,    0,     0],   [1.02, 0,    0   ];  % Pair 1 (Frame 1, horizontal)
        [0,    0,     0],   [0,    0,    1.02];  % Pair 2 (Frame 1, vertical)
        [4.06, 0.22,  0],   [5.05, 0.22, 0   ];  % Pair 3 (Frame 2, horizontal)
        [4.06, 0.22,  0],   [4.03, 0.22, 1.02];  % Pair 4 (Frame 2, vertical)
        [0.62, 6.34,  0],   [-0.4, 6.34, 0   ];  % Pair 5 (Frame 3, horizontal)
        [0.62, 6.34,  0],   [0.62, 6.34, 1.02];  % Pair 6 (Frame 3, vertical)
        [4.36, 6.34, -0.22],[3.34, 6.34, -0.22]; % Pair 7 (Frame 4, horizontal)
        [4.36, 6.34, -0.22],[4.36, 6.34, 0.79];  % Pair 8 (Frame 4, vertical)
    };

    % One center per frame: average of the two pair midpoints
    centers = zeros(4,3);
    for f = 1:4
        pH1 = mic_pairs{2*f-1,1};  pH2 = mic_pairs{2*f-1,2};
        pV1 = mic_pairs{2*f,  1};  pV2 = mic_pairs{2*f,  2};
        midH = (pH1 + pH2) / 2;  midV = (pV1 + pV2) / 2;
        centers(f,:) = (midH + midV) / 2;
    end

    nFiles = size(hAng,1);
    aoa_xyz = NaN(nFiles,3);

    fid = fopen(outfile,'w');
    if fid < 0, error('Cannot open %s for writing.', outfile); end
    fprintf(fid, 'file_idx\tx\ty\tz\tframes_used\tresidual\n');

    for k = 1:nFiles
        U = []; P = [];  % bearing directions and anchors for this transient

        for f = 1:4
            phiH = hAng(k, H_idx(f));   % degrees
            phiV = vAng(k, V_idx(f));   % degrees
            if ~isnan(phiH) && ~isnan(phiV)
                tH = deg2rad(phiH);
                tV = deg2rad(phiV);

                % Keep same sign convention as your existing plots:
                if f > 2
                    tV = -tV;
                end

                % Two planes' normals from angles (see earlier explanation)
                nV = [0;        cos(tV); -sin(tV)];
                nH = [-sin(tH); cos(tH);  0      ];

                % Direction is the intersection of the planes
                d = cross(nV, nH);
                nd = norm(d);
                if nd > 1e-9
                    u = (d / nd).';       % unit row vector
                    U = [U; u];
                    P = [P; centers(f,:)];
                end
            end
        end

        if size(U,1) >= 2
            [xhat, R] = triangulate_bearings(P, U);
            aoa_xyz(k,:) = xhat.';
            fprintf(fid, '%d\t%.6f\t%.6f\t%.6f\t%d\t%.6f\n', ...
                    k, xhat(1), xhat(2), xhat(3), size(U,1), R);
        else
            % Not enough rays for this transient
            fprintf(fid, '%d\tNaN\tNaN\tNaN\t%d\tNaN\n', k, size(U,1));
        end
    end
    fclose(fid);
end

% =========================
% Local helper (NEW)
% =========================
function [xhat, R] = triangulate_bearings(P, U)
% Least-squares intersection of rays x = p_i + t*u_i.
% Inputs:
%   P: [M x 3] anchor points
%   U: [M x 3] unit directions
% Outputs:
%   xhat: [3x1] best-fit 3D point
%   R: scalar RMS perpendicular distance to all rays

    A = zeros(3); b = zeros(3,1);
    for i = 1:size(U,1)
        ui = U(i,:).';  
        Pi = eye(3) - ui*ui.';   % projector onto plane orthogonal to ui
        A = A + Pi;              
        b = b + Pi * P(i,:).';
    end
    xhat = A \ b;

    % RMS residual (quality score)
    r2 = 0;
    for i = 1:size(U,1)
        ui = U(i,:).';  
        Pi = eye(3) - ui*ui.';
        r2 = r2 + norm(Pi*(xhat - P(i,:).')).^2;
    end
    R = sqrt(r2 / size(U,1));
end
