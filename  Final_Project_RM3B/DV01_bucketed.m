function [DV01_swaption, DV01_swap] = DV01_bucketed(i,all_buckets,mkt_data, dates_yearfrac, swaption_N,swap_N, freq,t1,t2,sigma_black,strike, sw_price)
% compute the bucketed DV01 of the swaption and for the swap for the bucket
%in all_buckets(i)
%

% INPUT:
%
% i                         :   index of bucket
% all_buckets               :   the bucket include in our hedging strategy
% mkt_data                  :   the swap rates of the pricing date 
% dates_yearfrac            :   time interval from settlement date
% swaption_N                :   Notional of the swaption
% swap_N                    :   Notional of the swap 
% freq                      :   frequency of coupons
% t1                        :   swaption maturity
% t2                        :   swaption end time (maturity + tenor)    
% sigma_black               :   sigma of the swaption
% strike                    :   strike of the swaption
% sw_price                  :   swaption price
%
% OUTPUT:
% DV01_swaption             :   the bucketed DVO1 of the swaption
% DV01_swap                 :   the bucketed DVO1 of the swap

    bucket= all_buckets(i);
    weights = weights_bucket(bucket,all_buckets, dates_yearfrac').*1e-2;
    mkt_data_up = mkt_data + weights';
    ZC_curve_up = ZC_bootstrap_IRS_matrix_only(dates_yearfrac, mkt_data_up,freq);
    %ZC_curve_up = [dates_yearfrac', ZC_curve_up(end,:)'];
    [sw_price_up]=Swaption_Black_receiver(t1,t2,freq,sigma_black,strike,dates_yearfrac,ZC_curve_up');

    MtM_swaption = swaption_N*sw_price;
    MtM_up_swaption = swaption_N*sw_price_up;
    DV01_swaption = MtM_up_swaption-MtM_swaption;

    mat = bucket;
    S=mkt_data(bucket)/100;
    [irs_price_up]=IRS_approx_fix_payer(mat, freq, S,dates_yearfrac,ZC_curve_up');

    MtM_up_swap= irs_price_up*swap_N;
    DV01_swap = MtM_up_swap;
end