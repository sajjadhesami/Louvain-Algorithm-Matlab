function [R]=deltaQ(En,N,I,CMs,cIndex)
% En: Adjecency matrix
% I: isolated node
% CMS: Community structure
% cIndex: Community index
m=sum(sum(En));
sigmaIn=intraCommunityEdges(En,CMs,cIndex);
sigmatot=0;

x=find(CMs==cIndex);

for i=1:length(x)
%     Z=setdiff(N(x(i)).N,x);
%     for j=1:length(Z)       
%        sigmatot=sigmatot+En(x(i),Z(j));        
%     end
    sigmatot=sigmatot+sum(En(x(i),:));
    %sigmatot=sigmatot+sum(En(:,x(i)));
end

ki=sum(En(I,:));%+sum(En(:,I));
kIin=0;
for i=1:length(x)
    kIin=kIin+En(x(i),I);
end

R=(((sigmaIn+2*kIin)/(m))-((sigmatot+ki)/m)^2)-((sigmaIn/(m))-(sigmatot/m)^2-(ki/m)^2);
%R=(2/m)*(kIin-(sigmatot*ki)/m);

end