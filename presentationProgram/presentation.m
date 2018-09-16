% presentation program using psytoolbox
%

classdef presentation < handle
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
        function obj= presentation()
            obj. clearTrialData();
        end
        function clearTrialData( obj )
            obj. trialData= struct( 'trialOnset', [], 'reportTime', [], ...
                'report', [], 'presentationQuadrant', [], 'betaIdx', [], ...
                'imgIdx', [] );
        end
        function fname= loadData( obj, grName )
            load( sprintf( '..\\WallpaperGroup\\images\\%s_data', grName ) );
            addpath('..\WallpaperGroup\StimulusGenerator');
            obj. gr= feval( grName );
            obj. dataSize= dataSize;
            obj. imgData= imgData;
        end
        function drawTexture( obj, data, texInd, texRect, quadrant, screenWidth, screenHeight )
            %define coordinates according to quadrant
            offAll = [-1 1 -1 1; -1 -1 1 1]/4;
            off= offAll(:, quadrant);
            for k=1:3,
                texRectPos= presentation.affineTransform( texRect(:, data==(4-k) )-0.5, off*screenHeight+[screenWidth; screenHeight]/2,[screenHeight screenHeight]*0.4 );
                Screen( 'DrawTextures', obj.win, texInd(k), [], texRectPos );
            end
        end
        function drawTexturePart( obj, data, texInd, texRect, quadrant, screenWidth, screenHeight, ind )
            %define coordinates according to quadrant
            offAll = [-1 1 -1 1; -1 -1 1 1]/4;
            off= offAll(:, quadrant);
            for k=1:3,
                texRectPos= presentation.affineTransform( texRect(:, data==(4-k) )-0.5, off*screenHeight+[screenWidth; screenHeight]/2,[screenHeight screenHeight]*0.4 );
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
        function drawStimFrame( obj, betaIdx, imgIdx, nFrames )
            screenWidth=obj. winRect(3)-obj. winRect(1);
            screenHeight=obj. winRect(4)-obj. winRect(2);
            
            gr= obj.gr;
            gr.data= createTextures.unpackImg4Clrs( obj.imgData(:,betaIdx,imgIdx)', obj.dataSize );
            texRect= gr. getPatchRects();
            
            quadrant= randi(4);
            obj. drawTexture( gr.data, obj. texInd, texRect, quadrant, screenWidth, screenHeight );
            quad= setdiff(1:4, quadrant);
            [~,rp]= sort( rand( numel( gr.data ), 3 ) );
            data1= gr.data;
            for k=1:3,
                data1( rp(:,k) )= gr.data;
                obj.drawTexture( data1, obj.texInd, texRect, quad(k), screenWidth, screenHeight );
            end
            obj.drawFixation();
            for k=1:nFrames,
                Screen('Flip', obj.win, 0, 1 );
            end
            Screen('Flip', obj.win );
            obj.trialData. presentationQuadrant(end+1)= quadrant;
            obj.trialData. betaIdx(end+1)= betaIdx;
            obj.trialData. imgIdx(end+1)= imgIdx;
        end
        function drawStimFrameMIB( obj, betaIdx, imgIdx, angle )
            screenWidth=obj. winRect(3)-obj. winRect(1);
            screenHeight=obj. winRect(4)-obj. winRect(2);
            
            gr= obj.gr;
            gr.data= createTextures.unpackImg4Clrs( obj.imgData(:,betaIdx,imgIdx)', obj.dataSize );
            texRect= gr. getPatchRects();
            
            quadrant= randi(4);
            quad= setdiff(1:4, quadrant);
            %[~,rp]= sort( rand( numel( gr.data ), 3 ) );
            %data1= gr.data;
            for k=1:4,
                %data1( rp(:,k) )= gr.data;
                obj. drawTextureRot( gr.data, obj. texInd, texRect, k, screenWidth, screenHeight, angle );
                %obj.drawTexture( data1, obj.texInd, texRect, quad(k), screenWidth, screenHeight );
            end
            obj.drawFixation();
            %for k=1:nFrames,
            Screen('Flip', obj.win, 0 );
            %end
            %Screen('Flip', obj.win );
            obj.trialData. presentationQuadrant(end+1)= quadrant;
            obj.trialData. betaIdx(end+1)= betaIdx;
            obj.trialData. imgIdx(end+1)= imgIdx;
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
        function runTrial( obj, betaIdx, imgIdx  )
            obj. drawFixation();
            Screen('Flip', obj.win );
            
            % wait for space bar
            [secs, keyCode] = KbWait();
            while ~keyCode(32)
                [secs, keyCode] = KbWait();
            end
            obj.trialData. trialOnset(end+1)= secs;
            
            WaitSecs( 0.3 );
            obj. drawStimFrame( betaIdx, imgIdx, 10);
            Screen('Flip', obj.win );
            
            [secs, keyCode] = KbWait();
            while ~any( keyCode([97 98 100 101]) )
                [secs, keyCode] = KbWait();
            end
            obj.trialData. reportTime(end+1)= secs;
            obj.trialData. report(end+1)= find( keyCode([100 101 97 98]) );
            
            %feedback
            if obj.trialData. presentationQuadrant(end) ~= obj.trialData. report(end),
                obj. playAudioFeedback();
            end
        end
        function runMIBTrial( obj, betaIdx, imgIdx  )
            obj. drawFixation();
            Screen('Flip', obj.win );
            
            % wait for space bar
            [secs, keyCode] = KbWait();
            while ~keyCode(32)
                [secs, keyCode] = KbWait();
            end
            obj.trialData. trialOnset(end+1)= secs;
            
            WaitSecs( 0.3 );
            angle= 0;
            for k=1:100,
                obj. drawStimFrameMIB( betaIdx, imgIdx, angle );
                angle= angle+0.01;
            end
                Screen('Flip', obj.win, 0 );
            
            [secs, keyCode] = KbWait();
            while ~any( keyCode([97 98 100 101]) )
                [secs, keyCode] = KbWait();
            end
            obj.trialData. reportTime(end+1)= secs;
            obj.trialData. report(end+1)= find( keyCode([100 101 97 98]) );
            
            %feedback
            if obj.trialData. presentationQuadrant(end) ~= obj.trialData. report(end),
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
