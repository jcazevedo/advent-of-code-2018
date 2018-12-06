#include <algorithm>
#include <cmath>
#include <cstdio>
#include <fstream>
#include <iostream>
#include <stack>
#include <string>

using namespace std;

int react(string p, char ignore = '_') {
  stack<char> s;
  int L = p.size();
  for (int i = 0; i < L; i++) {
    if (p[i] == ignore || p[i] - 32 == ignore)
      continue;
    if (s.empty() || abs(s.top() - p[i]) != 32)
      s.push(p[i]);
    else
      s.pop();
  }
  return s.size();
}

int main() {
  ifstream fin("05.input");
  string polymer;
  fin >> polymer;
  fin.close();
  cout << "Part 1: " << react(polymer) << endl;
  int best = polymer.size();
  for (char c = 'A'; c <= 'Z'; c++)
    best = min(best, react(polymer, c));
  cout << "Part 2: " << best << endl;
  return 0;
}
