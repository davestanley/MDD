

function hxp = xp_handles_newfig (xp, op)
    % xp must be 1D
    
    hxp = struct;
    
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
    op = struct_addDef(op,'supersize_me',false);
    op = struct_addDef(op,'supersize_me_factor',2);
    op = struct_addDef(op,'max_num_newfigs',5);
    op = struct_addDef(op,'figwidth',[]);
    op = struct_addDef(op,'figheight',[]);
    
    
    % Postpend date/time to save path
    if op.postpend_date_time
        mydate = datestr(datenum(date),'yy/mm/dd'); mydate = strrep(mydate,'/','');
        c=clock;
        sp = ['date' mydate '_time' num2str(c(4),'%10.2d') '' num2str(c(5),'%10.2d') '' num2str(round(c(6)),'%10.2d')];
        foldername = [op.save_figname_path '_' sp];
    else
        foldername = op.save_figname_path;
    end
    
    
    if op.supersize_me && strcmp(op.visible,'on')
        fprintf('For supersize_me mode, visible should be off. Setting to off \n');
        op.visible = 'off';
    end

    if ~op.save_figures && strcmp(op.visible,'off')
            %fprintf('For supersize_me mode or visible off, should save figures. Autosaving figures... \n');
            %op.save_figures = 1;
    end
    
    if op.save_figures
        mkdir(foldername);
    end
    

    % Open one figure for each data point along this dimension
    for i = 1:length(xp.data)
        
        % If too many figures are open, break
        if i > op.max_num_newfigs && strcmp(op.visible,'on') && ~op.save_figures
            fprintf('max_num_newfigs value of %s reached. Aborting. Increase max_num_newfigs to plot more. \n',num2str(op.max_num_newfigs));
            break
        end
        
        pos = [0,0,op.figwidth,op.figheight];
        if op.supersize_me
            pos(3:4) = pos(3:4) * op.supersize_me_factor;
        end
        
        hxp.hcurr(i) = figure('Units','normalized','Position',pos,'visible',op.visible); hxp.hsub{i} = xp.data{i}();
        
        % Add a title to the current figure
        if isa(hxp.hsub(i),'subplot_grid') && ~strcmp(xp.axis(1).name(1:3),'Dim')
            mytitle = [figformat_str(xp.axis(1).name) ': ' figformat_str(xp.axis(1).getvaluestring(i))];
            hxp.hsub(i).figtitle(mytitle);
        end
        
        if op.save_figures
            ext = '.png';
            filename = [op.save_figname_prefix num2str(i) ext];
            
            set(hxp.hcurr(i),'PaperPositionMode','auto');
            tic; print(hxp.hcurr(i),'-dpng','-r300','-opengl',fullfile(foldername,filename));toc
        end
        
    end
end


