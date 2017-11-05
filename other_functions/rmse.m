% root mean square error
function value = rmse(x,s)

if length(x) ~= length(s)
    error('The real and estimated state vectors must be of same lengths')
else
    e = x - s;
    value = sqrt(1/length(x)*(e')*e);
end
        
end