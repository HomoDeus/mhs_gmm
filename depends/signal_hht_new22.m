

clc;
clear all;
close all;

%%%%%��ȡ�������� .wav��16λ��˫ͨ�����ɣ�����ʱ��Ҫѡ��ĳһͨ������

[filename, pathname] = uigetfile({'*.wav;*.WAV','ѡ����Ƶ����';...
          '*.WAV','All Files' });
fl =[ pathname,filename];



[data,fs,nbits]=wavread(fl);
[M1,M2]=size(data);%�ж������ĸ�ʽ�Ƿ�Ϊ˫ͨ����M1*M2�ľ���
if M2==2
data=data(:,1);
end
%��ѡ���ͨ�����ݽ��в�����ת����ͳһת��Ϊ8KHz������ 
if fs~=8000;
data=resample(data,8000,fs);
end

data=data(5001:9000);%ȡ500ms���ȵ���������������������ȡ��ʵ��ʶ��ʱ��ÿ����ȡͬ�����ȵ��źŽ���ʶ��
% YD��1S�ڲ�������Ϊ8000������ô500ms�Ĳ�������Ϊ4000��������ȡ���ǵ�5001����9000�����������ݣ�

figure(1);
plot(data);
title('�ź�ʱ����');
xlabel('����');
ylabel('����')

%%��������packeg emd���������HHT����

imf=emd(data);
emd_visu(data,1:4000,imf,2);%��ʾ�ֽ��ĸ������ź�

% YD�����������������ʾ��������ģ̬�ֽ�����õĸ�������ģ̬�����Ͳ����źţ��Լ��������ؽ����źš�
%%-This procedure is used to show through after EMD from various intrinsic mode function and the residual signal, as well as the reconstruction of the signal from them.



%�������HHTʱƵ���������ñ߼�����ȡά��������
%��ʾHHT��
[A,f,tt]=hhspectrum(imf);
[im,tt]=toimage(A,f,tt);

disp_hhs(im);
title('�ź�HHT��');

%%%��ʱƵͼ�Ͽ��������źŵ�������Ҫ�ֲ��ڹ�һ��Ƶ�ʵ�һ��������
%%�߼��׼��㡢��ʾ���������������ɣ����洢Ϊ.mat ��ʶ�����
[A,fa,tt]=hhspectrum(imf);
[E,tt1]=toimage(A,fa,tt);
bjp=zeros(1,size(E,1));

for k=1:size(E,1);
bjp(k)=sum(E(k,:)); 
end
bjp=bjp/(max(bjp));%��һ���߶�

figure;
plot(bjp);
title('�źű߼���');

%�������˼�����������������ʱƵͼ�Ƕ�Ӧ�ģ�ע�����߼��׵�����
vector=zeros(1,25);
g=1;
for i=1:2:50%�۲�߼��ף��ɷ���1��50���ҵ�Ƶ�ʷ�Χ���������ұ仯�����䣬Ҳ�������ḻ���ڵ����䣬���Ϊ������㣬��ÿ�ε���2������������
    vector(g)=sum(bjp(i:i+2));
    g=g+1;
end
vector=vector/max(vector);%�����߶ȹ�һ��
figure;
stem(vector);
title('�߼�����������')
%%%�߼�����������
bjpvec=vector;




















