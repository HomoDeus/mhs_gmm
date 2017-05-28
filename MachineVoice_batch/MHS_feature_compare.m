function match= MHS_feature_compare(testing_data1,mhs_file)
No_of_Gaussians=12;  %the number of Gaussian Mixtures which will be used in modeling
%no_coeff=[1];
%no_coeff=[5:12];     


load(mhs_file);

Fs=96000;


sz=floor(size(testing_data1,1)/2048);
fe=zeros(0,25);


for k=0:sz-1
fe=[mhs(testing_data1(1+2048*k:2048+2048*k,:),96000);fe];   
disp({'extracted mhs' k+1});
end

%testing_features1=mhs(testing_data1,96000');

max=-100e+10;

% fea cell array holds the features of the persons
f=statusbar('Comparing');
for i=1:no_of_fe
 f=statusbar((i/no_of_fe),f);
    mu_t =fea{i,1};
    sigma_t=fea{i,2};
    c_t=fea{i,3};

[lYM,lY]=lmultigauss(fe(:,2:25)', mu_t,sigma_t,c_t);
maxv(i)=mean(lY);

end
match=maxv;
 delete(statusbar);