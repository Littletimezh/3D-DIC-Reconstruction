syms x y z
x;
y;
z;

n = 5;
p = polyfit(x,y,z,n);
xi = linspace(0,1,100);
plot(x,y,z,'.','k:',x,y,z,'b');
legend('原始数据','n阶曲线')
