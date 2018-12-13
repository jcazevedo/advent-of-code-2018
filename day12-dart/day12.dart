import "dart:io";

int sumOfPotNumbers(String pots, int start) {
  var sum = 0;
  for (var i = 0; i < pots.length; i++) {
    if (pots[i] == '#')
      sum += (i + start);
  }
  return sum;
}

List cleanup(List pots) {
  var s = pots[0];
  var j = 0;
  while (j < s.length && s[j] == '.')
    j++;
  var k = s.length - 1;
  while (k >= 0 && s[k] == '.')
    k--;
  var ni = pots[1] + j;
  return [s.substring(j, k + 1), ni];
}

List generate(List pots, Map m) {
  var s = "...." + pots[0] + "....";
  var res = "";
  for (var i = 2; i < s.length - 2; i++) {
    res += m[s.substring(i - 2, i + 3)];
  }
  return cleanup([res, pots[1] - 2]);
}

main() {
  var file = new File("12.input");
  var lines = file.readAsLinesSync();
  var initialState = cleanup([lines[0].substring(15), 0]);
  var m = {};
  for (var i = 2; i < lines.length; i++) {
    var ll = lines[i].split(" => ");
    m[ll[0]] = ll[1];
  }
  var state = initialState;
  for (var i = 0; i < 20; i++)
    state = generate(state, m);
  print("Part 1: " + sumOfPotNumbers(state[0], state[1]).toString());
  var v = {};
  var ss = [];
  var i = 0;
  var ld = 0;
  var ll = 0;
  state = initialState;
  while (true) {
    if (v.containsKey(state[0])) {
      ll = i - v[state[0]][0];
      ld = state[1] - v[state[0]][1];
      break;
    }
    ss.add(state[0]);
    v[state[0]] = [i, state[1]];
    state = generate(state, m);
    i++;
  }
  var targetIter = 50000000000;
  var ls = i - ll;
  var nLoops = (targetIter - ls) ~/ ll;
  state = [ss[ls], v[ss[ls]][1] + nLoops * ld];
  for (var j = ls + nLoops * ll; j < targetIter; j++)
    state = generate(state, m);
  print("Part 2: " + sumOfPotNumbers(state[0], state[1]).toString());
}
