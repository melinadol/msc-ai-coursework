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
% create matrix from data_file
fid = fopen('WINE.TXT');
junk = fgetl(fid);
junk = fscanf(fid,'%s',1);
nin = fscanf(fid,'%d',1); %nin = number of inputs
junk = fscanf(fid,'%s',1);
nout = fscanf(fid,'%d',1); %nout = number of outputs
junk = fscanf(fid,'%s',1);
nrpat = fscanf(fid,'%d',1); %nrpat = number of patterns
A = fscanf(fid,'%f',[nin+nout,Inf]); %A = [I/O pairs]
fclose(fid);
tic;
x = A(1:nin,:); %x = input patterns as column vectors
d = A(nin+1:nin+nout,:); %d = desired output vectors
s=0.6;
valpats=floor(20/100*(nrpat))+1;
testpats=floor(10/100*(nrpat))+1;
trpats=nrpat-valpats-testpats;

ppc=2; % aargotera na to bazei o xristis [1,2 or 5] prototypes per category
epochs=10; % aargotera na to bazei o xristis [5,10 or 15] 
ka=0.01; % aargotera na to bazei o xristis [0.01,0.1]

a0=0.5;
idx=randperm(nrpat);
x=x(:,idx);
d=d(:,idx);
W=zeros(nin,nout*ppc); %sinaptika vari
COUNT=0;
sumW=zeros(nin,nout*ppc);;
L=[];%labels for each charecteristic of the 3 classes
k=1;
for i=1:ppc
    L=[L,[1,2,3]];
end
cvtr1=zeros(epochs,10);
cvval1=zeros(epochs,10);
cvtest1=zeros(epochs,10);
for i=1:10    
%     find indexes for each one of the  10 cross-validation. 
%     we keep the indexes so we will have the positions of the data, in
%     case we need them later for visualization
    idxtr(i,:)=mod((i-1)*testpats:(i-1)*testpats+(trpats-1),nrpat)+1;
    idxval(i,:)=mod(idxtr(i,trpats):idxtr(i,trpats)+(valpats-1),nrpat)+1; 
    idxtest(i,:)=mod(idxval(i,valpats):idxval(i,valpats)+(testpats-1),nrpat)+1;

    Ptr=x(:,idxtr(i,:));
    Pval=x(:,idxval(i,:));
    Ptest=x(:,idxtest(i,:));

    dtr=d(:,idxtr(i,:));
    dval=d(:,idxval(i,:));
    dtest=d(:,idxtest(i,:));
    tr_lab=vec2ind(dtr);
    val_lab=vec2ind(dval);
    test_lab=vec2ind(dtest);
%  arxikopoiisi Wc(:,c) c[1:ppc]
 nn=ppc*nout; 
 
 for c=1:nn

     
     %bres training pattern with the same label
     while tr_lab(k)~=L(c)
         k=mod(k+1,trpats);
         if k==0
             k=trpats;
         end
     end
     
     W(:,c)=Ptr(:,k);
     Wlab(:,c)=tr_lab(c);
     k=mod(k,trpats);
     if k==0
         k=trpats;
     end
     
 end
 for ep=1:epochs
     
     for it=1:trpats
         trcount=0;
         vcount=0;
         tecount=0;
         % to a allazei meta apo kathe emfanisi
         t=(ep-1)*trpats+it-1;
         at=a0/(1+ka*t); %prosarmostiko kentro kathe epanalipsis
         ki=mod(t,trpats);%.... deiktis sto  Ptr
         if ki==0
             ki=trpats; %debagging
         end  
         eukldis=vecnorm(W-Ptr(:,ki), 2, 1); %duplicate  of distances to find dist1,dist2 min values easily
        
         distances=eukldis; %DUPLICATE
         [mindist,idx1]=min(eukldis);

         if L(idx1) ~= tr_lab(ki) %Wlab(idx1) wrong class            
                     W(:,idx1)=W(:,idx1)-at*(Ptr(:,ki)-W(:,idx1));  %vector for the incorrect category           
         end % 1st CRITERIA ARE TRUE Lfm IS LEARNING
         
         for s=1:size(W,2)
             [mindist2,idx2]=min(distances);
             if L(idx2) == tr_lab(ki)
                 
                 W(:,idx2)=W(:,idx2)+at*(Ptr(:,ki)-W(:,idx2));  %vector for the correct category
                 break
             else
                 distances(idx2)=inf;
             end
         
         end

         for ii=1:trpats
         trdist=vecnorm(W-Ptr(:,ii), 2, 1);
         [dist,p]=min(trdist);
         if tr_lab(ii)==L(p)
             trcount=trcount+1;
         end
        end
        cvtr1(ep,i)=trcount;
        cvtr=cvtr1./124;
        epcvtr=mean(cvtr, 2);

        for ii=1:valpats
         vdist=vecnorm(W-Pval(:,ii), 2, 1);
         [dist,p]=min(vdist);
         if val_lab(ii)==L(p)
             vcount=vcount+1;
         end
        end
        cvval1(ep,i)=vcount;
        cvval=cvval1/valpats;
        epcvval=mean(cvval, 2);

        for ii=1:testpats
         testdis=vecnorm(W-Ptest(:,ii), 2, 1);
         [dist,p]=min(testdis);
         if  test_lab(ii)==L(p)
             tecount=tecount+1;
         end
        end
        cvtest1(ep,i)=tecount;
        cvtest=cvtest1/testpats;
        epcvtest=mean(cvtest, 2);

     end
sumW=sumW+W;
COUNT=COUNT+1;
 end
end
toc;
% plot the diagram
figure(1)
plot([1:epochs],epcvtr)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% add labels for the x- and y-axes
xlabel('Epochs')
ylabel('CV-training values')
title('Accuracy of every epoch in Training data')
sumW=sumW/COUNT;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(2)
plot([1:epochs],epcvval )

% add labels for the x- and y-axes
xlabel('Epochs')
ylabel('CV-validation values')
title('Accuracy of every epoch in Validation data')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(3)
plot([1:epochs],epcvtest)
% add labels for the x- and y-axes
xlabel('Epochs')
ylabel('CV-test data set')
title('Accuracy of every epoch in Test data set')

fprintf('Number of epochs: %i, Number of patterns per category: %i, Rate of Learning: %f\n',epochs, ppc, ka);

fprintf('Accuracy Results on training set:\n');
disp(mean(epcvtr));
fprintf('Accuracy Results on validation set:\n ');
disp(mean(epcvval));
fprintf('Accuracy Results on test set:\n');
disp(mean(epcvtest));