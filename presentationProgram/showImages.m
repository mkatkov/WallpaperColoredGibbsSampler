% showImages
%
%
addpath( '../WallpaperGroup/StimulusGenerator/' )

groupNames= { 'P1', 'P2', 'CM', 'CMM', ...
                'PM', 'PG', 'PMM', 'PMG', 'P4', ...
                'PGG', 'P4M', 'P4G', 'P3', 'P3M1', ...
                'P31M', 'P6','P6M'  };
%data= load( '../WallpaperGroup/images3/image_0_1' );
%data= load( '../WallpaperGroup/images/groupP31M_data' );
groupName= groupNames{end};
data= load( sprintf( '../WallpaperGroup/images2/group%s_images_', groupName ) );
%data= load( sprintf( '../WallpaperGroup/images/group%s_data', groupName ) );
gr= eval( sprintf( 'group%s()', groupName ) );
%gr.colors= [0.8 0 0; 0 0 1; 1 1 0];

%%
figure(1)

for k=1:size( data. imgData, 2 )%:-1:1,
    %%
    %gr= eval( sprintf( 'group%s()', data. groupName{ k } ) );
    %gr.data= createTexturesCluster2.unpackImg4Clrs( data.imgData{k}, data.imgSize(:,k)' );
    gr.data= createTexturesCluster2.unpackImg4Clrs( data.imgData(:,k,2)', data.dataSize );
    gr.draw(gca)
    %gr.colorCells();
    %title( sprintf('%s %d, %d, %d, %d, %d, %d',data. groupName{ k }, data.betas{k}))
    title( sprintf('%s %.3f',groupName, data.beta(k)))
    set(gca, 'Position', [ 0.00    0.010    1    0.95] )
    drawnow()
    pause
    %print( '-dtiff', sprintf( 'imagesForVSS2\\i%03d.tiff', k ) ); 
    %pause
    %%
%     pause(1)
end

