%%
%after DIC calculation , extract the DIC data for 3D reconstruction
load('C:\Users\Administrator\Desktop\3D reconstruction\ncorr_data.mat');

%Extract results
Disp = data_dic_save.displacements;
DispInfo = data_dic_save.dispinfo;
nCur=size(Disp,2);

Factor = DispInfo.spacing+1;
ROI_DIC = cell(nCur,1);
CorCoeff=cell(nCur,1); CorCoeffVec=cell(nCur,1); Points=cell(nCur,1);
Uvec=cell(nCur,1); Vvec=cell(nCur,1);

for ii=1:nCur
    
    ROI_DIC{ii}=Disp(ii).roi_dic.mask;
    
    CorCoeff{ii}=Disp(ii).plot_corrcoef_dic;
    Uref=Disp(ii).plot_u_ref_formatted;
    Vref=Disp(ii).plot_v_ref_formatted;
    
    [YrefROIVec,XrefROIVec] = find(ROI_DIC{1});
    [YcurROIVec,XcurROIVec] = find(ROI_DIC{ii});
    
    PtempRef=[XrefROIVec,YrefROIVec];
    PtempRef=(PtempRef-1)*Factor+1; % switch from sapcing to pixels
    Pref=PtempRef;
    
    CorCoeffVec{ii}=CorCoeff{ii}(ROI_DIC{1});
    CorCoeffVec{ii}(CorCoeffVec{ii}==0)=NaN;
    
     % displacements from ref to cur
    UrefROIVec=Uref(ROI_DIC{1});
    UrefROIVec(UrefROIVec==0)=NaN;
    VrefROIVec=Vref(ROI_DIC{1});
    VrefROIVec(VrefROIVec==0)=NaN;
    
    Uvec{ii}=UrefROIVec;
    Vvec{ii}=UrefROIVec;
    % current points
    Points{ii}=[Pref(:,1)+UrefROIVec,Pref(:,2)+VrefROIVec];
end

%%
%calculate the 3D points of the objects

worldPoints = triangulate(Pref,Points{1},stereoParams);

%%
%3d visualization results of the lattice data
syms x y z

x = worldPoints(:,1);
y = worldPoints(:,2);
z = worldPoints(:,3);
scatter3(x,y,z,'.');

%%
%export the data of 3Dpoints as text formatting
save worldPoints.txt worldPoints -ascii -double

%%
% The purpose of this part is to calculate the curvature of the reconstructed 3d surface
%    handles_ncorr = ncorr

%ncorr_data
