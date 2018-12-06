#include <cmath>
#include <fstream>
#include <iostream>
#include <string>

using namespace std;

string react(string p) {
  int L = p.size();
  string next = "";
  int i = 0;
  while (i < L) {
    if (i + 1 == L || abs(p[i] - p[i + 1]) != 32) {
      next += p[i];
      i++;
    } else {
      i += 2;
    }
  }
  if (next.size() - L == 0)
    return p;
  return react(next);
}

string filter(char c, string p) {
  string res = "";
  int L = p.size();
  for (int i = 0; i < L; i++) {
    if (p[i] != c && (p[i] - c) != 32) {
      res += p[i];
    }
  }
  return res;
}

int main() {
  ifstream fin("05.input");
  string polymer;
  fin >> polymer;
  fin.close();
  string final_polymer = react(polymer);
  cout << "Part 1: " << final_polymer.size() << endl;
  string best = polymer;
  for (char c = 'A'; c <= 'Z'; c++) {
    string next = react(filter(c, polymer));
    if (next.size() < best.size())
      best = next;
  }
  cout << "Part 2: " << best.size() << endl;
  return 0;
}
