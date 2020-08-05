%%
%Some points are randomly selected from the 3d point cloud and the interval
%curvature of the point cloud is calculated
load('worldPoints.txt');

x = worldPoints(:,1);
y = worldPoints(:,2);
z = worldPoints(:,3);
scatter3(x,y,z,'.');

A = x(1:3:3133);
B = y(1:3:3133);
C = z(1:3:3133);
partial_data = [A,B,C];

%%
%The curvature of the point with interval step of 2 in the point cloud
%is calculated
%worldPoints are all the points,and partial_data is 1/3 points of 
%the worldPoints
% function  [K,H]=Point_Curvature(worldPoints,partial_data)

[Prow,Pcol]=size(partial_data);
[row,col]=size(worldPoints);

K = 0;
sum = 0;

for i=1:Prow
    
    distance=[];
    for j=1:row
        distance(j)=sqrt((A(i,1)-x(j,1))^2+(B(i,2)-y(j,2))^2);        
    end
    
    [sortdis,x]=sort(distance);
    mindis_five(1:5)=sortdis(2:6);
    
    %The label number of the point with the minimum 5 distances is 
    %calculated and stored in the matrix mindis_label
    mindis_label(1:5,i)=x(2:6);
    
    %coef stores the coefficients of the equation that holds all the points
    for j=1:5
        x=worldPoints(mindis_label(j,i),1);
        y=worldPoints(mindis_label(j,i),2);
        z=worldPoints(mindis_label(j,i),3);
        coef(5*(i-1)+j,1:6)=[x^2 2*x*y y^2 x y z];  
    end 
    
    % m stores the coefficient of the equation of the i-th point
    m=[];
    m=[coef(5*(i-1)+1,:);coef(5*(i-1)+2,:);coef(5*(i-1)+3,:);
        coef(5*(i-1)+4,:);coef(5*(i-1)+5,:)];
    
    % Solving the coefficient equations by Gaussian elimination
    Adet(i)=det(m(:,1:5));
    [L,U]=lu(m(:,1:5));
    coef_value(1:5,i)=U\(L\m(:,6));

    a=coef_value(1,i);
    b=coef_value(2,i);
    c=coef_value(3,i);
    d=coef_value(4,i);
    e=coef_value(5,i);

    K(i)=4*(a*c-b^2)/(1+d^2+e^2)^2;
    H(i)=(a+c+a*e^2+c*d^2-2*b*d*e)/(1+d^2+e^2)^(3/2); 
    K = sum + K(i);
end
average_curvature = K/Prow;
% end