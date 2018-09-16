% test.m
%
% tests for Stimulus generator

%close all
clear all

%% test for lattices with random filling

clf

subplot(321)
rl= RhombicLattice;
rl. baseSize= [1 1];
rl. size= [10 20];
rl. colors= [1 0 0
    0 1 0
    0 0 1];
rl.data= randi(3, 10, 20);
rl. draw( gca)
axis off

subplot(322)
hl= HexagonalLattice;
hl. baseSize= [1 1];
hl. size= [10 10];
hl. colors= [1 0 0
    0 1 0
    0 0 1];
hl.data= randi(3, 10, 10);
hl. draw( gca)
axis off


subplot(323)
sl= SquareLattice;
sl. baseSize= [1 1];
sl. size= [10 10];
sl. colors= [1 0 0
    0 1 0
    0 0 1];
sl.data= randi(3, 10, 10);
sl. draw( gca)
axis off


subplot(324)
pl= ParallelogrammaticLattice;
pl. baseSize= [1 1];
pl. size= [10 10];
pl. colors= [1 0 0
    0 1 0
    0 0 1];
pl.data= randi(3, 10, 10);
pl. draw( gca)
axis off

subplot(325)
rgl= RectangularLattice;
rgl. baseSize= [1 1];
rgl. size= [10 10];
rgl. colors= [1 0 0
    0 1 0
    0 0 1];
rgl.data= randi(3, 10, 10);
rgl. draw( gca)
axis off

%% test for pm group

clear all
figure(2)
clf
axes

pm= groupPM();
gs= pm. createUpdateGroups(1);

for k=1:100000,
    gs. data= randi(3, size( gs.data) );
    gs.sample( 100 );
    pm.data= gs.data;
    pm.draw(gca);
    title(k);
    pause(.1)
    drawnow
end

%% test for pg group

clear all
figure(2)
clf
axes

pg= groupPG();
gs= pg. createUpdateGroups();

for k=1:1e6,
    gs. data= randi(3, size( gs.data) );
    gs.sample( 1000 );
    pg.data= gs.data;
    pg.draw(gca);
    title(k);
    pause(.1)
    drawnow
end

%% test for pmm group

clear all
figure(2)
clf
axes

pmm= groupPMM();
gs= pmm. createUpdateGroups();

for k=1:1e6,
    gs. data= randi(3, size( gs.data) );
    gs.sample( 1000 );
    pmm.data= gs.data;
    pmm.draw(gca);
    title(k);
    pause(.1)
    drawnow
end

%% test for pmg group
% not working properly


%clear all
figure(2)
clf
axes

pmm= groupPMG();
gs= pmm. createUpdateGroups();

for k=1:1000,
    gs. data= randi(3, size( gs.data) );
    gs.sample( 1000 );
    pmm.data= gs.data;
    pmm.draw(gca);
    rectangle( 'Position', [1 1  16 8], 'EdgeColor', 'r', 'linewidth', 4 )
    title(k);
    pause(.1)
    drawnow
end

%% test for p4 group

clear all
figure(2)
clf
axes

p4= groupP4();
gs= p4. createUpdateGroups();

for k=1:1000,
    gs. data= randi(3, size( gs.data) );
    gs.sample( 1000 );
    p4.data= gs.data;
    p4.draw(gca);
    rectangle( 'Position', [1 1  8 8], 'EdgeColor', 'r', 'linewidth', 4 )
    title(k);
    pause(.1)
    drawnow
end

%% test for pgg  group

clear all
figure(2)
clf
axes

pgg= groupPGG();
gs= pgg. createUpdateGroups();

for k=1:1000,
    gs. data= randi(3, size( gs.data) );
    gs.sample( 1000 );
    pgg.data= gs.data;
    pgg.draw(gca);
    rectangle( 'Position', [1 1  16 8], 'EdgeColor', 'r', 'linewidth', 4 )
    title(k);
    pause(.1)
    drawnow
end

%% test for p4m group

clear all
figure(2)
clf
axes

p4m= groupP4M();
gs= p4m. createUpdateGroups();

