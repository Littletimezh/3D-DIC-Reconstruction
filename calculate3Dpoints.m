%%
syms worldPoints 
load('Points.mat');
load('stereoParams.mat');
load('Pref.mat');

worldPoints = triangulate(Pref,Points{1},stereoParams);

worldPoints