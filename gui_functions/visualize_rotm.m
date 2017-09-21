function visualize_rotm(B, time_vector)
%% Plot attitude animation
f1 = figure;
f1.NumberTitle = 'off';

% Set figure to full screen
pause(0.00001);
frame_h = get(handle(gcf),'JavaFrame');
set(frame_h,'Maximized',1); 

I = eye(3); % Inertial frame
inertial_axes = quiver3(zeros(3,1),zeros(3,1),zeros(3,1),2*I(:,1),2*I(:,2),2*I(:,3));
inertial_axes.Color = [.75 .75 .75]; % Grey
hold on

lw = 1; % Body axes LineWidth

B_current = B(:,:,1) * I;

body_axes_x = quiver3(0,0,0,B_current(1,1),B_current(2,1),B_current(3,1));
body_axes_x.Color = [1 0 0]; % Red
body_axes_x.LineWidth = lw;

body_axes_y = quiver3(0,0,0,B_current(1,2),B_current(2,2),B_current(3,2));
body_axes_y.Color = [0 1 0]; % Green
body_axes_y.LineWidth = lw;

body_axes_z = quiver3(0,0,0,B_current(1,3),B_current(2,3),B_current(3,3));
body_axes_z.Color = [0 0 1]; % Blue
body_axes_z.LineWidth = lw;

xlabel('North')
ylabel('East')
zlabel('Down')
xlim([-2 2])
ylim([-2 2])
zlim([-2 2])

legend('Inertial Frame','Body x','Body y','Body z')

set(gca,'Zdir','reverse')
set(gca,'Ydir','reverse')

for j = 1:10:size(B,3)
    if nargin > 1
    f1.Name = ['Attitude animation: t = ' num2str(time_vector(j)./1e6) 's, ' num2str(100 * (time_vector(j)-time_vector(1))/(time_vector(end)-time_vector(1))) '%'];
    end
    B_current = B(:,:,j) * I;
    body_axes_x.UData = B_current(1,1);
    body_axes_x.VData = B_current(2,1);
    body_axes_x.WData = B_current(3,1);
    
    body_axes_y.UData = B_current(1,2);
    body_axes_y.VData = B_current(2,2);
    body_axes_y.WData = B_current(3,2);
    
    body_axes_z.UData = B_current(1,3);
    body_axes_Z.VData = B_current(2,3);
    body_axes_z.WData = B_current(3,3);
    
    drawnow
%     pause(0.1)
end
