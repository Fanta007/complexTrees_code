function [tr,boot]  = phytree_read(filename)
% phytree_read reads a NEWICK tree formatted file.
%
%  TREE = PHYTREEREAD(FILENAME) reads a NEWICK tree formatted file
%  FILENAME, returning the data in the file as a PHYTREE object. FILENAME
%  can also be a URL or MATLAB character array that contains the text of a
%  NEWICK format file.
%
%  [TREE,BOOT] = PHYTREEREAD(FILENAME) returns bootstrap values when they
%  are specified either with square brackets ([]) after the branch or leaf
%  lengths or if they appear instead of the branch labels. Bootstrap values
%  that do not appear in the file default to NaN. 
%
%  The NEWICK tree format is found at:
%        http://evolution.genetics.washington.edu/phylip/newicktree.html
%
%  Note: This implementation only allows binary trees, non-binary trees
%  will be translated into a binary tree with extra branches of length 0.
%
%   Example:
%
%      tr = phytreeread('pf00002.tree')
%
%   See also GETHMMTREE, PHYTREE, PHYTREETOOL, PHYTREEWRITE.

% Copyright 2003-2008 The MathWorks, Inc.
% $Revision: 1.1.6.17 $ $Author: batserve $ $Date: 2010/10/08 16:34:53 $

strin = textscan(filename,'%s','delimiter','\n');%,'BufSize',1000000);

strinESC = strin{1}{1};
strin = strinESC;
%设置叶子节点数，枝干（非叶子）节点数，标记数
numBranches = sum(strinESC==',');
numLeaves   = numBranches + 1;
numLabels   = numBranches + numLeaves;

if (numBranches == 0)
    error('Bioinfo:phytreeread:NoCommaInInputString', ...
        ['There is not any comma in the data.\nInput string may not '...
        'be in Newick style or is not a valid filename.'])
end

% Find the string features: open and close parentheses and leaves
% e.g. strFeatures -> ((rb)((ss)((mc)w))d)
leafPositions = regexp(strinESC,'[(,][^(,)]')+1;
% any character contained within the bracket : ( or )
% 找到圆括号的位置索引
parenthesisPositions = regexp(strinESC,'[()]');  
strFeatures = strinESC(sort([leafPositions parenthesisPositions]));

% Some consistency checking on the parenthesis
temp = cumsum((strFeatures=='(') - (strFeatures==')'));
if any(temp(1:end-1)<1) || (temp(end)~=0)
    error('Bioinfo:phytreeread:InconsistentParentheses',...
        'The parentheses structure is inconsistent.\nInput string may not be in Newick style or is not a valid filename.')
end

dist = zeros(numLabels,1);             % allocating space for distances
tree = zeros(numBranches,2);           % allocating space for tree pointers
names = cell(numLabels,1);             % allocating space for tree labels
boot = cell(numLabels,1);             % allocating space for bootstrapping vals

try

    %----------------------------------------------------------------------
    % extract label information for the leaves
    st = regexp(strinESC,'[(,][^(,);]+','start');
    en = regexp(strinESC,'[(,][^(,);]+','end');
    for j=1:numel(st)    % st里面有20个元素

        ele_str = strinESC(st(j)+1:en(j));  
        ori_str = strin(st(j)+1:en(j));
        % find out if there is a bootstrap value within []
