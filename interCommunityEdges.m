function [n]=interCommunityEdges(En,CMs,cIndex1,cIndex2)
tmp=find(CMs==cIndex1);
tmp2=find(CMs==cIndex2);
n=0;
for i=1:length(tmp)
    for j=1:length(tmp2)
        if(En(tmp(i),tmp2(j))~=0)
            n=n+En(tmp(i),tmp2(j));
        end
    end    
end    
end