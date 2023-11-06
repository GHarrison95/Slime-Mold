clear all
close all

time_start = tic;

vid_title = 'vids/test.avi';

size_x = 250; %size of the grid the bugs
size_y = 250; %will live on

num_bug = 3000;

t_steps = 310; %how many time steps to go. 10 per sec. 
                %add 10 to get time right

%make scent field and bug list
scent_field = scent_field_orig(size_x,size_y);
% bug_list = []; 

bug_time = tic;
disp('generating bugs')

%preallocate bug_list
bug_list = bug_double.empty(0,num_bug);

for i=1:1:num_bug %define bug positions and such
    
%     x = (rand()*(size_x-1)) + 1; %Uniformly distribute
%     y = (rand()*(size_y-1)) + 1;

    x = (rand()*(10)) + size_x/2 -5; %Cluster at center
    y = (rand()*(10)) + size_y/2 -5;

    dir = (rand()*2*pi); %random direction in rads
    speed = (rand()*2); %random initial speed
    
    %append to list
%     bug_list = [bug_list, bug_double(x,y,2,dir)]; 
    bug_list(i) = bug_double(x,y,speed,dir);
    
    %also put down their initial scents
    scent_field.add_scent(round(x),round(y));
end

disp(['done bug gen    it took ',num2str(toc(bug_time)),' secs'])

% colors = importdata("flesh3_colormap.mat");

figure('Position',[700,150,700,600])
colormap(flipud(bone));
% colormap(colors)


frame_start_time = tic;
disp('making frames')

%preallocate F
F = struct('cdata',cell(1,t_steps),'colormap',cell(1,t_steps));

for t=1:t_steps %t = time step
    frame_time = tic;
    
    %plot with interp to smooth it
    imagesc(interp2(scent_field.Field))
    drawnow
    F(t) = getframe(gca);

    for i=1:num_bug %for each bug
        decide_dir(bug_list(i), scent_field);
        move(bug_list(i), scent_field);

        pos_x = round(bug_list(i).Pos_x);
        pos_y = round(bug_list(i).Pos_y);
        scent_field.add_scent(pos_x,pos_y);
    end

%iterate field
scent_field.diffuse_scent();

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







