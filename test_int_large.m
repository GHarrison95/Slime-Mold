clear all

size_x = 100;
size_y = 100;

num_bug = 500;

t_steps = 100;

scent_field = scent_field_orig(size_x,size_y);
bug_list = [];

for i=1:1:num_bug
%     x = round(rand()*(size_x-1)) + 1;
%     y = round(rand()*(size_y-1)) + 1;
    x = round(rand()*(size_x-30)) + 10;
    y = round(rand()*(size_y-30)) + 10;

    dir = round(rand()*7) + 1;
    bug_list = [bug_list, bug_integer(x,y,dir)];
end

for t=1:t_steps
    for i=1:num_bug
        decide_dir(bug_list(i), scent_field);
        move(bug_list(i), scent_field);

        pos = bug_list(i).Pos;
        scent_field.add_scent(pos(1),pos(2));
    end

    diffuse_scent(scent_field);

    figure(1)
    imagesc(scent_field.Field)
%     pause(0.01) %in seconds
end


