function [Fx, Fy, Fz, Tx, Ty, Tz] = myWrapper()
    persistent u offset initialized;

    % Initialize UDP connection and compute offset if not already done
    if isempty(initialized) || ~initialized
        u = netFT_openConnection();
        netFT_startStreaming(u);
        numOffsetSamples = 20;
        offset = netFT_getOffset(u, numOffsetSamples);
        initialized = true;
    end

    % Fetch fresh data
    try
        ftdata = netFT_getFreshData(u, offset);
    catch
        % Return zeros if data fetch fails
        ftdata = zeros(1, 6);
    end

    % Assign outputs
    Fx = ftdata(1);
    Fy = ftdata(2);
    Fz = ftdata(3);
    Tx = ftdata(4);
    Ty = ftdata(5);
    Tz = ftdata(6);
end
