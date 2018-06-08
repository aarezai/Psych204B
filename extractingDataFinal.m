%For each of the runs which I did not use to define the roi's, I want
%to extract the multivoxel time series. Additionally, I will also need
%the onset times and conditions for each stimulus, and am interested 
%in the betas from each voxel for each condition.

rois = {'mFus','pFus'}; %Names of ROI's that I have defined in mrVista

cd /Users/kweb/Documents/MATLAB/kgs072010_new %Path to mrSession

GLM_number = 10:13;
%The scan number for the glm associated with each of the followin runs:
%'DynamicRun2','StaticRun2','DynamicRun3','StaticRun3'

mvd = []; %Instantiating a structure that will contain the multi-voxel
          %data (mvd) across all of the runs
          
for glm = GLM_number
    
    for roi = 1:length(rois)
        
        %For this glm and roi, I want to initalize a hidden inplane
        hiddenIn = initHiddenInplane('GLMs',glm,rois(roi));
        
        %Extracting scan numbers and dts associated with the glm
        [scans,dts] = er_getScanGroup(hiddenIn,hiddenIn.curScan);
        
        %Extracting the multivoxel data for this group of scans
        mv = mv_init(hiddenIn,rois(roi),scans,dts,0);
        
        %Applying glm to all of the voxels
        mv = mv_applyGlm(mv);
        
        %I'll organize the multivoxel data into a structure with
        %4 rows corresponding to the 4 runs, and 2 columns corresponding
        %to the 2 rois
        mvd(glm-9,roi).tSeries = mv.tSeries; %Storing timeseries in mvd
        mvd(glm-9,roi).trialOnsets = mv.trials.onsetSecs; %Storing onset times
        mvd(glm-9,roi).trialConditions = mv.trials.cond; %Storing conditions 
                                          %for each stimulusc
        mvd(glm-9,roi).betas = squeeze(mv.glm.betas); %Storing beta from each voxel 
                                             %for each condition
    end
end

save('/Users/kweb/Documents/MATLAB/kgs072010_new/projectDataMVD.mat','mvd');