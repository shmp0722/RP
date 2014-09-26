function [a, sheets]=xlsfinfo('file.xls')
% function [a, sheets]=xlsfinfo('filename.xls')

for ind=1:length(sheets)
    disp('---');
    disp(sheets(ind));
    [data,header]=xlsread('file.xls',ind)
end;
