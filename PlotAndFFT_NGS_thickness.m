%Set parameters for files that need to be loaded
 basefolder = 'D:\BASOV\NiGa2S4\210301\Analysis';
 addpath 'D:\BASOV\Matlab scripts';

 %freqs=[770,780,790,800,820,830,850,860,870,880,890,900,910,920,930,940];
 % the first few samples to take are, S1-96 nm; S2-20nm; S8-40nm;
 % S12-200nm; S13-155nm; S14-72nm
 
 
 thicks=[20,40,72,96,155,200];
 thetas=[-6, -12, -41,-38,-45,12];
 flakeNum=["S2","S8","S14","S1","S13","S12"];
 
 
%dataName='210209_NGS_S2_%03dnm';
 dataName='NGS_%s_790nm_10x3um_%dnm'; 

   
%energies=1240./freqs; %if I want to convert to the energy for comparison

%% Load Data and plot NF signal

    %%Create the figure name
    %figName = sprintf('S2 %03d nm, %0.2f eV',freqs(j),energies(j));
    %figure('Name',figName)
    figNameS2 = sprintf('S2 for 790nm light'); 
    figNameS3 = sprintf('S3 for 790nm light');
    figNameS4 = sprintf('S4 for 790nm light');
    
    figure('Name',figNameS2); p=tiledlayout('flow');
    figure('Name',figNameS3); q=tiledlayout('flow');
    figure('Name',figNameS4); r=tiledlayout('flow');

