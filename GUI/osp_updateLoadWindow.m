function osp_updateLoadWindow(gui)
%% osp_updateLoadWindow
%   This function updates the load tab.
%
%
%   USAGE:
%       osp_updateLoadWindow(gui);
%
%   INPUT:  
%           gui      = gui class containing all handles and the MRSCont             
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
%%% 1. INITIALIZE %%%
        MRSCont = getappdata(gui.figure,'MRSCont');  % Get MRSCont from hidden container in gui class
        gui.Info.data = gui.layout.(gui.layout.rawTabhandles{gui.load.Selected}).Children(2);
        gui.InfoText.data = gui.layout.(gui.layout.rawTabhandles{gui.load.Selected}).Children(2).Children;
        % Grid for Plot and Data control sliders
        gui.Plot.data = gui.layout.(gui.layout.rawTabhandles{gui.load.Selected});
        gui.layout.EmptyPlot.data = 0;
%%% 2. FILLING INFO PANEL FOR THIS TAB %%%
% All the information from the Raw data is read out here
        if gui.load.Selected == 1 %Is metabolite data?
            StatText = ['Metabolite Data -> Sequence: ' gui.load.Names.Seq '; B0: ' num2str(MRSCont.raw{1,gui.controls.Selected}.Bo) '; TE / TR: ' num2str(MRSCont.raw{1,gui.controls.Selected}.te) ' / ' num2str(MRSCont.raw{1,gui.controls.Selected}.tr) ' ms ' '; spectral bandwidth: ' num2str(MRSCont.raw{1,gui.controls.Selected}.spectralwidth) ' Hz'...
                         '; raw subspecs: ' num2str(MRSCont.raw{1,gui.controls.Selected}.rawSubspecs) '; raw averages: ' num2str(MRSCont.raw{1,gui.controls.Selected}.rawAverages) '; averages: ' num2str(MRSCont.raw{1,gui.controls.Selected}.averages)...
                         '; Sz: ' num2str(MRSCont.raw{1,gui.controls.Selected}.sz) '; dimensions: ' num2str(MRSCont.raw{1,gui.controls.Selected}.geometry.size.(gui.load.Names.Geom{1})) ' x ' num2str(MRSCont.raw{1,gui.controls.Selected}.geometry.size.(gui.load.Names.Geom{2})) ' x ' num2str(MRSCont.raw{1,gui.controls.Selected}.geometry.size.(gui.load.Names.Geom{3})) ' mm = '...
                         num2str(MRSCont.raw{1,gui.controls.Selected}.geometry.size.(gui.load.Names.Geom{1}) * MRSCont.raw{1,gui.controls.Selected}.geometry.size.(gui.load.Names.Geom{2}) * MRSCont.raw{1,gui.controls.Selected}.geometry.size.(gui.load.Names.Geom{3})/1000) ' ml'];
        else if gui.load.Selected == 2 %Is water or ref data?
            StatText = ['Reference Data -> Sequence: ' gui.load.Names.Seq '; B0: ' num2str(MRSCont.raw_ref{1,gui.controls.Selected}.Bo) '; TE / TR: ' num2str(MRSCont.raw_ref{1,gui.controls.Selected}.te) ' / ' num2str(MRSCont.raw_ref{1,gui.controls.Selected}.tr) ' ms ' '; spectral bandwidth: ' num2str(MRSCont.raw_ref{1,gui.controls.Selected}.spectralwidth) ' Hz'...
                         '; raw subspecs: ' num2str(MRSCont.raw_ref{1,gui.controls.Selected}.rawSubspecs) '; raw averages: ' num2str(MRSCont.raw_ref{1,gui.controls.Selected}.rawAverages) '; averages: ' num2str(MRSCont.raw_ref{1,gui.controls.Selected}.averages)...
                         '; Sz: ' num2str(MRSCont.raw_ref{1,gui.controls.Selected}.sz) '; dimensions: ' num2str(MRSCont.raw_ref{1,gui.controls.Selected}.geometry.size.(gui.load.Names.Geom{1})) ' x ' num2str(MRSCont.raw_ref{1,gui.controls.Selected}.geometry.size.(gui.load.Names.Geom{2})) ' x ' num2str(MRSCont.raw_ref{1,gui.controls.Selected}.geometry.size.(gui.load.Names.Geom{3})) ' mm = '...
                         num2str(MRSCont.raw_ref{1,gui.controls.Selected}.geometry.size.(gui.load.Names.Geom{1}) * MRSCont.raw_ref{1,gui.controls.Selected}.geometry.size.(gui.load.Names.Geom{2}) * MRSCont.raw_ref{1,gui.controls.Selected}.geometry.size.(gui.load.Names.Geom{3})/1000) ' ml'];
            else
                StatText = ['Water Data -> Sequence: ' gui.load.Names.Seq '; B0: ' num2str(MRSCont.raw_w{1,gui.controls.Selected}.Bo) '; TE / TR: ' num2str(MRSCont.raw_w{1,gui.controls.Selected}.te) ' / ' num2str(MRSCont.raw_w{1,gui.controls.Selected}.tr) ' ms ' '; spectral bandwidth: ' num2str(MRSCont.raw_w{1,gui.controls.Selected}.spectralwidth) ' Hz'...
                         '; raw subspecs: ' num2str(MRSCont.raw_w{1,gui.controls.Selected}.rawSubspecs) '; raw averages: ' num2str(MRSCont.raw_w{1,gui.controls.Selected}.rawAverages) '; averages: ' num2str(MRSCont.raw_w{1,gui.controls.Selected}.averages)...
                         '; Sz: ' num2str(MRSCont.raw_w{1,gui.controls.Selected}.sz) '; dimensions: ' num2str(MRSCont.raw_w{1,gui.controls.Selected}.geometry.size.(gui.load.Names.Geom{1})) ' x ' num2str(MRSCont.raw_w{1,gui.controls.Selected}.geometry.size.(gui.load.Names.Geom{2})) ' x ' num2str(MRSCont.raw_w{1,gui.controls.Selected}.geometry.size.(gui.load.Names.Geom{3})) ' mm = '...
                         num2str(MRSCont.raw_w{1,gui.controls.Selected}.geometry.size.(gui.load.Names.Geom{1}) * MRSCont.raw_w{1,gui.controls.Selected}.geometry.size.(gui.load.Names.Geom{2}) * MRSCont.raw_w{1,gui.controls.Selected}.geometry.size.(gui.load.Names.Geom{3})/1000) ' ml'];
            end
        end
        set(gui.InfoText.data, 'String',sprintf(StatText))
