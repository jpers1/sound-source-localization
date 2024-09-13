function snr_experiment(files)


    rmse_values = zeros(1,length(files));
    for i = 1:length(files)
        data = load(files{i});
        rmse_values(i)=data.rmse;

        if contains(files{i}, 'tdoa', 'IgnoreCase', true)
            plot_title = 'TDOA';
        elseif contains(files{i}, 'rssi', 'IgnoreCase', true)
            plot_title = 'RSSI';
        else
            plot_title = 'Unknown measurements (the file name should contain tdoa or rssi))';
        end
    end

    snr = [35,25,18,15];

    % Plotting the graph with enhancements
    figure; % Create a new figure window
    plot(snr, rmse_values, '-o', 'LineWidth', 2, 'MarkerSize', 8, 'MarkerFaceColor', 'b');
    grid on; % Add grid lines
    %title('RMS', 'FontSize', 14); % Add a title with font size
    xlabel('SNR [dB]', 'FontSize', 12); % Label the x-axis
    ylabel('RMSE [m]', 'FontSize', 12); % Label the y-axis
    xlim([min(snr)-5, max(snr)+5]); % Set x-axis limits for better spacing
    ylim([min(rmse_values)-0.1*mean(rmse_values), max(rmse_values)+0.1*mean(rmse_values)]); % Adjust y-axis limits
    set(gca, 'FontSize', 12, 'LineWidth', 1.5); % Improve the appearance of axes
    title(plot_title);
    % Optionally, add a legend
    legend('RMSE vs SNR', 'Location', 'best');

    % Display the grid and set other plot properties
    box on; % Add a box around the plot
end