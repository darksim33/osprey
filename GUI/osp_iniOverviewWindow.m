function osp_iniOverviewWindow(gui)
%% osp_iniOverviewWindow
%   This function creates the inital overview window in the gui.
%
%
%   USAGE:
%       osp_iniOverviewWindow(gui);
%
%   INPUT:      gui      = gui class containing all handles and the MRSCont 
%
%   OUTPUT:     Changes in gui parameters and MRSCont are written into the
%               gui class
%
%
%   AUTHORS:
%       Dr. Helge Zoellner (Johns Hopkins University, 2020-01-16)
%       hzoelln2@jhmi.edu
%
%   CREDITS:
%       This code is based on numerous functions from the FID-A toolbox by
%       Dr. Jamie Near (McGill University)
%       https://github.com/CIC-methods/FID-A
%       Simpson et al., Magn Reson Med 77:23-33 (2017)
%
%   HISTORY:
%       2020-01-16: First version of the code.
%%% 1. GET HANDLES %%%
%This function creates the inital overview window
        MRSCont = getappdata(gui.figure,'MRSCont'); % Get MRSCont from hidden container in gui class
        gui.layout.tabs.TabEnables{6} = 'on';
        gui.layout.tabs.Selection  = 6;
% Creating subtabs
        gui.layout.specsOvTab = uix.HBox('Parent', gui.layout.overviewTab, 'Padding', 5,'BackgroundColor',gui.colormap.Background);
        gui.layout.meanOvTab = uix.HBox('Parent', gui.layout.overviewTab, 'Padding', 5,'BackgroundColor',gui.colormap.Background);
        gui.layout.quantOvTab = uix.HBox('Parent', gui.layout.overviewTab, 'Padding', 5,'BackgroundColor',gui.colormap.Background);
        gui.layout.distrOvTab = uix.HBox('Parent', gui.layout.overviewTab, 'Padding', 5,'BackgroundColor',gui.colormap.Background);
        gui.layout.corrOvTab = uix.HBox('Parent', gui.layout.overviewTab, 'Padding', 5,'BackgroundColor',gui.colormap.Background);
        gui.layout.diceOvTab = uix.HBox('Parent', gui.layout.overviewTab, 'Padding', 5,'BackgroundColor',gui.colormap.Background);
        gui.layout.overviewTab.TabTitles  = {'spectra', 'mean spectra', 'quantify table', 'distribution', 'correlation','dice ovelap'};
        gui.layout.overviewTab.TabWidth   = 115;
        gui.layout.overviewTab.Selection  = 1;
        gui.layout.overviewTab.TabEnables = {'on', 'on', 'on', 'on', 'on', 'off'};

%%% 2. SPECS OVERVIEW %%% 
%Overview Panel for all specs sorted by groups
        gui.Plot.specsOv = uix.VBox(...
            'Parent', gui.layout.specsOvTab, ...
            'Padding', 5,'BackgroundColor',gui.colormap.Background);

%Creates popup menu for the processed Subspectra (A,B,C,D,ref,water)
        gui.controls.specsOvPlot = uix.Panel('Parent', gui.Plot.specsOv,'Title', 'Actual Subspectra', ...
                                            'Padding', 5,'HighlightColor', gui.colormap.Foreground,'BackgroundColor',gui.colormap.Background,'ForegroundColor', gui.colormap.Foreground);
        gui.controls.pop_specsOvPlot = uicontrol('Parent',gui.controls.specsOvPlot,'style','popupmenu',...
                                                'Units', 'Normalized', 'Position', [0 0 1 1],'FontName', 'Arial', ...
                                                'String',gui.layout.proTab.TabTitles, 'Value', 1);

