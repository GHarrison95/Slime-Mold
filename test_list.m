clear all


scent_field = scent_field_list(30,20);



list = bug_list(3,[1,1;2,3;5,4],[2;1;1],[1;0;pi]);

for t=1:1:290

scent_field.add_scents(list);

list.move(scent_field);
list.decide_dir(scent_field);


scent_field.diffuse_scent();
% disp('diffusing')

figure(1)
imagesc(scent_field.Field)
% pause(0.01) %in seconds
end














