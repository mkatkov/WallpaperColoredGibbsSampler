classdef Exp9 < handle % fMRI, presentation3
    properties
        nick;
        data;
        presentation;
    end
    methods
        function obj= Exp9( nick, mode )
            
            if ~exist( 'mode', 'var' )
                mode= true;
            end
            
            % first we need to determine observer
            obj.nick= nick;
            addpath('..\WallpaperGroup\StimulusGenerator');
            grList= {@groupP6 };
            
            %then we need to check if data for the observer exist
            metaCl= metaclass( obj );
            fname= sprintf( '../ExpData/%s_%s.mat', metaCl.Name, nick );
            fprintf( '%s\n', fname )
            if exist( fname, 'file' ),
                obj.data= load(fname);
            else
                % create basic structure of experiment
                [~, betaIdx] = sort( rand(99, numel(grList)) );
                betaIdx= [repmat(100, 1, numel(grList)); betaIdx];
                obj. data= struct( 'groupList', [], 'curGroup', 1, ...
                    'groupPermutation', randperm( numel(grList) ), ...
                    'betaIdx', betaIdx, 'curBeta', 1, 'trialData', [], ...
                    'curImg', 1);
                obj.data.trialData= cell( numel(grList), 10 );
                obj.data.groupList= grList;
            end
            
            % we can run exprimental session here (20 min each)
            
            obj.presentation= presentation3(); 
            metaCl= metaclass( grList{ obj.getCurGroup() }() );
            %disp(metaCl);
            %fprintf( '%s\n', metaCl.Name );
            obj.presentation.loadData( metaCl.Name );
            trData= obj.data.trialData{ obj. getCurGroup() };
            if ~isempty( trData),
                obj.presentation.trialData= trData;
            end
            if mode,
                try
                obj.presentation.prepareVpiXX();
                catch
                obj.presentation.prepareNormalScreen( 1 );
                    
                end
            else
                obj.presentation.prepareNormalScreen( 0 );
            end
            
            
            obj.presentation.prepareScreen();
            start= GetSecs();
            
            %imgIdx=1;
            curTime= GetSecs();
            %while curTime- start< 20*60,
                obj.presentation.runTrial(  );
                if obj.data.curBeta >= size( obj.data. betaIdx, 1 ),
                    % we are done with this group
                    obj.data.trialData{ obj. getCurGroup(), 1 }= obj.presentation.trialData;
                    if obj. data. curGroup == numel( grList ),
                        if obj.data.curImg > 10,
                            %break; %we are done with experiment
                        end
                        obj.data.curImg = obj.data.curImg +1;
                        obj.data.curBeta=1;
                        obj.data.curGroup=0;
                    end
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
                        [obj.data.curBeta, obj.data.curImg]= ind2sub( [size( obj.data. betaIdx, 1 ), 10], numel(trData. report)+1 );
                    else
                        obj.presentation.clearTrialData();
                        obj.data.curBeta=1;
                    end
                else
                    obj.data.curBeta=obj.data.curBeta+1;
                end
                Screen( 'FillRect', obj.presentation.win, 0.25 );
                Screen( 'Flip', obj.presentation.win );
                curTime= GetSecs();                
            %end
            obj.data.trialData{ obj. getCurGroup(), 1 }= obj.presentation.trialData;
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

