classdef SquareLattice < Lattice
    methods
        function rect= getPatchRects( obj )
            sz= obj.size .* obj.baseSize;
            rect= zeros([4 sz(:)'] );
            for k1= 1:sz(1),
               for k2= 1:sz(2),
                   rect( :, k1, k2 )= [k1,k2,k1+1,k2+1];
%                   rectangle( 'Position', [ k1,k2,.91,.91], ...
%                       'FaceColor', obj.colors( obj. data(k1,k2), : ), ...
%                       'EdgeColor', 'none' )
               end
            end
            rect= reshape(rect, 4, prod(sz) );
            rect= rect- min(rect(:));
            rect=rect./max(rect(:));
        end
        function [xPos, yPos]= getCellSub( obj, off )
            sz= obj.size .* obj.baseSize;
            [xPos, yPos]= meshgrid( mod( off(1)*obj.baseSize(1)+(1:obj.baseSize(1)) -1, sz(1) )+1, mod( off(2)*obj.baseSize(2)+(1:obj.baseSize(2))-1, sz(1))+1 );
        end
        function draw( obj, ha )
            sz= obj.size .* obj.baseSize;
            if size( obj.patchHandles ) ~= size( obj. data ),
                obj.patchHandles=obj. data;
                hh=gca;
                axes(ha);
                axis equal
                cla(ha);
                for k1= 1:sz(1),
                    for k2= 1:sz(2),
                        obj.patchHandles(k1, k2)= rectangle( 'Position', [ k1,k2,.91,.91], ...
                       'FaceColor', obj.colors( obj. data(k1,k2), : ), ...
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
%             hh=gca;
%             axes(ha);
%             axis equal
%             axis off
%             cla(ha); 
%             sz= obj.size .* obj.baseSize;
%             for k1= 1:sz(1),
%                for k2= 1:sz(2),
%                   rectangle( 'Position', [ k1,k2,.91,.91], ...
%                       'FaceColor', obj.colors( obj. data(k1,k2), : ), ...
%                       'EdgeColor', 'none' )
%                end
%             end
%             axes( hh );
        end
        function coords= getCoordsM1( obj, pivot, offset )
        end
        function replicationRules(obj)
           id= log(eye(3)+1e-6);
           obj. interactionRules{end+1}= { obj. baseSize, id };
           obj. interactionRules{end+1}= { obj. baseSize.*[1 0], id };
           obj. interactionRules{end+1}= { obj. baseSize.*[0 1], id };            
           obj. interactionRules{end+1}= { -obj. baseSize, id };
           obj. interactionRules{end+1}= { -obj. baseSize.*[1 0], id };
           obj. interactionRules{end+1}= { -obj. baseSize.*[0 1], id };            
        end
    end
end