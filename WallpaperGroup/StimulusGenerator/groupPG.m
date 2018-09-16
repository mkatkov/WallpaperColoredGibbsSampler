classdef groupPG < SquareLattice
    
    methods
        function obj= groupPG()
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
            
            % computing glide reflection
            for k2=0:3,
                for k1=7:-1:0,
                    sidx( (1:8)  +k2*16, (1:8)+ k1*8 ) = idx( (1:8)+8+k2*16, (8:-1:1) + k1*8 );
                    sidx( (1:8)+8+k2*16, (1:8)+ k1*8 ) = idx( (1:8)  +k2*16, (8:-1:1) + k1*8 );
                end
            end
            id= -log(eye(3)+1e-300)*3e-3*beta;
            for grIdx= 1:2,
                pls=[];
                for k=0:7,
                    pl= idx( mod( (0:15)+   16*(k+grIdx), 64)+ 1 , (1:8)+ k*8 );
                    pls= [pls; pl(:)];
                    pl= idx( mod( 32+ (0:15)+   16*(k+grIdx), 64)+ 1 , (1:8)+ k*8 );
                    pls= [pls; pl(:)];
                end
                gs. updateGroups(grIdx). places= pls;
                
                % interaction rules
                ir= struct( 'potential', {}, 'places', {} );
                
                % first repetitive structure
                
                for sh= { obj.baseSize.*[1 0], obj.baseSize.*[-1 0], ...
                        obj.baseSize.*[0 1], obj.baseSize.*[0 -1] },
                    ir(end+1). potential= id/2;                    
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
                % he it is glide reflection
                ir(end+1). potential= id/5;
                ir(end). places= sidx( pls );
                for sh= { obj.baseSize.*[1 0], obj.baseSize.*[-1 0], ...
                        obj.baseSize.*[0 1], obj.baseSize.*[0 -1] },
                    ir(end+1). potential= id/5;                    
                    cidx= circshift( sidx, sh{1} );
                    ir(end). places= cidx( pls );
                end

  
                gs. updateGroups(grIdx). interactionRules= ir;
            end
        end
        function data= getGlideReflection( obj )
            data= obj.data;
            for k2=0:3,
                for k1=7:-1:0,
                    data( (1:8)  +k2*16, (1:8)+ k1*8 ) = obj.data( (1:8)+8+k2*16, (8:-1:1) + k1*8 );
                    data( (1:8)+8+k2*16, (1:8)+ k1*8 ) = obj.data( (1:8)  +k2*16, (8:-1:1) + k1*8 );
                end
            end            
        end
        function gs= createUpdateGroups2( obj, betas )
            % 2 beta values
            gs= GibbsSampler();
            gs. data= obj.data;
            gs. updateGroups= struct( 'places', {}, 'interactionRules', {} );
            
            idx= 1:numel( obj.data );
            idx= reshape( idx(:), size(obj. data) );
            
            % computing glide reflection
            sidx= idx;
            for k2=0:3,
                for k1=7:-1:0,
                    sidx( (1:8)  +k2*16, (1:8)+ k1*8 ) = idx( (1:8)+8+k2*16, (8:-1:1) + k1*8 );
                    sidx( (1:8)+8+k2*16, (1:8)+ k1*8 ) = idx( (1:8)  +k2*16, (8:-1:1) + k1*8 );
                end
            end
            id= -log(eye(3)+1e-300)*3e-3;
            for grIdx= 1:2,
                pls=[];
                for k=0:7,
                    for k2=0:2:7,
                        pl= idx( mod( (0:7)+   8*(k+k2+grIdx), 64)+ 1 , mod( (0:7)+ k*8, 64)+1 );
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
                % he it is glide reflection
                ir(end+1). potential= id*betas(2);
                %ir(end). places= pls;
                ir(end). places= sidx(pls);
                %ir(end). places= sidx( pls );

                %                 for sh= { obj.baseSize.*[1 0], obj.baseSize.*[-1 0], ...
%                         obj.baseSize.*[0 1], obj.baseSize.*[0 -1] },
%                     ir(end+1). potential= id*betas(2);                    
%                     cidx= circshift( sidx, sh{1} );
%                     ir(end). places= cidx( pls );
%                 end

  
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

