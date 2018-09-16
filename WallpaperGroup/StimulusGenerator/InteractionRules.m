classdef InteractionRules < handle
    properties
        places;      % indeces of places in data array to update
        interactions % an array of classes definig conditional contribution to potential
        
        currentPotential; % accumulator of potentials (same size as places)
    end
    methods
        function obj= setInteractionRules( obj, places, interactions )
            obj. places= places;
            obj. interactions= interactions;
            obj. currentPotential= zeros( 3, numel(places) );
        end        
        function computePotential( obj, dataClass )
            obj. currentPotential(:)= 0;
            
            % update potential for each group
%             for interactions= obj. interactions(:)', %#ok<PROP>  ensure single row 
%                 interactions. updatePotential( obj, dataClass ); %#ok<PROP>
%             end
            arrayfun( @( i) i. updatePotential( obj, dataClass ), ...
                obj. interactions(:) ); 
        end
        function sampleGroup( obj, dataClass )
            obj. currentPotential(:)= 0;
            arrayfun( @( i) i. updatePotential( obj, dataClass ), ...
                obj. interactions(:) ); 

            p= exp(bsxfun( @minus, obj. currentPotential, max( obj. currentPotential ) ));
            p= bsxfun( @rdivide, p, sum(p) )+10*eps;  % normalizing it
            p= bsxfun( @rdivide, p, sum(p) );  % normalizing it
            p= cumsum(p);  % creating cumulative distribution
            
            r= rand( 1, size(p,2) );
%             [~, c]= arrayfun( @(k) histc( r(k), p(:,k)), 1:size(p,2) );
            
            c= r; c(:)= 2;
            c( r<= p(1,:) ) = 1;
            c( r>= p(2,:) ) = 3;
            dataClass. data( obj.places )= c;
        end
    end
end
