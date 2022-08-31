function [digitstring] = add_leadingzeros(digit, num_digits)
digitstring = eval(['sprintf(''%0', num2str(num_digits), 'd'',', num2str(digit), ')']);
end