%%% 3. VISUALIZATION PART OF THIS TAB %%%
        temp = figure( 'Visible', 'off' );
        if gui.load.Selected == 1 %Is Metabolite data/tab?
            temp = osp_plotLoad(MRSCont, gui.controls.Selected,'mets',1 );
            if MRSCont.flags.isUnEdited %Is UnEdited?
                ViewAxes = gca();
                delete(gui.Plot.data.Children(1).Children(1).Children)
                set(ViewAxes.Children, 'Parent', gui.Plot.data.Children(1).Children(1));
                set(gui.Plot.data.Children(1).Children(1).Title, 'String', ViewAxes.Title.String)
                set(gui.Plot.data.Children(1).Children(1), 'XLim', ViewAxes.XLim)
            end
            if MRSCont.flags.isMEGA %Is MEGA?               
                delete(gui.Plot.data.Children(1).Children(1).Children)
                delete(gui.Plot.data.Children(1).Children(2).Children)
                set(temp.Children(2).Children, 'Parent', gui.Plot.data.Children(1).Children(2));
                set(temp.Children(1).Children, 'Parent', gui.Plot.data.Children(1).Children(1));
                set(gui.Plot.data.Children(1).Children(2).Title, 'String', temp.Children(2).Title.String)
                set(gui.Plot.data.Children(1).Children(2), 'XLim', temp.Children(2).XLim)
                set(gui.Plot.data.Children(1).Children(1), 'XLim', temp.Children(1).XLim)
            end
        else if gui.load.Selected == 2 %Is Ref data/tab?
                temp = osp_plotLoad(MRSCont, gui.controls.Selected,'ref',1 );
                ViewAxes = gca();
                delete(gui.Plot.data.Children(1).Children(1).Children)
                set(ViewAxes.Children, 'Parent', gui.Plot.data.Children(1).Children(1));
                set(gui.Plot.data.Children(1).Children(1).Title, 'String', ViewAxes.Title.String)
                set(gui.Plot.data.Children(1).Children(1), 'XLim',ViewAxes.XLim)
            else %Is water data/tab?
                temp = osp_plotLoad(MRSCont, gui.controls.Selected,'w',1 );
                ViewAxes = gca();
                delete(gui.Plot.data.Children(1).Children(1).Children)
                set(ViewAxes.Children, 'Parent', gui.Plot.data.Children(1).Children(1));
                set(  gui.Plot.data.Children(1).Children(1).Title, 'String',ViewAxes.Title.String)
                set(  gui.Plot.data.Children(1).Children(1), 'XLim',ViewAxes.XLim)
            end
        end
        % Get rid of the Load figure
        close( temp );    
        set(gui.Info.data,'Title', ['Actual file: ' MRSCont.files{gui.controls.Selected}] );
        setappdata(gui.figure,'MRSCont',MRSCont); % Write MRSCont into hidden container in gui class
end