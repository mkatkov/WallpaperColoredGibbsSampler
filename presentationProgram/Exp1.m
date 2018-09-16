classdef Exp1 < handle
    properties
        nick;
        data;
        presentation;
    end
    methods
        function obj= Exp1( nick, mode )
            
            if ~exist( 'mode', 'var' )
               mode= true; 
            end
            
            % first we need to determine observer
            obj.nick= nick;
            addpath('..\WallpaperGroup\StimulusGenerator');
            grList= {@groupPM, @groupPG, @groupPMM, ...
                @groupPMG, @groupP4, ...
                @groupPGG, @groupP4M, @groupP4G, @groupP3, groupP3M1, ...
                @groupP31M, groupP6, groupP6M };
            
            %then we need to check if data for the observer exist
            fname= sprintf( '../ExpData/exp1_%s.mat', nick );
            if exist( fname, 'file' ),
                obj.data= load(fname);
            else
                % create basic structure of experiment
                [~, betaIdx] = sort( rand(500, numel(grList)) );
                betaIdx= [ones(1, numel(grList)); betaIdx+1];
                obj. data= struct( 'groupList', [], 'curGroup', 1, ...
                    'groupPermutation', randperm( numel(grList) ), ...
                    'betaIdx', betaIdx, 'curBeta', 1, 'trialData', [] );
                obj.data.trialData= cell( numel(grList), 1 );
                obj.data.groupList= grList;
            end
            
            % we can run exprimental session here (20 min each)
            
            obj.presentation= presentation(); %#ok<CPROP>
            metaCl= metaclass( grList{ obj.getCurGroup() }() );
            %disp(metaCl);
            fprintf( '%s\n', metaCl.Name );
            obj.presentation.loadData( metaCl.Name );            
            trData= obj.data.trialData{ obj. getCurGroup() };
            if ~isempty( trData),
                obj.presentation.trialData= trData;
            end
            if mode,
                obj.presentation.prepareVpiXX();                
            else
                obj.presentation.prepareNormalScreen();
            end
            
            
            obj.presentation.prepareScreen();
            start= GetSecs();
            
            imgIdx=1;
            
            while GetSecs()- start< 20*60,
                obj.presentation.runTrial(  obj.data.betaIdx(obj.data.curBeta), imgIdx );
                if obj.data.curBeta >= size( obj.data. betaIdx, 1 ),
                   % we are done with this group 
                   if obj. data. curGroup == numel( grList ),
                      break; %we are done with experiment
                   end
                   obj.data.trialData{ obj. getCurGroup() }= obj.presentation.trialData;
                   %obj. presentation.drawTextCenter('Preparing new symmetry group, please wait');
                   Screen( 'FillRect', obj.presentation.win, 0.5 )
                   Screen( 'Flip', obj.presentation.win )
                   obj. data. curGroup= obj. data. curGroup+1;
                   data= obj.data; %#ok<PROP,NASGU>
                   save( fname, '-struct', 'data' );
                   clear data
                   metaCl= metaclass( grList{ obj.getCurGroup() }() );
                   obj.presentation.loadData( metaCl.Name )
                   trData= obj.data.trialData{ obj. getCurGroup };
                   if ~isempty( trData),
                       obj.presentation.trialData= trData;
                       obj.data.curBeta= numel( trData. report )+1;
                   else
                       obj.presentation.clearTrialData();
                       obj.data.curBeta=1;
                   end
                else
                    obj.data.curBeta=obj.data.curBeta+1;
                end
                Screen( 'FillRect', obj.presentation.win, 0.25 )
                Screen( 'Flip', obj.presentation.win )
            end
            obj.data.trialData{ obj. getCurGroup() }= obj.presentation.trialData;
            data= obj.data; %#ok<PROP,NASGU>
            save( fname, '-struct', 'data' );
            PsychPortAudio( 'Close' );
            Screen( 'CloseAll' )
        end
        function curGroup= getCurGroup( obj )
            curGroup= obj. data. groupPermutation( obj. data.curGroup );
        end
    end
end

