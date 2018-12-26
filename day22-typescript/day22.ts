let fs = require("fs");

function riskLevel(depth: number, targetI: number, targetJ: number) {
    let erosion = [];
    for (var i = 0; i <= targetI; i++) {
        erosion.push([...Array(targetJ + 1)]);
    }
    let risk = 0;
    for (var i = 0; i <= targetI; i++) {
        for (var j = 0; j <= targetJ; j++) {
            if (i == 0 && j == 0) {
                erosion[i][j] = depth;
            } else if (i == targetI && j == targetJ) {
                erosion[i][j] = depth;
            } else if (i == 0) {
                erosion[i][j] = j * 16807 + depth;
            } else if (j == 0) {
                erosion[i][j] = i * 48271 + depth;
            } else {
                erosion[i][j] = erosion[i - 1][j] * erosion[i][j - 1] + depth;
            }

            erosion[i][j] = erosion[i][j] % 20183;
            risk += erosion[i][j] % 3;
        }
    }
    return risk;
}

let lines = fs.readFileSync("22.input", "utf8").split("\n");
let depth = parseInt(lines[0].substring(7))
let target = lines[1].substring(8).split(",").map(x => parseInt(x))

console.log("Part 1: " + riskLevel(depth, target[1], target[0]))
