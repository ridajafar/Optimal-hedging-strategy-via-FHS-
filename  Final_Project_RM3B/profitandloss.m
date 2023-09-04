function PL= profitandloss(Simulated_shocks,dateyearfrac,mkt_data,t1,t2,freq,sigma_black,strike,swaption_N,swap_N2Y,swap_N5Y,swap_N10Y,sw_price)
 % compute the P&L of every given strategy 
 %
 %INPUT:
 % Simulated_shocks  :  Matrix of simulated shocks
 % dateyearfrac      :  time interval from settlement date
 % mkt_data          :  the swap rates of the pricing date 
 % t1                :  swaption maturity
 % t2                :  swaption end time (maturity + tenor)  
 % freq              :  frequency of coupons
 % sigma_black       :  sigma of the swaption
 % strike            :  strike of the swaption
 % swaption_N        :  Notional of the swaption
 % swap_N2Y          :  Notional of the swap 2 years
 % swap_N5Y          :  Notional of the swap 5 years
 % swap_N10Y         :  Notional of the swap 10 years
 % sw_price          :  the price of the swaption
 %
 %OUTPUT:
 % PL                :  Profit and Loss



sw_price_up = arrayfun(@(x) Swaption_Black_receiver(t1,t2,freq,sigma_black,strike,dateyearfrac,Simulated_shocks(:,x)),1:size(Simulated_shocks,2));


S=mkt_data(2*freq)/100;
[irs_price_up_2]=arrayfun(@(x) IRS_approx_fix_payer(2, freq, S, dateyearfrac, Simulated_shocks(:,x)),1:size(Simulated_shocks,2));

S=mkt_data(5*freq)/100;
[irs_price_up_5]=arrayfun(@(x) IRS_approx_fix_payer(5, freq, S, dateyearfrac, Simulated_shocks(:,x)),1:size(Simulated_shocks,2));

S=mkt_data(10*freq)/100;
[irs_price_up_10]=arrayfun(@(x) IRS_approx_fix_payer(10, freq, S,dateyearfrac, Simulated_shocks(:,x)),1:size(Simulated_shocks,2));

MtM=swaption_N*sw_price;
MtM_up = swaption_N*sw_price_up + swap_N2Y*irs_price_up_2 +swap_N5Y*irs_price_up_5 + swap_N10Y*irs_price_up_10;
 PL = MtM_up-MtM;

end