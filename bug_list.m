%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
% This holds  a list of all the bugs positions, andgle and such
% and has methods to decide a new direction based on a given scent_field
% The bug values are doubles and will be interpolated onto the grid.
% This bug can also have variable speed
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
classdef bug_list<handle
    
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









end %classdef