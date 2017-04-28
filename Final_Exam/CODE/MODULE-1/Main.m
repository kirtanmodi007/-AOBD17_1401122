
%  This file contains code that helps you get started on the
%  exercise. You will need to complete the following functions:
%     estimateGaussian.m
%     selectThreshold.m
%     cofiCostFunc.m
% =============== Part 1: Loading user's skills  dataset ================
%  You will start by loading the skills dataset to understand the
%  structure of the data.
%  


Y = randi([0,5],10,10)  
R = zeros(10,10);
for i=1:10
    for j=1:10
        if Y(i,j)>0     %Jya jya koi pan skill hase tya 1 kari deqanu and jya skills nathi tya 0.
        R(i,j)=1;       %means ke skill ma kai k experience hase to j aeni value aapde 1 karishu.   
        else
        R(i,j)=0;
        end
    end
end
disp(R)

%R(i,j) means user j has ith skill
%Y(i,j) means aapda user ni perticular skills mateno experience years ni
%term ma 6e.






%  We can "visualize" the ratings matrix by plotting it with imagesc
imagesc(Y);
ylabel('Skills');
xlabel('Users');

fprintf('\nProgram paused. Press enter to continue.\n');
pause;

% ============ Part 2: Collaborative Filtering Cost Function ===========
%  You will now implement the cost function for collaborative filtering.
%  To help you debug your cost function, we have included set of weights
%  that we trained on that. Specifically, you should complete the code in 
%  cofiCostFunc.m to return J.

%AAPde badha user ni skills na experience ne gani kadhiye 6iye

X = randi([-1,2],10,10);
Theta = randi([-1,2],10,10);        %Theta ni value aapdne train kari ne aapeli j 6e
num_users = 10; Number_skills = 10; num_features = 10;    

%  Reduce the data set size so that this runs faster
X = X(1:Number_skills, 1:num_features);
Theta = Theta(1:num_users, 1:num_features);
Y = Y(1:Number_skills, 1:num_users);
R = R(1:Number_skills, 1:num_users);

%  Evaluate cost function
J = cofiCostFunc([X(:) ; Theta(:)], Y, R, num_users, Number_skills, ...
               num_features, 0);
           
fprintf(['Cost at loaded parameters: %f '...
         '\n(this value should be about 22.22)\n'], J);

fprintf('\nProgram paused. Press enter to continue.\n');
pause;


% ============== Part 3: Collaborative Filtering Gradient ==============
%  Once your cost function matches up with ours, you should now implement 
%  the collaborative filtering gradient function. Specifically, you should 
%  complete the code in cofiCostFunc.m to return the grad argument.
%  
fprintf('\nChecking Gradients (without regularization) ... \n');

%  Check gradients by running checkNNGradients
checkCostFunction;

fprintf('\nProgram paused. Press enter to continue.\n');
pause;


% ========= Part 4: Collaborative Filtering Cost Regularization ========
%  Now, you should implement regularization for the cost function for 
%  collaborative filtering. You can implement it by adding the cost of
%  regularization to the original cost computation.
%  

%  Evaluate cost function
J = cofiCostFunc([X(:) ; Theta(:)], Y, R, num_users, Number_skills, ...
               num_features, 1.5);
           
fprintf(['Cost at loaded parameters (lambda = 1.5): %f '...
         '\n(this value should be about 31.34)\n'], J);

fprintf('\nProgram paused. Press enter to continue.\n');
pause;


% ======= Part 5: Collaborative Filtering Gradient Regularization ======
%  Once your cost matches up with ours, you should proceed to implement 
%  regularization for the gradient. 
%

%  
fprintf('\nChecking Gradients (with regularization) ... \n');

%  Check gradients by running checkNNGradients
checkCostFunction(1.5);

fprintf('\nProgram paused. Press enter to continue.\n');
pause;



%
skillslist = loadskillList();

%  Initialize my ratings
my_ratings = zeros(10, 1); % new user


my_ratings(1) = 5;
% 

my_ratings(2) = 2;
% 

 my_ratings(3) = 3;


fprintf('\n\nNew user ratings:\n');
for i = 1:length(my_ratings)
    if my_ratings(i) > 0 
        fprintf('Rated %d for %s\n', my_ratings(i), ...
                 skillslist{i});
    end
end

fprintf('\nProgram paused. Press enter to continue.\n');
pause;




fprintf('\nTraining collaborative filtering...\n');

%  Load data





%  Add our own ratings to the data matrix
Y = [my_ratings Y];
R = [(my_ratings ~= 0) R];

%  Normalize Ratings
[Ynorm, Ymean] = normalizeRatings(Y, R);

%  Useful Values
num_users = size(Y, 2);
Number_skills = size(Y, 1);
num_features = 10;

% Set Initial Parameters (Theta, X)
X = randn(Number_skills, num_features);
Theta = randn(num_users, num_features);

initial_parameters = [X(:); Theta(:)];

% Set options for fmincg
options = optimset('GradObj', 'on', 'MaxIter', 100);

% Set Regularization
lambda = 10;
theta = fmincg (@(t)(cofiCostFunc(t, Y, R, num_users, Number_skills, ...
                                num_features, lambda)), ...
                initial_parameters, options);

% Unfold the returned theta back into U and W
X = reshape(theta(1:Number_skills*num_features), Number_skills, num_features);
Theta = reshape(theta(Number_skills*num_features+1:end), ...
                num_users, num_features);

fprintf('Recommender system learning completed.\n');

fprintf('\nProgram paused. Press enter to continue.\n');
pause;

% ================== Part 8: Recommendation for you ====================
%  After training the model, you can now make recommendations by computing
%  the predictions matrix.
%

p = X * Theta';
my_predictions = p(:,1) + Ymean;

skillslist = loadskillList();

[r, ix] = sort(my_predictions, 'descend');
fprintf('\nTop recommendations for you:\n');
for i=1:10
    j = ix(i);
    fprintf('Predicting rating %.1f for Skill %s\n', my_predictions(j), ...
            skillslist{j});
end

fprintf('\n\nOriginal ratings provided:\n');
for i = 1:length(my_ratings)
    if my_ratings(i) > 0 
        fprintf('Rated %d for %s\n', my_ratings(i), ...
                 skillslist{i});
    end
end
