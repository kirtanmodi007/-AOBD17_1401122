clear all;
clc
close all;
tic

 Y = [1 0 0 0 0 1 0 1 1 1;0 1 0 0 0 1 1 1 0 1;0 0 1 0 0 0 1 1 1 0;
     0 0 0 1 0 1 0 1 1 0;0 0 0 0 1 1 0 1 1 1;0 1 0 0 0 1 1 1 1 1;
     1 0 0 0 0 1 0 1 1 1;0 0 0 0 0 1 1 1 1 0;0 0 0 0 0 0 0 1 1 1;
     0 0 0 0 0 1 0 1 1 0];

R=Y;

%  Y = 10X10 matrix, containing ratings (0 or 1) of 10 skills on  10 users
%  R = 10X10 matrix, where R(i,j) = 1 if and only if user j have that skill i

imagesc(Y);
ylabel('Skill');
xlabel('Users');

%  we will now implement the cost function for collaborative filtering.
%  To help you debug your cost function, we have included set of weights that we trained on that. Specifically, you should complete the code in 
%  cofiCostFunc.m to return J, X is experiance of skill
%  Theta = minimum experiance user have

X = [3;2.5;3;4;3;2;3;2;3;2]
X_max=max(X)+0.2;
X = X./X_max;

Theta = [2;3;2;3.6;4;3.7;3;2;2.7;2.9]
Theta_max= max(Theta)+0.2;
Theta=Theta./Theta_max;

num_users = 10; num_skills = 10; num_features = 1;    


%  Collaborative Filtering Cost Regularization 
%  Now, you should implement regularization for the cost function for 
%  collaborative filtering. You can implement it by adding the cost of
%  regularization to the original cost computation.
%  Evaluate cost function

J = cofiCostFunc([X(:) ; Theta(:)], Y, R, num_users, num_skills, ...
               num_features, 1.5);


%  Collaborative Filtering Gradient Regularization 
%  Once your cost matches up with ours, you should proceed to implement 
%  regularization for the gradient. 
%
%  Check gradients by running checkNNGradients
checkCostFunction(1.5);


%  Entering ratings for a new user 
%  Before we will train the collaborative filtering model, we will first
%  add ratings that correspond to a new user that we just observed. This
%  part of the code will also allow you to put in your own skils 

skillList = loadSkillsList();

my_skills = zeros(10, 1);

my_skills(4)=1;
my_skills(7)=1;

fprintf('\n\nNew user skills:\n');
for i = 1:length(my_skills)
    if my_skills(i) > 0 
        user_skill_minis=skillList{i};
        fprintf('User skill %s\n',skillList{i});
    end
end


% add new users skill

Y = [Y my_skills];
R = [R (my_skills ~= 0)];

%  Normalize skills
[Ynorm, Ymean] = normalizeRatings(Y, R);
%  Useful Values
num_users = size(Y, 2);
num_skills = size(Y, 1);
num_features = 1;

% Set Initial Parameters (Theta, X)
Theta(num_users,num_features) = randi([1 3],1, num_features)/Theta_max;

initial_parameters = [X(:); Theta(:)];

% Set options for fmincg
options = optimset('GradObj', 'on', 'MaxIter', 100);

% Set Regularization
lambda = 0.1;
theta = fmincg (@(t)(cofiCostFunc(t, Y, R, num_users, num_skills, ...
                                num_features, lambda)), ...
                initial_parameters, options);

% Unfold the returned theta back into U and W
X = reshape(theta(1:num_skills*num_features), num_skills, num_features);
Theta = reshape(theta(num_skills*num_features+1:end), ...
                num_users, num_features);
            

p = X * Theta';


figure;
plot(X,p)
hold on;
plot(X,Y,'o')
hold off;

skillList = loadSkillsList();

threshold=0.3;

[r, ix] = sort(p(:,num_users), 'descend');

fprintf('\nTop skill recommendations for user %s :\n');

for k=1:10
        j = ix(k);
        fprintf('This are new skills rating for future career goal : %s\n', skillList{j});
end
toc