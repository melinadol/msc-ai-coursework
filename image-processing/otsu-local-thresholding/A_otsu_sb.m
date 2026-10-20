
% sudoku.jpg
% cameraman.tif
% image.jpg
% tool.png
% coins.png
%lena_gray.tif
% sonet.jpg


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

% define an image filename
Filename='sonet.jpg';
InfoData=imfinfo(Filename);
% read the image
I=imread(Filename);
% show the image
% apply the gray colormap

subplot(1,3,1);imshow(I); colormap(gray(256)); 
title('Original image');

% get the first two image dimensions (rows and columns)
%%%starting data
Ivec=I(:);
[R,C,~]=size(I);
N=R*C;
t=1;
h=Ivec;
L=zeros(256,1);
P=zeros(256,1);
for i=1:256
    if i>1
     L(i-1)=i-1;   
    else
     L(i)=i;  
    end    
end   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%create Table for the results, for every T=1...254 
W0=zeros(254,1);
W1=zeros(254,1);
M0=zeros(254,1);
M1=zeros(254,1);
S0_2=zeros(254,1);
S1_2=zeros(254,1);
SW2=zeros(254,1);
Sb2=zeros(254,1);
T=zeros(254,1);

for i=1:254
    T(i)=i;
end
Re=table(T,W0,M0,S0_2,W1,M1,S1_2,SW2,Sb2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%creating P table pithanotitas kai dimiourgia Im table me ta dedomena
for n=1:N
    for l=1:256
            if l>1
                if Ivec(n)==L(l-1)
                    P(l-1)=(P(l-1)+1);
                end
                   
            else
                if Ivec(n)==L(l)
                    P(l)=(P(l)+1);
                end
                    
            end  
 
    end
end
%P(:)=P(:)/N; %for pdf
Im=table(L,P,'VariableNames',{'L Graylevels','P(i)'});
%%dialegontas to  prwto threshold me timi diafori toy midenos, diladi eparkes
%%count simeiwn sto histogram
for i=1:254
    if P(i)~=0
        thres=i;
        break
    end 
end
SB=0;
i_SB=0;

%gia T=thres, ginontai ta exis :
for jj=thres:254
   
    
    c0=thres-1;
    c1=254-thres;
    i_Pi0=0;%zeros(c0,1);
    i_Pi1=0;%zeros(c1,1);
    w0=0;
    w1=0;
    s0_2=0;
    s1_2=0;
    for i=1:254
        if i<=thres
            w0=P(i)+w0;
            i_Pi0=i*P(i)+i_Pi0;
        else
            w1=P(i)+w1;
            i_Pi1=i*P(i)+i_Pi1;
        end
    end
    m0=1/w0*i_Pi0;
    m1=1/w1*i_Pi1;

    for i=1:254
        if i<=thres
            s0_2=(i-m0)^2*P(i);
        else
            s1_2=(i-m1)^2*P(i);
        end
    end
    s0_2=1/w0*s0_2;
    s1_2=1/w1*s1_2;
    m=w0*m0+w1*m1;
    sw2=w0*s0_2+w1*s1_2;
    sb2=w0*w1*(m0-m1)^2;
    s=sw2+sb2;
    if isnan(sb2)
        sb2=0;
    end
    
    Re(thres,'W0')=array2table(w0);
    Re(thres,'M0')=array2table(m0);
    Re(thres,'S0_2')=array2table(s0_2);
    Re(thres,'W1')=array2table(w1);
    Re(thres,'M1')=array2table(m1);
    Re(thres,'S1_2')=array2table(s1_2);
    Re(thres,'SW2')=array2table(sw2);
    Re(thres,'Sb2')=array2table(sb2);

    thres=thres+1;


end
% find min of Sw values. There is the threshold im looking for.
max_sb=max(Re{:,'Sb2'})
THRESHOLD=find(Re{:,'Sb2'}==max_sb)
Ig=zeros(R,C);
for r=1:R
    for c=1:C
        if I(r,c)<=THRESHOLD
            Ig(r,c)=0;
        else
            Ig(r,c)=256;    
        end
    end
 end

% set orthonormal axes
axis image;
subplot(1,3,2);
imshow(Ig);
title('Otsu method-binary image');

% remove the x- and y- axis auto numbering

subplot(1,3,3);histogram(I); title('Histogram'); 
line([THRESHOLD, THRESHOLD], ylim, 'LineWidth', 2, 'Color', 'r');






