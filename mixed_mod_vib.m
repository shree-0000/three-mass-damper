fprintf('Follow this equation: w^2[M]{x} = [k]{x}\n');

M_matrix = input('Enter the mass matrix\n');
k_matrix = input('Enter the stiffness matrix\n');

static_disp_vec = input('Enter the static diaplacement vector (nx1)\n');
initial_disp_vec = input('Enter the initial diaplacement vector(nx1)\n');
initial_vel_vec = input('Enter the initial velocity vector (nx1)\n');

[eigen_vec, eigen_val] = eig(k_matrix, M_matrix);

mod_shapes = eigen_vec
nat_freqs = [];
for i = 1:length(eigen_vec(1, :))
    nat_freqs = [nat_freqs eigen_val(i, i)];
end
nat_freqs = sqrt(nat_freqs)

A_coff = [];
B_coff = [];
for j = 1:length(mod_shapes(1, :))
    A_r = (mod_shapes(:, j)')*M_matrix*initial_disp_vec;
    A_coff = [A_coff A_r];
    
    B_r = ((mod_shapes(:, j)')*M_matrix*initial_vel_vec)/(nat_freqs(j));
    B_coff = [B_coff B_r];
end

time = linspace(0, 50, 500);
ith_disp_function = [];
for i = 1:length(eigen_vec(:, 1))
    ith_disp_function = [ith_disp_function; linspace(0, 0, length(time))];
    for j = 1:length(mod_shapes(1, :))
        ith_disp_function(i,:) = ith_disp_function(i,:) + (A_coff(j)*cos(nat_freqs(j)*time) + B_coff(j)*sin(nat_freqs(j)*time))*mod_shapes(i, j);
    end
    ith_disp_function(i,:) = static_disp_vec(i, 1) + ith_disp_function(i,:);
%     subplot(length(eigen_vec(:, 1)), 1, i)
%     plot(time, ith_disp_function(i,:))
end

%     this is to plot the static indvusal responces along with the dynamic
%     systen responce

 for i = 1:length(eigen_vec(:, 1))
    if 0
        break
    end
    subplot(length(eigen_vec(:, 1)), 2, (2*length(eigen_vec(:, 1))-(2*i-1)))
    plot(time, ith_disp_function(i,:))
    if i == 1
        xlabel('time (sec)')
    end
    ylabel('x (m)')
    title(['mass no.', num2str(i)])
    grid on
    hold on
 end 
 
%   this loop should be manually handeled for system having masses other than 3
for l = 1:length(time)
    
%   put 1 inplace of 0 and uncomment the plot lines in the above for loop to just plot the static indisvual responce    
    if 0
        break
    end
    
    subplot(length(eigen_vec(:, 1)), 2, [2,2*length(eigen_vec(:, 1))]);
    
    for i = 1:length(eigen_vec(:, 1))
        plot(linspace(0.75, 1.25, 50), linspace(static_disp_vec(i), static_disp_vec(i), 50), '--k')
        hold on
        plot(ith_disp_function(i,l),'s', 'LineWidth', 2, 'MarkerEdgeColor' , 'k', 'MarkerSize', 30)
        if i ~= length(eigen_vec(:, 1))
            grid on
            hold on
        end

        axis([0.75 1.25 (min(ith_disp_function(1,:))-5) (max(ith_disp_function(length(eigen_vec(:, 1)),:))+5)])
        ylabel('Displacement (m)')
    end
    
    title('system responce')
    pause(0.00000000001)
    
    if l ~= length(time)
        cla
    end
end
