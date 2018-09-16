classdef HexagonalLattice <Lattice
    methods
        function rect= getPatchRects( obj )
            sz= obj.size .* obj.baseSize;
            rect= zeros([4 sz(:)'] );
            for k1= 1:sz(1),
                for k2= 1:sz(2),
                    rect( :, k1, k2 )= [-.45+0.86*.9*k1 -0.86*.45+k2*0.86+mod(k1,2)*0.43 .45+0.86*.9*k1 0.86*.45+k2*0.86+mod(k1,2)*0.43 ];
%                     obj.patchHandles(k1, k2)= patch( [ 1. 0.5 -0.5 -1. -0.5 0.5 1. ]*.45+0.86*.9*k1, ...
%                         [0 0.866 0.866 0 -0.866 -0.866 0 ]*.45+k2*0.86+mod(k1,2)*0.43, ...
%                         [obj.colors( obj. data(k1,k2), : )], ...
%                         'EdgeColor', 'none' );
                end
            end
            rect= reshape(rect, 4, prod(sz) );
            rect= rect- min(rect(:));
            rect=rect./max(rect(:));            
        end
        function draw( obj, ha )
            sz= obj.size .* obj.baseSize;
            if size( obj.patchHandles ) ~= size( obj. data ),
                obj.patchHandles= obj. data;
                hh=gca;
                axes(ha);
                axis equal
                cla(ha);
                for k1= 1:sz(1),
                    for k2= 1:sz(2),
                        obj.patchHandles(k1, k2)= patch( [ 1. 0.5 -0.5 -1. -0.5 0.5 1. ]*.45+0.86*.9*k1, ...
                            [0 0.866 0.866 0 -0.866 -0.866 0 ]*.45+k2*0.86+mod(k1,2)*0.43, ...
                            [obj.colors( obj. data(k1,k2), : )], ...
                            'EdgeColor', 'none' );
                    end
                end
                axis off
                axes( hh );
            else
                for k1= 1:sz(1),
                    for k2= 1:sz(2),
                        set( obj.patchHandles(k1, k2), 'FaceColor', obj.colors( obj. data(k1,k2), : ) );
                    end
                end
            end
        end
        function clearCells( obj )
            for h= obj. patchHandles(:)',
                set( h, 'EdgeColor', 'none' );
            end
        end
        function coords= getCoordsM1( obj, pivot, offset )
        end
        function [xPos, yPos]= getCellSub( obj, off )
            xPos= zeros(9);
            yPos= xPos;
            for k=1:9,
                xPos( k,: )= repmat( 1+mod( k+ off(1)*9-1, size(obj.data,1)), 1, 9);
                offY1= floor( off(1)/2 )*9;
                offY2= mod( off(1), 2);
                offY2= offY2*(4+mod( k,2) );
                offY= offY1+offY2;
                yPos(k,:)= 1+mod( floor(k/2)+(1:9)+off(2)*9+offY-1, size(obj.data,1) );
            end
        end
        function gs= createUpdateGroups( ~, ~ )
            gs= [];
        end
        function gs= createUpdateGroups2( ~, ~ )
            gs= [];
        end
    end
end