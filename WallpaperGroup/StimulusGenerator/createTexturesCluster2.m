% createTexturesCluster2.m
%
% create a texture database

classdef createTexturesCluster2 < handle
    properties(Constant=true)
        chunkSize= 1000;
    end
    methods(Static=true)
        function createParameters( )
            % into file imageGenerationParameters2 we need to write structure
            % with following fields:
            %
            % curImgIdx
            % groupName
            % betas
            %
            task. curImgIdx= 1;
            groupNames= { 'P1', 'P2', 'CM', 'CMM', ...
                'PM', 'PG', 'PMM', 'PMG', 'P4', ...
                'PGG', 'P4M', 'P4G', 'P3', 'P3M1', ...
                'P31M', 'P6','P6M'  };
            multipliers= { 1, [1 1], [1 1], [1 1 1], ...
                [1 1], [1 0.5], [1 1 1], [0.5 0.25 0.3], [0.5 0.5], ...
                [0.5 0.3 0.3], [0.5 0.3 0.3], [0.6 0.5 0.5], [1 1 1], [1 1 1], ...
                [1 1 1], [1 1 1 1], [1 1 1 1 1 1] };
            
            task. groupName= cell(1, 0);
            task.betas= cell(1, 0);
            
            % P1:
            %             bb= linspace( 0.025, 0.225, 2 );
            %             for b= bb,
            %                task. groupName{ end+1}= 'P1';
            %                task.betas{end+1}= b;
            %             end
            
            %             % 'P2',
            %             % full
            %             bb= linspace( 0.025, 0.3, 2 );
            %             for b= bb,
            %                task. groupName{ end+1}= 'P2';
            %                task.betas{end+1}= [b b];
            %             end
            %             % translate
            %             bb= linspace( 0.025, 100, 2 );
            %             for b= bb,
            %                task. groupName{ end+1}= 'P2';
            %                task.betas{end+1}= [b 0];
            %             end
            %             % second symmetry
            %             bb= linspace( 0.0, 100, 2 );
            %             for b= bb,
            %                task. groupName{ end+1}= 'P2';
            %                task.betas{end+1}= [0 b];
            %             end
            %
            %             %'CM',
            %             % full
            %             bb= linspace( 0.025, 0.125, 2 );
            %             for b= bb,
            %                task. groupName{ end+1}= 'CM';
            %                task.betas{end+1}= [b b];
            %             end
            %             % translate
            %             bb= linspace( 0.025, 100, 2 );
            %             for b= bb,
            %                task. groupName{ end+1}= 'CM';
            %                task.betas{end+1}= [b 0];
            %             end
            %             % second symmetry
            %             bb= linspace( 0.0, 400, 2 );
            %             for b= bb,
            %                task. groupName{ end+1}= 'CM';
            %                task.betas{end+1}= [0 b];
            %             end
            % % %
            %             %'CMM', ...
            %             % full
            %             bb= linspace( 0.025, 0.125, 2 );
            %             for b= bb,
            %                task. groupName{ end+1}= 'CMM';
            %                task.betas{end+1}= [b b b];
            %             end
            %             % translate
            %             bb= linspace( 0.025, 1, 2 );
            %             for b= bb,
            %                task. groupName{ end+1}= 'CMM';
            %                task.betas{end+1}= [b 0 0];
            %             end
            %             % second symmetry
            %             bb= linspace( 0.0, 400, 2 );
            %             for b= bb,
            %                task. groupName{ end+1}= 'CMM';
            %                task.betas{end+1}= [0 b 0];
            %             end
            %             % second symmetry
            %             bb= linspace( 0.0, 400, 2 );
            %             for b= bb,
            %                task. groupName{ end+1}= 'CMM';
            %                task.betas{end+1}= [0 0 b];
            %             end
            %
            % %
            %             %    'PM',
            %             % full
            %             bb= linspace( 0.1, 0.75, 2 );
            %             for b= bb,
            %                task. groupName{ end+1}= 'PM';
            %                task.betas{end+1}= [b b];
            %             end
            %             % translate
            %             bb= linspace( 0.1, 100, 2 );
            %             for b= bb,
            %                task. groupName{ end+1}= 'PM';
            %                task.betas{end+1}= [b 0];
            %             end
            %             % second symmetry
            %             bb= linspace( 0.0, 100, 2 );
            %             for b= bb,
            %                task. groupName{ end+1}= 'PM';
            %                task.betas{end+1}= [0 b];
            %             end
            
            %             %'PG',
            %             % full
            %             bb= linspace( 0.2, 0.75, 2 );
            %             for b= bb,
            %                task. groupName{ end+1}= 'PG';
            %                task.betas{end+1}= [b b ].*multipliers{6};
            %             end
            %             % translate
            %             bb= linspace( 0.2, 1, 2 );
            %             for b= bb,
            %                task. groupName{ end+1}= 'PG';
            %                task.betas{end+1}= [b 0 ].*multipliers{6};
            %             end
            %             % second symmetry
            %             bb= linspace( 0.0, 4, 2 );
            %             for b= bb,
            %                task. groupName{ end+1}= 'PG';
            %                task.betas{end+1}= [0 b ];
            %             end
            % %
            %             %'PMM',
            %             % full
            %             bb= linspace( 0.15, 0.55, 2 );
            %             for b= bb,
            %                task. groupName{ end+1}= 'PMM';
            %                task.betas{end+1}= [b b b];
            %             end
            %             % translate
            %             bb= linspace( 0.15, 10, 2 );
            %             for b= bb,
            %                task. groupName{ end+1}= 'PMM';
            %                task.betas{end+1}= [b 0 0];
            %             end
            %             % second symmetry
            %             bb= linspace( 0.0, 2, 2 );
            %             for b= bb,
            %                task. groupName{ end+1}= 'PMM';
            %                task.betas{end+1}= [0 b 0];
            %             end
            %             % second symmetry
            %             bb= linspace( 0.0, 2, 2 );
            %             for b= bb,
            %                task. groupName{ end+1}= 'PMM';
            %                task.betas{end+1}= [0 0 b];
            %             end
            
            %              %'PMG',
            %             % full
            %             bb= linspace( 0.35, 0.75, 2 );
            %             for b= bb,
            %                task. groupName{ end+1}= 'PMG';
            %                task.betas{end+1}= [b b b].*multipliers{8};
            %             end
            %             % translate
            %             bb= linspace( 0.2, 100, 2 );
            %             for b= bb,
            %                task. groupName{ end+1}= 'PMG';
            %                task.betas{end+1}= [b 0 0].*multipliers{8};
            %             end
            %             % second symmetry
            %             bb= linspace( 0.35, 200, 2 );
            %             for b= bb,
            %                task. groupName{ end+1}= 'PMG';
            %                task.betas{end+1}= [0 b 0].*multipliers{8};
            %             end
            %             % second symmetry
            %             %bb= linspace( 0.0, 4, 20 );
            %             for b= bb,
            %                task. groupName{ end+1}= 'PMG';
            %                task.betas{end+1}= [0 0 b].*multipliers{8};
            %             end
            
            %'P4', ...