for k=1:1000,
    gs. data= randi(3, size( gs.data) );
    gs.sample( 1000 );
    p4m.data= gs.data;
    p4m.draw(gca);
    rectangle( 'Position', [1 1  8 8], 'EdgeColor', 'r', 'linewidth', 4 )
    title(k);
    pause(.1)
    drawnow
end

%% test for p4g group

clear all
figure(2)
clf
axes

p4g= groupP4G();
gs= p4g. createUpdateGroups();

for k=1:1000,
    gs. data= randi(3, size( gs.data) );
    gs.sample( 1000 );
    p4g.data= gs.data;
    p4g.draw(gca);
    rectangle( 'Position', [1 1  8 8], 'EdgeColor', 'r', 'linewidth', 4 )
    title(k);
    pause(.1)
    drawnow
end

%% test for p3 group

%clear all
p3= groupP3();

figure(2)
clf
axes

gs= GibbsSampler2();
p3.data= randi(3, size( p3.data) );
p3.draw( gca )
gs.dataClass= p3;

for beta= linspace(1, 0, 100 ),
    ir= p3.getInteractionRules( beta );
    gs. createGroups( ir );
    
    
    % %
    % p3.data(:)=1;
    % p3. colorCells()
    % p3.clearCells()
    
    for k=1:3,
        p3.data= randi(3, size( p3.data) );
        gs. sample(1000);
        p3.draw( gca )
        %     hh= patch( [0.5 7.5 7.5 0.5], [0.5 4.5 12.5 8.5], 'k', 'FaceColor', 'none', 'linewidth', 2 );
        %     hh= patch( [0.5 7.5 7.5 0.5], 8+[0.5 4.5 12.5 8.5], 'k', 'FaceColor', 'none', 'linewidth', 2 );
        title(sprintf('\\beta=%.3f, %d', beta, k));
        %pause(1)
        drawnow
    end
end
%% debugging

% clear all
p3= groupP3();

gs= GibbsSampler2();
gs.dataClass= p3;

ir= p3.getInteractionRules();
gs. createGroups( ir );
p3.data(:)=1;
p3.draw(gca);
p3. colorCells()


%% test for p3m1 group

clear all
p3m1= groupP3M1();

figure(2)
clf
axes

gs= GibbsSampler2();
p3m1.data= randi(3, size( p3m1.data) );
p3m1.draw( gca )
gs.dataClass= p3m1;

for beta= linspace(1, 0, 100 ),
    ir= p3m1.getInteractionRules( beta );
    gs. createGroups( ir );
    
    
    % %
    % p3.data(:)=1;
    % p3m1. colorCells()
    % p3m1.clearCells()
    p3m1.data= randi(3, size( p3m1.data) );
    for k=1:1,
        gs. sample(1000);
        p3m1.draw( gca )
        %     hh= patch( [0.5 7.5 7.5 0.5], [0.5 4.5 12.5 8.5], 'k', 'FaceColor', 'none', 'linewidth', 2 );
        %     hh= patch( [0.5 7.5 7.5 0.5], 8+[0.5 4.5 12.5 8.5], 'k', 'FaceColor', 'none', 'linewidth', 2 );
        title(sprintf('\\beta=%.3f, %d', beta, k));
        %pause(1)
        drawnow
    end
end

%% test for p3m1 group

clear all
p31m= groupP31M();

figure(2)
clf
axes

gs= GibbsSampler2();
p31m.data= randi(3, size( p31m.data) );
p31m.draw( gca )
gs.dataClass= p31m;
%%
for beta= 0.1;%linspace(1, 0, 100 ),
    ir= p31m.getInteractionRules( beta );
    gs. createGroups( ir );
    
    
    % %
    % p3.data(:)=1;
    % p31m. colorCells()
    % p31m.clearCells()
    p31m.data= randi(3, size( p31m.data) );
    for k=1:1,
    p31m.data= randi(3, size( p31m.data) );
        gs. sample(300);
        p31m.draw( gca )
        %     hh= patch( [0.5 7.5 7.5 0.5], [0.5 4.5 12.5 8.5], 'k', 'FaceColor', 'none', 'linewidth', 2 );
        %     hh= patch( [0.5 7.5 7.5 0.5], 8+[0.5 4.5 12.5 8.5], 'k', 'FaceColor', 'none', 'linewidth', 2 );
        title(sprintf('\\beta=%.3f, %d', beta, k));
        %pause(1)
        drawnow
    end
