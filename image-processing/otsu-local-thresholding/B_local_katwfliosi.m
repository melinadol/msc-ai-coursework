% % sudoku.jpg
% % cameraman.tif
% % image.jpg
% % tool.png
% % coins.png
% %lena_gray.tif
% % sonet.jpg



% clean Command window
clc; 
% clear all variables from memory
clear;
% close any open figures
close all;
% use a compact format in Command Window
format compact;
dbstop if error;
dbstop if warning;

c=input('Δώσε τιμή σταθεράς C= '); 
while c<0
    c=input('Λάθος καταχώρηση, Δώσε μη αρνητική τιμή σταθεράς C= '); 
end 

% define an image filename
Filename='image.jpg';
InfoData=imfinfo(Filename);
% read the image
I=imread(Filename);
[R,C,~]=size(I);
% show the image
% apply the gray colormap
subplot(1,3,1);imshow(I); colormap(gray(256)); 
title('Original');
tic;
%% lets make a window size 3x3 
rw=30;
cw=30;

diastI=(floor(R/rw)*rw+rw)-R;
diastJ=(floor(C/cw)*cw+cw)-C;

Iper=padarray(I,[diastI,diastJ],'replicate','post');
Iper=padarray(Iper,[rw,cw],'replicate','pre');
%Iv=im2col(Iper,[rw,cw]);
[rp,cp]=size(Iper);


% eikonaI=metasximatismenieikona-C
% Η σταθερά 𝐶 έχει 0 ή θετική τιμή. 
% Για τιμές πχ. 5 ή 10 βελτιώνει τα αποτελέσματα σε περιοχές της εικόνας με ομοιογενή φωτεινότητα
% Ivec=zeros(rw*cw,R*C);
Iw=inf(rw,cw);
countig=1;
k=floor(rw/2)+1;
Igmean=zeros(rp,cp);
Igmed=zeros(rp,cp);
Igmesos=zeros(rp,cp);
ak=38;     %katwfli antithesis
for i=rw+1:rp-(diastI+rw)
    for j=cw+1:cp-(diastJ+cw)
        Iw=Iper(i-k+1:i+k-1,j-k+1:j+k-1);
        Ivec=reshape(Iw,[],1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% mean
        meanT=mean(Ivec(:,1))-c;
        
        if (Iper(i,j)<=meanT)|(meanT<=0)
            Igmean(i,j)=0;
        else
            Igmean(i,j)=256;    
        end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% median
        medT=median(Ivec(:,1))-c;
        if (Iper(i,j)<=medT)|(medT<=0)
            Igmed(i,j)=0;
        else
            Igmed(i,j)=256;    
       end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% endiamesos
        mesosT=(max(Ivec(:,1))+min(Ivec(:,1)))/2-c;
        if (Iper(i,j)<=mesosT)|(mesosT<=0)
            Igmesos(i,j)=0;
        else
            Igmesos(i,j)=256;    
        end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%           
     end 
 end           
toc; 

 % set orthonormal axes
axis image;
subplot(1,3,2);
imshow(Igmean);
title('Adaptive thres-mean');  

axis image;
subplot(1,3,3);
imshow(Igmed);
title('Adaptive thres-median'); 

% axis image;
% subplot(1,3,3);
% imshow(Igmesos);
% title('Bersen Method'); 

imwrite(Igmean,'mean.png');
imwrite(Igmed,'median.png');
imwrite(Igmesos,'mesos.png');
