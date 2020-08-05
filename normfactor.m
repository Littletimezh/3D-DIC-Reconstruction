kdtree = vl_kdtreebuild(worldPoints);      %使用vlfeat建立kdtree

normE=[];
for i=1:length(worldPoints)
    
    p_cur = worldPoints(:,i);
    [index, distance] = vl_kdtreequery(kdtree, worldPoints, p_cur, 'NumNeighbors', 10);    %寻找当前点最近的10个点
    p_neighbour = worldPoints(:,2)';
    p_cent = mean(p_neighbour);     %得到局部点云平均值，便于计算法向量长度和方向
    
    %最小二乘估计平面
    X=p_neighbour(:,1);
    Y=p_neighbour(:,2);
    Z=p_neighbour(:,3);
    XX=[X Y ones(length(2),1)];
    YY=Z;
    %得到平面法向量
    C=(XX'*XX)\XX'*YY;
    
    %局部平面指向局部质心的向量
    dir1 = p_cent-p_cur';
    %局部平面法向量
    dir2=[C(1) C(2) -1];
    
    %计算两个向量的夹角
    ang = dir1.*dir2 / (sqrt(dir1(1)^2 +dir2(1)^2) + sqrt(dir1(2)^2 +dir2(2)^2)+sqrt(dir1(3)^2 +dir2(3)^2) );
    
    %根据夹角判断法向量正确的指向
    flag = acos(ang);
    dis = norm(dir1);
    if flag<0
        dis = -dis;
    end
    
    %画出当前点的表面法向量
    t=(0:dis/100:dis)';
    x = p_cur(1) + C(1)*t;
    y = p_cur(2) + C(2)*t;
    z = p_cur(3) + (-1)*t;
    
    normE =[normE;x y z];
    i
end
pcshowpair(pc,pointCloud(normE));