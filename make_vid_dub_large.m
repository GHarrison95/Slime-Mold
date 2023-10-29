clear all
close all

time_start = tic;

vid_title = 'test_guy.avi';

size_x = 450;
size_y = 450;

num_bug = 2000;

t_steps = 200;

scent_field = scent_field_orig(size_x,size_y);
bug_list = [];

bug_time = tic;
disp('generating bugs')

for i=1:1:num_bug
%     x = round(rand()*(size_x-1)) + 1;
%     y = round(rand()*(size_y-1)) + 1;
    x = round(rand()*(10)) + size_x/2 -5;
    y = round(rand()*(10)) + size_y/2 -5;

    dir = round(rand()*2*pi);
    bug_list = [bug_list, bug_double(x,y,2,dir)];
end

disp(['done bug gen    it took ',num2str(toc(bug_time)),' secs'])

colors = importdata("flesh3_colormap.mat");

figure(Position=[700,150,700,600])
% colormap(flipud(bone));
colormap(colors)

% axis off
% set(gca,'xtick',[])
% set(gca,'xticklabel',[])
% set(gca,'ytick',[])
% set(gca,'yticklabel',[])

frame_start_time = tic;
disp('making frames')

for t=1:t_steps
    frame_time = tic;
    for i=1:num_bug
        decide_dir(bug_list(i), scent_field);
        move(bug_list(i), scent_field);

        pos_x = round(bug_list(i).Pos_x);
        pos_y = round(bug_list(i).Pos_y);
        scent_field.add_scent(pos_x,pos_y);
    end


scent_field.diffuse_scent();

% figure(1, Position=[0,0,500,500])
imagesc(interp2(scent_field.Field))
drawnow
F(t) = getframe(gca);
% pause(0.01) %in seconds

disp(['making frames ',num2str(100*t/t_steps),'%'])
disp(['it took ',num2str(toc(frame_time)),' seconds'])
end


disp(['rendering video took ',num2str(toc(frame_start_time)),' seconds total'])
% create the video writer with 1 fps
writerObj = VideoWriter(vid_title);
writerObj.FrameRate = 10;
% set the seconds per image

% open the video writer
open(writerObj);

% write the frames to the video
for i=3:length(F)
    % convert the image to a frame
    frame = F(i) ;    
    writeVideo(writerObj, frame); %save
end

% close the writer object
close(writerObj);


disp(['done'])
disp(['total time: ', num2str(toc(time_start)/60), ' mins'])







