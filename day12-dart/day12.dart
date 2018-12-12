import "dart:io";

int sumOfPotNumbers(String pots, int start) {
  var sum = 0;
  for (var i = 0; i < pots.length; i++) {
    if (pots[i] == '#')
      sum += (i + start);
  }
  return sum;
}

List generate(List pots, Map m) {
  var s = "...." + pots[0] + "....";
  var res = "";
  for (var i = 2; i < s.length - 2; i++) {
    res += m[s.substring(i - 2, i + 3)];
  }
  var j = 0;
  while (j < res.length && res[j] == '.')
    j++;
  var k = res.length - 1;
  while (k >= 0 && res[k] == '.')
    k--;
  var ni = pots[1] - 2 + j;
  return [res.substring(j, k + 1), ni];
}

main() {
  var file = new File("12.input");
  var lines = file.readAsLinesSync();
  var state = [lines[0].substring(15), 0];
  var m = {};
  for (var i = 2; i < lines.length; i++) {
    var ll = lines[i].split(" => ");
    m[ll[0]] = ll[1];
  }
  for (var i = 0; i < 20; i++) {
    state = generate(state, m);
  }
  print("Part 1: " + sumOfPotNumbers(state[0], state[1]).toString());
}
