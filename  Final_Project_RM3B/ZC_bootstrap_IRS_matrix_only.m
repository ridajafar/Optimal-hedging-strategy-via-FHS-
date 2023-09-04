function [ZC_curve]= ZC_bootstrap_IRS_matrix_only(dates_yearfrac, IRS_data,freq)

% Bootstrap of ZC curve from IRS
% 
% INPUT:
% dates_yearfrac:    IRS maturity (year frac)
% IRS_data      :    Table of EUR IRS for tenor 1Y to 10Y
%   Column #i   :    EUR IRS for tenor i
% freq          :    frequency of fixed coupons (in our case it's 1 for once a year)
% 
% OUTPUT:
% ZC_curve:          Table of ZC rates 
%                    Maturities are dates_yearfrac


% Swap rates

swap_rates = IRS_data/100;

% Compute discount factors from swap rates
%Matrix of discount factors every row to tenor 1Y to 10Y
B = zeros(size(IRS_data)); 


for i=1:size(IRS_data,1)
   for j=1:size(IRS_data,2)
      B(i,j) = (1 - swap_rates(i,j).*sum(B(i,1:j-1))/freq)/(1 + swap_rates(i,j)/freq);
   end
end
 


% Compute zero rates from discount factors
matrix_ZC_1=dates_yearfrac.*ones(size(IRS_data));

ZC_curve = (-log(B))./matrix_ZC_1;
 

end