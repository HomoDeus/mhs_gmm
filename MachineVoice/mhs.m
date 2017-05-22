function c=mhs(data,fs)
%mhs Calculate the mhs of a signal C=(S,FS)
[M1,M2]=size(data);%�ж������ĸ�ʽ�Ƿ�Ϊ˫ͨ��
if M2==2
    data=data(:,1);
end
%��ѡ���ͨ�����ݽ��в�����ת�� ͳһת��Ϊ8KHz������ 
if fs~=8000
data=resample(data,8000,fs);
end

len=4000;%4000��500ms��8000��1s
%data=data(5001:9000);

vector=zeros(1,25);
l=length(data);
num=floor(l/len);


for n=1:num     %������ȫ����ȡ������������ƽ��

da=data(1+(n-1)*len:n*len);%ȡ500ms���ȵ���������������������ȡ ʵ��ʶ��ʱ��ÿ����ȡͬ�����ȵ��źŽ���ʶ��

% figure(1);
% plot(data);
% title('�ź�ʱ����');
% xlabel('����');
% ylabel('����')

%%%%%��������packeg emd���������HHT�������Բ�ͬ�źŽ���EMD����ʾ�����źź�ʱƵͼ������

imf=emd(da);
% emd_visu(data,1:4000,imf,2);%��ʾ�ֽ��ĸ������ź�

%YD�����������������ʾ��������ģ̬�ֽ�����õĸ�������ģ̬�����Ͳ����źţ��Լ��������ؽ����źš�
%%-This procedure is used to show through after EMD from various intrinsic mode function and the residual signal, 
%  as well as the reconstruction of the signal from them.

% Es=sum(abs(da.^2));
% for n=1:5
% E_imf(n)=sum(abs(imf(n,:).^2))/Es;%�����߶ȹ�һ��
% end
% figure(3)
% stem(E_imf);%������ά��������ͼ
% title('�ź�EMD������������');

%%�������HHTʱƵ���������ñ߼�����ȡά��������
%��ʾHHT��
[A,f,tt]=hhspectrum(imf);
[im,tt]=toimage(A,f,tt);

% disp_hhs(im);
% title('�ź�HHT��');

%%%%%%%%%��ʱƵͼ�Ͽ�����ͬ�źŵ�������Ҫ�ֲ��Ϲ�һ��Ƶ�ʵ�һ�������ڡ�
%%�߼��׼��㡢��ʾ���������������� ���洢Ϊ.mat ��ʶ�����
[A,fa,tt]=hhspectrum(imf);
[E,tt1]=toimage(A,fa,tt);
bjp=zeros(1,size(E,1));

for k=1:size(E,1);
bjp(k)=sum(E(k,:)); 
end
bjp=bjp/(max(bjp));%��һ���߶�

% figure;
% plot(bjp);
% title('�źű߼���');

%���˼���������������ʱƵͼ�Ƕ�Ӧ�ģ�ע�����߼��׵�����

g=1;
for i=1:2:50%�۲�߼��ף��ɷ���1��50���ҵ�Ƶ�ʷ�Χ���������ұ仯�����䣬Ҳ�������ḻ���ڵ����䣬���Ϊ������㣬��ÿ�ε���2������������
    vector(g)=sum(bjp(i:i+2))+vector(g);
    g=g+1;
end

end

c=vector/max(vector);%�����߶ȹ�һ��

end


