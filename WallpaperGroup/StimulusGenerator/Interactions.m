classdef Interactions < handle
    properties
        places;     % places inside group to update potential (an array)
        condPlaces  % places in the full data array the potential depends on (an array same size as places)
        potential   % handle to potential that is the came for all places (single instance)        
    end
    methods
        function updatePotential( obj, groupClass, dataClass )
            condData= dataClass.data( obj. condPlaces );
            u= obj.potential.U( :, condData(:) );
            groupClass. currentPotential( :, obj. places )= ...
                groupClass. currentPotential( :, obj. places ) + u;
        end
    end
end