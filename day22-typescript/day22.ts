let fs = require("fs");

class PriorityQueue<T> {
    data: T[];
    length: number;
    currentSize: number;
    nextSize: number;
    compare: (v1: T, v2: T) => boolean;

    constructor(comparisonF: (v1: T, v2: T) => boolean) {
        this.data = [];
        this.length = 0;
        this.currentSize = 0;
        this.nextSize = 2;
        this.compare = comparisonF
    }

    parent(i: number): number {
        return Math.floor((i - 1) / 2);
    }

    left(i: number): number {
        return 2 * i + 1;
    }

    right(i: number): number {
        return 2 * i + 2;
    }

    push(v: T): void {
        if (this.length == this.currentSize) {
            this.data = this.data.concat(new Array(this.nextSize).fill(null));
            this.currentSize = this.length + this.nextSize;
            this.nextSize *= 2;
        }
        this.length++;
        var i = this.length - 1;
        this.data[i] = v;
        while (i != 0 && this.compare(this.data[i], this.data[this.parent(i)])) {
            let tmp = this.data[i];
            this.data[i] = this.data[this.parent(i)];
            this.data[this.parent(i)] = tmp;
            i = this.parent(i);
        }
    }

    heapify(i: number): void {
        let l = this.left(i);
        let r = this.right(i);
        let sm = i;
        if (l < this.length && this.compare(this.data[l], this.data[i]))
            sm = l;
        if (r < this.length && this.compare(this.data[r], this.data[sm]))
            sm = r;
        if (sm != i) {
            let tmp = this.data[i];
            this.data[i] = this.data[sm];
            this.data[sm] = tmp;
            this.heapify(sm);
        }
    }

    pop(): T {
        if (this.length <= 0)
            return null;
        if (this.length == 1) {
            this.length--;
            return this.data[0];
        }

        var root = this.data[0];
        this.data[0] = this.data[this.length - 1];
        this.length--;
        this.heapify(0);
        return root;
    }
}

let lines = fs.readFileSync("22.input", "utf8").split("\n");
let depth = parseInt(lines[0].substring(7));
let target = lines[1].substring(8).split(",").map(x => parseInt(x));
let erosion = new Map<string, number>();
function getErosion(i: number, j: number) {
    let v = [i, j].join(",");
    if (!erosion.has(v)) {
        if ((i == 0 && j == 0) || (i == target[1] && j == target[0])) {
            erosion.set(v, depth % 20183);
        } else if (i == 0) {
            erosion.set(v, (j * 16807 + depth) % 20183);
        } else if (j == 0) {
            erosion.set(v, (i * 48271 + depth) % 20183);
        } else {
            erosion.set(v, (getErosion(i - 1, j) * getErosion(i, j - 1) + depth) % 20183);
        }
    }
    return erosion.get(v);
}

function riskLevel() {
    let risk = 0;
    for (var i = 0; i <= target[1]; i++) {
        for (var j = 0; j <= target[0]; j++) {
            risk += getErosion(i, j) % 3;
        }
    }
    return risk;
}

function getMinTime() {
    let directions = [[0, 1], [0, -1], [1, 0], [-1, 0]];
    let acceptedEquipment = [[1, 2], [0, 1], [0, 2]];
    let maxDist = (target[0] + target[1]) * 8;
    let dist = new Map<string, number>();
    dist.set([0, 0, 2].join(","), 0);
    let compare = function(v1: number[], v2: number[]): boolean {
        var i = 0;
        while (i < v1.length) {
            if (v1[i] < v2[i])
                return true;
            if (v2[i] < v1[i])
                return false;
            i++;
        }
        return false;
    }
    let pq = new PriorityQueue<number[]>(compare);
    pq.push([0, 0, 0, 2]);
    while (pq.length > 0) {
        let curr = pq.pop();
        let currDist = curr[0];
        let currI = curr[1];
        let currJ = curr[2];
        let currEquipment = curr[3];

        if (currI == target[1] && currJ == target[0] && currEquipment == 2)
            return currDist;

        if (currDist > dist.get([currI, currJ, currEquipment].join(",")))
            continue;

        for (var i = 0; i < directions.length; i++) {
            let dir = directions[i];
            let nextI = currI + dir[0];
            let nextJ = currJ + dir[1];
            if (nextI >= 0 && nextJ >= 0 && nextI + nextJ < maxDist) {
                let nextType = getErosion(nextI, nextJ) % 3;
                let equipments = acceptedEquipment[nextType];
                for (var j = 0; j < equipments.length; j++) {
                    let equip = equipments[j];
                    let nextDist = 1 + currDist + (currEquipment == equip ? 0 : 7);
                    let ks = [nextI, nextJ, equip].join(",");
                    if (!dist.has(ks) || dist.get(ks) > nextDist) {
                        dist.set(ks, nextDist);
                        pq.push([nextDist, nextI, nextJ, equip]);
                    }
                }
            }
        }
    }
}

console.log("Part 1: " + riskLevel());
console.log("Part 2: " + getMinTime());
