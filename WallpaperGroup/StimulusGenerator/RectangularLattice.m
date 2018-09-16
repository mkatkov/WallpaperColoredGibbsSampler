classdef RectangularLattice < Lattice
    methods
        function draw( obj, ha )
            hh=gca;
            axes(ha);
            axis equal
            cla(ha); 
            sz= obj.size .* obj.baseSize;
            for k1= 1:sz(1),
               for k2= 1:sz(2),
                  rectangle( 'Position', [ k1,k2*0.75,.91,.75*.91], ...
                      'FaceColor', obj.colors( obj. data(k1,k2), : ), ...
                      'EdgeColor', 'none' )
               end
            end
            axes( hh );
        end
        function coords= getCoordsM1( obj, pivot, offset )
        end
    end    
end