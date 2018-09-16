% Lattice.m 
%Contains basic definition for base class of 5 type of Lattices

classdef Lattice < handle
    properties
       size;            % size of the lattice in base elements
       baseSize;        % size of translated elements
       data;            % colors of lattice elements
       colors;          % color of each data element
       
       interactionRules;% interaction rules for generating textures

       patchHandles;   % handles to drawn patches
    end
    methods(Abstract)
        draw(obj, ha) % draws the lattice in axes ha
        coords= getCoordsM1( obj, pivot, offset ) % returns the coordinates with 'offset' 
        %from 'pivot', Many pivot points and one offset
    end
    methods 
        function obj= Lattice()
           obj. interactionRules= {};            
        end
        function pos= getCellInd( obj, off )
            [xPos, yPos]= obj. getCellSub( off );
            pos= sub2ind( size(obj.data), xPos, yPos );
        end
        function colorCells( obj )
            clrs= 'rgby';
            for k1= 1:obj. size(1),
                for k2=1:obj.size(2),
                    clr= clrs( bitand(k1,1)*2+bitand( k2, 1) +1 );
                    set( obj.patchHandles(obj. getCellInd([k1, k2])), ...
                        'EdgeColor', clr );
                end
            end
        end
    end    
end