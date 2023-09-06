function textable = mat2textable(mat)
    [rows, cols] = size(mat);
    texrows = [];
    for r = 1:rows
        texrows = cat(1, texrows, join(mat(r, :), " & "));
    end
    textable = join(texrows, "\\ \hline ");
    textable = sprintf("\\begin{tabular}{%s}\n\\hline %s\n \\\\ \\hline \\end{tabular}", "|"+join(repmat("c",1,cols), "|")+"|", textable);
end