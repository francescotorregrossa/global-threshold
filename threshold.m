function [new_img, threshold, dx, dy] = threshold(img)

dx = conv2(img, [1 2 1]', 'same');
dx = conv2(dx, [-1 0 1], 'same');

dy = conv2(img, [-1 0 1]', 'same');
dy = conv2(dy, [1 2 1], 'same');

magnitude = sqrt(dx.^2 + dy.^2);
magnitude = uint8((magnitude / max(magnitude(:)) * 255));

hist = imhist(magnitude, 256);

threshold = 127;
used = zeros(256, 'logical');
used(threshold) = 1;
while 1
    
    range_left = 1: threshold;
    range_right = threshold + 1: 256;
    
    left = hist(range_left)';
    right = hist(range_right)';
    
    s_left = max([1, sum(left)]);
    s_right = max([1, sum(right)]);
    
    expected_left = sum(left .* range_left) / s_left;
    expected_right = sum(right .* range_right) / s_right;
    
    new_threshold = round((expected_left + expected_right) / 2);
    
    if used(new_threshold) == 1
        break;
    end
    
    threshold = new_threshold;
    used(threshold) = 1;
    
end

new_img = magnitude > threshold;

end
