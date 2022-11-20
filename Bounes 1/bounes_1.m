clear all;
clc;
close all;
%% 1. Read an image -any image.
my_cat = imread('my_cat.jpeg');
whos
imshow(my_cat);
%% 2. Present one of its RGB channels ? I1
%showing Red level 
I1 = my_cat(:,:,1);
figure(1);
imshow(I1);

%% 3. Permute I1 and present it.
rand_order = randperm(numel(I1));
permI1 = I1(rand_order);
whos
figure(2);
permI1_im = reshape(permI1,size(I1)); 
imshow(permI1_im)

%% 4. Present the histogram of I1.
I1_doub = double(I1);
figure(3); 
hist(I1_doub(I1_doub~= 0), 256);
%to get a PDF 
P_I1 = prob_norm(I1);

figure(4);
permI1_doub = double(permI1_im);
hist(permI1_doub(permI1_doub~= 0), 256);

%% 5. Calculate its entropy.

J_I1 = -sum(P_I1(P_I1~=0).*log2(P_I1(P_I1~=0)))
%entropy(I1)
J_permI1 = entropy(permI1_im)

%% 6. Calculate the Mutual Information between I1 pixels and their respective left-neighbors.
I1_last = I1(:,end);
I1_mid = I1(:,[10:end]);
I1_last_mat = cast(ones(1,9),"uint8").* I1_last;  
I1L = [I1_mid, I1_last_mat];
imshow(I1L);

P_I1_L = prob_norm(I1L);
figure; 
hist = histogram2(double(I1L), double(I1), 256);
hist
P_mat = hist.Values;
P_mat = P_mat./length(I1);


Mut_I1 = mut_info(P_mat,P_I1_L,P_I1)

%% 7. Calculate the Mutual Information between the permutation image?s pixels and their respective left-neighbors
I1perm_last = permI1_im(:,end);
I1perm_mid = permI1_im(:,[10:end]);
I1perm_last_mat = cast(ones(1,9),"uint8").* I1perm_last;  
I1permL = [I1perm_mid, I1perm_last_mat];
imshow(I1permL);

P_Perm = prob_norm(permI1_im);
P_PermL = prob_norm(I1permL);

hist_perm = histogram2(double(I1permL), double(permI1_im), 256);
%P_Mat_perm = hist_perm.Values;
P_Mat_perm = hist_perm.Values./length(permI1_im);

Mut_I1_perm = mut_info(P_Mat_perm,P_PermL,P_Perm)

%% Functions section  
function mut_sum = mut_info(Mat_p,P1,P2)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    n = length(P1); 
    mut_sum = 0;
    for k  = 1:n 
        for j = 1:n 
            if not(Mat_p(k,j) == 0 ||P1(k) == 0||P2(j) == 0)
                mut_sum = mut_sum + Mat_p(k,j)*log2(Mat_p(k,j)/(P1(k)*P2(j)));
            end       
        end
    end            
end

function PDF = prob_norm(I)
    I = double(I(:));
    h = hist(I(I~= 0), 256);
    len = length(I); 
    PDF = h./len;

end
