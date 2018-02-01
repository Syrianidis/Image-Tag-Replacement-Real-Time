function imOut=imImpose(imRef0,imWrp,imRep,ftrExt)
% imOut=imImpose(imRef,imWrp,imRep,ftrExt)
% 
% DESCRIPTION
%   imImpose( ) uses a feature-based method to locate certain patterns, 
%               called tags, in a reference image, estimates the geomtric
%               transform from the xy-plane to the plane of the reference
%               image, applies the transform on randomly chosen image,
%               replacement image, and replaces the tag with the latter in
%               the reference image
% 
% INPUT
%   'imRef'     is an image of reference
%   'imWrp'     is a warped image (Tag) to be found in imRef
%   'imRep'     is an image to replace the Tag in imRef 
%   'ftrExt'    is the method for feature extraction
% 
% OUTPUT
%   'imOut'     is imRef with a Tag replaced with imRep
% 
% EXAMPLE
% imRef = imread('scene1.jpg');
% imWrp = imread('tag1.jpg');
% ImRep = imread('butterfly.jpg');
% imImpose(imRef, imWrp, imRep, 'SURF');

imRef=imRef0;
if nargin==0
    help imDelude
    return
end

[mR,nR,kR]=size(imRef);
[mW,nW,kW]=size(imWrp);
if kR>1
    qRef=rgb2gray(imRef);
else
    qRef=imRef;
end
if kW>1
    qWrp=rgb2gray(imWrp);
else
    qWrp=imWrp;
end

if strcmp(ftrExt,'Harris')
    points1=detectHarrisFeatures(qRef);
    points2=detectHarrisFeatures(qWrp);
elseif strcmp(ftrExt,'SURF')
    points1=detectSURFFeatures(qRef);
    points2=detectSURFFeatures(qWrp);
elseif strcmp(ftrExt,'MSER')
    points1=detectMSERFeatures(qRef);
    points2=detectMSERFeatures(qWrp);
elseif strcmp(ftrExt,'MinEigen')
    points1=detectMinEigenFeatures(qRef);
    points2=detectMinEigenFeatures(qWrp);
else
    help imDelude
    return
end

[f1, vpts1]=extractFeatures(qRef, points1);
[f2, vpts2]=extractFeatures(qWrp, points2);

indexPairs=matchFeatures(f1,f2);
if isempty(indexPairs)
    imOut=imRef;
    imshow(imOut)
else
    matchedPoints1=vpts1(indexPairs(:, 1));
    matchedPoints2=vpts2(indexPairs(:, 2));
    [tform,~,~,state]=estimateGeometricTransform(matchedPoints2,matchedPoints1,'projective');
    if state~=0
%         fprintf('%d\n',state)
        imOut=imRef;
        if nargout==0
            imshow(imOut)
        end
    else
        qq=qWrp;
        for i=1:size(imRep,3)
            qq(:,:,i)=imresize(imRep(:,:,i),[mW,nW],'nearest');
        end
        outputView=imref2d([mR,nR]);
        Iq=imwarp(qq, tform, 'OutputView', outputView);
        imRef(Iq>0)=0;
        imOut=imRef+Iq;
        if nargout==0
            imshow(imOut)
        end
    end
end
% if nargout==0
%     if ~isempty(indexPairs)
%         showMatchedFeatures(imRef,imWrp,matchedPoints1,matchedPoints2,'montage');
%         figure;imshow(imOut)
% %     else
% %         imshow(imOut);
%     end
% end