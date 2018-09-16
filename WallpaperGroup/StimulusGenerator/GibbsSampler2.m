classdef GibbsSampler2 < handle
    properties
        dataClass;        % class containing 'data' field to sample
        interactionRules  % array of classes containing interaction rules
        %each variable is for different update group
    end
    methods
        function sample( obj, n )
            for k=1:n,
                arrayfun( @(ir) ir.sampleGroup( obj. dataClass), ...
                    obj. interactionRules );
            end
        end
        function createGroups( obj, ir )
            % ir-  interaction rules structure with size of the data array
            % and fields 'places' and 'potential'. 'places' field show
            % location of conditional dependency and 'potential' is
            % reference to 'Potential' class representing corresponding
            % dependencies
            
            % first we need to color data field to define dependent groups
            % starting from left corner
            data= ones( size( obj. dataClass.data ) );
            curGroup= 1;
            dataUpdated= true;
            while dataUpdated,
                dataUpdated= false;
                for k1= 1:numel( data)
                    if data(k1) ~= curGroup, continue, end
                    for k2= ir( k1). places(:)',
                        if data( k2 ) ~= curGroup, continue, end
                        data( k2 ) = curGroup+1;
                        dataUpdated= true;
                    end
                end
                curGroup= curGroup+1;
            end
            curGroup= curGroup-1;            
            obj. interactionRules= repmat( InteractionRules(), 1, curGroup);
            % now create interaction rules
            for grIdx= 1: curGroup
                %for each group we need to break down conditional
                %dependensies with the same potential
                
                %first select places
                plIdx= find( data==grIdx );
                grIr= ir( plIdx ); %#ok<FNDSB>
                                
                uPot= unique( cat( 2, grIr(:).potential) ); % unique potentials

                interactions= repmat( Interactions(), 0, 1 );
                
                for pot= uPot(:)', % for each potential
                    %find all the places to be updated
                    potPl= cell( size( grIr) ); % this is an empty accumulator 
                    % for to be updated places associated with this potential
                    
                    % following is a stupid implementation 
                    for grPlaceIdx= 1:numel(grIr),
                        grPlace= grIr(grPlaceIdx);
                        plsToUpdate= grPlace. places( grPlace. potential == pot );
                        for plToUpdate= plsToUpdate(:)'
                            potPl{grPlaceIdx}(end+1)= plToUpdate;
                        end
                    end
                    
                    % now we need to collect slices from potPl into
                    % Interactions
                    
                    numPl= cellfun( @numel, potPl);
                    nInt= max( numPl );
                    for k=1:nInt,
                       intPl= numPl>= k;
                       interactions(end+1).potential= pot;
                       interactions(end).places= intPl;
                       interactions(end).condPlaces= cellfun( @(pl) pl(k), potPl(intPl) );
                    end
                end
                obj. interactionRules( grIdx )= InteractionRules( );
                obj. interactionRules( grIdx ).setInteractionRules( ...
                    plIdx, interactions );                
            end
        end
    end
end