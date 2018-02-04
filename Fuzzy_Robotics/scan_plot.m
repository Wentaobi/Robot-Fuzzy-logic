function scan_plot(~,msgs)
    steps=length(msgs.Ranges);
    max_ang=msgs.AngleMax+0.5*pi;
    min_ang=msgs.AngleMin+0.5*pi;
    scan_info=msgs.Ranges';
    idx=scan_info>=8;
    scan_info(idx)=8;
    polar(linspace(min_ang,max_ang,steps),scan_info);
end