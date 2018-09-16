classdef groupP4G < SquareLattice
    
    methods
        function obj= groupP4G()
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
            
            im= reshape(1:64, 8, 8);
            rot= rot90( im );
            flipAll= @(bl) bl.data';
            sidx2= blockproc( idx, [4,4], flipAll );
            
            % computing rotation
            for k2=7:-1:0,
                for k1=7:-1:0,
                    ii= idx( (1:8)+k1*8, (1:8)+k2*8 );
                    sidx1( (1:8)+k1*8, (1:8)+k2*8 ) = ii(rot);
                end
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
                    ir(end+1). potential= id*.6;                    
                    cidx= circshift( idx, sh{1} );
                    ir(end). places= cidx( pls );
                end
                
                % than we need to add symmetry
                % here it is glide reflection
                ir(end+1). potential= id*.5;
                ir(end). places= sidx1( pls );
                ir(end+1). potential= id*.5;
                ir(end). places= sidx2( pls );

                gs. updateGroups(grIdx). interactionRules= ir;
            end
        end
        function idx= getCellReflectionIndeces( obj )
            sz= obj. baseSize/2;
            idx= reshape( 1:prod(obj. baseSize), obj. baseSize );
            ii= reshape( 1:prod(sz), sz );
            idx( (1:sz(1)), (1:sz(2)) + sz(2) )= idx( (1:sz(1)), (1:sz(2)) + sz(2) )';
            idx( (1:sz(1)), (1:sz(2)) )= rot90( rot90(idx( (1:sz(1)), (1:sz(2)) ), 1 )', 3);
            idx( (1:sz(1))+sz(1), (1:sz(2)) )= rot90( rot90(idx( (1:sz(1)) +sz(1) , (1:sz(2)) ), 2 )', 2);
            idx( (1:sz(1))+sz(1), (1:sz(2)) +sz(2) )= rot90(rot90(idx( (1:sz(1))+sz(1), (1:sz(2))+sz(2) ), 3 )', 1);
        end
        function gs= createUpdateGroups2( obj, betas )
            % 3 beta values
            gs= GibbsSampler();
            gs. data= obj.data;
            gs. updateGroups= struct( 'places', {}, 'interactionRules', {} );
            
            idx= 1:numel( obj.data );
            idx= reshape( idx(:), size(obj. data) );
            
            im= reshape(1:64, 8, 8);
            rot= rot90( im );
            %flipAll= @(bl) bl.data';
            %sidx2= blockproc( idx, [4,4], flipAll );
            
            sidx3= obj. getCellReflectionIndeces();
            
            % computing rotation
            for k2=7:-1:0,
                for k1=7:-1:0,
                    ii= idx( (1:8)+k1*8, (1:8)+k2*8 );
                    sidx1( (1:8)+k1*8, (1:8)+k2*8 ) = rot90(ii,1);
                    sidx4( (1:8)+k1*8, (1:8)+k2*8 ) = rot90(ii,3);
                    sidx2( (1:8)+k1*8, (1:8)+k2*8 ) = ii(sidx3);
                end
            end
            
            grPos= [
                1 1 1 1 0 0 0 0 
                1 1 1 0 1 0 0 0
                1 1 0 0 1 1 0 0
                1 0 0 0 1 1 1 0
                0 1 1 1 0 0 0 1
                0 0 1 1 0 0 1 1
                0 0 0 1 0 1 1 1
                0 0 0 0 1 1 1 1];
            grAll= repmat( [grPos ~grPos; ~grPos grPos], 4,4);
            
            id= -log(eye(3)+1e-300)*3e-3;
            for grIdx= 1:2,
                pls=[];
                for k2=0:2:7,
                    for k1=0:7,
                        pl= idx( mod( (0:8)+ 8*(k2+grIdx), 64)+ 1 , (1:8)+ k1*8 );
                        pls= [pls; pl(:)];
                    end
                end
                if grIdx==1,
                pls= find(grAll);
                else
                pls= find(~grAll);
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
                % here it is glide reflection
                ir(end+1). potential= id*betas(2);
                ir(end). places= sidx1( pls );
                ir(end+1). potential= id*betas(2);
                ir(end). places= sidx4( pls );
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

