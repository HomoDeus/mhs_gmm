function c=mhs(data,fs)
%mhs Calculate the mhs of a signal C=(S,FS)
[M1,M2]=size(data);%判断语音的格式是否为双通道
if M2==2
    data=data(:,1);
end
%对选择的通道数据进行采样率转换 统一转换为8KHz采样率 
if fs~=8000
data=resample(data,8000,fs);
end

len=4000;%4000即500ms，8000即1s
%data=data(5001:9000);

vector=zeros(1,25);
l=length(data);
num=floor(l/len);


for n=1:num     %对数据全部提取特征并最终求平均

da=data(1+(n-1)*len:n*len);%取500ms长度的声音进行特征分析与提取 实际识别时，每次亦取同样长度的信号进行识别

% figure(1);
% plot(data);
% title('信号时域波形');
% xlabel('采样');
% ylabel('幅度')

%%%%%下面利用packeg emd工具箱进行HHT分析，对不同信号进行EMD，显示分量信号和时频图供分析

imf=emd(da);
% emd_visu(data,1:4000,imf,2);%显示分解后的各分量信号

%YD：这个程序是用来显示经过经验模态分解后所得的各个固有模态函数和残余信号，以及由它们重建的信号。
%%-This procedure is used to show through after EMD from various intrinsic mode function and the residual signal, 
%  as well as the reconstruction of the signal from them.

% Es=sum(abs(da.^2));
% for n=1:5
% E_imf(n)=sum(abs(imf(n,:).^2))/Es;%特征尺度归一化
% end
% figure(3)
% stem(E_imf);%画出该维特征向量图
% title('信号EMD分量特征向量');

%%下面基于HHT时频分析，利用边际谱提取维特征向量
%显示HHT谱
[A,f,tt]=hhspectrum(imf);
[im,tt]=toimage(A,f,tt);

% disp_hhs(im);
% title('信号HHT谱');

%%%%%%%%%从时频图上看，不同信号的能量主要分布上归一化频率的一定区间内。
%%边际谱计算、显示、及特征向量生成 并存储为.mat 供识别调用
[A,fa,tt]=hhspectrum(imf);
[E,tt1]=toimage(A,fa,tt);
bjp=zeros(1,size(E,1));

for k=1:size(E,1);
bjp(k)=sum(E(k,:)); 
end
bjp=bjp/(max(bjp));%归一化尺度

% figure;
% plot(bjp);
% title('信号边际谱');

%依此计算特征向量，与时频图是对应的，注意理解边际谱的意义

g=1;
for i=1:2:50%观察边际谱，可发现1到50左右的频率范围是能量剧烈变化的区间，也是特征丰富存在的区间，因此为方便计算，且每次递增2点来计算特征
    vector(g)=sum(bjp(i:i+2))+vector(g);
    g=g+1;
end

end

c=vector/max(vector);%特征尺度归一化

end


