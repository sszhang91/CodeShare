function out = sp_correctdrift_ssz(z,plotflag)
%correct drift of scan
%line up scanned edge to physical edge
d = diff(z,1,2);

[~,j] = max(abs(d),[],2);

out = zeros(size(z));
for m = 1:size(z,1)
    %circshift sufficient for line as long as initial scan has sufficient x
    out(m,:) = circshift(z(m,:),-j(m) + round(mean(j)),2);

end
%plot the shifted if specified
if nargin>1
    figure();s=pcolor(out);
    set(s,'EdgeColor','none');    
end