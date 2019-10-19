%AM115 Final Project - Individual Agent Sector Investment: INVESTMENT IN
%GIVEN FIRM LEVEL SIMULATION 

%population/firm initialization 
incomelevels = 4;
indperlev = 100;
years = 50;
firmsperlev = 10;
familysize = 6;


%Firm size transition matrix : http://www.jadafea.com/wp-content/uploads/2015/12/JAD_vol17-2_ch3.pdf
T1 = [0.66 0.21 0.08 0.04;
     0.19 0.44 0.15 0.22;
     0.08 0.18 0.31 0.43;
     0.01 0.01 0.08 0.90];
     

%savings rates for each quartile
savings = [.014 .02 .06 .12];


%consumption by quintile for Sierra Leone 
%https://archive.lib.msu.edu/DMC/African%20Working%20Papers/AREP/AREP16/AREP16.pdf
%consumption of quintile 1
sq1 = [.266 .535 .043 .019];
%consumption of quintile 2
sq2 = [.260 .522 .056 .02];
%consumption of quintile 3
sq3 = [.257 .476 .062 .021];
%consumption of quintile 4
sq4 = [.254 .509 .069 .021]; 

% % % % % % % % % % % % % % %%%consuming of all quintile one products by every other quintile 
% % % % % % % % % % % % % % ssq1 = [.266 .260 .257 .254]; %consumption of q1 products by q1 q2 q3 q4
% % % % % % % % % % % % % % ssq2 = [.535 .522 .476 .509]; %consumption of q2 products by q1 q2 q3 q4
% % % % % % % % % % % % % % ssq3 = [.043 .056 .062 .069]; %consumption of q3 products by q1 q2 q3 q4
% % % % % % % % % % % % % % ssq4 = [.019+.135 .02+.141 .021+.144 .021+.147]; %consumption of q4 products by q1 q2 q3 q4
% % % % % % % % % % % % % % 
% % % % % % % % % % % % % % SQX = [.266 .260 .257 .254;
% % % % % % % % % % % % % %       .535 .522 .476 .509;
% % % % % % % % % % % % % %       .043 .056 .062 .069;
% % % % % % % % % % % % % %       .019+.135 .02+.141 .021+.144 .021+.147];
  

%%%%% exporting share by firm size  %%%%%

k = [20/25 3/25 1/25 1/25];
expshare = ones(incomelevels, firmsperlev) .* k';

%%%%%%%%%TARIFF RANGE INITIALIZATION%%%%%%%
Investment = [ 0.12 0 0 0;
               0 0.12 0 0;
               0 0 0.12 0;
               0 0 0 0.12];
inv = 4;
%gdptariff = zeros(years, Tmag);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%SIMULATION%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

simulations = 10;



