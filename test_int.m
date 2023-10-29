clear all


scent_field = scent_field_orig(30,30);

% scent_field.add_scent(5,5);
% scent_field.add_scent(5,4);
% scent_field.add_scent(5,6);

% for i=1:1:5
%     figure(1)
%     imagesc(scents.Field,[0 1])
%     scents.diffuse_scent();
%     pause
% end


bug1 = bug_integer(5,1,1);
bug2 = bug_integer(1,5,3);

for t=1:1:60

pos1 = bug1.Pos;
pos2 = bug2.Pos;
scent_field.add_scent(pos1(1),pos1(2));
scent_field.add_scent(pos2(1),pos2(2));

move(bug1, scent_field);
move(bug2, scent_field);
decide_dir(bug1, scent_field);
decide_dir(bug2, scent_field);


scent_field.diffuse_scent();
disp('diffusing')

figure(1)
% imagesc(scent_field.Field,[0 1])
imagesc(scent_field.Field)
pause(0.01) %in seconds
end


%% test randn
randoms = zeros(1000,1);
for i=1:100000
    randoms(i) = (randn()/(5*pi)+1);
end

histogram(randoms)
% mean(randoms)
% max(randoms)
% min(randoms)
