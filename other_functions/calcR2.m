function R2 = calcR2(x,x_est)
% 'coefficient of determination' or 'variance explained'
R2 = 1 - sum((x-x_est).^2)/sum((x-mean(x)).^2);
% if R2<0
%     error('R2<0')
% end
