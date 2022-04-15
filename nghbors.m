function [N]=nghbors(v,E)
% gives back neighbors of specific node
N=[];
for i=1:length(v)
    verti=E(:,v(i));
    vInd=find(verti~=0);
    hori=E(v(i),:);
    hInd=find(hori~=0);
    N=[N struct('N',[v(i);union(vInd,hInd)])];
end
end