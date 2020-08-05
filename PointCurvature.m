%%
A = x(1:3:3133);
B = y(1:3:3133);
C = z(1:3:3133);
partial_data = [A,B,C];
function  [K,H]=Point_Curvature(worldPoints,partial_data)

%此函数的功能是模型上的部分点的曲率
%data    为模型上所有的点
%partial_data    为模型上的部分点(特征点或匹配候选点)

[Prow,Pcol]=size(partial_data);
[row,col]=size(worldPoints);

for i=1:Prow
    
    distance=[];
    for j=1:row     
       distance(j)=sqEuclidean_distance(partial_data(i,:),worldPoints(j,:));        
    end
  
    [sortdis,x]=sort(distance);
    mindis_five(1:5)=sortdis(2:6);
%计算最小5个距离的点的标号，存放于 矩阵mindis_label
    mindis_label(1:5,i)=x(2:6);
    
%coef存放所有点的方程的系数
    for j=1:5
        x=worldPoints(mindis_label(j,i),1);
        y=worldPoints(mindis_label(j,i),2);
        z=worldPoints(mindis_label(j,i),3);
        coef(5*(i-1)+j,1:6)=[x^2 2*x*y y^2 x y z];  
    end 
    
% A存放的是第i个点的方程的系数
    A=[];
    A=[coef(5*(i-1)+1,:);coef(5*(i-1)+2,:);coef(5*(i-1)+3,:);coef(5*(i-1)+4,:);coef(5*(i-1)+5,:)];
    
% 用高斯消元法解系数方程组
    Adet(i)=det(A(:,1:5));
    [L,U]=lu(A(:,1:5));
    coef_value(1:5,i)=U\(L\A(:,6));

    a=coef_value(1,i);
    b=coef_value(2,i);
    c=coef_value(3,i);
    d=coef_value(4,i);
    e=coef_value(5,i);

    K(i)=4*(a*c-b^2)/(1+d^2+e^2)^2;
    H(i)=(a+c+a*e^2+c*d^2-2*b*d*e)/(1+d^2+e^2)^(3/2);   
end
end

%%
  function    distance = sqEuclidean_distance(fist,last)
distance = norm(fist - last);
  end



