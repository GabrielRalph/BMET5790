function str = funit(value, qty, options)
    arguments
        value (1,1) {mustBeNumeric} = 1
        qty {mustBeText} = "N"
        options.precision {mustBeInteger} = 0
    end
    num = value;
    unum = 0;
    while (num > 1000) 
        num = num / 1000;
        unum = unum + 1;
    end
    while (abs(num) < 1)
        num = num * 1000;
        unum = unum - 1;
    end
    
    unitsa = ['k', 'M', 'G', 'T'];
    unitsb = ['m', 'u', 'n', 'p', 'f'];
    if (unum < 0)
        unum = unitsb(-unum);
    elseif (unum > 0) 
        unum = unitsa(anum);
    else
       unum = '' ;
    end
    
    prec = options.precision;
    if (num < 10) 
        if mod(num * 100, 100) ~= 0 
            prec = prec + 1;
        end
        if mod(num * 100, 10) ~= 0
            prec = prec + 1;
        end
    elseif (num < 100) 
        if mod(num * 10, 10) ~= 0
            prec = prec + 1;
        end
    end


    str = sprintf("%.*f %c%s", prec, num, unum, qty);
end