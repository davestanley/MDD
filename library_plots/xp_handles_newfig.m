

function h = xp_handles_newfig (xp, op)
    % xp must be 1D
    
    if ~isvector(xp.data); error('For xp_handles_newfig, data must be 1D'); end
    
    if nargin < 2
        op = struct;
    end
    
    if isempty(op); op = struct; end;
    
    op = struct_addDef(op,'visible','on');
    op = struct_addDef(op,'save_figures',false);
    op = struct_addDef(op,'save_figname_prefix','fig_');
    op = struct_addDef(op,'save_figname_path','Figs');
    op = struct_addDef(op,'postpend_date_time',true);
    op = struct_addDef(op,'supersize_me',true);
    op = struct_addDef(op,'supersize_me_factor',3);
    
    % Postpend date/time to save path
    if op.postpend_date_time
        mydate = datestr(datenum(date),'yy/mm/dd'); mydate = strrep(mydate,'/','');
        c=clock;
        sp = ['date' mydate '_time' num2str(c(4),'%10.2d') '' num2str(c(5),'%10.2d') '' num2str(round(c(6)),'%10.2d')];
        foldername = [op.save_figname_path '_' sp];
    else
        foldername = op.save_figname_path;
    end
    
    if op.save_figures
        mkdir_silent(foldername);
    end
    

    % Open one figure for each data point along this dimension
    for i = 1:length(xp.data)
        
        pos = [0,0,1,1];
        if op.supersize_me
            pos(3:4) = pos(3:4) * op.supersize_me_factor;
            op.visible = 'off';
        end
        
        h.hf(i) = figure('Units','normalized','Position',pos,'visible',op.visible); h.hsg(i) = xp.data{i}();
        
        % Add a title to the current figure
        if isa(h.hsg(i),'subplot_grid') && ~strcmp(xp.axis(1).name(1:3),'Dim')
            mytitle = [figformat_str(xp.axis(1).name) ': ' figformat_str(xp.axis(1).getvaluestring(i))];
            h.hsg(i).figtitle(mytitle);
        end
        
        if op.save_figures
            ext = '.png';
            filename = [op.save_figname_prefix num2str(i) ext];
            
            set(h.hf(i),'PaperPositionMode','auto');
            tic; print(h.hf(i),'-dpng','-r100','-opengl',fullfile(foldername,filename));toc
        end
        
    end
end


