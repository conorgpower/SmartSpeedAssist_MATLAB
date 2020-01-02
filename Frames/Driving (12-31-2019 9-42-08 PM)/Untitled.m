jpgFilename = strcat('highQualitySign.png');
I = imread(jpgFilename);
imshow(I);
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