classdef ParallelogrammaticLattice < Lattice
    properties
       % patchHandles;   % handles to drawn patches
    end
    methods
        function rect= getPatchRects( obj )
            sz= obj.size .* obj.baseSize;
            rect= zeros([4 sz(:)'] );
            for k1= 1:sz(1),
                for k2= 1:sz(2),
                    rect( :, k1, k2 )= [k1 k2+0.5*k1-floor(k1/2) ...
                        1+k1 1+k2+0.5*k1-floor(k1/2)]';
                end
            end
            rect= reshape(rect, 4, prod(sz) );
            rect= rect- min(rect(:));
            rect=rect./max(rect(:));
        end
        function draw( obj, ha )
            hh=gca;
            axes(ha);
            axis equal
            sz= obj.size .* obj.baseSize;
            if isempty( obj. patchHandles ),
                cla(ha);
                for k1= 1:sz(1),
                    for k2= 1:sz(2),
                        obj.patchHandles(k1, k2)=patch( [0 1 1 0]*0.9 + k1, ...
                            [0 0.5 1.5 1]*0.9 +k2 +0.5*k1- floor(k1/2),...
                            obj.colors( obj. data(k1,k2), : ), ...
                            'EdgeColor', 'none' );
                    end
                end
            else
                for k1= 1:sz(1),
                    for k2= 1:sz(2),
                        set( obj.patchHandles(k1, k2), 'FaceColor',  obj.colors( obj. data(k1,k2), : ) );
                    end
                end
            end
            axes( hh );
        end
        function coords= getCoordsM1( obj, pivot, offset )
        end
        function gs= createUpdateGroups( ~, ~ )
            gs= [];
        end
        function gs= createUpdateGroups2( ~, ~ )
            gs= [];
        end
        function pos= getCellInd( obj, off )
            [xPos, yPos]= obj. getCellSub( off );
            pos= sub2ind( size(obj.data), xPos, yPos );
        end
        function [xPos, yPos]= getCellSub( obj, off )
            gridSize= obj.baseSize.*obj.size;
            xPos= zeros( obj. baseSize );
            yPos= xPos;
            pos= 1:max(obj.baseSize);
            pos= [pos;pos];
            %(0,0) cell
            xPos= repmat((1:obj.baseSize(1))+off(1)*obj.baseSize(1), obj.baseSize(2),1);
            yPos= bsxfun( @plus, floor( ( (1:obj.baseSize(2))+off(1)*obj.baseSize(1) )/2), (1:obj.baseSize(2))'+off(2)*obj.baseSize(2));
            
            
            yPos= mod(yPos-1, gridSize(2))+1;
            xPos= mod(xPos-1, gridSize(1))+1;
        end
        function colorCells( obj )
            clrs= 'rgby';
            for k1= 1:obj. size(1),
                for k2=1:obj.size(2),
                    %             for k1= 0:10,
                    %                 for k2=0:10,
                    clr= clrs( mod(k1,2)*2+mod( k2, 2) +1 );
                    set( obj.patchHandles(obj. getCellInd([k1, k2])), ...
                        'EdgeColor', clr );
                end
            end
        end
        function clearCells( obj )
            for h= obj. patchHandles(:)',
                set( h, 'EdgeColor', 'none' );
            end
        end
    end
end