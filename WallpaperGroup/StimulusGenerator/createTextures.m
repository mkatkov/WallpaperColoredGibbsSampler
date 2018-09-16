% createTextures.m
%
% create a texture database

classdef createTextures < handle
    
    methods(Static=true)
        function [data, fname]= loadData( symmGr )
                metaCl= metaclass(symmGr);
                fname= sprintf('../images/%s_data.mat', metaCl.Name );
                
                if exist( fname, 'file'),
                    data= load( fname );
                else
                    nBetas=501;
                    nImages= 1000;
                    data.beta= linspace(1, 0, nBetas );
                    data.dataSize= size( symmGr.data);
                    nBytes= ceil(numel( symmGr.data )/4);
                    
                    data. imgData= uint8(zeros( nBytes, nBetas, nImages ));
                    data. imgIdx= 1;
                    data. betaIdx= 1;
                end            
        end
        function doIt(  )
            % groups should be sampled with GibbsSampler
            groups= {@groupP1, @groupP2, @groupCM, @groupCMM, ...
                @groupPM, @groupPG, @groupPMM, @groupPMG, @groupP4, ...
                @groupPGG, @groupP4M, @groupP4G, @groupP3, groupP3M1, ...
                @groupP31M, groupP6, groupP6M };
            grNotFull= true( numel(groups), 1);
            grId=1;
            while any(grNotFull),
            %for gr= groups,
                %symmGr= gr{1}();

                while ~grNotFull(grId),
                    grId= mod( grId, numel(groups))+1;
                end
                
                symmGr= groups{grId}();
                [data, fname]= createTextures. loadData( symmGr );
                [~, nBetas, nImages]= size( data.imgData );
                
                updateCount= 501;
                
                while true
                    gs= symmGr. createUpdateGroups(data.beta( data.betaIdx ));
                    if isempty( gs )
                        % this is GibbsSampler2 textures
                        ir= symmGr.getInteractionRules( data.beta( data.betaIdx ) );
                        gs= GibbsSampler2();
                        gs.dataClass= symmGr;
                        gs. createGroups( ir );
                        symmGr.data= randi(3, size( symmGr.data) );
                        gs. sample(1000);
                        data.imgData(:, data.betaIdx, data.imgIdx)= ...
                            createTextures.packImg4Clrs( symmGr.data );                        
                    else % this is GibbsSampler texture
                        gs. data= randi(3, size( gs.data) );
                        gs.sample( 1000 );
                        data.imgData(:, data.betaIdx, data.imgIdx)= ...
                            createTextures.packImg4Clrs( gs.data );                        
                    end
                    
                    
                    if data.betaIdx < nBetas,
                        data.betaIdx=  data.betaIdx+1;
                    elseif data.imgIdx < nImages,
                        data.imgIdx=  data.imgIdx+1;
                        data.betaIdx= 1;
                    else
                        grNotFull( grId )= false;
                        grId= mod( grId, numel(groups))+1;
                        break;
                    end
                    
                    if updateCount> 0,
                        updateCount= updateCount-1;
                        if mod( updateCount, 50) ==0,
                            fprintf( '\n%d', updateCount )
                        elseif mod( updateCount, 10) ==0,
                            fprintf( '%d', mod( updateCount/10, 10) )
                        else
                            fprintf('.')
                        end
                    else
                        %updateCount= 5010;
                        %save( fname, '-struct', 'data', '-v7.3' );
                        grId= mod( grId, numel(groups))+1;
                        break
                    end                    
                end
                save( fname, '-struct', 'data', '-v7.3' );
            end
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