%             %full
%             bb= linspace( 0.5, 0.8, 2 );
%             for b= bb,
%                 task. groupName{ end+1}= 'P4';
%                 task.betas{end+1}= [b b].*multipliers{9};
%             end
%             % translate
%             bb= linspace( 0.025, 10, 2 );
%             
%             for b= bb,
%                 task. groupName{ end+1}= 'P4';
%                 task.betas{end+1}= [b 0].*multipliers{9};
%             end
%             % second symmetry
%             bb= linspace( 0.4, 10, 2 );
%             
%             for b= bb,
%                 task. groupName{ end+1}= 'P4';
%                 task.betas{end+1}= [0 b].*multipliers{9};
%             end
            
            
                        %    'PGG',
                        % full
%                         bb= linspace( 0.5, 0.75, 2 );
%                         for b= bb,
%                            task. groupName{ end+1}= 'PGG';
%                            task.betas{end+1}= [b b b].*multipliers{10};
%                         end
                        % translate
%                         bb= linspace( 0.2, 4, 2 );
%                         bb=3;
% %                         for b= bb,
% %                            task. groupName{ end+1}= 'PGG';
% %                            task.betas{end+1}= [b 0 0].*multipliers{10};
% %                         end
%                         % second symmetry
% %                         bb= linspace( 0.2, 400, 2 );
%                         for b= bb,
%                            task. groupName{ end+1}= 'PGG';
%                            task.betas{end+1}= [0 b 0];
%                         end
%                         % second symmetry
%                         %bb= linspace( 0.0, 4, 20 );
%                         for b= bb,
%                            task. groupName{ end+1}= 'PGG';
%                            task.betas{end+1}= [0 0 b];
%                         end
            
            
                        %'P4M',
                         % full
