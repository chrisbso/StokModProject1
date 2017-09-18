function problem1c
format short;
rng('shuffle');                 % initialize random generator with different seed every run
n = 30;                         % # of participants
bMax = 1000;                    % # of realizations
k = floor(n/exp(1));            % optimal stopping rule
x = rand(bMax,n);               % list of x_i's for every realization per row.

m = 0;                          % # of times the strategy gives the best candidate.
p = 0;                          % # of times the strategy gives candidate among top three
q = 0;                          % # of times the strategy gives you candidate x_n (the last candidate).
for i = 1:bMax
    
    maxIndex = find(x(i,:) == max(x(i,:)));
    
    if length(maxIndex) > 1                          % if there are several participants with the highest value
        if length(maxIndex(maxIndex > k)) > 1        % if x_best exists to the right of k, find the first one after k
            maxIndex = maxIndex(maxIndex > k);
            maxIndex = maxIndex(1);
        else                                         %else it has to be to the left of k
            maxIndex = maxIndex(1);
        end
    end
   
    % if (x_best is not left of x_k) AND (there are no participant between the right of x_k and x_best for which (x_{k<i<maxIndex} > x_k) ),then the best participant is chosen.
    if (maxIndex > k) && (sum(x(i,k+1:maxIndex-1) > max(x(i,1:k))) == 0 )
        m = m + 1; %%strategy worked.
    end
    
    xSorted = sort(x(i,:));
    x_top3 = xSorted(end-2);
    
    if sum( (x(i,k+1:end) >= x_top3)) > 0 
        p = p + 1; %%strategy worked.
        continue; %%no reason to check if we get the last candidate
    end
    
    if sum( (x(i,k+1:end) <= max(x(i,k)))) == 0
        q = q + 1;
    end
        
    
    
end

fprintf('For %i realizations, with a total of %i participants,\nThe # of times the strategy gave the best result was %i / %d ~= %.4f,\n', bMax,n,m,bMax,m/bMax);
fprintf('while the probability is (k/n)*ln(n/k) = %.4f.\n',k/n*log(n/k));
fprintf('The # of times the strategy gave us one of the top three candidates was %i / %d ~= %.4f,\n', p,bMax,p/bMax);
fprintf('The # of times the strategy gave us the last candidate was %i / %d ~= %.4f,\n', q,bMax,q/bMax);

end

