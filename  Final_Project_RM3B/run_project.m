%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Optimal Hedging strategy via Filtred Historical Simulation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Financial Engineering A.Y. 2022/2023

% Students: Rida Jafar
%           Lorenzo Tonelli

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;
close all;
clc;
format long;
%% Read market data

rng('default')
formatData='dd/mm/yyyy';

%load the data
rates = readExcelData('IRS', formatData);
dates=load("matlab.mat");

dates=dates.datesSet;

%% Drop the row of data that have more than 5 missing values
 
% numMissing Count the number of NaN values in each row
% rowsToDrop Rows with more than five missing values

 numMissing = sum(isnan(rates), 2);  
 rowsToDrop = numMissing > 5;  

 swaps=rates;
 swaps(rowsToDrop , :) = [];

% replace the last component of the first row with the one in the next row (to avoid extrap)
 swaps(1,10)=swaps(2,10); 

% Remove the corresponding dates 
 dates(rowsToDrop,:)=[];

%% Linear interpolation for other missing values

 swaps=fillmissing(swaps,'linear');
%% seed
 
 rng('default')

%% Bootstap the ZC rates
 
 freq=1;
 dates_yearfrac = 1:size(swaps,2);
[ZC_curve]= ZC_bootstrap_IRS_matrix_only(dates_yearfrac, swaps,freq);
%%
log_returns= log(ZC_curve(2:end,:)./ZC_curve(1:end-1,:));

%%
figure
plot(dates_yearfrac,ZC_curve(1,:),'x','Linewidth', 2,'LineStyle','-')
%grid
set(gca, 'YGrid', 'on', 'XGrid', 'off')
title('Zero Coupon Curve 31/12/2008')
xlabel('Time (year frac)')


%% Filtred Historical simulation 

   N=5000; %number of simulation
   h=10;   %time horizon

   [Simulated_shocks]=FHS(ZC_curve,N,h);
%%
figure
plot(dates_yearfrac,Simulated_shocks(:,1),'x','Linewidth', 2,'LineStyle','-',Color= 'k' )
%grid
set(gca, 'YGrid', 'on', 'XGrid', 'off')
title('Zero Coupon Curve for one simulation of 10 days')
xlabel('Time (year frac)')

%% Strike of the ATM swaption

ZC_curve_2008=[dates_yearfrac', ZC_curve(end,:)'];
t1 = 3;
t2 = t1 + 5;
strike = s_fwd( t1, t2, freq, ZC_curve_2008 );

