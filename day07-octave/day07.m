[nn1, nn2] = textread("07.input", "Step %s must be finished before step %s can begin.");

function [children, in_degree] = build_graph(nn1, nn2)
  children = {};
  in_degree = {};

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

    children.(n1){size(children.(n1))(2) + 1} = n2;
    in_degree.(n2) = in_degree.(n2) + 1;
  endfor
endfunction

function res = part1 (nn1, nn2)
  [children, in_degree] = build_graph(nn1, nn2);

  res = "";

  while (numfields(in_degree) > 0)
    next = "";

    for [degree, node] = in_degree
      if (degree == 0 && (size(next)(2) == 0 || node < next))
        next = node;
      endif
    endfor

    if (isfield(children, next))
      for child = children.(next)
        c = child{1, 1};
        in_degree.(c) = in_degree.(c) - 1;
      endfor
    endif

    in_degree = rmfield(in_degree, next);
    res = [res; next];
  endwhile
endfunction

function res = part2 (nn1, nn2, n_workers)
  [children, in_degree] = build_graph(nn1, nn2);

  min_start_time = {};
  for [_, node] = in_degree
    min_start_time.(node) = 0;
  endfor

  workers = [];
  for i = 1:n_workers
    workers = [workers; 0];
  endfor

  res = 0;

  while (numfields(in_degree) > 0)
    next = "";

    for [degree, node] = in_degree
      if (degree == 0)
        if (size(next)(2) == 0 || min_start_time.(node) < min_start_time.(next))
          next = node;
        endif
      endif
    endfor

    worker = 1;
    for i = 2:n_workers
      if (workers(i) < workers(worker))
        worker = i;
      endif
    endfor

    duration = 60 + next - "A" + 1;
    start_time = max(min_start_time.(next), workers(worker));
    end_time = start_time + duration;
    workers(worker) = end_time;
    res = max(res, end_time);

    if (isfield(children, next))
      for child = children.(next)
        c = child{1, 1};
        in_degree.(c) = in_degree.(c) - 1;
        min_start_time.(c) = max(min_start_time.(c), end_time);
      endfor
    endif

    in_degree = rmfield(in_degree, next);
  endwhile
endfunction

disp(sprintf("Part 1: %s", part1(nn1, nn2)));
disp(sprintf("Part 2: %d", part2(nn1, nn2, 5)));