%                          bb=2;
%                         %bb= linspace( 0.5, 0.75, 2 );
%                         for b= bb,
%                            task. groupName{ end+1}= 'P4M';
%                            task.betas{end+1}= [b b b];
%                         end
%                         % translate
%                         %bb= linspace( 0.2, 100, 20 );
%                         for b= bb,
%                            task. groupName{ end+1}= 'P4M';
%                            task.betas{end+1}= [b 0 0];
%                         end
%                         % second symmetry
%                         %bb= linspace( 0.2, 400, 2 );
%                         for b= bb,
%                            task. groupName{ end+1}= 'P4M';
%                            task.betas{end+1}= [0 b 0];
%                         end
%                         % second symmetry
%                         %bb= linspace( 0.0, 4, 20 );
%                         for b= bb,
%                            task. groupName{ end+1}= 'P4M';
%                            task.betas{end+1}= [0 0 b];
%                         end
            
                       %'P4G',
                          % full
                        %bb= linspace( 0.38, 0.55, 2 );
%                         bb=10;
%                         for b= bb,
%                            task. groupName{ end+1}= 'P4G';
%                            task.betas{end+1}= [b b b];
%                         end
%                         % translate
%                         %bb= linspace( 0.2, 75, 2 );
%                         for b= bb,
%                            task. groupName{ end+1}= 'P4G';
%                            task.betas{end+1}= [b 0 0];
%                         end
%                         % second symmetry
%                         %bb= linspace( 0.2, 400, 2 );
%                         for b= bb,
%                            task. groupName{ end+1}= 'P4G';
%                            task.betas{end+1}= [0 b 0];
%                         end
%                         % second symmetry
%                         %bb= linspace( 0.0, 4, 20 );
%                         for b= bb,
%                            task. groupName{ end+1}= 'P4G';
%                            task.betas{end+1}= [0 0 b];
%                         end
            
