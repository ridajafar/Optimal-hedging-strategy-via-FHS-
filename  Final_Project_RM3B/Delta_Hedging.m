function [swap_N] = Delta_Hedging(mkt_data,all_buckets, dates_yearfrac, sw_N, freq,t1,t2,sigma_black,strike,sw_price)
% compute a vector of notionals of the swaps to delta hedge the swaption

% INPUT:
%
% mkt_data                  :   the swap rates of the pricing date 
% all_buckets               :   the bucket include in our hedging strategy
% dates_yearfrac            :   time interval from settlement date
% sw_N                      :   Notional of the swaption
% freq                      :   frequency of coupons
% t1                        :   swaption maturity
% t2                        :   swaption end time (maturity + tenor)    
% sigma_black               :   sigma of the swaption
% strike                    :   strike of the swaption
% sw_price                  :   swaption price
%
% OUTPUT:
% swap_N                    :   vector of notionals of the swaps 

DV01_swaption=zeros(size(all_buckets));
DV01_swap=zeros(size(all_buckets));

for i=1:length(all_buckets)
[DV01_swaption(i), DV01_swap(i)]= DV01_bucketed(i, all_buckets, mkt_data, dates_yearfrac, sw_N,1, freq,t1,t2,sigma_black,strike, sw_price);
end


swap_N = -DV01_swaption./DV01_swap;

end