%         bootstr = regexp(ele_str,'\[[\d\.]*\]','match','once')
%         bootstr = regexp(ele_str,'\[[\d\.]*\]','match','once');
        left = find(ele_str == '[');
        right = find (ele_str == ']');
        bootstr = ele_str(left:right);
        
        %把bootstr中括号中的branch点的坐标值写到boot{j}之中
        if ~isempty(bootstr)
            boot{j} = bootstr(2:end-1);     %把枝干信息写到boot{j}中，注意这里boot{j}存的是字符串
            ele_str = strrep(ele_str,bootstr,'');
            ori_str = strrep(ori_str,bootstr,'');
        end
        
        coi = find(ele_str==':',1,'last');
        
        if isempty(coi) % if no colon no length, the whole label is the name
            dist(j) = 0;
            names{j} = strin(st(j)+1:en(j));
        else % if there is colon, get name and length
            dist(j) = 1;%strread(ori_str(coi+1:end),'%f')
            names{j} = ori_str(1:coi-1) ; % 记录这个node所对应的名字 如R1，L1等
        end
        
    end
    %----------------------------------------------------------------------
    
    % uniformizing empty cells, value inside the brackets can never be empty
    % because branch names will always be empty
    [names{cellfun('isempty',names)}] = deal('');

    % extract label information for the parenthesis
    st = regexp(strinESC,')[^(,);]*','start');
    en = regexp(strinESC,')[^(,);]*','end');
    parenthesisDist = zeros(numel(st),1);
    parenthesisData = cell(numel(st),1);
    parenthesisBoot = cell(numel(st),1);
    for j=1:numel(st)
        ele_str = strinESC(st(j)+1:en(j));
        ori_str = strin(st(j)+1:en(j));
        % find out if there is a bootstrap value within []
        left = find(ele_str == '[');
        right = find (ele_str == ']');
        bootstr = ele_str(left:right);
        if ~isempty(bootstr)

            parenthesisBoot{j} = bootstr(2:end-1);
            ele_str = strrep(ele_str,bootstr,'');
            ori_str = strrep(ori_str,bootstr,'');
        end

        coi = find(ele_str==':',1,'last');
        if isempty(coi) % if no colon no length, the whole label is the name
            parenthesisDist(j) = 0;
            parenthesisData{j} = ori_str;
        else % 将父子结点之间的距离默认为1
            parenthesisDist(j) = 1; 
            parenthesisData{j} = ori_str(1:coi-1);
        end
    end
    
    %----------------------------------------------------------------------
    % uniformizing empty cells, value inside brackes may be empty
    if any(cellfun('isempty',parenthesisData))
        [parenthesisData{cellfun('isempty',parenthesisData)}] = deal('');
    end

    li = 1; bi = 1; pi = 1;                  % indexes for leaf, branch and parentheses
    queue = zeros(1,2*numLeaves); qp = 0;    % setting the queue (worst case size)

    j = 1;
    
    %   strFeatures存储的是括号加R和L
    while j <= numel(strFeatures)
        switch strFeatures(j)
            case ')' % close parenthesis, pull values from the queue to create
                % a new branch and push the new branch # into the queue
                lastOpenPar = find(queue(1:qp)==0,1,'last');
                numElemInPar = min(3,qp-lastOpenPar);
                switch numElemInPar
                    case 2  % 99% of the cases, two elements in the parenthesis
                        bp = bi + numLeaves;
                        names{bp} = parenthesisData{pi};      % set name
                        dist(bp) = parenthesisDist(pi);       % set length
                        boot{bp} = parenthesisBoot{pi};       % set bootstrap
                        tree(bi,:) = queue(qp-1:qp);
                        qp = qp - 2; % writes over the open par mark
                        queue(qp) = bp;
                        bi = bi + 1;
                        pi = pi + 1;
                    case 3  % find in non-binary trees, create a phantom branch
                        bp = bi + numLeaves;
                        names{bp} = '';      % set name
                        dist(bp) = 0;        % set length
                        boot(bp) = NaN;        % set bootstrap
                        tree(bi,:) = queue(qp-1:qp);
                        qp = qp - 1; % writes over the left element
                        queue(qp) = bp;
                        bi = bi + 1;
                        j = j - 1; %repeat this closing branch to get the rest
                    case 1  % parenthesis with no meaning (holds one element)
                        qp = qp - 1;
                        queue(qp) = queue(qp+1);
                        pi = pi + 1;
                    case 0  % an empty parenthesis pair
                        error('Bioinfo:phytreeread:ParenthesisPairWithNoData', ...
                            ['Found parenthesis pair with no data.\n', ...
                            'Input string may not be in Newick style or',...
                            'is not a valid filename.'])
                end % switch numElemInPar

            case '(' % an open parenthesis marker (0) pushed into the queue
                qp = qp + 1;
                queue(qp) = 0;

            otherwise % a new leaf pushed into the queue
                qp = qp + 1;
                queue(qp) = li;
                li = li + 1;
        end % switch strFeatures
        j = j + 1;
    end % while j ...

catch le
    if strcmp(le.identifier,'Bioinfo:phytreeread:ParenthesisPairWithNoData')
        rethrow(le)
    else
        error('Bioinfo:phytreeread:IncorrectString',...
            ['An error occurred while trying to interpret the data.\n'...
            'Input string may not be in Newick style or is not a '...
            'valid filename.'])
    end
end

% Remove all escape characters
names = regexprep(names,'\\([\(\):;,])','$1');

% some formats store bootstrap values instead of for branches instead of branch names,
% check here that all branch names can be converted to numbers and if so,
% consider them as bootstrap values:
if isequal(regexp(names(numLeaves+1:end),'[\d\.]+','match','once'),names(numLeaves+1:end))
    for j = numLeaves+(1:numBranches)
        if ~isempty(names{j})
           boot(j) = strread(names{j},'%f');
           names{j} = '';
        end
    end
end

% make sure all dists are greater than 0
dist = max(0,dist);
parenthesisPositions;
if sum(dist) == 0  % there was no distance information so force to an unitary ultrametric tree
    tr = phytree(tree,names);
elseif sum(dist(1:numLeaves)) == 0 % no dist infor for leaves, so force an ultrametric tree
    tr = phytree(tree,dist(numLeaves+1:end),names);
else % put all info into output object
    tr = phytree(tree,dist,names);
end