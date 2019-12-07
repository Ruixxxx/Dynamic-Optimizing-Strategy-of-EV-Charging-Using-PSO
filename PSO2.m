function[info,fv] = PSO2(N,c1,c2,w,M,knownEV_info,k,n,timeInterval,load_grid)
% info EVs with the start times which give the smallest fitness value
% fv the smallest fitness value

% c1,c2 learning factor
% w inertia weight
% M maximum number of iterations
% D number of vehicles needed to be arranged   %need to be changed to vinfo
% N number of particles
% k kth interval to be arranged

% EVs with manageable start time
aEV = knownEV_info(find(knownEV_info(:,5) >= (k-1)*timeInterval),:);
%
bEV = knownEV_info(find(knownEV_info(:,5) < (k-1)*timeInterval),:);

% initalize particles

for i = 1:N
    for j=1:length(aEV(:,5))
        x(i,j) = aEV(j,2) + (aEV(j,4) - aEV(j,3)- aEV(j,2))*rand;
%         x(i,j) = 0;
%         while (x(i,j) < (k-1)*15) || (x(i,j) > (aEV(j,4) - aEV(j,3)))
%             x(i,j) = randn*12*60; % initialize the start time of vehicles
%         end
        v(i,j) = randn; % initialize the speed
    end
end

% calculate the fitness and initialize particle optimal and global optimal
for i=1:N
    aEV(:,5) = x(i,:)';
    vehicle_info = sortrows([aEV;bEV],1);
    p(i) = fitness(vehicle_info,n,load_grid);
    y(i,:) = x(i,:);
end
% find the global optimal
pg = x(N,:);
vg = p(N);
for i=1:(N-1)
    if(p(i)<vg)
        pg = x(i,:);
        vg = p(i);
    end
end


% main iteration
for t=1:M
    for i=1:N  % update the speed and the start time
        v(i,:)=w*v(i,:)+c1*rand*(y(i,:)-x(i,:))+c2*rand*(pg-x(i,:));
        
        for j=1:length(aEV(:,5))
            if ((x(i,j)+v(i,j)) >= aEV(j,2)) &&  ((x(i,j)+v(i,j)) <= (aEV(j,4) - aEV(j,3)))
                x(i,j) = x(i,j)+v(i,j);
            end
        end
        
        aEV(:,5) = x(i,:)';
        vehicle_info = sortrows([aEV;bEV],1);
        if fitness(vehicle_info,n,load_grid) < p(i)
            p(i)=fitness(vehicle_info,n,load_grid);
            y(i,:) = x(i,:);
        end
        if p(i) < vg
            pg = y(i,:);
            vg = p(i);
        end
    end
    Pbest(t) = vg;
end

% result
aEV(:,5) = pg';
info = sortrows([aEV;bEV],1);
fv = vg;