%op_plotspec is used to visualize the processed data
        gui.layout.shiftind = 0.2;
        for g = 1 :  gui.overview.Number.Groups %Loop over groups. Difterenc colors and shifts for different groups
            temp = figure( 'Visible', 'off' );
            if (strcmp(gui.process.Names{gui.process.Selected},'A') || strcmp(gui.process.Names{gui.process.Selected},'D') || strcmp(gui.process.Names{gui.process.Selected},'C') || strcmp(gui.process.Names{gui.process.Selected},'D')) %Metabolite data
                if gui.overview.NAAnormed ==1 %Has been normalized to NAA
                    shift = gui.layout.shiftind * (g-1);
                    temp = op_plotspec(MRSCont.overview.(['sort_data_g' num2str(g) '_NAAnormalized']).(gui.process.Names{gui.process.Selected}),2,1,gui.colormap.cb(g,:),shift,['Overview ' gui.layout.proTab.TabTitles{gui.process.Selected}]);
                else %Normalize to max value of the spec
                    ylimmax = max(real(MRSCont.overview.all_data.(gui.process.Names{gui.load.Selected}){1,1}.specs));
                    shift = ylimmax * gui.shiftind * (g-1);
                    temp = op_plotspec(MRSCont.overview.(['sort_data_g' num2str(g)]).(gui.process.Names{gui.process.Selected}),2,1,gui.colormap.cb(g,:),shift,['Overview ' gui.layout.proTab.TabTitles{gui.process.Selected}]);
                end
            else %Is water data
                ylimmax = max(real(MRSCont.overview.all_data.(gui.process.Names{1}){1,1}.specs));
                shift = ylimmax * gui.layout.shiftind * (g-1);
                temp = op_plotspec(MRSCont.overview.(['sort_data_g' num2str(g)]).(gui.process.Names{gui.process.Selected}),2,1,gui.colormap.cb(g,:),shift,['Overview ' gui.layout.proTab.TabTitles{gui.process.Selected}]);
            end
            set(gca, 'YColor', MRSCont.colormap.Background);
            set(gca,'YTickLabel',{})
            set(gca,'YTick',{});
            set(gca,'XColor',MRSCont.colormap.Foreground);
            set(gca,'Color','w');
            set(gcf,'Color','w');
            title(['Overview ' gui.layout.proTab.TabTitles{gui.load.Selected}],'Color', MRSCont.colormap.Foreground);
            if g == 1
                ax=get(temp,'Parent');
                figpl = get(ax,'Parent');
                ViewAxes = gca();
                set(ViewAxes, 'Parent', gui.Plot.specsOv);
                % Get rid of the Load figure
                close( figpl );
            else
                ax=get(temp,'Parent');
                figpl = get(ax,'Parent');
                copyobj(ax.Children, gui.ViewAxes);
                % Get rid of the Load figure
                close( figpl );
            end
        end
        if gui.load.Selected ==1 %Metabolite data?
            set(gui.Plot.specsOv.Children(2), 'XLim', [0.2 4.5])
        else %Water data?
            set(gui.Plot.specsOv.Children(2), 'XLim', [0 2*4.68])
        end
        set(gui.Plot.specsOv,'Heights', [-0.07 -0.93]);

%%% 3. MEAN SPECS %%%
       gui.layout.overviewTab.Selection  = 2;
       gui.Plot.meanOv = uix.VBox('Parent', gui.layout.meanOvTab, 'Padding', 5,'BackgroundColor',gui.colormap.Background);

%Creates popup menu for the processed Subspectra (A,B,C,D,ref,water)
       gui.controls.meanOvPlot = uix.Panel('Parent', gui.Plot.meanOv,'Title', 'Actual Subspectra', ...
                                          'Padding', 5,'HighlightColor', gui.colormap.Foreground,'BackgroundColor',gui.colormap.Background,'ForegroundColor', gui.colormap.Foreground);
       gui.controls.pop_meanOvPlot = uicontrol('Parent',gui.controls.meanOvPlot,'style','popupmenu',...
                                              'Units', 'Normalized', 'Position', [0 0 1 1],'FontName', 'Arial', ...
                                              'String',gui.layout.proTab.TabTitles, 'Value', 1);

%op_plotspec is used for a dummy plot which is update later
        gui.layout.shift = 0.5;
        temp = figure( 'Visible', 'off' );
        if gui.load.Selected ==1 %Metabolite data
            temp = op_plotspec(MRSCont.overview.(['sort_data_g' num2str(1)]).(gui.process.Names{2}),2,1,gui.colormap.cb(1,:),gui.layout.shift*(1-1),['Overview ' gui.layout.proTab.TabTitles{gui.load.Selected}]);
        else %Water data?
            temp = op_plotspec(MRSCont.overview.(['sort_data_g' num2str(1)]).(gui.process.Names{1}),2,1,gui.colormap.cb(1,:),gui.layout.shift*(1-1),['Overview ' gui.layout.proTab.TabTitles{gui.load.Selected}]);
        end
        set(gca, 'YColor', MRSCont.colormap.Background);
        set(gca,'YTickLabel',{})
        set(gca,'YTick',{});
        set(gca,'XColor',MRSCont.colormap.Foreground);
        set(gca,'Color','w');
        set(gcf,'Color','w');
        title(['Overview ' gui.layout.proTab.TabTitles{gui.load.Selected}],'Color', MRSCont.colormap.Foreground);
        ax=get(temp,'Parent');
        figpl = get(ax,'Parent');
        ViewAxes = gca();
        set(ViewAxes, 'Parent', gui.Plot.meanOv);
        close( figpl );
        if gui.load.Selected ==1
            set(gui.Plot.meanOv.Children(2), 'XLim', [0.2 4.5])
        else
            set(gui.Plot.meanOv.Children(2), 'XLim', [0 2*4.68])
        end
        osp_updatemeanOvWindow(gui); %Update the plot with the mean and SD
        set(gui.Plot.meanOv,'Heights', [-0.07 -0.93]);

