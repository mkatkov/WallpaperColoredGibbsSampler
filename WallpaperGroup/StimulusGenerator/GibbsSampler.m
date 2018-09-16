classdef GibbsSampler < handle
    % here we sacrifise spase to increase speed.
    properties
       data;        % array to update
       updateGroups % this is a cell array with groups of places that 
            % can be updated in parallel. Has following structure:
            % places             - an array with indeces in the data-array 
            %                      to update.
            % interactionRules   - struct array with rules has following
            %                      structure
            %    potential       - 3x3 array of conditional potential
            %    places          - conditioning places
            %
       currentPotential; % accumulating potential
    end
    methods
        function updatePotential( obj, rule )
            condData= obj.data( rule. places );
            u= rule.potential( :, condData(:) );
            obj. currentPotential= obj. currentPotential + u;
        end
        function computePotential( obj, group )
            
            % clear potential
            if numel( group. places ) == size( obj. currentPotential, 2 ),
                obj. currentPotential(:)= 0;
            else
                obj. currentPotential= zeros( 3, numel( group.places) );
            end
            
            % update potential for each group
            for k=1:numel( group. interactionRules )
                obj. updatePotential( group. interactionRules( k ) );
            end
        end
        function sampleFromPotential( obj, group )
            p= exp(-bsxfun( @minus, obj. currentPotential, min( obj. currentPotential ) ));
            p= cumsum(p);  % creating cumulative distribution
            p= bsxfun( @rdivide, p, p(end,:) );  % normalizing it
            r= rand( 1, size(p,2) );
            
            c= r; c(:)= 2;
            c( r<= p(1,:) ) = 1;
            c( r>= p(2,:) ) = 3;
            obj. data( group.places )= c;
        end
        function sampleCycle( obj )
            for k=1:numel( obj. updateGroups )
                gr= obj.updateGroups(k);
                obj. computePotential( gr );
                obj. sampleFromPotential( gr );
            end
        end
        function sample(obj, n)
            for k=1:n,
                obj. sampleCycle()
            end
        end
        function createUpdateGroups( obj, ir )
           % ir-  interaction rules structure with size of the data array 
           % and fields 'places' and 'potential'. 'places' field show
           % location of conditional dependency and 'potential' is
           % reference to 'Potential' class representing corresponding
           % dependencies
           
           % first we need to color data field to define dependent groups
           % starting from left corner 
           obj.data(:)=1;
           curGroup= 1;
           dataUpdated= true;
           while dataUpdated,
               dataUpdated= false;
               for k1= 1:numel( obj. data)
                   if obj.data(k1) ~= curGroup, continue, end
                   for k2= ir( k1). places(:)',
                       if obj.data( k2 ) ~= curGroup, continue, end
                       obj.data( k2 ) = curGroup+1;
                       dataUpdated= true;
                   end
               end
               curGroup= curGroup+1;
           end
        end
    end
end


