classdef groupP1 < ParallelogrammaticLattice
    properties
    end
    methods
        function obj= groupP1()
            % by default it is 64x64 elements grid with 3 colors
            obj. baseSize= [8 8];
            obj. size= [8 8];
            obj. data= randi( 3, obj. baseSize.* obj.size);
            obj. colors= [.33;.67;1]*[1 1 1]; %[1 0 0; 0 1 0; 0 0 1];
            obj. interactionRules= {};
            
        end
        function im= getCellImg( obj, off )
            im= false( size(obj.data) );
            pos= obj. getCellInd( off );
            im( pos )= true;
        end
        function ir= getInteractionRules2( obj, betas )
            ir= obj. getInteractionRules( betas );
        end
        function ir= getInteractionRules( obj, beta )
            % 1 beta value
            id= Potential();
            id.U = log(eye(3)+3e-2)*beta;
           
            ir= struct( 'places',[], 'potential', id([]) );
            ir= repmat( ir, size( obj.data ) );
            for k1=0:10,
                for k2=0:10,
                    % translations
                    pos= obj. getCellInd( [k1, k2] );
                    for off= [1 0 -1 0; 0 1 0 -1],
                        posDoff= obj. getCellInd( [k1+off(1), k2+off(2)] );
                        
                        for k=1:numel(pos),
                            ir( pos(k) ). places(end+1)= posDoff(k);
                            ir( pos(k) ). potential(end+1)= id;
                        end
                    end
                    
               end
            end
        end
    end
end

