clear all


scent_field = scent_field_orig(30,30);



bug1 = bug_double(5,1,1,0);

for t=1:1:60

pos1_x = bug1.Pos_x;
pos1_y = bug1.Pos_y;
scent_field.add_scent(round(pos1_x),round(pos1_y));

move(bug1, scent_field);
decide_dir(bug1, scent_field);


scent_field.diffuse_scent();
disp('diffusing')

figure(1)
imagesc(scent_field.Field)
pause(0.01) %in seconds
end