end

%% test for p6 group

clear all
p6= groupP6();

figure(2)
clf
axes

gs= GibbsSampler2();
p6.data= randi(3, size( p6.data) );
p6.draw( gca )
gs.dataClass= p6;
%%
for beta= linspace(1, 0, 100 ),
    ir= p6.getInteractionRules( beta );
    gs. createGroups( ir );
    
    
    % %
    % p6.data(:)=1;
    % p6. colorCells()
    % p6.clearCells()
    p6.data= randi(3, size( p6.data) );
    for k=1:10,
    p6.data= randi(3, size( p6.data) );
        gs. sample(300);
        p6.draw( gca )
        %     hh= patch( [0.5 7.5 7.5 0.5], [0.5 4.5 12.5 8.5], 'k', 'FaceColor', 'none', 'linewidth', 2 );
        %     hh= patch( [0.5 7.5 7.5 0.5], 8+[0.5 4.5 12.5 8.5], 'k', 'FaceColor', 'none', 'linewidth', 2 );
        title(sprintf('\\beta=%.3f, %d', beta, k));
        %pause(1)
        drawnow
    end
end

%% test for p6m group

clear all
p6m= groupP6M();

figure(2)
clf
axes

gs= GibbsSampler2();
p6m.data= randi(3, size( p6m.data) );
p6m.draw( gca )
gs.dataClass= p6m;

%%
for beta= linspace(1, 0, 100 ),
    ir= p6m.getInteractionRules( beta );
    gs. createGroups( ir );
    
    
    % %
    % p6m.data(:)=1;
    % p6m. colorCells()
    % p6m.clearCells()
    p6m.data= randi(3, size( p6m.data) );
    for k=1:10,
    p6m.data= randi(3, size( p6m.data) );
        gs. sample(300);
        p6m.draw( gca )
        %     hh= patch( [0.5 7.5 7.5 0.5], [0.5 4.5 12.5 8.5], 'k', 'FaceColor', 'none', 'linewidth', 2 );
        %     hh= patch( [0.5 7.5 7.5 0.5], 8+[0.5 4.5 12.5 8.5], 'k', 'FaceColor', 'none', 'linewidth', 2 );
        title(sprintf('\\beta=%.3f, %d', beta, k));
        %pause(1)
        drawnow
    end
end


%%
ind= p3.getCellInd([0 0]);
for plii=ind(:)',%:numel(gs. interactionRules(1).places),
    p3.data(:)=1;
    for ir1= gs. interactionRules(:)',
        pli= find( ir1.places == plii );
        if ~isempty( pli ), break; end
    end
    p3.data( ir1.places(pli))= 3;
    for k=1:numel( ir1.interactions),
        pli1= find( ir1.places(ir1.interactions(k).places) == plii );
        if isempty( pli1 ),
            pl(k)= nan;
        else
            p3.data( ir1.interactions(k).condPlaces(pli1))= 2;
            pl(k)= ir1.interactions(k).condPlaces(pli1);
        end
    end
    p3.draw(gca);
    % for kk=-1:7,
    %     for kk1= 0:7,
    % %hh= patch( [0.5 7.5 7.5 0.5], [0.5 4.5 12.5 8.5], 'k', 'FaceColor', 'none', 'linewidth', 2 );
    % hh= patch( [0.5 7.5 7.5 0.5]+kk1*7, 8*kk+[0.5 4.5 12.5 8.5], 'k', 'FaceColor', 'none', 'linewidth', 2 );
    %     end
    % end
    % axis([0 56 0 56]); drawnow;
    pause
end
%%
gs.data(:)=1;
gs.data( 1:16:end, 1:16:end)= 2;
pm.data= gs.data;
pm.draw(gca);

