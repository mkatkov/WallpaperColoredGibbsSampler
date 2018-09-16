% presentation program using psytoolbox
%

classdef presentation2 < handle
    properties
        imgData;
        dataSize;
        gr;
        win;
        winRect;
        texInd;
        trialData;
        audioPortHandle;
    end
    methods(Static=true)
        function rectNew= affineTransform( rect, shift, size )
            sz= [size(:); size(:)];
            sh= [shift(:);shift(:)];
            rectNew= bsxfun( @plus, bsxfun(@times, rect, sz ), sh);
        end
        function rectNew= rotate( rect, center, angle )
            sh= [center(:);center(:)];
            rot= [cos(angle) sin(angle); -sin(angle) cos(angle)];
            rot= blkdiag( rot, rot );
            rectNew= bsxfun( @plus, rot*( bsxfun( @minus, rect, sh) ), sh);
        end
    end
    methods
        function obj= presentation2()
            obj. clearTrialData();
        end
        function clearTrialData( obj )
            obj. trialData= struct( 'trialOnset', [], 'reportTime', [], ...
                'report', [], 'presentationQuadrant', [], 'betaIdx', [], ...
                'imgIdx', [], 'sizeIdx', [], 'grIdx', [] );
        end
        function loadData( obj )
            grList= {@groupP1, @groupP3, groupP3M1, ...
                @groupP31M, groupP6, groupP6M };
            
            for grIdx=1: numel(grList ),
                metaCl= metaclass( grList{ grIdx }() );
                grName= metaCl.Name;
                load( sprintf( '..\\WallpaperGroup\\images2\\%s_images_', grName ) );
                addpath('..\WallpaperGroup\StimulusGenerator');
                obj. gr{grIdx}= feval( grName );
                obj. dataSize{grIdx}= dataSize; %#ok<CPROP>
                switch grName,
                    case 'groupP1'
                        imgIdx= round( linspace(1, 90, 10 ) );
                    case 'groupP3'
                        imgIdx= round( linspace(10, 90, 10 ) );
                    case 'groupP3M1'
                        imgIdx= round( linspace(30, 90, 10 ) );
                    case 'groupP31M'
                        imgIdx= round( linspace(10, 70, 10 ) );
                    case 'groupP6'
                        imgIdx= round( linspace(25, 90, 10 ) );
                    case 'groupP6M'
                        imgIdx= round( linspace(25, 90, 10 ) );
                end
                obj. imgData{grIdx}= imgData(:, imgIdx, : ); %#ok<PROP,NODEF>
            end
        end
        function drawTexture( obj, data, texInd, texRect, quadrant, screenWidth, screenHeight )
            %define coordinates according to quadrant
            offAll = [-1 1 -1 1; -1 -1 1 1]/4;
            off= offAll(:, quadrant);
            for k=1:3,
                texRectPos= presentation.affineTransform( texRect(:, data==(4-k) ), off*screenHeight+[screenWidth; screenHeight]/2,[screenHeight screenHeight]*0.4 );
                Screen( 'DrawTextures', obj.win, texInd(k), [], texRectPos );
            end
        end
        function drawTexturePart( obj, data, texInd, texRect, quadrant, screenWidth, screenHeight, ind )
            %define coordinates according to quadrant
            offAll = [-1 1 -1 1; -1 -1 1 1]/4;
            off= offAll(:, quadrant);
            for k=1:3,
                texRectPos= presentation.affineTransform( texRect(:, data==(4-k) ), off*screenHeight+[screenWidth; screenHeight]/2,[screenHeight screenHeight]*0.4 );
                Screen( 'DrawTextures', obj.win, texInd(k), [], texRectPos(:, ind) );
            end
        end
        function drawTextureRot( obj, data, texInd, texRect, quadrant, screenWidth, screenHeight, angle )
            %define coordinates according to quadrant
            offAll = [-1 1 -1 1; -1 -1 1 1]/4;
            off= offAll(:, quadrant);
            for k=1:3,
                texRectPos= presentation.affineTransform( texRect(:, data==(4-k) )-0.5, off*screenHeight+[screenWidth; screenHeight]/2,[screenHeight screenHeight]*0.5 );
                texRectPos= presentation.rotate( texRectPos, [screenWidth; screenHeight]/2, angle );
                Screen( 'DrawTextures', obj.win, texInd(k), [], texRectPos );
            end
        end
        function drawStimFrame( obj, betaIdx, imgIdx, grIdx, sizeIdx, stimIdx,  nFrames )
            screenWidth=obj. winRect(3)-obj. winRect(1);
            screenHeight=obj. winRect(4)-obj. winRect(2);
            
            gr= obj.gr{grIdx}; %#ok<PROP>
            gr.data= createTextures.unpackImg4Clrs( obj.imgData{grIdx}(:,betaIdx,imgIdx)', obj.dataSize{grIdx} ); %#ok<PROP>
            texRect= (gr. getPatchRects()-0.5);
            
            pos= 1:numel(gr.data);
            % select subregion gefined by size
            switch sizeIdx,
                case 1 % one cell
                    pos= gr. getCellInd( [3 3] );
                case 2 % two cells
                    pos= arrayfun( @(k,m) gr. getCellInd( [k m] ), repmat( 3:4, 2, 1), repmat( (3:4)', 1, 2) , 'UniformOutput', false );
                    pos= cat(3, pos{:} );
                case 3 %3 cells
                    clIdx= 1:4;
                    pos= arrayfun( @(k,m) gr. getCellInd( [k m] ), repmat( clIdx, numel(clIdx), 1), repmat( clIdx', 1, numel(clIdx) ) , 'UniformOutput', false );
                    pos= cat(3, pos{:} );
                case 4 % full image
                    pos= 1:numel( gr.data );
                case 5
                    pos= [];
                    texRect= texRect*2;                    
                    for xGrid=[3],
                        for yGrid=[3],
                            
                            posGr= gr. getCellInd( [xGrid yGrid] );
                            if numel( posGr )==64,
                                % group p1
                                pos1= [];
                                for k=0:7
                                    pos1= [ pos1 k*8+(1:(8-k))];
                                end
                                pos2= [setdiff(1:64, pos1) 8:7:57];
                            else
                                pos1= [1:26 28:34 37:42 46:50 55:58 64:66 73 74];
                                pos2= [ setdiff( 1:81, pos1) 18:8:74];
                            end
                            if randi(2) == 2
                                pos= [pos posGr(pos1)];
                                %disp(1);
                            else
                                pos= [pos posGr(pos2)];
                                %disp(2)
                            end
                        end
                    end
                case 6
                    pos= gr. getCellInd( [3 3] );
                    texRect= texRect*2;
                case 7
                    pos= arrayfun( @(k,m) gr. getCellInd( [k m] ), repmat( 3:4, 2, 1), repmat( (3:4)', 1, 2) , 'UniformOutput', false );
                    pos= cat(3, pos{:} );
                    texRect= texRect*2;
            end

            texRect= texRect(:,pos(:) );
            
            texRectYMean= texRect( [2 4], : );
            texRectYMean= mean( [min(texRectYMean) max(texRectYMean)] );
            texRect([2 4], : )= texRect([2 4], : )- texRectYMean;
            
            texRectXMean= texRect( [1 3], : );
            texRectXMean= mean( [min(texRectXMean) max(texRectXMean)] );
            texRect([1 3], : )= texRect([1 3], : )- texRectXMean;

            quadrant= randi(4);
            obj. drawTexture( gr.data(pos(:)), obj. texInd, texRect, quadrant, screenWidth, screenHeight ); %#ok<PROP>
            quad= setdiff(1:4, quadrant);
            [~,rp]= sort( rand( numel( gr.data ), 3 ) ); %#ok<PROP>
            data1= gr.data; %#ok<PROP>
            for k=1:3,
                data1( rp(:,k) )= gr.data; %#ok<PROP>
                obj.drawTexture( data1(pos(:)), obj.texInd, texRect, quad(k), screenWidth, screenHeight );
            end
            obj.drawFixation();
            for k=1:nFrames,
                Screen('Flip', obj.win, 0, 1 );
            end
            Screen('Flip', obj.win );
            obj.trialData. presentationQuadrant(stimIdx  )= quadrant;
            obj.trialData. betaIdx(stimIdx  )= betaIdx;
            obj.trialData. imgIdx(stimIdx  )= imgIdx;
            obj.trialData. grIdx(stimIdx  )= grIdx;
            obj.trialData. sizeIdx(stimIdx  )= sizeIdx;
        end
        function prepareVpiXX( obj )
            PsychDataPixx('Open');
            PsychDataPixx('EnableVideoScanningBacklight');
            PsychDataPixx('Close');
            
            % % % gamma correction
            gamma=2.2; %3.7;
            
            AssertOpenGL; % Break and send an eror message if the installed Psychtoolbox is not based on OpenGL or Screen() is not working properly.
            
            % % PsychTool box imaging for Vpixx initialization
            PsychImaging('PrepareConfiguration'); %Prepare setup of imaging pipeline for onscreen window
            PsychImaging('AddTask', 'General', 'FloatingPoint32Bit');% Add a task or processing requirement with a 32 bit floating point precision framebuffer
            PsychImaging('AddTask', 'General', 'EnableDataPixxM16Output'); % Enable the performance driver for M16 mode of the VPixx
            PsychImaging('AddTask', 'FinalFormatting', 'DisplayColorCorrection', 'SimpleGamma'); % applying  gamma correction to all view channels
            
            Screen('Preference','VisualDebugLevel', 3); % cancel the psychtoolbox "welcome-screen"
            screens=Screen('Screens');% Return an array of screenNumbers. 0=full Windows desktop. 1-n=display monitors 1 to n.
            screenNumber=max(screens);
            
            % % open datapixx screen number x with a black color background.
            
            [w, rect]= PsychImaging('OpenWindow', screenNumber, [.25 .25 .25]); % black background = 0, rect = 1920*1080
            
            PsychColorCorrection('SetEncodingGamma', w, 1/gamma);% the gamma value which is used for gamma correction.
            Screen('LoadNormalizedGammaTable', w, linspace(0, 1, 256)' * [1, 1, 1]); % gamma correction for graphics cards with built-in gamma tables (256 values of 1-0)
            
            HideCursor;	% Hide the mouse cursor
            obj. win= w;
            obj.winRect= rect;
        end
        function prepareNormalScreen( obj )
            AssertOpenGL;
            
            screens=Screen('Screens');% Return an array of screenNumbers. 0=full Windows desktop. 1-n=display monitors 1 to n.
            screenNumber=max(screens);
            
            %[obj. win, obj.winRect]= Screen('OpenWindow', screenNumber, [0 0 0] );   % open screen number x with a gray color background.
            [obj. win, obj.winRect]= Screen('OpenWindow', screenNumber, [0 0 0], [0 0 1200 800]);   % open screen number x with a gray color background.
        end
        function prepareScreen(obj)
            win= obj. win;
            %[screenWidth, screenHeight]=Screen('WindowSize', win);
            Screen('BlendFunction', win, GL_ONE, GL_ONE);
            
            % create Gaussian blob
            x= linspace( -2, 2, 32 );
            gauss1D= exp( -x.^2/2 );
            gauss2D= bsxfun( @times, gauss1D, gauss1D' );
            
            for k=3:-1:1,
                obj.texInd(k)= Screen('MakeTexture', win, gauss2D/k*256*.5 );
            end
            
            InitializePsychSound(1);
            obj.audioPortHandle= PsychPortAudio( 'Open', [], [], [], 44800 );
            
        end
        function drawFixation( obj )
            screenWidth=obj. winRect(3)-obj.winRect(1);
            screenHeight=obj. winRect(4)-obj.winRect(2);
            Screen( 'DrawDots', obj.win, [screenWidth; screenHeight]/2, 3 );
        end
        function runTrial( obj, betaIdx, imgIdx, grIdx, sizeIdx, stimIdx  )
            obj. drawFixation();
            Screen('Flip', obj.win );
            
            % wait for space bar
            [secs, keyCode] = KbWait();
            while ~keyCode(32)
                [secs, keyCode] = KbWait();
            end
            obj.trialData. trialOnset(stimIdx )= secs;
            
            WaitSecs( 0.3 );
            obj. drawStimFrame( betaIdx, imgIdx, grIdx, sizeIdx,  stimIdx,  10);
            Screen('Flip', obj.win );
            
            [secs, keyCode] = KbWait();
            while ~any( keyCode([97 98 100 101]) )
                [secs, keyCode] = KbWait();
            end
            obj.trialData. reportTime(stimIdx  )= secs;
            obj.trialData. report(stimIdx  )= find( keyCode([100 101 97 98]) );
            
            %feedback
            if obj.trialData. presentationQuadrant(stimIdx  ) ~= obj.trialData. report(stimIdx  ),
                obj. playAudioFeedback();
            end
        end
        
        function playAudioFeedback( obj )
            t= linspace( 0, 0.1, 4480 );
            snd= sin( 4400*t );
            PsychPortAudio('FillBuffer', obj.audioPortHandle, [snd(:) snd(:)]' );
            PsychPortAudio('Start', obj.audioPortHandle, 0, 0, 1);
            WaitSecs( t(end) );
            PsychPortAudio('Stop', obj.audioPortHandle, 1);
        end
        function run( obj )
            obj. prepareScreen();
            
            betaIdx= [1 randperm(500)+1];
            imgIdx=1;
            for trNum=1:numel(betaIdx),
                obj. runTrial( betaIdx(trNum), imgIdx )
            end
            PsychPortAudio( 'Close' );
            Screen( 'CloseAll' )
        end
        function drawTextCenter( obj, str )
            txtBounds= TextBounds( obj. win, str );
            txtStart= (obj.winRect-txtBounds)/2;
            Screen( 'DrawText', obj. win, str, txtStart(1), txtStart(2) );
            Screen( 'Flip', obj.win );
        end
    end
end
