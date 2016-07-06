a=1.5;
c=10;
[u,v]=meshgrid(-90:-10:-270,0:10:360);
z=(c+a*cosd(v)).*cosd(u);
y=(c+a*cosd(v)).*sind(u);
x=a*sind(v);
surfl(x,y,z)
hold on;
[xs,ys,zs] = sphere(40);
surf(a*xs,a*ys+c,a*zs) % centered at (3,-2,0)
surf(a*xs,a*ys-c,a*zs) % centered at (0,1,-3)
axis equal;
h=10;
d = 7;
surf(a*xs,a*ys+d,a*zs+h) % centered at (0,1,-3)
surf(a*xs,a*ys-d,a*zs+h) % centered at (0,1,-3)
r = 1.2;
%axis([-r*c r*c -r*c r*c -r*c r*c]);

