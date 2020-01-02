centers = 0;
% Loop through all frames in the folder
for k = 1:48
   jpgFilename = strcat("Driving ", num2str(k), '.jpg');
   imageData = imread(jpgFilename);
   imshow(imageData);
   % Find and highlight circles
   if k < 43
       % The first two signs repsond better to dark object polarity
       [centers,radii] = imfindcircles(imageData,[50,110],'ObjectPolarity','dark','Sensitivity',0.9);
   else 
       % The last sign repsonds better to bright object polarity
       [centers,radii] = imfindcircles(imageData,[50,110],'ObjectPolarity','bright','Sensitivity',0.9);
   end
   h = viscircles(centers,radii);
   pause(0.25);
   % If a circle is found
   if centers ~= 0
       % Crop image
       I = imcrop(imageData, [centers(1)-radii centers(2)-radii radii*2 radii*2]);
       if k == 11
           I = imcrop(I, [radii*0.49 radii*0.38 radii*0.994 radii*0.9]);
       else
           I = imcrop(I, [radii*0.49 radii*0.49 radii*0.994 radii*0.9]);
       end
       % RGB to Gray filter 
       I = rgb2gray(I);
       % Sharpen Filter
       I = imsharpen(I, 'Amount', 0.9);
       % Binarization Filter
       I = imbinarize(I,'adaptive','ForegroundPolarity','dark','Sensitivity',0.55);
       % Remove indivual spots of noise
       I = bwmorph(I, 'clean');
       % Fill adjoining broken lines
       I = bwmorph(I, 'fill');
       % Optical Character Recognition
       IocrResults = ocr(I,'CharacterSet','0123456789','TextLayout','word');
       recognizedText = IocrResults.Text;
       figure;
       imshow(I);
       % Display recognized text
       text(-50, 0, recognizedText, 'BackgroundColor', [1 1 1]);
       pause(5);
  end
   centers = 0;
end