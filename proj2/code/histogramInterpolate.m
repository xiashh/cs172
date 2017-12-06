function vector = histogramInterpolate(vector, r_bin, c_bin, o_bin, m_w)
%myFun - Description
%
% Syntax: ori_hist = hist(image, x, y, scale)
%
% Long description
r = floor(r_bin);
c = floor(c_bin);
o = floor(o_bin);
dr = r_bin - r;
dc = c_bin - c;
do = o_bin - o;

for i = 0:1
    r_index = r + i;
    if (r_index >= 0 && r_index < 4)
        for j = 0:1
            c_index = c + j;
            if (c_index >=0 && c_index < 4)
                for k = 0:1
                    o_index = mod(o+k, 8);
                    value = m_w * ( 0.5 + (dr - 0.5)*(2*i-1) ) ...
                        * ( 0.5 + (dc - 0.5)*(2*j-1) ) ...
                        * ( 0.5 + (do - 0.5)*(2*k-1) );
                    index = r_index*4*8 + c_index*8 + o_index +1;
                    vector(index) = vector(index) + value;
                end
            end
        end
    end
end

end