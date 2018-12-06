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

int main() {
  ifstream fin("05.input");
  string polymer;
  fin >> polymer;
  fin.close();
  string final_polymer = react(polymer);
  cout << "Part 1: " << final_polymer.size() << endl;
  return 0;
}
