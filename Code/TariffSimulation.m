%AM115 Final Project - Individual Agent Sector Investment: TARIFF
%SIMULATION 

%population/firm initialization 
incomelevels = 4;
indperlev = 100;
years = 50;
firmsperlev = 10;
familysize = 6;

%%%%productivity output by firm level compared with income level 1 output 
OutputProd = [1 1.075 1.2 1.3];


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
Tarrif = [0 .10 .20 .35 .45 .65 .82 .91 .100 .107 .115 .123 .130 .135 .142]; 
Tmag = 15;
%gdptariff = zeros(years, Tmag);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%SIMULATION%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

simulations = 3;



for x = 1:simulations

        gdptariff = zeros(years, Tmag);

        for t = 1:Tmag
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
                ssq4 = [.019 .02 .021 .021];
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

                %%%consuming of all quintile one products by every other quintile 
                ssq1 = [.266 .260 .257 .254]; %consumption of q1 products by q1 q2 q3 q4
                ssq2 = [.535 .522 .476 .509]; %consumption of q2 products by q1 q2 q3 q4
                ssq3 = [.043 .056 .062 .069]; %consumption of q3 products by q1 q2 q3 q4
                ssq4 = [.019+Tarrif(t) .02+Tarrif(t) .021+Tarrif(t) .021+Tarrif(t)]; %consumption of q4 products by q1 q2 q3 q4

                SQX = [.266 .260 .257 .254;
                      .535 .522 .476 .509;
                      .043 .056 .062 .069;
                      .019+Tarrif(t) .02+Tarrif(t) .021+Tarrif(t) .021+Tarrif(t)];


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
                gdptariff(i,t) = manugdp(i); 

                end 


        end


%         plot(firmplot(:,1), 'Color', 'b');
%         hold on;
%         plot(firmplot(:,2), 'Color', 'g');
%         plot(firmplot(:,3), 'Color', 'r');
%         plot(firmplot(:,4), 'Color', 'k');
%         xlabel('Years (increments of 4 years)'); % x-axis label
%         ylabel('Firm Wealth in $'); % y-axis label
%         legend('Q1','Q2', 'Q3','Q4');


%         plot(wealthplot(:,1), 'Color', 'b');
%         hold on;
%         plot(wealthplot(:,2), 'Color', 'g');
%         plot(wealthplot(:,3), 'Color', 'r');
%         plot(wealthplot(:,4), 'Color', 'k');
%         xlabel('Years (increments of 4 years)'); % x-axis label
%         ylabel('Individual Wealth in $'); % y-axis label
%         legend('Q1','Q2', 'Q3','Q4');

%         plot(gdptariff(:,1), 'Color', 'b');
%         hold on;
%         plot(gdptariff(:,2), 'Color', 'g');
%         plot(gdptariff(:,3), 'Color', 'r');
%         plot(gdptariff(:,4), 'Color', 'k');
%         xlabel('Years (increments of 4 years)'); % x-axis label
%         ylabel('GDP per Manufacturing Sector in $'); % y-axis label
%         legend('Q1','Q2', 'Q3','Q4');
        
%         plot(gdptariff);
%         hold on;
        plot(gdptariff(:,1), 'Color', 'b');
        hold on;
        plot(gdptariff(:,2), 'Color', 'g');
        plot(gdptariff(:,3), 'r*');
        plot(gdptariff(:,4), 'Color', 'k');
        plot(gdptariff(:,5), 'Color', 'y');
        plot(gdptariff(:,6), 'Color', 'c');
        plot(gdptariff(:,7), 'Color', 'm');
        plot(gdptariff(:,8), 'g*');
        plot(gdptariff(:,9), 'b--o');
        plot(gdptariff(:,10), 'g--o');
        plot(gdptariff(:,11), 'r--o');
        plot(gdptariff(:,12), 'k--o');
        plot(gdptariff(:,13), 'y--o');
        plot(gdptariff(:,14), 'c--o');
        plot(gdptariff(:,15), 'c*');
        xlabel('Years (increments of 4 years)');
        ylabel('Manufacturing Gross Domestic Product by tariff')
        legend('T15','T14', 'T13', 'T12', 'T11', 'T10', 'T9', 'T8', 'T7', 'T6', 'T5', 'T4', 'T3', 'T2', 'T1');
        
end  


hold off; 