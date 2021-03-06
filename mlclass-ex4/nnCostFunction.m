function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

X = [ones(m, 1) X];

delta2 = zeros(size(Theta2));
delta1 = zeros(size(Theta1));
for i = 1:m
    a1 = X(i, :)';
    ymat = zeros(num_labels, 1);
    if y(i) == 0
        ymat(10) = 1;
    else
        ymat(y(i)) = 1;
    end

    z2 = Theta1 * a1;
    a2 = sigmoid(z2);
    a2 = [1; a2];
    
    z3 = Theta2 * a2;
    a3 = sigmoid(z3);
    
    %Cost function computation
    
    q = 0;
    for k = 1:num_labels
        q = q + ymat(k) * log(a3(k)) + (1 - ymat(k)) * log(1 - a3(k));
    end
    
    J = J - q;
    
    %Gradient computation
    del3 = a3 - ymat;
    del2 = (Theta2' * del3) .* [1; sigmoidGradient(z2)];
    del2 = del2(2:end);
    delta1 = delta1 + del2 * a1';
    delta2 = delta2 + del3 * a2';
end

J = J / m;

reg_term = 0;
ctheta1 = Theta1;
ctheta2 = Theta2;
ctheta1(:, 1) = 0;
ctheta2(:, 1) = 0;

reg_term = lambda * (sum(sum(ctheta1 .^2)) + sum(sum(ctheta2 .^2))) / (2 * m);

J = J + reg_term;


Theta1_grad = delta1 / m + lambda * ctheta1 / m;
Theta2_grad = delta2 / m + lambda * ctheta2 / m;





% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