for x = 1:simulations

        gdpinvestment = zeros(years, inv);

        for c = 1:inv
                %%%%%%%%%%%%%%%%%%%%%%REINITIALIZATION%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %reinitialization
                pop = ones(incomelevels, indperlev); 
                pop(2,:) = 2;
                pop(3,:) = 3;
                pop(4,:) = 4;

                %%%%%plotting matrices: 
                firmplot = zeros(years, incomelevels);
                wealthplot = zeros(years, incomelevels);
                gdpplot = zeros(years, incomelevels);

                %reinitializing wagesincome 
                wagesincome = [1.5*260 5.75*260 15.75*260 25*260];

                %reinitializing each firms income per year 
                ssq1 = [.266 .260 .257 .254]; %consumption of q1 products by q1 q2 q3 q4
                ssq2 = [.535 .522 .476 .509]; %consumption of q2 products by q1 q2 q3 q4
                ssq3 = [.043 .056 .062 .069]; %consumption of q3 products by q1 q2 q3 q4
                ssq4 = [.019+.135 .02+.141 .021+.144 .021+.147];
                
                SQX = [.266 .260 .257 .254;
                .535 .522 .476 .509;
                .043 .056 .062 .069;
                .019+.135 .02+.141 .021+.144 .021+.147];
                
                %initialization of firm productivity given size/income level
                OutputProd = [1 1.075 1.2 1.3];
                
                %firmincome = zeros(incomelevels, indperlev); 
                %firmincome = zeros(incomelevels, firmsperlev);
                firmincome = ones(incomelevels, firmsperlev);
                firmincome(1,:) = firmincome(1,:) .* (OutputProd(1)).*((sum((wagesincome .* (1.-savings) .* ssq1).* indperlev)/firmsperlev) - ((wagesincome(1) .* (indperlev/familysize))/firmsperlev));
                firmincome(2,:) = firmincome(2,:) .* (OutputProd(2)).*((sum((wagesincome .* (1.-savings) .* ssq2).* indperlev)/firmsperlev) - ((wagesincome(2) .* (indperlev/familysize))/firmsperlev));
                firmincome(3,:) = firmincome(3,:) .* (OutputProd(3)).*((sum((wagesincome .* (1.-savings) .* ssq3).* indperlev)/firmsperlev) - ((wagesincome(3) .* (indperlev/familysize))/firmsperlev));
                firmincome(4,:) = firmincome(4,:) .* (OutputProd(4)).*((sum((wagesincome .* (1.-savings) .* ssq4).* indperlev)/firmsperlev) - ((wagesincome(4) .* (indperlev/familysize))/firmsperlev));

                wealth = zeros(incomelevels, indperlev);
                manugdp = zeros(years, 1);
                
                
                %%%%%%%%%%%%%%%%%%%%%%REINITIALIZATION%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                %%%%productivity output by firm level compared with income level 1 output 
                OutputProd = [1+Investment(c,1) 1.075+Investment(c,2) 1.2+Investment(c,3) 1.3+Investment(c,4)];
                

                for i = 1:years

                        for r = 1:incomelevels %for each individual in each income level at year i
                            %%%%%%%%%%%%%%%%%%%%
                            %wagesincome = [1.5*260 5.75*260 15.75*260 25*260];
                            %changing wages based on firm output, and probability of
                            %individual switching from smaller firm to bigger firm or vice
                            %versa
                            rnd = rand(1.0);
                            if (wagesincome(r) == 1.5 * 260) %%%%% <========= maybe change to firm output levels? 
                                if (rnd < T1(1,2))
                                    wagesincome(r) = 5.75 * 260;
                                elseif (rnd < T1(1,3))
                                    wagesincome(r) = 15.75 * 260;
                                elseif (rnd < T1(1,4))
                                    wagesincome(r) = 25 * 260;
                                else
                                    wagesincome(r) = 1.5 * 260; 
                                end
                            end
                            rnd = rand(1.0);
                            if (wagesincome(r) == 5.75 * 260)
                                if (rnd < T1(2,1))
                                    wagesincome(r) = 1.5 * 260;
                                elseif (rnd < T1(2,3))
                                    wagesincome(r) = 15.75 * 260;
                                elseif (rnd < T1(2,4))
                                    wagesincome(r) = 25 * 260;
                                else
                                    wagesincome(r) = 5.75 * 260; 
                                end
                            end
                            rnd = rand(1.0);
                            if (wagesincome(r) == 15.75 * 260)
                                if (rnd < T1(3,1))
                                    wagesincome(r) = 1.5 * 260;
                                elseif (rnd < T1(3,2))
                                    wagesincome(r) = 5.75 * 260;
                                elseif (rnd < T1(3,4))
                                    wagesincome(r) = 25 * 260;
                                else
                                    wagesincome(r) = 15.75 * 260; 
                                end
                            end
                            rnd = rand(1.0);
                            if (wagesincome(r) == 25 * 260)
                                if (rnd < T1(4,1))
                                    wagesincome(r) = 1.5 * 260;
                                elseif (rnd < T1(4,2))
                                    wagesincome(r) = 5.75 * 260;
                                elseif (rnd < T1(2,4))
                                    wagesincome(r) = 15.75 * 260;
                                else
                                    wagesincome(r) = 25 * 260; 
                                end
                            end


                            %%%%%%%%%%%%%%%%%%%%
                            for b = 1:firmsperlev 

                                %calculating firm income after every year = prior income + sales - laborcosts  
                                firmincome(r,b) = firmincome(r,b) + (OutputProd(r)).*(sum((wagesincome .* (1.-savings) .* SQX(r,:).* indperlev)/firmsperlev)) - ((wagesincome(r) .* (indperlev/familysize))/firmsperlev) + (expshare(r,b).* manugdp(i));

                            end


                            for a = 1:indperlev

                                %aggregating total wealth for each individual in each income
                                %level 
                                wealth(r,a) = wealth(r,a) + (wagesincome(pop(r,a)) * savings(pop(r,a))); % + firmincome(r,a);


                            end

%                             firmplot(i,r) = firmincome(r,1);
%                             wealthplot(i,r) = wealth(r,1);
%                             gdpplot(i,r) = firmplot(i,r) + wealthplot(i,r);

                        end

                manugdp(i) = sum(sum(wealth') + sum(firmincome'));
                gdpinvestment(i,c) = manugdp(i); 

                end 


        end


        plot(gdpinvestment(:,1), 'b*');
        hold on;
        plot(gdpinvestment(:,2), 'Color', 'g');
        plot(gdpinvestment(:,3), 'r*');
        plot(gdpinvestment(:,4), 'Color', 'k');
        xlabel('Years (increments of 4 years)');
        ylabel('Manufacturing Gross Domestic Product by Investment Type')
        legend('Low-Income Firm Investment','Low-Mid Income Firm Investment', 'Mid-Income Firm Investment', 'High-Income Firm Investment');
        
end  


hold off; 
