classdef groupP2 < ParallelogrammaticLattice
    properties
    end
    methods
        function obj= groupP2()
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
            %             for k=1:9,
            %                 im( mod( k+off(1)*9, size(obj.data,1)),...
            %                     mod( floor((k-mod(off(1),2))/2)+(1:9)+off(2)*9+off(1)*5, size(obj.data,1) ) )= true;
            %             end
        end
        function data= getCentralRotations( obj )
            pos=[];
            rotPos=[];
            for k1=0:10,
                for k2=0:10,
                    cellPos= obj. getCellInd( [k1, k2] );
                    pos= [pos; cellPos(:)];
                    cellPos= imrotate(cellPos,180);
                    rotPos= [rotPos; cellPos(:)];
                end
            end
            data= obj.data;
            data( rotPos )= data(pos);
        end
        function pos= getCellRotation( obj, k1,k2 )
                    pos= obj. getCellInd( [k1, k2] );
                    pos= imrotate(pos,180);
        end
        function ir= getInteractionRules( obj, beta )
            % first cell should be replicated
            id= Potential();
            id.U = log(eye(3)+1e-2)*beta;
            id2= Potential();
            id2.U = log(eye(3)+1e-2)*beta;
            
            ir= struct( 'places',[], 'potential', id([]) );
            ir= repmat( ir, size( obj.data ) );
            for k1=0:10,
                for k2=0:10,
                    % translations
                    pos= obj. getCellInd( [k1, k2] );
                    for off= [1 0; 0 1],
                        posDoff= obj. getCellInd( [k1+off(1), k2+off(2)] );
                        
                        for k=1:numel(pos),
                            ir( pos(k) ). places(end+1)= posDoff(k);
                            ir( pos(k) ). potential(end+1)= id;
                        end
                    end
                    
                    pos1= pos;%(idx);
                    posOff= imrotate(pos,180);%( rot{1}(idx) );
                    idx= (pos1~= posOff);
                    pos1= pos1(idx);
                    posOff= posOff(idx);
                    for k=1:numel(pos1),
                        ir( pos1(k) ). places(end+1)= posOff(k);
                        ir( pos1(k) ). potential(end+1)= id2;
                    end
                    
                end
            end
        end
        function ir= getInteractionRules2( obj, betas )
            % 2 beta values
            id= Potential();
            id.U = log(eye(3)+1e-2)*betas(1);
            id2= Potential();
            id2.U = log(eye(3)+1e-2)*betas(2);
            
            ir= struct( 'places',[], 'potential', id([]) );
            ir= repmat( ir, size( obj.data ) );
            for k1=0:10,
                for k2=0:10,
                    % translations
                    pos= obj. getCellInd( [k1, k2] );
                    for off= [1 0; 0 1],
                        posDoff= obj. getCellInd( [k1+off(1), k2+off(2)] );
                        
                        for k=1:numel(pos),
                            ir( pos(k) ). places(end+1)= posDoff(k);
                            ir( pos(k) ). potential(end+1)= id;
                        end
                    end
                    
                    pos1= pos;%(idx);
                    posOff= imrotate(pos,180);%( rot{1}(idx) );
                    idx= (pos1~= posOff);
                    pos1= pos1(idx);
                    posOff= posOff(idx);
                    for k=1:numel(pos1),
                        ir( pos1(k) ). places(end+1)= posOff(k);
                        ir( pos1(k) ). potential(end+1)= id2;
                    end
                    
                end
            end
        end
    end
end