for j=1:length(thicks)
    

    fileName=sprintf(dataName,flakeNum(j),thicks(j)); %combine the 'dataName' and 
    %replacing the "%d" with the corresponding frequency (if it is w/ multiple freqs)
    %here we are looping through all frequencies
    %if we want to specify 3 numbers to replace,replace %d with %03d
    %eg if we want 80nm to be 080nm
    
    
    %%Assign each set of data to an array/variable
    %load in file, appending 'O2A' to the file name
    %the function sp_load_file_for_script adds 
    %filepath = strcat(folder, "\", filebasename, " ", suffix, " raw.gsf");
    %P2X{j} puts the read in data into slot {j}, while x{j} and y{j}
    %store the x and y dimensions for that set of data
    %Q2X for O3, R2X for O5
    
    [P2X{j}, x{j},y{j}]=sp_load_file_for_script(basefolder,fileName,'O2A');
    [Q2X{j}, x{j},y{j}]=sp_load_file_for_script(basefolder,fileName,'O3A');
    [R2X{j}, x{j},y{j}]=sp_load_file_for_script(basefolder,fileName,'O4A');
    
    xs=x{j}*1e6;
    ys=y{j}*1e6;
    

    %%%%%%%%%%%%%Plot for S2%%%%%%%%%%%%
          
    nexttile(p)       %if this is being plotted in a tile figure; p for S2
    figName=sprintf('S2 for %dnm thick',thicks(j));
    
    %plotX=x{j};    %to get the x and y axis values for this particular
    %plotY=y{j};    %set of data   
    
    %%Remove outliers
    %get the data to plot into temporary file 'plotDat'
    %for 'spikes' set the value to 0
    plotDat=cell2mat(P2X(j));
    plotDat(plotDat>=25000)=0;
    
    %get the average of all the plot values, and for very small or very
    %large values, set them to the average value
    plotAvg=mean(plotDat,'all');
    plotDat(plotDat==0)=plotAvg;   
    plotDat(plotDat<(plotAvg/2.5))=plotAvg;

    %put this 'cleaned up' plotDat into a file for later
    P2Avg{j}=plotDat;
    
    %%Plot and display the near field signal for each set of data
    s=pcolor(xs,ys,plotDat);    %plot w/ corresponding axes but in nm
    set(s,'EdgeColor','none');      %remove the lines for the pcolor plot
    
    %xlim ([100 300]); %limits for the 1st set
    
    title(figName); %title plot
    colormap(morgenstemning);   %set colormap
    caxis([plotAvg/20, plotAvg*2.5]);   %adjust colourbar limits

    %%%%%%%%%Plot for S3%%%%%%%%%%%%%%%
    nexttile(q)
    figName=sprintf('S3 for %dnm thick',thicks(j));
    
    plotDat=cell2mat(Q2X(j));
    plotDat(plotDat>=25000)=0;    
    plotAvg=mean(plotDat,'all');
    plotDat(plotDat==0)=plotAvg;   
    plotDat(plotDat<(plotAvg/2.5))=plotAvg;
    Q2Avg{j}=plotDat;

    s=pcolor(xs,ys,plotDat);   
    set(s,'EdgeColor','none');    
    title(figName);
    colormap(morgenstemning); 
    caxis([plotAvg/20, plotAvg*2.5]);  
    
    
    %%%%%%%%%Plot for S4%%%%%%%%%%%%%%%
    nexttile(r)
    figName=sprintf('S4 for %dnm thick',thicks(j));
    
    plotDat=cell2mat(R2X(j));
    plotDat(plotDat>=25000)=0;    
    plotAvg=mean(plotDat,'all');
    plotDat(plotDat==0)=plotAvg;   
    plotDat(plotDat<(plotAvg/2.5))=plotAvg;
    R2Avg{j}=plotDat;

    s=pcolor(xs,ys,plotDat);   
    set(s,'EdgeColor','none');  
    title(figName); 
    colormap(morgenstemning); 
    caxis([plotAvg/20, plotAvg*2.5]); 
    
end
        %Get dimension of the data in the x and y direction
    xSize=size(plotDat,2); 
    ySize=size(plotDat,1);
    
    %set(gcf,'Position',[350,250,1500,600]); %put the figure in somewhere sensible
    
%% LINECUTS

%Average the line cuts to get something sensible


%we can get the line average for each one in a loop
figNameLCS2 = sprintf('Linecuts for 790nm light for S2');
figNameLCS3 = sprintf('Linecuts for 790nm light for S3');
figNameLCS4 = sprintf('Linecuts for 790nm light for S4');
figNameLCDiv = sprintf('Linecuts for 790nm light for S4/S3');
    
%figure('Name',figNameLCS2); t=tiledlayout('flow');
%figure('Name',figNameLCS3); u=tiledlayout('flow');
figure('Name',figNameLCS4); v=tiledlayout('flow');
figure('Name',figNameLCDiv); dv=tiledlayout('flow');

    %lcS2=zeros(1,xSize);
    %lcS3=zeros(length(thicks),xSize);
    %lcS4=zeros(length(thicks),xSize);
%    lcDiv=zeros(length(thicks),xSize);
    
x_maxs=[365, 315, 345, 340, 315, 350];
x_mins=x_maxs-310;

for j=1:length(thicks)
    x_max=xs(x_maxs(j));
    x_min=xs(x_mins(j));
    P2Avg;
    Q2Avg;
    R2Avg;
    
    plotDatS2=P2Avg{j}; %for S2
    plotDatS3=Q2Avg{j}; %for S3
    plotDatS4=R2Avg{j}; %for S4
    
    plotDatDiv=plotDatS4./plotDatS2;
    
    xAvgS2=zeros(1,xSize);
    xAvgS3=zeros(1,xSize);
    xAvgS4=zeros(1,xSize);
    xAvgDiv=zeros(1,xSize);



    for l=1:ySize
        
        xAvgS2=xAvgS2+plotDatS2(l,:);   %add each line cut together
        xAvgS3=xAvgS3+plotDatS3(l,:);   %add each line cut together
        xAvgS4=xAvgS4+plotDatS4(l,:);   %add each line cut together
        xAvgDiv=xAvgDiv+plotDatDiv(l,:);   %add each line cut together
    end
        
        xAvgS2=xAvgS2/ySize; %average everything
        xAvgS3=xAvgS3/ySize; %average everything
        xAvgS4=xAvgS4/ySize; %average everything
        xAvgDiv=xAvgDiv/ySize; %average everything
        
        lcS2{j}=xAvgS2;
        lcS3{j}=xAvgS3;
        lcS4{j}=xAvgS4;
        lcDiv{j}=xAvgDiv;
%         
%     nexttile(t);
%     figName=sprintf('Line cut for %dnm thick S2',thicks(j));
%     plot(x{j},xavgS2);
%     title(figName);
%     
%     nexttile(u);
%     figName=sprintf('Line cut for %dnm thick S3',thicks(j));
%     plot(xs,lcS3{j});
%     xline(x_max);xline(x_min);
%     title(figName);
%     
    nexttile(v);
    figName=sprintf('Line cut for %dnm thick S4',thicks(j));
    plot(xs,lcS4{j});
    xline(x_max);xline(x_min);
    title(figName);
    
    
    nexttile(dv);
    figName=sprintf('Line cut for %dnm thick S4/S2',thicks(j));
    plot(xs,lcDiv{j});
    xline(x_max);xline(x_min);
    title(figName);
    
end


%% Take the FFT using 'fft_and_plot.m'
%figNameFFTS3 = "FFT 790nm light (S3)";
figNameFFTS4 = "FFT 790nm light (S4)";
figNameFFTDiv = "FFT 790nm light (S4 div S2)";
    
%figure('Name',figNameFFTS3); fu=tiledlayout(3,2);
figure('Name',figNameFFTS4); fv=tiledlayout(3,2);
figure('Name',figNameFFTDiv); fdv=tiledlayout(3,2);


%title(fu,figNameFFTS3,'FontName','Helvetica','FontSize',13,'FontWeight','bold');
title(fv,figNameFFTS4,'FontName','Helvetica','FontSize',13,'FontWeight','bold');
title(fdv,figNameFFTDiv,'FontName','Helvetica','FontSize',13,'FontWeight','bold');


x_maxs=[365, 315, 345, 340, 315, 350];
x_mins=x_maxs-310;

q_obs1=[0.31 0.31 0.33 0.38 0.33 0.31];
q_obs2=[0.38 0.46 0.54 0.51 0.51 0.41]; 

 for j=1:length(thicks)    
     x_min_ind=x_mins(j);
     x_max_ind=x_maxs(j);

    x_max=xs(x_max_ind);
    x_min=xs(x_min_ind);
    x_range=x_max-x_min;
    
    
    %data_line is passed in such that it is already truncated to the x_min
    %and x_max
    
%       
%     %S3 FFT
%     nexttile(fu);
%     data_line=lcS3{j};
%     data_line=data_line(x_min_ind:x_max_ind);
%     [fft_S3{j},q_S3{j}]=fft_and_plot(data_line,x_range);  
%     q_plot=q_S3{j};
%     fft_abs_plot=abs(fft_S3{j});
%     plot((q_plot(2:60)),fft_abs_plot(2:60));
%     title(sprintf('%dnm thick',thicks(j)));
%     xlabel('µm-1'); 
%     ymax=max(fft_abs_plot(2:60));
%     ylim([0 (ymax*1.1)]);
% 
%    S4 FFT
    nexttile(fv);
    data_line=lcS4{j};
    data_line=data_line(x_min_ind:x_max_ind);
    [fft_S4{j},q_S4{j}]=fft_and_plot(data_line,x_range);  
    q_plot=q_S4{j};
    fft_abs_plot=abs(fft_S4{j});
    plot((q_plot(2:60)),fft_abs_plot(2:60));
    title(sprintf('%dnm thick',thicks(j)));
    xlabel('µm-1');
%    
    ymax=max(fft_abs_plot(2:60));
    ylim([0 (ymax*1.1)]);
%     % add arrow annotation
     
    q1_ind=find(abs(q_plot-q_obs1(j))<0.01);
    fft1=max(fft_abs_plot(q1_ind-3:q1_ind+3));
    fft1=fft1-(0.01*ymax);
    txt = ['\leftarrow q_1=' num2str(q_obs1(j))];
    q_1_txt=text(q_obs1(j)*1.05,fft1,txt,'FontSize',8,'HorizontalAlignment','left');
    
    if q_obs1(j)~=q_obs2(j)
        q2_ind=find(abs(q_plot-q_obs2(j))<0.01);
        fft2=max(fft_abs_plot(q2_ind-3:q2_ind+3));
        if fft2>fft1
            fft2=fft2-(0.01*ymax);
        else
            fft2=fft2+(0.02*ymax);
        end
        txt = ['\leftarrow q_2=' num2str(q_obs2(j))];
        q_2_txt=text(q_obs2(j)*1.05,fft2,txt,'FontSize',8,'HorizontalAlignment','left');
    end

    
% % %     
%     %S4/S2 FFT
%         %data_line is passed in such that it is already truncated to the x_min
%     %and x_max
    data_line=lcDiv{j};
    %data_line=lcS3{j}./lcS2{j};
    data_line=data_line(x_min_ind:x_max_ind);
    [fft_Div{j},q_Div{j}]=fft_and_plot(data_line,x_range);  
    
    q_plot=q_Div{j};
    fft_abs_plot=abs(fft_Div{j});
    nexttile(fdv);
    plot((q_plot(2:60)),fft_abs_plot(2:60));
    title(sprintf('%dnm thick',thicks(j)));
    xlabel('µm-1'); 
    
    ymax=max(fft_abs_plot(2:60));
    ylim([0 (ymax*1.1)]);
    % add arrow annotation
    
    q1_ind=find(abs(q_plot-q_obs1(j))<0.01);
    fft1=max(fft_abs_plot(q1_ind-3:q1_ind+3));
    fft1=fft1-(0.01*ymax);
    txt = ['\leftarrow q_1=' num2str(q_obs1(j))];
    q_1_txt=text(q_obs1(j)*1.05,fft1,txt,'FontSize',8,'HorizontalAlignment','left');
    
    if q_obs1(j)~=q_obs2(j)
        q2_ind=find(abs(q_plot-q_obs2(j))<0.01);
        fft2=max(fft_abs_plot(q2_ind-3:q2_ind+3));
        if fft2>fft1
            fft2=fft2-(0.01*ymax);
        else
            fft2=fft2+(0.02*ymax);
        end
        txt = ['\leftarrow q_2=' num2str(q_obs2(j))];
        q_2_txt=text(q_obs2(j)*1.05,fft2,txt,'FontSize',8,'HorizontalAlignment','left');
    end


    err(j)=3*(q_plot(2)-q_plot(1));
 end


%% angle correction
%q_obs0=[0.18,0, 0.2,0.4,0,0.3];
q_obs1=[0.31 0.31 0.33 0.38 0.33 0.31];
q_obs2=[0.38 0.46 0.54 0.51 0.51 0.41]; 
%[1.94778744522567,1.94778744522567,2.19911485751286,2.38761041672824,2.19911485751286,2.01061929829747]
%[2.57610597594363,2.76460153515902,3.20442450666159,3.58141562509236,3.20442450666159,2.51327412287183]
lambda0=790;

 thicks=[20,40,72,96,155,200];
 thetas=[-6, -12, -41,-38,-45,12];

 %for the observed air modes, the expected q are, at these thetas:
 

for i=1:length(q_obs1)
    [q1_ac(i),l1_ac(i),q_air(i),l_air(i)]=angle_correct2(q_obs1(i),thetas(i),lambda0);
end

for i=1:length(q_obs1)
    [q2_ac(i),l2_ac(i),q_air(i),l_air(i)]=angle_correct2(q_obs2(i),thetas(i),lambda0);
end

q_air_obs=1./(l_air*2*pi*1e-3);

fig_air=figure();
ax=gca;
hold(ax,'on');
pbaspect([6 5 1]);
set(ax,'FontSize',13,'LabelFontSizeMultiplier',1,...
    'TitleFontSizeMultiplier',1,'XColor','k','Box','on','TickDir','in');
% 
% q1_obsplot=plot(thicks,q_obs1,'o','LineWidth',1);
% q2_obsplot=plot(thicks,q_obs2,'x','LineWidth',1);

q1_obsplot=errorbar(thicks,q_obs1,err,'o','MarkerSize',7,'LineStyle','none');
q2_obsplot=errorbar(thicks,q_obs2,err,'^','MarkerSize',7,'LineStyle','none');
q_air_plot=plot(thicks,q_air_obs,'s','MarkerSize',10,'MarkerFaceColor','y','LineWidth',1);
xlim([0 210]); ylim([0.2 0.7]);
ylabel('observed q (µm-1)');
xlabel('Thickness (nm)');
legend('q1','q2','q_{air}');
title('Observed q and expected observed air mode');
hold (ax,'off');

%% Manually pick out the ones that were probably NOT air modes
% i.e. set the ones that 'match' to 0

q1_ac_sel=[0.8827 0.8802 0.001 0.001 0.001 0.8802];
q2_ac_sel=[0.001 0.9734 0.9707 0.9617 0.9430 0.9423];


fig_wv=figure();
ax=gca;
hold(ax,'on');
pbaspect([6 5 1]);
set(ax,'FontSize',13,'LabelFontSizeMultiplier',1,...
    'TitleFontSizeMultiplier',1,'XColor','k','Box','on','TickDir','in');

q1_selplot=plot(thicks,q1_ac_sel,'o','LineWidth',1);
q2_selplot=plot(thicks,q2_ac_sel,'^','LineWidth',1);

% 
% err1_scale=err'.*(q1_ac_sel./q_obs1);
% err2_scale=err'.*(q2_ac_sel./q_obs2);
% q1_selplot=errorbar(thicks,q1_ac_sel,err,'o','MarkerSize',7,'LineStyle','none');
% q2_selplot=errorbar(thicks,q2_ac_sel,err,'^','MarkerSize',7,'LineStyle','none');

% % these are from 'NGS_TEM_TE_mode.m'
wv_at_790nm_TE_div=wv_at_790nm_TE/(10e6);
wv_at_790nm_TM_div=wv_at_790nm_TM/(10e6);
TE_plot=plot(T_thicks,wv_at_790nm_TE_div,'LineWidth',1);
TM_plot=plot(T_thicks,wv_at_790nm_TM_div,'LineWidth',1);

color_order_mult={'#0072BD','#D95319','#FF0000','#0000FF'};
colororder(color_order_mult);
ylim([0.5 1.15]);
xlim([0 210]); %ylim([0.2 1.5]);
ylabel('q (µm-1)');
xlabel('Thickness (nm)');
legend('q1','q2','TE mode','TM mode');
title('Angle corrected q and air mode');


hold off;




%% Take the FFT using 'fft_and_plot.m'
% figNameFFTS3 = "FFTs for 40nm thick flake S3";
% figNameFFTS4 = "FFT for 40nm thick flake S4";
% figNameFFTDiv = "FFT 40nm thick flake S3/S2";
%     
% figure('Name',figNameFFTS3); fu=tiledlayout(4,2);
% %figure('Name',figNameFFTS4); fv=tiledlayout(4,2);
% figure('Name',figNameFFTDiv); fdv=tiledlayout(4,2);
% ignore=[890];        
% 
% title(fu,figNameFFTS3,'FontName','Helvetica','FontSize',13,'FontWeight','bold');
% %title(fv,figNameFFTS4);
% title(fdv,"FFT 40nm thick flake S3/S2",'Interpreter','none',...
%     'FontName','Helvetica','FontSize',13,'FontWeight','bold');
% 
% %the q_obs were actually picked out after the FFT was taken
% %and then manually copied here to add the arrow annotation
% q_obs1=[0.36,0.36,0.36,0.33,0.29,0.30,0.30,0.30,0.27 ];
% q_obs2=[0.72,0.72,0.69,0.47,0.42,0.42,0.39,0.39,0.39];
% 
% for j=1:length(freqs)   
%     
%         %don't show the wonky ones
% 
%     if ismember(freqs(j),ignore)
%         continue
%     end
%     
%     x_min_ind=90;
%     x_max_ind=250;
%     x_max=xs(x_max_ind);
%     x_min=xs(x_min_ind);
%     x_range=x_max-x_min;
%     
%     %data_line is passed in such that it is already truncated to the x_min
%     %and x_max
%     
% %       
% %     %S3 FFT
%     nexttile(fu);
%     data_line=lcS3{j};
%     data_line=data_line(x_min_ind:x_max_ind);
%     [fft_S3{j},q_S3{j}]=fft_and_plot(data_line,x_range);  
%     q_plot=q_S3{j};
%     fft_abs_plot=abs(fft_S3{j});
%     plot((q_plot(2:60)),fft_abs_plot(2:60));
%     title(sprintf('%03dnm (%.2feV)',freqs(j),Es(j)));
%     xlabel('µm-1'); 
%     ymax=max(fft_abs_plot(2:60));
%     ylim([0 (ymax*1.1)]);
% 
%     %S4 FFT
% %     nexttile(fv);
% %     data_line=lcS4{j};
% %     data_line=data_line(x_min_ind:x_max_ind);
% %     [fft_S4{j},q_S4{j}]=fft_and_plot(data_line,x_range);  
% %     q_plot=q_S4{j};
% %     fft_abs_plot=abs(fft_S4{j});
% %     plot((q_plot(2:60)),fft_abs_plot(2:60));
% %     title(sprintf('%03dnm (%.2feV)',freqs(j),Es(j)));
% % %     xlabel('µm-1');
% %    
% %     ymax=max(fft_abs_plot(2:60));
% %     ylim([0 (ymax*1.1)]);
% %     % add arrow annotation
% %     
% %     q1_ind=find(abs(q_plot-q_obs1(j))<0.01);
% %     fft1=fft_abs_plot(q1_ind);
% %     fft1=fft1-(0.01*ymax);
% %     txt = ['\leftarrow q_1=' num2str(q_obs1(j))];
% %     q_1_txt=text(q_obs1(j)*1.05,fft1,txt,'FontSize',8,'HorizontalAlignment','left');
% %     
% %     if q_obs1(j)~=q_obs2(j)
% %         q2_ind=find(abs(q_plot-q_obs2(j))<0.01);
% %         fft2=fft_abs_plot(q2_ind);
% %         if fft2>fft1
% %             fft2=fft2-(0.01*ymax);
% %         else
% %             fft2=fft2+(0.02*ymax);
% %         end
% %         txt = ['\leftarrow q_2=' num2str(q_obs2(j))];
% %         q_2_txt=text(q_obs2(j)*1.05,fft2,txt,'FontSize',8,'HorizontalAlignment','left');
% %     end
% %     
% % %     
%     %S3/S2 FFT
%         %data_line is passed in such that it is already truncated to the x_min
%     %and x_max
%     data_line=lcDiv{j};
%     data_line=data_line(x_min_ind:x_max_ind);
%     [fft_Div{j},q_Div{j}]=fft_and_plot(data_line,x_range);  
%     
%     q_plot=q_Div{j};
%     fft_abs_plot=abs(fft_Div{j});
%     nexttile(fdv);
%     plot((q_plot(2:60)),fft_abs_plot(2:60));
%     title(sprintf('%03dnm (%.2feV)',freqs(j),Es(j)));
%     xlabel('µm-1'); 
%     
%     ymax=max(fft_abs_plot(2:60));
%     ylim([0 (ymax*1.1)]);
%     % add arrow annotation
%     
%     q1_ind=find(abs(q_plot-q_obs1(j))<0.01);
%     fft1=fft_abs_plot(q1_ind);
%     fft1=fft1-(0.01*ymax);
%     txt = ['\leftarrow q_1=' num2str(q_obs1(j))];
%     q_1_txt=text(q_obs1(j)*1.05,fft1,txt,'FontSize',8,'HorizontalAlignment','left');
%     
%     if q_obs1(j)~=q_obs2(j)
%         q2_ind=find(abs(q_plot-q_obs2(j))<0.01);
%         fft2=fft_abs_plot(q2_ind);
%         if fft2>fft1
%             fft2=fft2-(0.01*ymax);
%         else
%             fft2=fft2+(0.02*ymax);
%         end
%         txt = ['\leftarrow q_2=' num2str(q_obs2(j))];
%         q_2_txt=text(q_obs2(j)*1.05,fft2,txt,'FontSize',8,'HorizontalAlignment','left');
%     end
% end

%% angle correction
% q_obs1=[0.36,0.36,0.36,0.33,0.29,0.30,0.30,0.27 ];
% q_obs2=[0.72,0.72,0.69,0.47,0.42,0.42,0.39,0.39];
% lambda0=[770,790,800,830,850,870,910,930]; %890 isn't good, exclude
% for i=1:length(q_obs1);
%     [q1_ac(i),l1_ac(i),q_air(i),l_air(i)]=angle_correct2(q_obs1(i),theta,lambda0(i));
% end
% 
% for i=1:length(q_obs1);
%     [q2_ac(i),l2_ac(i),q_air(i),l_air(i)]=angle_correct2(q_obs2(i),theta,lambda0(i));
% end
% 
% 
% fig_wv=figure();
% ax=gca;
% hold(ax,'on');
% pbaspect([5 6 1]);
% set(ax,'FontSize',13,'LabelFontSizeMultiplier',1,...
%     'TitleFontSizeMultiplier',1,'XColor','k','Box','on','TickDir','in');
% 
% q1_plot=plot(q1_ac,Es,'o','LineWidth',1);
% q2_plot=plot(q2_ac,Es,'x','LineWidth',1);
% 
% color_order_mult={'#0072BD','#D95319','#FF0000','#0000FF'};
% colororder(color_order_mult);
% 
% % these are from 'NGS_TEM_TE_mode.m'
% wv_abs_TE_40_div=wv_abs_TE_40/(10e6);
% wv_abs_TM_40_div=wv_abs_TM_40/(10e6);
% TE_plot=plot(wv_abs_TE_40_div,E,'LineWidth',1,'DisplayName','TE mode');
% TM_plot=plot(wv_abs_TM_40_div,E,'LineWidth',1,'DisplayName','TM mode');
% xlabel('q (um-1)')
% ylabel('E (eV)')
% set(gca,'Box','on')
% title('Angle corrected q for 40nm thick sample');
% xlim([0.5 1.2]);
% ylim([1.3 1.7]);
% 
% legend([TE_plot TM_plot],'TE mode','TM mode');
% 
% hold off;

