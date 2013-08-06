function adj_matrix_gui(action)
% ADJ_MATRIX_GUI
% Opens a figure.  Double click to create a vertex. Single click to
% connect vertices.  Right click to delete vertices or edges.
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: Kranti Konganti, James Cai.
% (C) Texas A&M University.
%
% $LastChangedDate: 2012-12-28 19:01:43 -0600 (Fri, 28 Dec 2012) $
% $LastChangedRevision: 278 $
% $LastChangedBy: konganti $
%


if nargin == 0
    action = 'init';
end

switch action
case 'motion'
    line_h = getappdata(gcf,'motionline');
    pt = get(gca,'CurrentPoint');
    pt = pt(1,:);
    xdata = get(line_h,'XData');
    ydata = get(line_h,'YData');
    xdata(2) = pt(1);
    ydata(2) = pt(2);
    set(line_h,'XData',xdata,'YData',ydata)
case 'down'
    button = get(gcf,'SelectionType');
    switch button
    case 'normal'
        h = gco;
        fig = gcf;

        % First click
        if ~isappdata(fig, 'motionline')
            if isequal(get(h,'Type'),'text')
                pt = get(h,'Position');
                hold on
                line_h = plot(pt(1), pt(2),'b-.' ...
                                          ,'EraseMode','normal');
                setappdata(line_h,'startobj',h)    % Save start object
                hold off
                stack_text_on_top
                setappdata(fig,'motionline',line_h)
                set(fig,'WindowButtonMotionFcn', 'adj_matrix_gui(''motion'')');
            end
        else
        % Second click
            line_h = getappdata(fig,'motionline');

            if isequal(get(gco,'Type'),'text')
                startobj = getappdata(line_h,'startobj');
                endobj = gco;
                startpt = get(startobj,'Position');
                endpt = get(endobj,'Position');
                set(line_h,'XData',[startpt(1) endpt(1)] ...
                          ,'YData',[startpt(2) endpt(2)]);
                I = round(str2double(get(startobj,'String')));
                J = round(str2double(get(endobj,'String')));
                Matrix = getappdata(gcf,'Matrix');
                Matrix(I,J) = Matrix(I,J)+1;
                Matrix(J,I) = Matrix(J,I)+1;
                setappdata(gcf,'Matrix',Matrix)
                Matrix
            else
                delete(line_h)
            end

            rmappdata(gcf,'motionline')
            set(fig,'WindowButtonMotionFcn', '');
        end
    case 'open'
        pt = get(gca,'CurrentPoint');
        pt = pt(1,:);
        hold on
        n = 1+length(findobj(get(gca,'Children'),'Type','text'));
        h = text(pt(1),pt(2),num2str(n) ...
                            ,'Color','r','FontWeight','bold');
        hold off
        if ~isappdata(gcf,'Matrix')
            setappdata(gcf,'Matrix',[])
        end
        Matrix = getappdata(gcf,'Matrix');
        Matrix(n,n) = 0;
        setappdata(gcf,'Matrix',Matrix)
        Matrix
    case 'alt'
        switch get(gco,'Type')
        case 'text'
            n = round(str2double(get(gco,'String')));
            pt = get(gco,'Position');
            handles = get(gca,'Children');
            for I=1:length(handles)
                h = handles(I);
                if isequal(get(h,'Type'),'text')
                    n2 = round(str2double(get(h,'String')));
                    if n2 > n
                        set(h,'String',n2-1)
                    end
                else
                    xdata = get(h,'XData');
                    ydata = get(h,'YData');
                    if (xdata(1) == pt(1) & ydata(1) == pt(2)) ...
                    |  (xdata(2) == pt(1) & ydata(2) == pt(2))
                        delete(h)
                    end
                end
            end
            if isappdata(gcf,'Matrix')
                Matrix = getappdata(gcf,'Matrix');
                Matrix(n,:) = [];
                Matrix(:,n) = [];
                setappdata(gcf,'Matrix',Matrix)
                Matrix
            end
            delete(gco)
        case 'line'
            xdata = get(gco,'XData');
            ydata = get(gco,'YData');
            txt_h = findobj(get(gca,'Children'),'Type','text');
            for K=1:length(txt_h)
                h = txt_h(K);
                pt = get(h,'Position');
                if (xdata(1) == pt(1) & ydata(1) == pt(2))
                    I = round(str2double(get(h,'String')));
                elseif (xdata(2) == pt(1) & ydata(2) == pt(2))
                    J = round(str2double(get(h,'String')));
                end
            end
            if isappdata(gcf,'Matrix')
                Matrix = getappdata(gcf,'Matrix');
                Matrix(I,J) = Matrix(I,J)-1;
                Matrix(J,I) = Matrix(J,I)-1;
                setappdata(gcf,'Matrix',Matrix)
                Matrix
            end
            delete(gco)
        end % End object switch
    end % End button switch
case 'keypress'
    ESC = 27;
    switch get(gcf,'CurrentCharacter')
    case ESC
        if isappdata(gcf,'motionline')
            line_h = getappdata(gcf,'motionline');
            delete(line_h)

            rmappdata(gcf,'motionline')
        end
        set(gcf,'WindowButtonMotionFcn', '');
    end

case 'init'
    fig = figure('BackingStore', 'on', 'IntegerHandle', 'off', 'Name', 'Adjacency Matrix' ...
            ,'NumberTitle', 'off', 'MenuBar', 'none', 'DoubleBuffer','on');

	ax = axes;
    title('Double click to create vertex. Single click to connect. Right click to delete')
    xlim([0 10]);
    ylim([0 10]);
    set(fig,'WindowButtonDownFcn', 'adj_matrix_gui(''down'')');
    set(fig,'KeyPressFcn','adj_matrix_gui(''keypress'')')
otherwise
    error(['Unknown - ' action])
end % End action switch

function stack_text_on_top
    ax = gca;
    handles = get(gca,'Children');
    txt_h = findobj(handles,'Type','text');

    set(gca,'Children',[txt_h; setdiff(handles,txt_h)])