%% Price and analytic delta of the swaption
sigma_black=0.3;
[sw_price]=Swaption_Black_receiver(t1,t2,freq,sigma_black,strike,dates_yearfrac,ZC_curve(end,:)');

disp('–––  Pricing Swaption  3yx5y  –––')
fprintf('Swaotion price:  %.3f\n', sw_price)
disp(' ')

%% Price and analytic delta of the swap 5y

mat = 5;
S=swaps(end,5)/100;
[irs5y_price]=IRS_approx_fix_payer(mat, freq, S,dates_yearfrac,ZC_curve(end,:)');

disp('–––  Pricing IRS 5y  –––')
fprintf('IRS price: %.3f\n', irs5y_price)
disp(' ')

%% Q3: MtM

% Actual portfolio exposure
sw_N = 100000000;                 % Swaption 3x5 receiver notional
irs5y_N = 34000000;               % IRS fixed rate receiver notional

MtM = sw_N*sw_price+irs5y_N*irs5y_price;

disp('–––  Mark to market  –––')
fprintf('MtM: %.3f\n', MtM)
disp(' ')

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Hedgin strategies
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Strategy 1: with swap 2Y
% Strategy 2: with swap 5Y
% Strategy 3: with swap 10Y
% Strategy 4: with swap 2Y, swap 5Y, swap 10Y
% Strategy 5: with swap 2Y, swap 5Y
% Strategy 6: with swap 2Y, swap 10Y
% Strategy 7: with swap 5Y, swap 10Y


%% Strategy 1: with swap 2Y
 all_buckets = 2;
 [swap_N2Y] = Delta_Hedging(swaps(end,:),all_buckets,dates_yearfrac,sw_N,freq, t1,t2,sigma_black,strike,sw_price);

 disp('–––  Notional (startegy 1)  –––')
 fprintf('Notional Swap2Y:  %.3f\n', swap_N2Y)
 disp(' ')

%% Strategy 2: with swap 5Y
 all_buckets = 5;
[swap_N5Y] = Delta_Hedging(swaps(end,:),all_buckets,dates_yearfrac,sw_N,freq, t1,t2,sigma_black,strike,sw_price);

  disp('–––  Notional (startegy 2)  –––')
  fprintf('Notional Swap5Y:  %.3f\n', swap_N5Y)
  disp(' ')


%% Strategy 3: with swap 10Y
 all_buckets = 10;
[swap_N10Y] = Delta_Hedging(swaps(end,:),all_buckets,dates_yearfrac,sw_N,freq, t1,t2,sigma_black,strike,sw_price);
 
 disp('–––  Notional (startegy 3)  –––')
 fprintf('Notional Swap10Y:  %.3f\n', swap_N10Y)
 disp(' ')

%% Strategy 4: with swap 2Y, swap 5Y, swap 10Y
 all_buckets = [2,5,10];
[swap_N_all] = Delta_Hedging(swaps(end,:),all_buckets,dates_yearfrac,sw_N,freq, t1,t2,sigma_black,strike,sw_price);

 disp('–––  Notional (startegy 4)  –––')
 fprintf('Notional Swap2Y:  %.3f\n', swap_N_all(1))
 fprintf('Notional Swap5Y:  %.3f\n', swap_N_all(2))
 fprintf('Notional Swap10Y:  %.3f\n', swap_N_all(3))
 disp(' ')

%% Strategy 5: with swap 2Y, swap 5Y
all_buckets = [2,5];
[swap_N2Y_5Y] = Delta_Hedging(swaps(end,:),all_buckets,dates_yearfrac,sw_N,freq, t1,t2,sigma_black,strike,sw_price);
 
 disp('–––  Notional (startegy 5)  –––')
 fprintf('Notional Swap2Y:  %.3f\n', swap_N2Y_5Y(1))
 fprintf('Notional Swap5Y:  %.3f\n', swap_N2Y_5Y(2))
 disp(' ')

%% Strategy 6: with swap 2Y, swap 10Y
all_buckets = [2,10];
[swap_N2Y_10Y] = Delta_Hedging(swaps(end,:),all_buckets,dates_yearfrac,sw_N,freq, t1,t2,sigma_black,strike,sw_price);

 disp('–––  Notional (startegy 6)  –––')
 fprintf('Notional Swap2Y:  %.3f\n', swap_N2Y_10Y(1))
 fprintf('Notional Swap10Y:  %.3f\n', swap_N2Y_10Y(2))
 disp(' ')

%% Strategy 7: with swap 5Y, swap 10Y

all_buckets = [5,10];
[swap_N5Y_10Y] = Delta_Hedging(swaps(end,:),all_buckets,dates_yearfrac,sw_N,freq, t1,t2,sigma_black,strike,sw_price);


 disp('–––  Notional (startegy 7)  –––')
 fprintf('Notional Swap5Y:  %.3f\n', swap_N5Y_10Y(1))
 fprintf('Notional Swap10Y:  %.3f\n', swap_N5Y_10Y(2))
 disp(' ')


%% Profit and LOSS

PL=zeros(1,7);

%Shift of the stress test
%we get from the function linearize_shocks
%shift = [35,70,103,137,170,174,178,182,186,190].*1e-2;

shift=linearize_shocks([2,5,10],[70,170,190],dates_yearfrac).*1e-2;
mkt_data_up = swaps(end,:) + shift;
ZC_curve_up = ZC_bootstrap_IRS_matrix_only(dates_yearfrac, mkt_data_up,freq);

%%
%Strategy1

PL(1)= profitandloss(ZC_curve_up',dates_yearfrac,swaps(end,:),t1,t2,freq,sigma_black,strike,sw_N,swap_N2Y,0,0,sw_price);

%Strategy2
PL(2)= profitandloss(ZC_curve_up',dates_yearfrac,swaps(end,:),t1,t2,freq,sigma_black,strike,sw_N,0,swap_N5Y,0,sw_price);

%Strategy3
PL(3)= profitandloss(ZC_curve_up',dates_yearfrac,swaps(end,:),t1,t2,freq,sigma_black,strike,sw_N,0,0,swap_N10Y,sw_price);

%Strategy4
PL(4)= profitandloss(ZC_curve_up',dates_yearfrac,swaps(end,:),t1,t2,freq,sigma_black,strike,sw_N,swap_N_all(1),swap_N_all(2),swap_N_all(3),sw_price);

%Strategy5
PL(5)= profitandloss(ZC_curve_up',dates_yearfrac,swaps(end,:),t1,t2,freq,sigma_black,strike,sw_N,swap_N2Y_5Y(1),swap_N2Y_5Y(2),0,sw_price);

%Strategy6
PL(6)= profitandloss(ZC_curve_up',dates_yearfrac,swaps(end,:),t1,t2,freq,sigma_black,strike,sw_N,swap_N2Y_10Y(1),0,swap_N2Y_10Y(2),sw_price);

%Strategy7
PL(7)= profitandloss(ZC_curve_up',dates_yearfrac,swaps(end,:),t1,t2,freq,sigma_black,strike,sw_N,0,swap_N5Y_10Y(1),swap_N5Y_10Y(2),sw_price);


 disp('–––  P&L  –––')
 fprintf('P&L strategy 1:  %.3f\n', PL(1))
 fprintf('P&L strategy 2:  %.3f\n', PL(2))
 fprintf('P&L strategy 3:  %.3f\n', PL(3))
 fprintf('P&L strategy 4:  %.3f\n', PL(4))
 fprintf('P&L strategy 5:  %.3f\n', PL(5))
 fprintf('P&L strategy 6:  %.3f\n', PL(6))
 fprintf('P&L strategy 7:  %.3f\n', PL(7))

 disp(' ')


%% Best strategy
 Best_strategy_PL = sum((1:7).*(PL==ones(1,7)*max(PL)));

 disp('––– Best strategy P&L  –––')
 fprintf('Best strategy P&L :  %.0f\n', Best_strategy_PL)
 disp(' ')


%% 10day VaR via FHS


confidenceLevel=0.99;
%% Strategy 1: with swap 2Y

[VaR_1]=VaR_FHS(Simulated_shocks,dates_yearfrac,confidenceLevel,sw_price,sw_N,t1,t2,freq,sigma_black,strike,swap_N2Y,0,0,swaps(end,:)) ;

%% Strategy 2: with swap 5Y

[VaR_2]=VaR_FHS(Simulated_shocks,dates_yearfrac,confidenceLevel,sw_price,sw_N,t1,t2,freq,sigma_black,strike,0,swap_N5Y,0,swaps(end,:));

%% Strategy 3: with swap 10Y

[VaR_3]=VaR_FHS(Simulated_shocks,dates_yearfrac,confidenceLevel,sw_price,sw_N,t1,t2,freq,sigma_black,strike,0,0,swap_N10Y,swaps(end,:));

%% Strategy 4: with swap 2Y, swap 5Y, swap 10Y

[VaR_4]=VaR_FHS(Simulated_shocks,dates_yearfrac,confidenceLevel,sw_price,sw_N,t1,t2,freq,sigma_black,strike,swap_N_all(1),swap_N_all(2),swap_N_all(3),swaps(end,:)); 

 %% Strategy 5: with swap 2Y, swap 5Y

[VaR_5]=VaR_FHS(Simulated_shocks,dates_yearfrac,confidenceLevel,sw_price,sw_N,t1,t2,freq,sigma_black,strike,swap_N2Y_5Y(1),swap_N2Y_5Y(1),0,swaps(end,:));

%% Strategy 6: with swap 2Y, swap 10Y

[VaR_6]=VaR_FHS(Simulated_shocks,dates_yearfrac,confidenceLevel,sw_price,sw_N,t1,t2,freq,sigma_black,strike,swap_N2Y_10Y(1),0,swap_N2Y_10Y(2),swaps(end,:));

%% Strategy 7: with swap 5Y, swap 10Y

[VaR_7]=VaR_FHS(Simulated_shocks,dates_yearfrac,confidenceLevel,sw_price,sw_N,t1,t2,freq,sigma_black,strike,0,swap_N5Y_10Y(1),swap_N5Y_10Y(2),swaps(end,:)); 

%% Vector of VaR for the 7 strategies

VaR= [VaR_1,VaR_2,VaR_3,VaR_4,VaR_5,VaR_6,VaR_7];

Best_strategy_VaR= sum((1:7).*(VaR==min(VaR)));


 disp('–––  VaR via FHS  –––')
 fprintf('VaR strategy1 :  %.3f\n', VaR(1))
 fprintf('VaR strategy2 :  %.3f\n', VaR(2))
 fprintf('VaR strategy3 :  %.3f\n', VaR(3))
 fprintf('VaR strategy4 :  %.3f\n', VaR(4))
 fprintf('VaR strategy5 :  %.3f\n', VaR(5))
 fprintf('VaR strategy6 :  %.3f\n', VaR(6))
 fprintf('VaR strategy7 :  %.3f\n', VaR(7))
 disp(' ')

 disp('––– Best strategy VaR  –––')
 fprintf('Best strategy VaR :  %.0f\n', Best_strategy_VaR)
 disp(' ')
