clear all
close all


size_x = 150;
size_y = 150;

num_bug = 2000;

t_steps = 3000;

scent_field = scent_field_orig(size_x,size_y);
bug_list = [];

for i=1:1:num_bug
%     x = round(rand()*(size_x-1)) + 1;
%     y = round(rand()*(size_y-1)) + 1;
    x = round(rand()*(10)) + size_x/2;
    y = round(rand()*(10)) + size_y/2;

    dir = round(rand()*2*pi);
    bug_list = [bug_list, bug_double(x,y,2,dir)];
end

colors = importdata("flesh3_colormap.mat");

figure(Position=[0,0,700,600])
% colormap(flipud(bone));
% colormap(colors)

for t=1:t_steps
    for i=1:num_bug
        decide_dir(bug_list(i), scent_field);
        move(bug_list(i), scent_field);

        pos_x = round(bug_list(i).Pos_x);
        pos_y = round(bug_list(i).Pos_y);
        scent_field.add_scent(pos_x,pos_y);
    end


scent_field.diffuse_scent();

% figure(1, Position=[0,0,500,500])
imagesc(scent_field.Field)
drawnow
% pause(0.01) %in seconds
end














