classdef groupP3 < HexagonalLattice
    properties
        %         cellImg; % img of a single cell
        rot3_1;
        rot3_2;
        %         rot31;
        %         rot32;
    end
    methods
        function obj= groupP3()
            % by default it is 64x64 elements grid with 3 colors
            obj. baseSize= [9 9];
            obj. size= [8 8];
            obj. data= randi( 3, obj. baseSize.* obj.size);
            obj. colors= [.33;.67;1]*[1 1 1]; %[1 0 0; 0 1 0; 0 0 1];
            obj. interactionRules= {};
            
            %             obj.cellImg= false( size(obj.data) );
            %             for k=1:9,
            %                 obj.cellImg( k, floor(k/2)+(1:9) )= true;
            %             end
            
            obj. rot3_1= zeros(9);
            obj. rot3_2= zeros(9);
            for k=1:9
                obj. rot3_1(1:(10-k), k )= (10-k) +(0:8:(9-k)*8);
                obj. rot3_2( (10-k):end, k)= (10-k)*9 +(0:8:8*(k-1)) ;
                %obj.rot31(k,:)= [obj. rot3_1(k, 1:k) obj. rot3_2(k, k+1:end)];
                %obj.rot32(k,:)= [obj. rot3_1(k, 1:k-1) obj. rot3_2(k, k:end)];
            end
            %obj.rot31= obj.rot31';
            %obj.rot32= obj.rot32';
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
        function ir= getInteractionRules( obj, beta )
            % first cell should be replicated
            id= Potential();
            id.U = log(eye(3)+1e-2)*beta;
            id2= Potential();
            id2.U = log(eye(3)+1e-2)*beta;
            
            ir= struct( 'places',[], 'potential', id([]) );
            ir= repmat( ir, size( obj.data ) );
            for k1=0:7,
                for k2=0:7,
                    % translations
                    pos= obj. getCellInd( [k1, k2] );
                    for off= [1 0 -1 0; 0 1 0 -1],
                        posDoff= obj. getCellInd( [k1+off(1), k2+off(2)] );
                        
                        for k=1:numel(pos),
                            ir( pos(k) ). places(end+1)= posDoff(k);
                            ir( pos(k) ). potential(end+1)= id;
                        end
                    end
                    
                    % symmetry group
                    for rot= {obj.rot3_1, obj.rot3_2},
                        idx= ( rot{1} ~=0 );
                        pos1= pos(idx);
                        posOff= pos( rot{1}(idx) );
                        for k=1:numel(pos1),
                            ir( pos1(k) ). places(end+1)= posOff(k);
                            ir( pos1(k) ). potential(end+1)= id2;
                        end
                    end
                end
            end
        end
        function data= getRotation1( obj )
            data= obj.data;
            rots= {obj.rot3_1};
            for k1=0:7,
                for k2=0:7,
                    % translations
                    pos= obj. getCellInd( [k1, k2] );
                    for sidx=1:size(rots) ,
                        rot= rots( sidx );
                        idx= ( rot{1} ~=0 );
                        pos1= pos(idx);
                        posOff= pos( rot{1}(idx) );
                        for k=1:numel(pos1),
                            data( pos1(k) )= obj.data(posOff(k));
                        end
                    end
                end
            end
        end
        function ir= getInteractionRules2( obj, betas )
            %3 beta values
            
            % first cell should be replicated
            id= Potential();
            id.U = log(eye(3)+1e-2)*betas(1);
            id2= Potential();
            id2.U = log(eye(3)+1e-2)*betas(2);
            id3= Potential();
            id3.U = log(eye(3)+1e-2)*betas(2);
            
            ids= {id2, id3};
            
            ir= struct( 'places',[], 'potential', id([]) );
            ir= repmat( ir, size( obj.data ) );
            for k1=0:7,
                for k2=0:7,
                    % translations
                    pos= obj. getCellInd( [k1, k2] );
                    for off= [1 0 -1 0; 0 1 0 -1],
                        posDoff= obj. getCellInd( [k1+off(1), k2+off(2)] );
                        
                        for k=1:numel(pos),
                            ir( pos(k) ). places(end+1)= posDoff(k);
                            ir( pos(k) ). potential(end+1)= id;
                        end
                    end
                    
                    % symmetry group
                    rots= {obj.rot3_1, obj.rot3_2};
                    for sidx=1:2 ,
                        rot= rots( sidx );
                        idx= ( rot{1} ~=0 );
                        pos1= pos(idx);
                        posOff= pos( rot{1}(idx) );
                        for k=1:numel(pos1),
                            ir( pos1(k) ). places(end+1)= posOff(k);
                            ir( pos1(k) ). potential(end+1)= ids{sidx};
                        end
                        pos2= pos;
                        pos2(idx)= posOff;
                        posOff= pos2( rot{1}(idx) );
                        for k=1:numel(pos1),
                            ir( pos1(k) ). places(end+1)= posOff(k);
                            ir( pos1(k) ). potential(end+1)= ids{sidx};
                        end
                    end
                end
            end
        end
    end
end

