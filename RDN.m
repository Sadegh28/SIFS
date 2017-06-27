function rdn=RDN(Data)
REDUN=[];
for i=1:size(Data,2)
sum=0;
Xi=Data(:,i);
R=1:size(Data,2);
R(i)=[];
for j=R
Xj=Data(:,j);
sum=sum+mi(Xi,Xj);
end
REDUN=[REDUN,sum];
end

rdn=REDUN
