clear all
close all

%just checking that this is working correctly

size_x = 100;
size_y = 100;

num_bug = 1000;

t_steps = 300;

scent_field = scent_field_list(size_x,size_y);
pos_list = zeros(num_bug,2);
spd_list = zeros(num_bug,1);
dir_list = zeros(num_bug,1);


%define our bug positions and such
for i=1:1:num_bug
%     x = round(rand()*(size_x-1)) + 1;
%     y = round(rand()*(size_y-1)) + 1;
    x = round(rand()*(10)) + size_x/2;
    y = round(rand()*(10)) + size_y/2;

    dir = round(rand()*2*pi);
    pos_list(i,:) = [x,y];
    spd_list(i,1) = 10*rand();
    dir_list(i,1) = dir;

    %also put down their initial scents
    scent_field.add_scent(round(x),round(y));
end

list = bug_list(num_bug,pos_list,spd_list,dir_list);

colors = importdata("flesh3_colormap.mat");

figure(Position=[0,0,700,600])
% colormap(flipud(bone));
% colormap(colors)

for t=1:t_steps

    imagesc(scent_field.Field)
    drawnow

    list.decide_dir(scent_field);
    list.move(scent_field);

    scent_field.add_scents(list);
    scent_field.diffuse_scent();
    
end














