function [interped_array]=curve_int_func(array_in,newx1,newx2,num_points)
%interpolate points in curve
%get the desired step size
step_size=(newx2-newx1)/(num_points-1);

new_x_vec=transpose(newx1:step_size:newx2);
method='makima'; %can change interpolation method, this has worked best

x_in=array_in(:,1);
y_in=array_in(:,2);

x_in=nonzeros(x_in);
indexb=find(x_in);
%y_out=interp1(x_in,y_in(indexb),new_x_vec,method,'extrap');
y_out=interp1(x_in,y_in(indexb),new_x_vec,method);

interped_array(:,1)=new_x_vec;
interped_array(:,2)=y_out;
%output the new x and the interpolated y points