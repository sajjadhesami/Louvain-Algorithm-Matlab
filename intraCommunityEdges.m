function [n]=intraCommunityEdges(En,CMs,cIndex)

tmp=find(CMs==cIndex);
n=0;
for i=1:length(tmp)
    for j=1:length(tmp)
        if(En(tmp(i),tmp(j))~=0)
            n=n+En(tmp(i),tmp(j));
        end
    end    
end
    
end