classdef Exp6 < handle % different Size with presentation2
    properties
        nick;
        data;
        presentation;
    end
    methods
        function obj= Exp6( nick, mode )
            
            if ~exist( 'mode', 'var' )
                mode= true;
            end
            
            % first we need to determine observer
            obj.nick= nick;
            addpath('..\WallpaperGroup\StimulusGenerator');
            grList= {@groupP1, @groupP3, groupP3M1, ...
                @groupP31M, groupP6, groupP6M };
            
            %then we need to check if data for the observer exist
            metaCl= metaclass( obj );
            fname= sprintf( '../ExpData/%s_%s.mat', metaCl.Name, nick );
            fprintf( '%s\n', fname )
            if exist( fname, 'file' ),
                obj.data= load(fname);
            else
                % create basic structure of experiment
                % we need beta, group, img, size Idxs
                betaIdx= repmat( (1:10)' , [1, numel( grList), 10, 8, 10] );
                groupIdx= repmat( 1:numel( grList) , [10, 1, 10, 8, 10] );
                imgIdx= repmat( shiftdim(1:10, -1) , [10, numel( grList), 1, 8, 10] );
                sizeIdx= repmat( shiftdim(1:8,-2) , [10, numel( grList), 10, 1, 10 ]);

                permIdx= randperm( numel( betaIdx ) );
                betaIdx= betaIdx( permIdx );
                groupIdx= groupIdx( permIdx );
                imgIdx= imgIdx( permIdx );
                sizeIdx= sizeIdx( permIdx );

                obj. data= struct( 'groupIdx', groupIdx, 'imgIdx', imgIdx, ...
                    'sizeIdx', sizeIdx, ...
                    'betaIdx', betaIdx, 'curStim', 1, 'trialData', [] );
                obj.data.trialData= [];
                obj.data.groupList= grList;
            end
            
            % we can run exprimental session here (20 min each)
            
            obj.presentation= presentation2(); 
            %metaCl= metaclass( grList{ obj.getCurGroup() }() );
            %disp(metaCl);
            %fprintf( '%s\n', metaCl.Name );
            obj.presentation.loadData(  );
            trData= obj.data.trialData;
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
            
            %imgIdx=1;
            curTime= GetSecs();
            while curTime- start< 20*60,
                obj.presentation.runTrial(   obj.data.betaIdx(obj.data.curStim), ...
                     obj.data.imgIdx(obj.data.curStim), ...
                      obj.data.groupIdx(obj.data.curStim), ...
                      obj.data.sizeIdx(obj.data.curStim), ...
                      obj.data.curStim );
                if obj.data.curStim >= numel( obj.data. betaIdx ),
                    % we are done with this group
                    break;
                else
                    obj.data.curStim=obj.data.curStim+1;
                end
                curTime= GetSecs();                
            end
            obj.data.trialData= obj.presentation.trialData;
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

