classdef groupP4M < SquareLattice
    
    methods
        function obj= groupP4M()
            % by default it is 64x64 elements grid with 3 colors
            obj. baseSize= [8 8];
            obj. size= [8 8];
            obj. data= randi( 3, obj. baseSize.* obj.size);
            obj. colors= [.33;.67;1]*[1 1 1]; %[1 0 0; 0 1 0; 0 0 1];
            obj. interactionRules= {};
        end
        function gs= createUpdateGroups( obj, beta )
            gs= GibbsSampler();
            gs. data= obj.data;
            gs. updateGroups= struct( 'places', {}, 'interactionRules', {} );
            
            idx= 1:numel( obj.data );
            idx= reshape( idx(:), size(obj. data) );
            
            rot= imrotate( reshape(1:64, 8, 8), 90 );
            
            % computing rotation
            for k2=7:-1:0,
                for k1=7:-1:0,
                    sidx1( (1:8)+k1*8, (1:8)+k2*8 ) = imrotate( idx( (1:8)+k1*8, (1:8)+k2*8 ), 90);
                end
            end
            %computing reflections
            for k2=7:-1:0,
                    sidx2( (1:8)+k2*8, : ) = idx( (8:-1:1)+k2*8, : );
            end            
            
            id= -log(eye(3)+1e-300)*3e-3*beta;
            for grIdx= 1:2,
                pls=[];
                for k2=0:2:7,
                    for k1=0:7,
                        pl= idx( mod( (0:8)+ 8*(k2+grIdx), 64)+ 1 , (1:8)+ k1*8 );
                        pls= [pls; pl(:)];
                    end
                end
                gs. updateGroups(grIdx). places= pls;
                
                % interaction rules
                ir= struct( 'potential', {}, 'places', {} );
                
                % first repetitive structure
                
                for sh= { obj.baseSize.*[1 0], obj.baseSize.*[-1 0], ...
                        obj.baseSize.*[0 1], obj.baseSize.*[0 -1] },
                    ir(end+1). potential= id*.5;                    
                    cidx= circshift( idx, sh{1} );
                    ir(end). places= cidx( pls );
                end
%                 for sh= { obj.baseSize, -obj.baseSize, ...
%                         obj.baseSize.*[1 0], obj.baseSize.*[-1 0], ...
%                         obj.baseSize.*[0 1], obj.baseSize.*[0 -1] },
%                     ir(end+1). potential= id;                    
%                     cidx= circshift( idx, sh{1} );
%                     ir(end). places= cidx( pls );
%                 end
                
                % than we need to add symmetry
                % here it is glide reflection
                ir(end+1). potential= id*.3;
                ir(end). places= sidx1( pls );
                ir(end+1). potential= id*.3;
                ir(end). places= sidx2( pls );
                
                gs. updateGroups(grIdx). interactionRules= ir;
            end
        end
        function gs= createUpdateGroups2( obj, betas )
            % 3 beta values
            gs= GibbsSampler();
            gs. data= obj.data;
            gs. updateGroups= struct( 'places', {}, 'interactionRules', {} );
            
            idx= 1:numel( obj.data );
            idx= reshape( idx(:), size(obj. data) );
            
            rot= imrotate( reshape(1:64, 8, 8), 90 );
            
            % computing rotation
            for k2=7:-1:0,
                for k1=7:-1:0,
                    sidx1( (1:8)+k1*8, (1:8)+k2*8 ) = rot90( idx( (1:8)+k1*8, (1:8)+k2*8 ));
                    sidx3( (1:8)+k1*8, (1:8)+k2*8 ) = rot90( idx( (1:8)+k1*8, (1:8)+k2*8 ), 3);
                end
            end
            %computing reflections
            for k2=7:-1:0,
                    sidx2( (1:8)+k2*8, : ) = idx( (8:-1:1)+k2*8, : );
            end            
            
            id= -log(eye(3)+1e-300)*3e-3;
            for grIdx= 1:2,
                pls=[];
                for k2=0:2:7,
                    for k1=0:7,
                        pl= idx( mod( (0:7)+ 8*(k2+grIdx+mod(k1, 2) )+4, 64)+ 1 , mod( (0:7)+ k1*8+4, 64)+1 );
                        pls= [pls; pl(:)];
                    end
                end
                gs. updateGroups(grIdx). places= pls;
                
                % interaction rules
                ir= struct( 'potential', {}, 'places', {} );
                
                % first repetitive structure
                
                for sh= { obj.baseSize.*[1 0], obj.baseSize.*[-1 0], ...
                        obj.baseSize.*[0 1], obj.baseSize.*[0 -1] },
                    ir(end+1). potential= id*betas(1);                    
                    cidx= circshift( idx, sh{1} );
                    ir(end). places= cidx( pls );
                end
                
                % than we need to add symmetry
                
                ir(end+1). potential= id*betas(2);
                ir(end). places= sidx1( pls );
                ir(end+1). potential= id*betas(2);
                ir(end). places= sidx3( pls );
                ir(end+1). potential= id*betas(3);
                ir(end). places= sidx2( pls );
                
                gs. updateGroups(grIdx). interactionRules= ir;
            end
        end
        function interactionRules( obj )
            % first cell should be replicated
            id= log(eye(3)+1e-6);
            obj. interactionRules{end+1}= { obj. baseSize, id };
            obj. interactionRules{end+1}= { obj. baseSize.*[1 0], id };
            obj. interactionRules{end+1}= { obj. baseSize.*[0 1], id };
        end
    end
end

