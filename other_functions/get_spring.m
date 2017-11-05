function spring_out = get_spring(spring,label)
% function to load the data of a single spring ('label') from the big
% structure ('spring') to the single structure ('spring_out')
for nn = 1:length(spring)
    spr_lab = spring(nn).label;
    if strcmp(spr_lab,label)
        spring_out = spring(nn);
    end
end