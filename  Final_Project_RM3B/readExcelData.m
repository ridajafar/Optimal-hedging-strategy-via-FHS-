function  rates = readExcelData( filename, formatData)
% Reads data from excel
%  It reads bid/ask prices and relevant dates
%  All input rates are in % units
%
% INPUTS:
%  filename: excel file name where data are stored
%  formatData: data format in Excel
% 
% OUTPUTS:
%  dates: struct with settlementDate, deposDates, futuresDates, swapDates
%  rates: struct with deposRates, futuresRates, swapRates

%% Dates from Excel

%Date relative to swaps: expiry dates


%% Rates from Excel (Bids & Asks)

%Swaps
tassi_swaps = xlsread(filename, 1, 'B3:K3655');
rates = tassi_swaps;

end % readExcelData