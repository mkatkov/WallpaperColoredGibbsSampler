classdef groupP6 < HexagonalLattice
    properties
        symm;   % a set of symmetry transformations of a cell
    end
    methods
        function obj= groupP6()
            %by default it is 64x64 elements grid with 3 colors
            obj. baseSize= [9 9];
            obj. size= [8 8];
            obj. data= randi( 3, obj. baseSize.* obj.size);
            obj. colors= [.33;.67;1]*[1 1 1]; %[1 0 0; 0 1 0; 0 0 1];
            obj. interactionRules= {};
            
            %there are 3? symmetries on p3m1 group
            
            obj. symm{1}= mod( bsxfun( @minus, (81:-8:17)' , (0:8)*9 ), 81 )'+1;
            symm= reshape(1:81, 9,9)'; %#ok<PROP>
            symm( 2:end,:)= flipud( symm( 2:end,:) ); %#ok<PROP>
            symm( :,2:end)= fliplr( symm( :, 2:end ) ); %#ok<PROP>
            obj. symm{2}= symm'; %#ok<PROP>
            obj. symm{3}= [1 18 26 34 42 50 58 66 74
                9 17 25 33 41 49 57 65 73
                8 16 24 32 40 48 56 64 81
                7 15 23 31 39 47 55 72 80
                6 14 22 30 38 46 63 71 79
                5 13 21 29 37 54 62 70 78
                4 12 20 28 45 53 61 69 77
                3 11 19 36 44 52 60 68 76
                2 10 27 35 43 51 59 67 75]';
            obj. symm{4}= [1:9
                74:81 73
                66:72 64:65
                58:63 55:57
                50:54 46:49
                42:45 37:41
                34:36 28:33
                26:27 19:25
                18 10:17];
        end
        function im= getCellImg( obj, off )
            im= false( size(obj.data) );
            pos= obj. getCellInd( off );
            im( pos )= true;
        end
%         function gs= createUpdateGroups( obj ) %#ok<MANU,STOUT>
%         end
        function ir= getInteractionRules( obj, beta )
            %first cell should be replicated
            id= Potential();
            id.U = log(eye(3)+3e-1)*beta;
            id2= Potential();
            id2.U = log(eye(3)+9e-1)*beta;
            
            ir= struct( 'places',[], 'potential', id([]) );
            ir= repmat( ir, size( obj.data ) );
            for k1=0:7,
                for k2=0:7,
                    %translations
                    pos= obj. getCellInd( [k1, k2] );
                    for off= [1 0 -1 0; 0 1 0 -1],
                        for off= [1 0 -1 0 1 1; 0 1 0 -1 1 -1],
                            posDoff= obj. getCellInd( [k1+off(1), k2+off(2)] );
                            
                            for k=1:numel(pos),
                                ir( pos(k) ). places(end+1)= posDoff(k);
                                ir( pos(k) ). potential(end+1)= id;
                            end
                        end
                        
                        %symmetry group
                        for symm= obj.symm, %#ok<PROP>
                            idx= ( symm{1} ~=0 ); %#ok<PROP>
                            pos1= pos(idx);
                            posOff= pos( symm{1}(idx) ); %#ok<PROP>
                            for k=1:numel(pos1),
                                if pos1(k) == posOff(k), continue; end
                                ir( pos1(k) ). places(end+1)= posOff(k);
                                ir( pos1(k) ). potential(end+1)= id2;
                            end
                        end
                    end
                end
            end
        end
        function ir= getInteractionRules2( obj, betas )
            % 4 beta values
            
            ids= cell(4,1);
            for k=1:4
                id= Potential();
                id.U = log(eye(3)+1e-1)*betas(k);
                ids{k}= id;
            end
                        
            ir= struct( 'places',[], 'potential', id([]) );
            ir= repmat( ir, size( obj.data ) );
            for k1=0:7,
                for k2=0:7,
                    %translations
                    pos= obj. getCellInd( [k1, k2] );
                    for off= [1 0 -1 0; 0 1 0 -1],
                        for off= [1 0 -1 0 1 1; 0 1 0 -1 1 -1],
                            posDoff= obj. getCellInd( [k1+off(1), k2+off(2)] );
                            
                            for k=1:numel(pos),
                                ir( pos(k) ). places(end+1)= posDoff(k);
                                ir( pos(k) ). potential(end+1)= id;
                            end
                        end
                        
                        %symmetry group
                        for sidx= 1:4,
                            symm= obj.symm(sidx); %#ok<PROP>
                            idx= ( symm{1} ~=0 ); %#ok<PROP>
                            pos1= pos(idx);
                            posOff= pos( symm{1}(idx) ); %#ok<PROP>
                            for k=1:numel(pos1),
                                if pos1(k) == posOff(k), continue; end
                                ir( pos1(k) ). places(end+1)= posOff(k);
                                ir( pos1(k) ). potential(end+1)= ids{sidx};
                            end
                        end
                    end
                end
            end
        end
    end
end
