%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
% This bug holds its position and has methods to decide a new 
% direction based on a given scent_field
% The bug values are integers and are confined to the grid
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
classdef bug_integer<handle
    
    properties
        Pos (1,2) int16 %the x-y coords of the bug
        Dir int8 %the direction its facing
                 %        2 1 8
                 %        3 X 7
                 %        4 5 6
    end

    properties (Constant) %, Access = private
        % A list that converts a Dir into a pair that 
        %can be added to Pos to get the pos in that dir
        move_list int16 = [
                     [0, 1],
                     [-1, 1],
                     [-1, 0],
                     [-1,-1],
                     [0,-1],
                     [1,-1],
                     [1, 0],
                     [1, 1]
                    ]
                 %        2 1 8
                 %        3 X 7
                 %        4 5 6
    end
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    methods
        %create a bug with a pos and dir
        function obj = bug_integer(pos_x, pos_y, direction)
            obj.Pos = [pos_x, pos_y];
            obj.Dir = direction;
        end
        
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        %Move to point specified by dir
        % or reflect off of walls
        function move(bug, scent_field)
            arguments
                bug bug_integer
                scent_field scent_field_orig
            end
            
            next_pos = bug.Pos + bug.move_list(bug.Dir,:);
            if (Field_val(scent_field, next_pos(1), next_pos(2))  >=0)
                bug.Pos = bug.Pos + bug.move_list(bug.Dir,:);
            else
                %this is my reflect function
                %it is dumb for now
%                 bug.Dir = mod(bug.Dir+3,8)+1;
                bug.Dir = round(rand()*7) + 1;
                move(bug, scent_field)
            end
        end

%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        %Find new direction
        function decide_dir(bug, scent_field)
            arguments
                bug bug_integer
                scent_field scent_field_orig
            end
            
            left_dir = mod(bug.Dir,8)+1;
            cent_dir = mod(bug.Dir-1,8)+1;
            right_dir = mod(bug.Dir-2,8)+1;

            left = bug.Pos + bug.move_list(left_dir,:);
            cent = bug.Pos + bug.move_list(cent_dir,:);
            right = bug.Pos + bug.move_list(right_dir,:);

            vals = [
                    scent_field.Field_val(left(1),left(2)) *(randn()/4+1) 
                    scent_field.Field_val(cent(1),cent(2)) *(randn()/4+1) 
                    scent_field.Field_val(right(1),right(2)) *(randn()/4+1) 
                   ];

            %currently defaults to the leftmost in a tie
            [~,index] = max(vals);

            %new dir is bug.Dir - (index-2) but need to mod8 -1 +1
            bug.Dir = mod(bug.Dir-index+1,8)+1;
        end
    end
end

