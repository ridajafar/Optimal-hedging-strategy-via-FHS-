function shock_estimates = linearize_shocks(years, swap_shocks, target_years)
   % compute a vector of linearized shocks 
   %
   %INPUT:
   % years             : vector of years of known shocks
   % swap_shocks       : vector of known shocks
   % target_years      : the years for linearization
   %
   %OUTPUT:
   % shock_estimates   : linearized shocks


    shock_estimates = zeros(size(target_years));
    
    % Linearize shocks between 0 and the first year
    indices = target_years <= years(1);
    shock_estimates(indices) = swap_shocks(1) * (target_years(indices) / years(1));
    
    for i = 1:numel(years)-1
        start_year = years(i);
        end_year = years(i+1);
        
        start_shock = swap_shocks(i);
        end_shock = swap_shocks(i+1);
        
        indices = target_years > start_year & target_years <= end_year;
        target_years_segment = target_years(indices);
        
        % Perform linear interpolation
        shock_estimates_segment = start_shock + (end_shock - start_shock) * (target_years_segment - start_year) / (end_year - start_year);
        
        shock_estimates(indices) = shock_estimates_segment;
    end
end

