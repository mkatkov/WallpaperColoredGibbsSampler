classdef groupCMM < RhombicLattice
    properties
    end
    methods
        function obj= groupCMM()
            % by default it is 64x64 elements grid with 3 colors
            obj. baseSize= [8 8];
            obj. size= [5 12];
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
        function fillRandomPerfect( obj )
            idx0= obj. getCellInd( [0,0] );
            obj.data(idx0)= randi(3, numel( idx0), 1 );
            for k1=0:10,
                for k2=0:10,
                    % translations
                    pos= obj. getCellInd( [k1, k2] );
                    obj.data(pos)= obj.data(idx0);
                end
            end
        end
        function data= getLocalMirrorSymmetry(obj)
            pos=[];
            mirPos=[];
            for k1=0:10,
                for k2=0:10,
                    cellPos= obj. getCellInd( [k1, k2] );
                    pos= [pos; cellPos(:)];
                    cellPos= cellPos';
                    mirPos= [mirPos; cellPos(:)];
                end
            end
            data= obj.data;
            data( mirPos )= data(pos);            
        end
        function data= getCentralRotations( obj )
            pos=[];
            rotPos=[];
            for k1=0:10,
                for k2=0:10,
                    cellPos= obj. getCellInd( [k1, k2] );
                    pos= [pos; cellPos(:)];
                    cellPos= rot90( cellPos,2);
                    rotPos= [rotPos; cellPos(:)];
                end
            end
            data= obj.data;
            data( rotPos )= data(pos);
        end
        function ir= getInteractionRules( obj, beta )
            % first cell should be replicated
            id= Potential();
            id.U = log(eye(3)+2e-1)*beta;
            id2= Potential();
            id2.U = log(eye(3)+1e-2)*beta;
            
            ir= struct( 'places',[], 'potential', id([]) );
            ir= repmat( ir, size( obj.data ) );
            for k1=0:10,
                for k2=0:10,
                    % translations
                    pos= obj. getCellInd( [k1, k2] );
                    %for off= [1 0 -1 0; 0 1 0 -1],
                    for off= [1 0 -1 0 1 1 ; 0 1 0 -1 1 -1],
                        posDoff= obj. getCellInd( [k1+off(1), k2+off(2)] );
                        
                        for k=1:numel(pos),
                            ir( pos(k) ). places(end+1)= posDoff(k);
                            ir( pos(k) ). potential(end+1)= id;
                        end
                    end
                    
                    % symmetry group
                    %for rot= {obj.rot3_1, obj.rot3_2},
                    %idx= ( rot{1} ~=0 );
                    pos1= pos;%(idx);
                    posOff= pos';%( rot{1}(idx) );
                    idx= (pos1~= posOff);
                    pos1= pos1(idx);
                    posOff= posOff(idx);
                    for k=1:numel(pos1),
                        ir( pos1(k) ). places(end+1)= posOff(k);
                        ir( pos1(k) ). potential(end+1)= id2;
                    end
                    %end
                    pos1= pos;%(idx);
                    posOff= rot90( pos,2)';%( rot{1}(idx) );
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
            % 3 beta values
            
            % first cell should be replicated
            id= Potential();
            id.U = log(eye(3)+2e-1)*betas(1);
            id2= Potential();
            id2.U = log(eye(3)+1e-2)*betas(2);
            id3= Potential();
            id3.U = log(eye(3)+1e-2)*betas(3);
            
            ir= struct( 'places',[], 'potential', id([]) );
            ir= repmat( ir, size( obj.data ) );
            for k1=0:10,
                for k2=0:10,
                    % translations
                    pos= obj. getCellInd( [k1, k2] );
                    %for off= [1 0 -1 0; 0 1 0 -1],
                    for off= [1 0 -1 0 1 1 ; 0 1 0 -1 1 -1],
                        posDoff= obj. getCellInd( [k1+off(1), k2+off(2)] );
                        
                        for k=1:numel(pos),
                            ir( pos(k) ). places(end+1)= posDoff(k);
                            ir( pos(k) ). potential(end+1)= id;
                        end
                    end
                    
                    % symmetry group
                    %for rot= {obj.rot3_1, obj.rot3_2},
                    %idx= ( rot{1} ~=0 );
                    pos1= pos;%(idx);
                    posOff= pos';%( rot{1}(idx) );
                    idx= (pos1~= posOff);
                    pos1= pos1(idx);
                    posOff= posOff(idx);
                    for k=1:numel(pos1),
                        ir( pos1(k) ). places(end+1)= posOff(k);
                        ir( pos1(k) ). potential(end+1)= id2;
                    end
                    %end
                    pos1= pos;%(idx);
                    posOff= rot90( pos,2);%( rot{1}(idx) );
                    idx= (pos1~= posOff);
                    pos1= pos1(idx);
                    posOff= posOff(idx);
                    for k=1:numel(pos1),
                        ir( pos1(k) ). places(end+1)= posOff(k);
                        ir( pos1(k) ). potential(end+1)= id3;
                    end
                end
            end
        end
    end
end