%%
gs.sample( 1 );
pm.data= gs.data;
pm.draw(gca);

%% debugging checking interaction rules

ug= gs.updateGroups(1);
ug.places(1)

plIdx= 17;

pm.data(:)= 1;
pm.data( ug.places(plIdx) )= 2;

for k=1: numel( ug. interactionRules ),
    pl= ug. interactionRules(k). places;
    pm.data( pl(plIdx) )=3;
end
pm.draw(gca);

%% playing with hexaginal lattice

figure(1)
clf
axes

hl= HexagonalLattice;
hl. baseSize= [9 9];
hl. size= [7 7];
hl. colors= [1 0 0
    0 1 0
    0 0 1];
hl.data= randi(3, hl. baseSize.* hl. size );
hl.data(:)=1;
for k=1:9,
    hl.data( k, floor(k/2)+(1:9) )= 3;
end
% hl.data( 2, 1+(1:9))= 3;
% hl.data( 3, 1+(1:9))= 3;
% hl.data( 4, 2+(1:9))= 3;
hl. draw( gca)
axis off

%%

%load D:\Users\mikle\boxSync\OrderPerception\WallpaperGroup\images\groupPM_data.mat
pm= groupPM();
figure(1)
clf
axes

imIdx= 1;

for betaIdx= 1:numel(beta),
    pm.data= createTextures.unpackImg4Clrs( imgData(:, betaIdx, imIdx).', dataSize );
    pm. draw( gca )
    title( sprintf( '%3f, %d', beta(betaIdx), imIdx ) )
    drawnow
end


%% test for group cm

cm= groupCM();
cm.data(:)=1;

figure(2)
clf
axes

for k1=0:10,
    for k2=0:10
        cm.data(:)=1;
        idx= cm.getCellInd( [k1,k2]);
        cm.data( idx )= 2;
        cm.draw( gca )
        pause
    end
end


cm.draw( gca )
cm. colorCells()

%[xPos, yPos]=cm.getCellSub( [0 0] );

%% test for cm group

clear all
cm= groupCM();

figure(2)
clf
axes
axis off

gs= GibbsSampler2();
cm.data= randi(3, size( cm.data) );
cm.draw( gca )
gs.dataClass= cm;
%%
for beta= linspace(1, 0, 100 ),
    ir= cm.getInteractionRules( beta );
    gs. createGroups( ir );
    
    
    % %
    % cm.data(:)=1;
    % cm. colorCells()
    % cm.clearCells()
    cm.data= randi(3, size( cm.data) );
    for k=1:3,
        cm.data= randi(3, size( cm.data) );
        gs. sample(300);
        cm.draw( gca )
        %     hh= patch( [0.5 7.5 7.5 0.5], [0.5 4.5 12.5 8.5], 'k', 'FaceColor', 'none', 'linewidth', 2 );
        %     hh= patch( [0.5 7.5 7.5 0.5], 8+[0.5 4.5 12.5 8.5], 'k', 'FaceColor', 'none', 'linewidth', 2 );
        title(sprintf('\\beta=%.3f, %d', beta, k));
        %pause(1)
        drawnow
    end
end


%% test for cmm group

figure(2)
clf
axes
axis off

clear all
cmm= groupCMM();


gs= GibbsSampler2();
cmm.data= randi(3, size( cmm.data) );
cmm.draw( gca )
gs.dataClass= cmm;
%%
for beta= 1;%linspace(1, 0, 100 ),
    ir= cmm.getInteractionRules( beta );
    gs. createGroups( ir );
    
    
    % %
    % cmm.data(:)=1;
    %cmm. colorCells()
    % cmm.clearCells()
    %cmm.data= randi(3, size( cmm.data) );
    cmm. fillRandomPerfect(  )
    for k=1:3,
        cmm. fillRandomPerfect(  )
        %cmm.data= randi(3, size( cmm.data) );
        gs. sample(300);
        cmm.draw( gca )
        %     hh= patch( [0.5 7.5 7.5 0.5], [0.5 4.5 12.5 8.5], 'k', 'FaceColor', 'none', 'linewidth', 2 );
        %     hh= patch( [0.5 7.5 7.5 0.5], 8+[0.5 4.5 12.5 8.5], 'k', 'FaceColor', 'none', 'linewidth', 2 );
        title(sprintf('\\beta=%.3f, %d', beta, k));
        pause(1)
        drawnow
    end
end

%% create temperature array
figure(3)
bIds= round( linspace( 378, 411, 10));
clf
    p31m= groupP31M();    
for k=1:10,
    %subplot(2,5,k)
    data= createTextures.unpackImg4Clrs( imgData(:,bIds(k),1)', dataSize );    
    p31m.data= data;
    p31m.draw( gca )
pause
end

%% stim presentation

subplot(221)
     p31m= groupP31M();    
    p31m.data= data;
    p31m.draw( gca )
 for k=2:4,
    subplot( 2,2,k)
     p31m= groupP31M();    
     p31m.data(:)= data(randperm(numel(data)));
    p31m.draw( gca )    
 end
 

%% test for group p1

cm= groupP1();
cm.data(:)=1;

figure(2)
clf
axes

% for k1=0:10,
%     for k2=0:10
%         cm.data(:)=1;
%         idx= cm.getCellInd( [k1,k2]);
%         cm.data( idx )= 2;
%         cm.draw( gca )
%         %pause
%     end
% end

[xPos, yPos]= cm. getCellSub( [0 0] )
cm.draw( gca )
cm. colorCells()


%% test for p1 group

figure(2)
clf
axes
axis off

clear all
cmm= groupP1();


gs= GibbsSampler2();
cmm.data= randi(3, size( cmm.data) );
cmm.draw( gca )
gs.dataClass= cmm;
%%
for beta= 1;%linspace(1, 0, 100 ),
    ir= cmm.getInteractionRules( beta );
    gs. createGroups( ir );
    
    
    % %
    % cmm.data(:)=1;
    %cmm. colorCells()
    % cmm.clearCells()
    cmm.data= randi(3, size( cmm.data) );
    %cmm. fillRandomPerfect(  )
    for k=1:3,
        %cmm. fillRandomPerfect(  )
        cmm.data= randi(3, size( cmm.data) );
        gs. sample(300);
        cmm.draw( gca )
        %     hh= patch( [0.5 7.5 7.5 0.5], [0.5 4.5 12.5 8.5], 'k', 'FaceColor', 'none', 'linewidth', 2 );
        %     hh= patch( [0.5 7.5 7.5 0.5], 8+[0.5 4.5 12.5 8.5], 'k', 'FaceColor', 'none', 'linewidth', 2 );
        title(sprintf('\\beta=%.3f, %d', beta, k));
        pause(1)
        drawnow
    end
end
%% test for p2 group

figure(2)
clf
axes
axis off

clear all
cmm= groupP2();


gs= GibbsSampler2();
cmm.data= randi(3, size( cmm.data) );
cmm.draw( gca )
gs.dataClass= cmm;
%%
for beta= linspace(1, 0, 100 ),
    ir= cmm.getInteractionRules( beta );
    gs. createGroups( ir );
    
    
    % %
    % cmm.data(:)=1;
    %cmm. colorCells()
    % cmm.clearCells()
    cmm.data= randi(3, size( cmm.data) );
    %cmm. fillRandomPerfect(  )
    for k=1:3,
        %cmm. fillRandomPerfect(  )
        cmm.data= randi(3, size( cmm.data) );
        gs. sample(300);
        cmm.draw( gca )
        %     hh= patch( [0.5 7.5 7.5 0.5], [0.5 4.5 12.5 8.5], 'k', 'FaceColor', 'none', 'linewidth', 2 );
        %     hh= patch( [0.5 7.5 7.5 0.5], 8+[0.5 4.5 12.5 8.5], 'k', 'FaceColor', 'none', 'linewidth', 2 );
        title(sprintf('\\beta=%.3f, %d', beta, k));
        pause(1)
        drawnow
    end
end


