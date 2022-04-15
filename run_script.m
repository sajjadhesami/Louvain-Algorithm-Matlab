% This implementation of Louvain that saves every level of dendogram in a 
% cell of an array of "struct"s.
clear;clc;close all;warning off;

load('karate.mat');
A=Problem.A;
% load ground-truth data
%GT=Problem.aux.nodevalue; %+1( % in some datasets community identifiers
%start from 0) 


H=[struct('A',[],'solution_vector',[],'Q',-inf)];
k=1;

while(true) % A loop that keeps running until no merge happens
    solution_vector=[1:length(A)]; % Singleton communities
    H(k).solution_vector=solution_vector; % save the solution vector
    N=[]; % the list of neighbors
    for i=1:size(A,1) % find the list of neighbors of each node
        N= [N nghbors(i,A)];
    end
    z=0;
    while(true) % A loop that keeps combining communities until no merge improves deltaQ
        flag=false;
        for i=1:length(A)
            tmp2=[];
            for j=1:length(N(i).N)
                solution_vector_tmp=solution_vector;
                
                solution_vector_tmp(i)=solution_vector(N(i).N(j)); % set i in its j'th neighbor's community
                tmp=deltaQ(A,N,i,solution_vector_tmp,solution_vector(N(i).N(j)));% calculate deltaQ
                tmp2=[tmp2 tmp]; % save deltaQ
            end
            [a, b]=max(tmp2);
            if(a>0 && solution_vector(i)~=solution_vector(N(i).N(b)))
                solution_vector(i)=solution_vector(N(i).N(b)); % merge communities
                flag=true; % merge flag
            end
        end
        if(flag)
            H(k).solution_vector=unique(solution_vector);
            for i=1:length(H(k).solution_vector) % set the community identifiers from 1 to k
                solution_vector(solution_vector==H(k).solution_vector(i))=i;
            end
            figure(1)
            hold on
            z=z+1;
            plot(z,QFModul(solution_vector,A),'.','color','b')
            title(([num2str(k) ') modularity: ' num2str(QFModul(solution_vector,A))]))
            pause(0.001)
            H(k).solution_vector=solution_vector;
            H(k).A=A;
            H(k).Q=QFModul(solution_vector,A);
        else
            break;
        end
    end
    
    %pause
    A2=zeros(length(unique(solution_vector))); % create a higher layer network
    for i=1:length(A2)
        for j=1:length(A2)
            if(i==j)
                A2(i,j)=intraCommunityEdges(A,solution_vector,i);
            else
                A2(i,j)=interCommunityEdges(A,solution_vector,i,j);
            end
        end
    end
    if(isequal(unique(solution_vector),solution_vector)) % if no change occured at all
        H(k).solution_vector=unique(solution_vector);
        for i=1:length(H(k).solution_vector)
            solution_vector(solution_vector==H(k).solution_vector(i))=i;
        end
        break; % end the algorithm
    else % if a change occured: continue the algorithm
        H=[H;struct('A',A2,'solution_vector',[],'Q',QFModul(unique(solution_vector),A2))];
        k=k+1;
        A=A2;
    end
end

disp(strcat('Modularity:',num2str(H(k).Q)))

% % uncomment if you want to print the NMI value of the partition
% for i=k:-1:2 % creating the solution vector of the main network from the upper layer combinations
%     for z=1:length(H(i-1).solution_vector)
%         H(i-1).solution_vector(z)=H(i).solution_vector(H(i-1).solution_vector(z));
%     end
% end
% disp(strcat('NMI:',num2str(PSNMI(H(1).solution_vector,GT))))