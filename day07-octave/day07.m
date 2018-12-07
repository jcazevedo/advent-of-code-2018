[nn1, nn2] = textread("07.input", "Step %s must be finished before step %s can begin.");

children = {};
in_degree = {};
tot_edges = 0;

for i = 1:size(nn1)
  n1 = nn1{i, 1};
  n2 = nn2{i, 1};

  if (!isfield(children, n1))
    children.(n1) = {};
  endif
  if (!isfield(in_degree, n1))
    in_degree.(n1) = 0;
  endif
  if (!isfield(in_degree, n2))
    in_degree.(n2) = 0;
  endif

  tot_edges = tot_edges + 1;
  children.(n1){size(children.(n1))(2) + 1} = n2;
  in_degree.(n2) = in_degree.(n2) + 1;
endfor

res = "";

while (tot_edges > 0)
  next = "Z";

  for [degree, node] = in_degree
    if (degree == 0 && node < next)
      next = node;
    endif
  endfor

  for child = children.(next)
    c = child{1, 1};
    tot_edges = tot_edges - 1;
    in_degree.(c) = in_degree.(c) - 1;
  endfor

  in_degree = rmfield(in_degree, next);
  res = [res; next];
endwhile

if (size(in_degree)(1) > 0)
  res = [res; fieldnames(in_degree){1, 1}];
endif

disp(sprintf("Part 1: %s", res));
