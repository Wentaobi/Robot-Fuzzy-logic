function MembershipPlot(Vmin,Vmax)
Far = [];
Close = [];
VeryClose = [];
for V=0:0.1:5 
    [Obstacles MF] = IRReading(V,Vmax,Vmin);
    Far = [Far,MF.Far];
    Close = [Close,MF.Close];
    VeryClose = [VeryClose,MF.VeryClose];
end
hold on
grid on
v = 0:0.1:5;
plotFar = plot(v,Far,'Color','r','Linewidth',3);
plotClose = plot(v,Close,'Color','b','Linewidth',3);
plotVeryClose = plot(v,VeryClose,'Color','m','Linewidth',3);
legend([plotFar plotClose plotVeryClose],'Far','Close','Very Close');
title('Membership Functions','FontSize',16);
end