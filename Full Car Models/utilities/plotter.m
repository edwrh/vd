function [] = plotter(car,g_g_vel,plot_choice)
% plotting gg-diagram variations for car

max_vel = car.max_vel;

long_g_accel = car.longAccelLookup(:,1)'/9.81;
lat_g_accel = car.longAccelLookup(:,2)'/9.81;
vel_accel = car.longAccelLookup(:,3)';

long_g_braking = car.longDecelLookup(:,1)'/9.81;
lat_g_braking = car.longDecelLookup(:,2)'/9.81;
vel_braking = car.longDecelLookup(:,3)';
    
if plot_choice(1)
    % g-g diagram for different velocities, scatter plot    
    figure
    
    scatter3([lat_g_accel -lat_g_accel -lat_g_braking lat_g_braking],...
        [long_g_accel long_g_accel long_g_braking long_g_braking],...
        [vel_accel vel_accel vel_braking vel_braking],'b');
    title('Velocity-Dependent G-G diagram Scatter Plot','FontSize',18)
    xlabel('Lat G','FontSize',15)
    ylabel('Long G','FontSize',15)
    zlabel('Velocity','FontSize',15)
end

if plot_choice(2) 
    % g-g diagram for different velocities, surface        
    figure
    
    crust_matrix = [lat_g_accel' long_g_accel' vel_accel'
    -lat_g_accel',long_g_accel',vel_accel'
    -lat_g_braking',long_g_braking',vel_braking'
    lat_g_braking',long_g_braking',vel_braking'];

    % crust-based surface reconstruction algorithm, credit Luigi Giaccari
    t = MyCrustOpen(crust_matrix);
    trisurf(t,crust_matrix(:,1),crust_matrix(:,2),crust_matrix(:,3)*2.23694);
    title('Velocity-Dependent G-G Diagram Surface','FontSize',18)
    xlabel('Lateral G','FontSize',16)
    ylabel('Longitudinal G','FontSize',16)
    zlabel('Velocity (mph)','FontSize',16)
end

if plot_choice(3)
    figure
    
    x = lat_g_accel;
    y = vel_accel;
    z = long_g_accel;

    F_accel = scatteredInterpolant([x' y'],z');

    [Xq,Yq] = meshgrid(-2:0.05:2, 5:0.05:max_vel);
    Vq = F_accel(Xq,Yq);
    mesh(Xq,Yq,Vq);
    title('Max Accel (Scattered Interpolant)','FontSize',18)        
    xlabel('Lat G')
    ylabel('Velocity')
    zlabel('Long G')

    hold on
    scatter3(x,y,z);
    xlim([0 2]);
    zlim([0 1.5]);
    hold off
end

if plot_choice(4)
    figure
    
    x = lat_g_braking;
    y = vel_braking;
    z = long_g_braking;

    F_braking = scatteredInterpolant([x' y'],z');

    [Xq,Yq] = meshgrid(-2:0.05:2, 5:0.05:max_vel);
    Vq = F_braking(Xq,Yq);
    mesh(Xq,Yq,Vq);
    title('Max Braking (Scattered Interpolant)','FontSize',18)    
    xlabel('Lat G')
    ylabel('Velocity')
    zlabel('Long G')

    hold on
    scatter3(x,y,z);
    xlim([0 2]);
    zlim([-1.5 0]);
    hold off
end

if plot_choice(5)
    % 2D g-g diagram at specified velocity
    figure    
    
    for i = 1:numel(g_g_vel)
        
        index_accel = vel_accel == g_g_vel(i);
        index_braking = vel_braking == g_g_vel(i);

        scatter([lat_g_accel(index_accel) lat_g_braking(index_braking)...
            -lat_g_braking(index_braking) -lat_g_accel(index_accel)],...
            [long_g_accel(index_accel) long_g_braking(index_braking)...
                long_g_braking(index_braking) long_g_accel(index_accel)],...          
            'DisplayName',sprintf('%d m/s',g_g_vel(i)));
        hold on        
            
        title('G-G Diagram','FontSize',18)
        xlabel('Lat G','FontSize',15)
        ylabel('Long G','FontSize',15)

    end    
    leg = legend('show');
    leg.FontSize = 13;

    hold off
end

