%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
% This bug holds its position and has methods to decide a new 
% direction based on a given scent_field
% The bug values are doubles and will be interpolated onto
% the grid.
% This bug can also have variable speed
%@@@@@@@@@@@@@@@@@@@@@@5@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
classdef bug_double<handle
    
    properties
        Pos_x single %the x coord of the bug
        Pos_y single %the y coord of the bug
        Dir single   %the direction its facing
                     %as an angle from x-axis in rads
        Speed single %how many squares it moves each time
        Smell_dist single  %how far away it detects scents
    end

    properties (Constant) %, Access = private
        Smell_angle = 0.5236 % 30 deg
                             % the angle that left and right are
        Accel = 1;
        Speed_base = 2; % lowest poss speed
    end
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    methods
        %create a bug with a pos and dir
        function bug = bug_double(pos_x, pos_y, speed, direction)
            bug.Pos_x = pos_x;
            bug.Pos_y = pos_y;
            bug.Dir = direction;
            bug.Speed = speed;
            bug.Smell_dist = 1;%just set to one for now
        end
        
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        %Move to point specified by dir
        % or reflect off of walls
        function move(bug, scent_field)
            arguments
                bug bug_double
                scent_field scent_field_orig
            end
            
            next_pos_x = bug.Pos_x + bug.Speed*cos(bug.Dir);
            next_pos_y = bug.Pos_y + bug.Speed*sin(bug.Dir);

            if (Field_val(scent_field, round(next_pos_x), round(next_pos_y))  >=0)
                bug.Pos_x = next_pos_x;
                bug.Pos_y = next_pos_y;
            else
                %this is my reflect function
                %it is dumb for now
                bug.Dir = round(rand()*2*pi);
                move(bug, scent_field)
            end
        end

%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        %Find new direction
        function decide_dir(bug, scent_field)
            arguments
                bug bug_double
                scent_field scent_field_orig
            end
            
            vals = zeros(1,3);
            for i=-1:1:1
                dir = i*bug.Smell_angle + bug.Dir;

                next_pos_x = bug.Pos_x + bug.Speed*cos(dir);
                next_pos_y = bug.Pos_y + bug.Speed*sin(dir);

                vals(i+2) = Field_val_interp(scent_field, round(next_pos_x), round(next_pos_y));

            end
            %currently defaults to the leftmost in a tie
            [val,index] = max(vals);

            %new dir is bug.Dir - (index-2) but need to mod8 -1 +1
            bug.Dir = (index-2)*bug.Smell_angle + bug.Dir;%*(randn()/40 + 1);
            bug.Speed = bug.Accel*val + bug.Speed_base;
        end
    end
end

