A set of MATLAB(C) scripts to generate noisy Wallpaper group images.

This code acompanying a publication, 

Images are generated by the Gibbs sampler, so this is very slow process. 
For fast start one can download generated images form https://osf.io/84mvb/ (~2Gb, DOI: 10.17605/OSF.IO/84MVB )
and put 2 folders "images" and "images2" inside "WallpaperGroup" folder.
Open MATLAB(C) and go to "presentationProgram" folder inside MATLAB(C). Close all figure windows and run "showImages.m". The script will present images. To advance to the next image ane needs to press any key.

To generate new set of images use "createTextures.m" from "WallpaperGroup/StimulusGenerator". First, edit line 10 ("fname=..."), specifying where you want to store images, and initial parameters below this line. Then run "createTexture.doIt()". This is very-very slow process. The main parameter is the range of inverse temperatures, line 17. ("data.beta=...")