%                         %'P3',
%                         % full
%                         bb= linspace( 0.08, 0.18, 2 );
%                         bb= 1;
%                         for b= bb,
%                            task. groupName{ end+1}= 'P3';
%                            task.betas{end+1}= [b b ];
%                         end
%                         %translate
%                         for b= bb,
%                            task. groupName{ end+1}= 'P3';
%                            task.betas{end+1}= [b 0 ];
%                         end
%                         % second symmetry
%                         %bb= linspace( 0.0, 400, 2 );
%                         for b= bb,
%                            task. groupName{ end+1}= 'P3';
%                            task.betas{end+1}= [0 b ];
%                         end
%                         % second symmetry
% %                         for b= bb,
% %                            task. groupName{ end+1}= 'P3';
% %                            task.betas{end+1}= [0 0 b];
% %                         end
            %
                        %'P3M1', ...
                        % full
                        %bb= linspace( 0.125, 0.25, 2 );
                        bb=10;
                        for b= bb,
                           task. groupName{ end+1}= 'P3M1';
                           task.betas{end+1}= [b b b];
                        end
                        % translate
                        for b= bb,
                           task. groupName{ end+1}= 'P3M1';
                           task.betas{end+1}= [b 0 0];
                        end
                        % second symmetry
                        %bb= linspace( 0.0, 100, 2 );
                        for b= bb,
                           task. groupName{ end+1}= 'P3M1';
                           task.betas{end+1}= [0 b 0];
                        end
                        % second symmetry
                        for b= bb,
                           task. groupName{ end+1}= 'P3M1';
                           task.betas{end+1}= [0 0 b];
                        end
            %
            %             %    'P31M',
            %              % full
            %             bb= linspace( 0.02, 0.06, 2 );
            %             for b= bb,
            %                task. groupName{ end+1}= 'P31M';
            %                task.betas{end+1}= [b b b];
            %             end
            %             % translate
            %             bb= linspace( 0.0, 400, 2 );
            %             for b= bb,
            %                task. groupName{ end+1}= 'P31M';
            %                task.betas{end+1}= [b 0 0];
            %             end
            %             % second symmetry
            %             bb= linspace( 0.0, 400, 2 );
            %             for b= bb,
            %                task. groupName{ end+1}= 'P31M';
            %                task.betas{end+1}= [0 b 0];
            %             end
            %             % second symmetry
            %             for b= bb,
            %                task. groupName{ end+1}= 'P31M';
            %                task.betas{end+1}= [0 0 b];
            %             end
            %
            %
            %             %'P6',
            %             % full
            %             bb= linspace( 0.05, 0.09, 2 );
            %             for b= bb,
            %                task. groupName{ end+1}= 'P6';
            %                task.betas{end+1}= [b b b b];
            %             end
            %             % translate
            %             bb= linspace( 0.0, 500, 2 );
            %             for b= bb,
            %                task. groupName{ end+1}= 'P6';
            %                task.betas{end+1}= [b 0 0 0];
            %             end
            %             % second symmetry
            %             bb= linspace( 0.0, 500, 2 );
            %             for b= bb,
            %                task. groupName{ end+1}= 'P6';
            %                task.betas{end+1}= [0 b 0 0];
            %             end
            %             % second symmetry
            %             for b= bb,
            %                task. groupName{ end+1}= 'P6';
            %                task.betas{end+1}= [0 0 b 0];
            %             end
            %             for b= bb,
            %                task. groupName{ end+1}= 'P6';
            %                task.betas{end+1}= [0 0 0 b];
            %             end
            %
            %
            %             %'P6M'
            %             % full
            %             bb= linspace( 0.025, 0.05, 2 );
            %             for b= bb,
            %                task. groupName{ end+1}= 'P6M';
            %                task.betas{end+1}= [b b b b b b];
            %             end
            %             % translate
            %             bb= linspace( 0.0, 500, 2 );
            %             for b= bb,
            %                task. groupName{ end+1}= 'P6M';
            %                task.betas{end+1}= [b 0 0 0 0 0];
            %             end
            %             % second symmetry
            %             for b= bb,
            %                task. groupName{ end+1}= 'P6M';
            %                task.betas{end+1}= [0 b 0 0 0 0];
            %             end
            %             % second symmetry
            %             for b= bb,
            %                task. groupName{ end+1}= 'P6M';
            %                task.betas{end+1}= [0 0 b 0 0 0];
            %             end
            %             for b= bb,
            %                task. groupName{ end+1}= 'P6M';
            %                task.betas{end+1}= [0 0 0 b 0 0];
            %             end
            %             for b= bb,
            %                task. groupName{ end+1}= 'P6M';
            %                task.betas{end+1}= [0 0 0 0 b 0];
            %             end
            %             for b= bb,
            %                task. groupName{ end+1}= 'P6M';
            %                task.betas{end+1}= [0 0 0 0 0 b];
            %             end
            %
            save( 'imageGenerationParameters2', '-struct', 'task', '-v7.3' );
            
        end
        function [task, task_fname]= loadData( jobNum )
            %metaCl= metaclass(symmGr);
            %symmName= metaCl.Name;
            task=load( 'imageGenerationParameters2');
            % image generation file should consist task structure with
            % initial task parameters
            task_fname= sprintf( '../images3/task_%d.mat', jobNum );
            %fname= sprintf('../images3/%s_images_%d.mat', symmName, jobNum );
            
            if exist( task_fname, 'file'),
                task= load( task_fname );
            end
        end
        function doIt(  )
            try
                jobid = getenv('LSB_JOBINDEX');
                if isempty(jobid),
                    jobnum=1;
                else
                    jobnum = str2double(jobid);
                end
            catch e %#ok<NASGU>
                jobnum=1;
            end
            % groups should be sampled with GibbsSampler
            %             groups= {@groupP1, @groupP2, @groupCM, @groupCMM, ...
            %                 @groupPM, @groupPG, @groupPMM, @groupPMG, @groupP4, ...
            %                 @groupPGG, @groupP4M, @groupP4G, @groupP3, groupP3M1, ...
            %                 @groupP31M, @groupP6, @groupP6M };
            
            [task, fname]= createTexturesCluster2. loadData( jobnum );
            
            % all tasks are finished
            
            if mod( task.curImgIdx, createTexturesCluster2. chunkSize ) == 1,
                data= createTexturesCluster2. createEmptyDataStructure( task.curImgIdx, task );
            else
                fNum= floor( (task.curImgIdx-1)/createTexturesCluster2. chunkSize  );
                data= load( sprintf( '../images3/image_%d_%d.mat', fNum, jobnum ) );
            end
            while true,
                if task. curImgIdx > length( task. betas ),
                    break;
                end
                tic
                while toc< 60*10,
                    if task. curImgIdx > length( task. betas ),
                        break;
                    end
                    %define symmetry group
                    symmGr= eval( sprintf( 'group%s()', task. groupName{ task.curImgIdx } ) );
                    
                    gs= symmGr. createUpdateGroups2( task.betas{ task.curImgIdx } );
                    if isempty( gs )
                        % this is GibbsSampler2 textures
                        ir= symmGr.getInteractionRules2( task.betas{ task.curImgIdx } );
                        gs= GibbsSampler2();
                        gs.dataClass= symmGr;
                        gs. createGroups( ir );
                        symmGr.data= randi(3, size( symmGr.data) );
                        if true,
                            gs.sample( 1000 );
                        else
                            clf
                            for k=1:1000,
                                %symmGr.data= gs.data;
                                symmGr.draw( gca ); 
                                symmGr.colorCells();
                                gs.sample( 1 );
                                drawnow();
                            end
                        end
                        data.imgData{ mod(task.curImgIdx-1, createTexturesCluster2. chunkSize )+1 }= ...
                            createTextures.packImg4Clrs( symmGr.data );
                        data. imgSize(:, mod(task.curImgIdx-1, createTexturesCluster2. chunkSize )+1 )= size(symmGr.data);
                    else % this is GibbsSampler texture
                        gs. data= randi(3, size( gs.data) );
                        if true,
                            gs.sample( 1000 );
                        else
                            clf
                            for k=1:1000,
                                symmGr.data= gs.data;
                                symmGr.draw( gca ); 
                                symmGr.colorCells();
                                gs.sample( 1 );
                            end
                        end
                        data.imgData{mod(task.curImgIdx-1, createTexturesCluster2. chunkSize )+1}= ...
                            createTextures.packImg4Clrs( gs.data );
                        data. imgSize(:, mod(task.curImgIdx-1, createTexturesCluster2. chunkSize )+1 )= size(gs.data);
                    end
                    task.curImgIdx= task.curImgIdx+1;
                    if mod( task.curImgIdx-1, createTexturesCluster2. chunkSize ) == 0,
                        fNum= floor( task.curImgIdx/createTexturesCluster2. chunkSize  );
                        save( sprintf( '../images3/image_%d_%d.mat', fNum-1, jobnum ), '-struct', 'data' );
                        data= createTexturesCluster2. createEmptyDataStructure( task.curImgIdx, task );
                    end
                end
                fNum= floor( (task.curImgIdx-1)/createTexturesCluster2. chunkSize );
                save( sprintf( '../images3/image_%d_%d.mat', fNum, jobnum ), '-struct', 'data' );
                save( fname, '-struct', 'task', '-v7.3' );
            end
        end
        function data= createEmptyDataStructure( curImgIdx, task  )
            startIdx= floor(curImgIdx/createTexturesCluster2. chunkSize )*createTexturesCluster2. chunkSize +1;
            endIdx= min(ceil(curImgIdx/createTexturesCluster2. chunkSize )*createTexturesCluster2. chunkSize , numel( task.betas));
            data. betas= task.betas( startIdx:endIdx );
            data. groupName= task.groupName( startIdx:endIdx );
            data. imgData= cell(createTexturesCluster2. chunkSize ,1);
            data. imgSize= zeros(2, createTexturesCluster2. chunkSize );
        end
        function code= packImg4Clrs( img )
            im= reshape( img, 4, numel(img)/4 );
            code= uint8([1 4 16 64]*im);
        end
        function img= unpackImg4Clrs( code, size )
            img= rem(floor(1./[1; 4; 16; 64]* double(code) ),4);
            img= reshape( img, size);
        end
    end
end