%%% 4. QUANTIFICATION TABLE %%%
        gui.layout.overviewTab.Selection  = 3;
        gui.Plot.quantOv = uix.VBox('Parent', gui.layout.quantOvTab,'Padding', 5,'BackgroundColor',gui.colormap.Background);

%Creates Popup menu to change between quantifications (tCr, waterScaled etc.)
        gui.controls.quantOvPlot = uix.Panel('Parent', gui.Plot.quantOv,'Title', 'Actual Quantification', ...
                                            'Padding', 5,'HighlightColor', gui.colormap.Foreground,'BackgroundColor',gui.colormap.Background,'ForegroundColor', gui.colormap.Foreground);
        gui.controls.pop_quantOvPlot = uicontrol('Parent',gui.controls.quantOvPlot,'style','popupmenu',...
                                                'Units', 'Normalized', 'Position', [0 0 1 1],'FontName', 'Arial', ...
                                                'String',gui.quant.Names.Quants, 'Value', 1);
 
% Quantification table is created based on uicontrol
        gui.Results.quantOv = uix.Panel('Parent', gui.Plot.quantOv, 'Padding', 5, ...
                                        'Title', ['Results: ' (gui.quant.Names.Quants{gui.quant.Selected.Quant})],...
                                        'FontName', 'Arial','HighlightColor', gui.colormap.Foreground,'BackgroundColor',gui.colormap.Background,'ForegroundColor', gui.colormap.Foreground);
        QuantTextOv = cell(MRSCont.nDatasets+1,gui.quant.Number.Metabs);
        QuantTextOv(1,:) = MRSCont.quantify.metabs;
        QuantTextOv(2:end,:) = table2cell(MRSCont.quantify.tables.(gui.quant.Names.Model{gui.quant.Selected.Model}).(gui.quant.Names.Quants{gui.quant.Selected.Quant})(:,:));
        temp=uimulticollist ( 'units', 'normalized', 'position', [0 0 1 1], 'string', QuantTextOv,...
            'BackgroundColor',gui.colormap.Background,'ForegroundColor', gui.colormap.Foreground);
        set(temp,'BackgroundColor',gui.colormap.Background)
        set(temp, 'Parent', gui.Results.quantOv );
        set(gui.Plot.quantOv,'Heights', [-0.07 -0.93]);
    
%%% 5. RAINCLOUD PLOTS %%%
        gui.layout.overviewTab.Selection  = 4;
        gui.Plot.distrOv = uix.VBox('Parent', gui.layout.distrOvTab, 'Padding', 5,'BackgroundColor',gui.colormap.Background);

%Creates popup menus for differnt quantifications and metabolites
        gui.controls.distrOvPanel = uix.Panel('Parent', gui.Plot.distrOv,'Title', 'Actual Quantification and Metabolite', ...
                                             'Padding', 5,'HighlightColor', gui.colormap.Foreground,'BackgroundColor',gui.colormap.Background,'ForegroundColor', gui.colormap.Foreground);
        gui.controls.distrOv = uix.HBox('Parent', gui.controls.distrOvPanel,...
                                       'Padding', 5, 'Spacing', 10,'BackgroundColor',gui.colormap.Background);
        gui.controls.pop_distrOvQuant = uicontrol('Parent',gui.controls.distrOv,'style','popupmenu',...
                                                 'Units', 'Normalized', 'Position', [0 0 1 1],'FontName', 'Arial',...
                                                 'String',gui.quant.Names.Quants, 'Value', 1);
        gui.controls.pop_distrOvMetab = uicontrol('Parent',gui.controls.distrOv,'style','popupmenu',...
                                                 'Units', 'Normalized', 'Position', [0 0 1 1],'FontName', 'Arial', ...
                                                 'String',MRSCont.quantify.metabs, 'Value', 1);

