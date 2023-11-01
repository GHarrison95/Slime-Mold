%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
% This contains a double array that holds the desireability value
% for each grid coordinate. This is called scent and is valued [0,1]
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
classdef scent_field_orig<handle

    properties
        Field (:,:) single %the 2D area containing scents

        %the bounds of the Field
        size_x int16 
        size_y int16
    end

    properties (Access = private)
        K (:,:) single %convolution kernal
    end
    properties (Constant)
        scent_add = 1; %amount added by a bug every step
        scent_loss = 0.9; %percentage kept after every step

        diffuse_strength = 1;%1.5;%2.75;
    end
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    methods
        %create and define the object
        function obj = scent_field_orig(size_x, size_y)
            obj.Field = zeros(size_x,size_y);

            obj.size_x = size_x;
            obj.size_y = size_y;
            
            % Define the convolution kernal
            C = cell(1,2);
            [C{:}] = ndgrid([1 0 1]);
            tmp = 1./(sum(cat(3,C{:}),3)+1);
%             tmp = sum(cat(3,C{:}),3) <= 1;
            obj.K = obj.diffuse_strength*tmp/nnz(tmp);
        end

%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%       % get field value at an arbitrary point through interpolation
%       %    off the edge returns -1
function val = Field_val_interp(scent_field,x,y)
            val = interp2(scent_field.Field,x,y,'linear',-1);
        end

%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%       % get field value at a grid point
%       %    off the edge returns -1
        function val = Field_val(obj,x,y)
            if (x<1 || x>obj.size_x || y<1 || y>obj.size_y)
                val = -1;
            else
                val = obj.Field(x,y);
            end
        end

%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%       %Add scent to a given position
        function add_scent(obj,x,y)
            obj.Field(x,y) = obj.Field(x,y) + obj.scent_add;
        end

%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        %Spread the scents and reduce them all
        function diffuse_scent(obj)
            %spread scents based on convolution field
%             obj.Field = min(conv2(obj.Field,obj.K,'same'), 1);
            obj.Field = conv2(obj.Field,obj.K,'same');

            %decrease all scents as they fade
            obj.Field = obj.Field * obj.scent_loss;
        end

    end


end
