%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
% This holds  a list of all the bugs positions, andgle and such
% and has methods to decide a new direction based on a given scent_field
% The bug values are doubles and will be interpolated onto the grid.
% This bug can also have variable speed
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
classdef bug_list<handle
    
    properties
        Pos single %the x-y coords of the bugs
        Dir single   %the direction theyre facing
                     %as an angle from x-axis in rads
        Speed single %how many squares they moves each time
%         Smell_dist single  %how far away they detects scents

        num_bugs int32 %the length of the previous lists
    end

    properties (Constant) %, Access = private
        Smell_angle = 0.5236; % 30 deg
                             % the angle that left and right are
        Smell_dist = 1;  %how far away they detects scents
        Accel = 1;
        Speed_base = 1; % lowest poss speed
    end
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
methods
    %create a bug with a pos and dir
    function list = bug_list(length, pos, speed, direction)
        if (size(pos,1)~=length || size(speed,1)~=length || size(direction,1)~=length)
            disp('mismatched size')
            disp(['num bugs = ',num2str(length)])
            disp(['num positions = ',num2str(size(pos,1))])
            disp(['num speeds = ',num2str(size(speed,1))])
            disp(['num directions = ',num2str(size(direction,1))])
            return
        end
        list.num_bugs = length;
        list.Pos = pos;
        list.Dir = direction;
        list.Speed = speed;
    end
        
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    %Move to point specified by dir
    % or reflect off of walls
    function move(list, scent_field)
        arguments
            list bug_list
            scent_field scent_field_list
        end
            
        for i=1:list.num_bugs
            
            next_pos_x = list.Pos(i,1) + list.Speed(i)*cos(list.Dir(i));
            next_pos_y = list.Pos(i,2) + list.Speed(i)*sin(list.Dir(i));

            if (scent_field.Field_val_interp((next_pos_x), (next_pos_y))  >= 0)
                list.Pos(i,1) = next_pos_x;
                list.Pos(i,2) = next_pos_y;
            else
                %this is my reflect function
                %it sends the bug to the other side of the field
                list.Pos(i,1) = mod(next_pos_x,cast(scent_field.size_x-1,'single'))+1;
                list.Pos(i,2) = mod(next_pos_y,cast(scent_field.size_y-1,'single'))+1;
                %IT DIDNT WORK :'(

            end
        end

    end
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    %Find new directions for the bugs
    function decide_dir(list, scent_field)
        arguments
            list bug_list
            scent_field scent_field_list
        end
        Vals = zeros(list.num_bugs,3);
        
        %Find left values
        Xs = list.Pos(:,1) + list.Speed.*cos(list.Dir - list.Smell_angle);
        Ys = list.Pos(:,2) + list.Speed.*sin(list.Dir - list.Smell_angle);
%         Vals(:,1) = interp2(scent_field.Field,Ys,Xs,'linear',-1);
        Vals(:,1) = interp2(scent_field.Field,Ys,Xs,'makima');

        %Find center values
        Xs = list.Pos(:,1) + list.Speed.*cos(list.Dir);
        Ys = list.Pos(:,2) + list.Speed.*sin(list.Dir);
%         Vals(:,2) = interp2(scent_field.Field,Ys,Xs,'linear',-1);
        Vals(:,2) = interp2(scent_field.Field,Ys,Xs,'makima');

        %Find left values
        Xs = list.Pos(:,1) + list.Speed.*cos(list.Dir + list.Smell_angle);
        Ys = list.Pos(:,2) + list.Speed.*sin(list.Dir + list.Smell_angle);
%         Vals(:,3) = interp2(scent_field.Field,Ys,Xs,'linear',-1);
        Vals(:,3) = interp2(scent_field.Field,Ys,Xs,'makima');

        [max_scents,indexs] = max(Vals,[],2);

        max_scents = max(max_scents,zeros(size(max_scents)));

        list.Dir = list.Dir + (indexs-2)*list.Smell_angle + 0.1*rand();
        list.Speed = (list.Accel*max_scents + list.Speed_base + list.Speed)/2;
    end
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

end %methods

end %classdef