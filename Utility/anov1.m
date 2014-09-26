function p=anov1(m)
% 1-way ANOVA
% {[group1], [group2], ...}
% each group can have different number of elements
% written by T.Mogami (2003)

k=length(m);
gm=0; %grand mean
gn=0; %total num of samples
for i=1:k
   gm=gm+sum(m{i});
   gn=gn+length(m{i});
end   
gm=gm/gn;
sa=0;
se=0;
for i=1:k
   if length(m{i})~=0
      sa=sa+length(m{i})*(mean(m{i})-gm)^2;
   end
   se=se+ sum((m{i}-gm).^2);      
end
sa=sa/(k-1);
se=se/(gn-k);
p=1-fcdf(sa/se, k-1, gn-k);