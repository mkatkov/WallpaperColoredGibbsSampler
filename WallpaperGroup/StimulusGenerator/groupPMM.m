classdef groupPMM < SquareLattice
    
    methods
        function obj= groupPMM()
            % by default it is 64x64 elements grid with 3 colors
            obj. baseSize= [16 8];
            obj. size= [4 8];
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
            for k=7:-1:0,
                sidx1( :, (8:-1:1)+ k*8 ) = idx( :, (1:8) + k*8 );
            end
            for k=3:-1:0,
                sidx2( (16:-1:1)+ k*16, : ) = idx( (1:16) + k*16, : );
            end
            id= -log(eye(3)+1e-300)*3e-3*beta;
            cc=1;
            for grIdx= 1:4,
                pls=[];
                for k=0:15,
                    pl= idx( mod( (0:15)+   16*(k+grIdx), 64)+ 1 , (1:4)+ k*4 );
                    pls= [pls; pl(:)];
                end
                gs. updateGroups(grIdx). places= pls;
                
                % interaction rules
                ir= struct( 'potential', {}, 'places', {} );
                
                % first repetitive structure
                
                for sh= { obj.baseSize.*[1 0],  ...
                        obj.baseSize.*[0 1] },
                    ir(end+1). potential= id;
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
                ir(end+1). potential= id;
                ir(end). places= sidx1( pls );
                ir(end+1). potential= id;
                ir(end). places= sidx2( pls );
                
                %                 for sh= { obj.baseSize, -obj.baseSize, ...
                %                         obj.baseSize.*[1 0], ...
                %                         obj.baseSize.*[0 1] },
                %                     ir(end+1). potential= id;
                %                     cidx= circshift( sidx, sh{1} );
                %                     ir(end). places= cidx( pls );
                %                 end
                
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
            for k=7:-1:0,
                sidx1( :, (8:-1:1)+ k*8 ) = idx( :, (1:8) + k*8 );
            end
            for k=3:-1:0,
                sidx2( (16:-1:1)+ k*16, : ) = idx( (1:16) + k*16, : );
            end
            id= -log(eye(3)+1e-300)*3e-3;
            cc=1;
            for grIdx= 1:8,
                pls=[];
                for k=0:15,
                    pl= idx( mod( (0:7)+   8*(k+grIdx), 64)+ 1 , (1:4)+ k*4 );
                    pls= [pls; pl(:)];
                end
                gs. updateGroups(grIdx). places= pls;
                
                % interaction rules
                ir= struct( 'potential', {}, 'places', {} );
                
                % first repetitive structure
                
                for sh= { obj.baseSize.*[1 0],  ...
                        obj.baseSize.*[0 1] },
                    ir(end+1). potential= id*betas(1);
                    cidx= circshift( idx, sh{1} );
                    ir(end). places= cidx( pls );
                end
                
                % than we need to add symmetry
                ir(end+1). potential= id*betas(2);
                ir(end). places= sidx1( pls );
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

