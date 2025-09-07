%% EPGA移民操作

function subPops= migrateEPGA(subPops, params, plant)  
numSubPops = length(subPops);
subPopSize = params.popSize/numSubPops;
migrationRatio = 0.15;
migrantsPerLink = 2;
allMigrants = cell(numSubPops);

%阶段1:收集精英移民
for i = 1:numSubPops
    fitness = cellfun(@(ind) fitnessFunction(ind, plant), subPops{i});
    [~, idx] = sort(fitness);
    numMigrants = ceil(subPopSize*migrationRatio);
    elites = subPops{i}(idx(1:numMigrants));
    
    for j = 1:numSubPops
        if j ~= i
            allMigrants{i,j} = elites(1:min(migrantsPerLink, length(elites)));
        end
    end
end

%阶段2:全连接迁移
for receiver = 1:numSubPops
    incomingMigrants = {};
    for sender = 1:numSubPops
        if sender ~= receiver && ~isempty(allMigrants{sender, receiver})
            incomingMigrants = [incomingMigrants; allMigrants{sender, receiver}(:)];
        end
    end
    
    if ~isempty(incomingMigrants)
        fitness = cellfun(@(ind) fitnessFunction(ind, plant), subPops{receiver});
        [~, worstIdx] = maxk(fitness, length(incomingMigrants));
        replaceNum = min(length(worstIdx), length(incomingMigrants));
        subPops{receiver}(worstIdx(1:replaceNum)) = incomingMigrants(1:replaceNum);
    end
end

%阶段3:多样性增强
for i = 1:numSubPops
    diversityRatio = 0.05;
    numNew = ceil(subPopSize*diversityRatio);
    newInds = initializePopulation(numNew, params);
    
    fitness = cellfun(@(ind) fitnessFunction(ind, plant), subPops{i});
    [~, worstIdx] = maxk(fitness, numNew);
    subPops{i}(worstIdx) = newInds;
end
end