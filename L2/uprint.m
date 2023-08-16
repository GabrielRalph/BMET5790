function uprint(var,unit)
    vname = inputname(1);
    fprintf("%s = %s\n", vname, funit(var, unit));
end

