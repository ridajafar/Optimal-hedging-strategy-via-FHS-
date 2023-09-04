function [VaR]=VaR_FHS(Simulated_shoks,dateyearfrac,confidenceLevel,Swaption_price,N_sw,t1,t2,freq,sigma_black,strike,N2,N5,N10,swaps)
 % compute the VaR of every given strategy 
 %
 %INPUT:
 % Simulated_shocks  :  Matrix of simulated shocks
 % dateyearfrac      :  time interval from settlement date
 % confidenceLevel   :  confidence level
 % Swaption_price    :  the price of the swaption
 % sw_N              :  Notional of the swaption
 % t1                :  swaption maturity
 % t2                :  swaption end time (maturity + tenor)  
 % freq              :  frequency of coupons
 % sigma_black       :  sigma of the swaption
 % strike            :  strike of the swaption
 % N2                :  Notional of the swap 2 years
 % N5                :  Notional of the swap 5 years
 % N10               :  Notional of the swap 10 years
 %
 %OUTPUT
 % VaR               : Value at Risk for given strategy

PL= profitandloss(Simulated_shoks,dateyearfrac,swaps,t1,t2,freq,sigma_black,strike,N_sw,N2,N5,N10,Swaption_price);
sortedPL = sort(PL);

% Calculate VaR
VaR = sortedPL(floor(confidenceLevel * numel(sortedPL)));

end