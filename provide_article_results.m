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
