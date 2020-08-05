function [Points,CorCoeffVec,F,CF] = extractNcorrResults(handles_ncorr,IMref)
DICresults = handles_ncorr.data_dic;

% Extract results
Disp=DICresults.displacements;
DispInfo=DICresults.dispinfo;
nCur=size(Disp,2);

Factor=DispInfo.spacing+1;
ROI_DIC=cell(nCur,1);
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
    
    % save face colors for further 3D analysis
    if ii==1
        % pixel colors
        IMrefSmall=IMref(1:Factor:end,1:Factor:end);
        IMrefSmallMasked=IMrefSmall;
        IMrefSmallMasked(~ROI_DIC{1})=[];
        ColorRef=IMrefSmallMasked(:);
    end
    
end