%osp_plotQuantifyTable to create distribution overview as raincloud plot
        temp = figure( 'Visible', 'off' );
        [temp] = osp_plotRaincloud(MRSCont,gui.quant.Names.Model{gui.quant.Selected.Model}, gui.quant.Names.Quants{gui.quant.Selected.Quant},MRSCont.quantify.metabs{gui.overview.Selected.Metab},'Raincloud plot',1);
        ViewAxes = gca();
        set(ViewAxes, 'Parent', gui.Plot.distrOv);
        close( temp );
        set(gui.Plot.distrOv,'Heights', [-0.07 -0.90 -0.03]);
        gui.Plot.distrOv.Children(3).Legend.Location = 'North';

 %%% 6. CORRELATION PLOTS %%%
        rmpath(genpath([gui.folder.spmversion filesep]));
        gui.layout.overviewTab.Selection  = 5;
        gui.Plot.corrOv = uix.VBox('Parent', gui.layout.corrOvTab, 'Padding', 5,'BackgroundColor',gui.colormap.Background);
 %%%%%%%%%%%%%%%%%%DATA CONTROLS FOR THIS TAB%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Creates popup menu for differnt quantification, metabolite and
% correaltion measure
        gui.controls.corrOvPanel = uix.Panel('Parent', gui.Plot.corrOv,'Title', 'Actual Quantification, Metabolite, and Correlation Measure', ...
                                            'Padding', 5,'HighlightColor', gui.colormap.Foreground,'BackgroundColor',gui.colormap.Background,'ForegroundColor', gui.colormap.Foreground);
        gui.controls.corrOv = uix.HBox('Parent', gui.controls.corrOvPanel,'Padding', 5, 'Spacing', 10,'BackgroundColor',gui.colormap.Background);
        gui.controls.pop_corrOvQuant = uicontrol('Parent',gui.controls.corrOv,'style','popupmenu',...
                                                'Units', 'Normalized', 'Position', [0 0 1 1],'FontName', 'Arial',...
                                                'String',gui.quant.Names.Quants, 'Value', 1);
        gui.controls.pop_corrOvMetab = uicontrol('Parent',gui.controls.corrOv,'style','popupmenu',...
                                                'Units', 'Normalized', 'Position', [0 0 1 1],'FontName', 'Arial', ...
                                                'String',MRSCont.quantify.metabs, 'Value', 1);
        gui.controls.pop_corrOvCorr = uicontrol('Parent',gui.controls.corrOv,'style','popupmenu',...
                                               'Units', 'Normalized', 'Position', [0 0 1 1],'FontName', 'Arial', ...
                                               'String',gui.overview.Names.Corr, 'Value', 1);
        gui.controls.pop_whichcorrOvCorr = uicontrol('Parent',gui.controls.corrOv,'style','popupmenu',...
                                       'Units', 'Normalized', 'Position', [0 0 1 1],'FontName', 'Arial', ...
                                       'String',{'MRSCont.overview.corr','metabolites','QM'}, 'Value', 1);
%%%%%%%%%%%%%%%%%%VISUALIZATION PART OF THIS TAB%%%%%%%%%%%%%%%%%%%%%%%%
%osp_plotQuantifyTable is used to create a correlation plot
        temp = figure( 'Visible', 'off' );
        [temp] = osp_plotScatter(MRSCont, gui.quant.Names.Model{gui.quant.Selected.Model}, gui.quant.Names.Quants{gui.quant.Selected.Quant},MRSCont.quantify.metabs{gui.overview.Selected.Metab},gui.overview.CorrMeas{gui.overview.Selected.Corr},gui.overview.Names.Corr{gui.overview.Selected.Corr},1);
        ViewAxes = gca();
        set(ViewAxes, 'Parent', gui.Plot.corrOv);
        set(gui.Plot.corrOv,'Heights', [-0.07 -0.90 -0.03]);
        gui.Plot.corrOv.Children(3).Legend.Location = 'North';
        close( temp );
        gui.layout.overviewTab.Selection  = 2;
        setappdata(gui.figure,'MRSCont',MRSCont); % Write MRSCont into hidden container in gui class
end