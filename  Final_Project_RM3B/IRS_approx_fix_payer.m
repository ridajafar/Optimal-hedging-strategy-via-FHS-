function [price]=IRS_approx_fix_payer(mat, freq, S, dateyearfrac, ZC)
% Computes the approximated price of the IRS (we approximate the PV of the 
% IRS as a short fixed rate bond, with coupons equal to the swap rate 
% and face value equal to the IRS notional, plus a long cash position with 
% same amount as the IRS notional) 

% INPUT:
%
% mat           :     IRS maturity
% freq          :     frequency of coupons
% S             :     IRS coupon
% ZC            :     Table of ZC rates (cont. comp. 30/360)
%                     Maturities are year fractions
% dateyearfrac  :     time interval from settlement date
%
% OUTPUT:
%
% price         :        price of IRS


ZC_curve=[dateyearfrac',ZC];

B = exp(-ZC_curve(:,2).*ZC_curve(:,1));

c = S*ones(length(B(1:freq*mat)),1);
c(end) = c(end) + 1;

% Price computation
price = -sum(c.*B(1:freq*mat)) +1;



end