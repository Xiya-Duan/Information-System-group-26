% Course: Information Systems
% Association Rule Analysis with Apriori
% Author: Dr. George Azzopardi
% Date: December 2019

% input parameters: minsup = minimum support, minconf = minimum confidence
function associationRulesedit(minsup,minconf)
shoppingList = readDataFile;
% Create the histogram
ntrans = size(shoppingList,1);
[items, ia, ic] = unique([shoppingList{:}]);
% C = categorical(ic, 1:1:169, items);
% histogram(C);
xtickangle(60);

nitems = numel(items);

[tridx,trlbl] = grp2idx(items);

% Create the binary matrix
dataset = zeros(ntrans,nitems);
for i = 1:ntrans
   dataset(i,tridx(ismember(items,shoppingList{i}))) = 1;
end

% Generate frequent items of length 1
support{1} = sum(dataset)/ntrans;
f = find(support{1} >= minsup);
frequentItems{1} = tridx(f);
support{1} = support{1}(f);

% Generate frequent item sets
k = 1;
while k < nitems && size(frequentItems{k},1) > 1
    % Generate length (k+1) candidate itemsets from length k frequent itemsets
    frequentItems{k+1} = [];
    support{k+1} = [];
    
    % Consider joining possible pairs of item sets
    for i = 1:size(frequentItems{k},1)-1
        for j = i+1:size(frequentItems{k},1)
            if k == 1 || isequal(frequentItems{k}(i,1:end-1),frequentItems{k}(j,1:end-1))
                candidateFrequentItem = union(frequentItems{k}(i,:),frequentItems{k}(j,:));  
                if all(ismember(nchoosek(candidateFrequentItem,k),frequentItems{k},'rows'))                
                    sup = sum(all(dataset(:,candidateFrequentItem),2))/ntrans;                    
                    if sup >= minsup
                        frequentItems{k+1}(end+1,:) = candidateFrequentItem;
                        support{k+1}(end+1) = sup;
                    end
                end
            else
                break;
            end            
        end
    end         
    k = k + 1;
end
% load('confidences.mat'
tic
confidences =  [];
% Generate association rules. To be implemented by students
% j control the layer of frequentItemList
for j = 2:k-1
    for i = 1:length(frequentItems{j})
        currentItem = frequentItems{j}(i, :);
        % generate all combinations of frequentItems to get rules
        antecedents = nchoosek(currentItem, j-1);
        for k = 1:length(antecedents)
            antecedent = antecedents(k,:);
            % compute the symmetric difference of currentItem and
            % antecedent to obtain the consequent
            consequent = setxor(currentItem, antecedent);
            %{
            % no anti-monotone property        
            for l = 0:j-2
                currentItem(j-l) = [];        

                Items2index = find(ismember(frequentItems{j-1-l}, currentItem, 'rows'));
                confidence = support{j}(i) / support{j-1-l}(Items2index);
                if confidence < minconf
                    continue;
                end
            end
            confidences = [confidences; [confidence j i l]];
            %}
            % with anti-monotone property
            Items2index = find(ismember(frequentItems{j-1}, antecedent, 'rows'));
                confidence = support{j}(i) / support{j-1}(Items2index);
                if confidence < minconf
                    continue;
                end
            confidences = [confidences; [confidence j Items2index consequent]];
        end
    end
end

confidences = sortrows(confidences,1,'descend');
toc

rules = strings(30, 1);
for k = 1:30
    current = confidences(k, :);
    conf = current(1);
    j = current(2);
    i = current(3);
    antecedent = frequentItems{j-1}(i, :);
%     antecedent = frequentItems{j}(i, :);
    consequent = current(4);
%     antecedent(j) = [];
%     consequent = frequentItems{j}(i, :);
    ant = join(items(antecedent), ', ');
    con = join(items(consequent), ', ');
    rule = sprintf('%d. %s => %s [conf=%d]',...
        k, char(ant), char(con), conf);
    rules(k) = rule;
    disp(rule);
end

save('confidences.mat', 'confidences','support','frequentItems','items');
disp('end');