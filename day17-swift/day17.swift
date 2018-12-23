import Foundation

struct Vein {
    let x1: Int
    let x2: Int
    let y1: Int
    let y2: Int
}

func createVein(str: String) -> Vein {
    let elems = str.components(separatedBy: ", ")
    let v1 = Int(String(elems[0].dropFirst(2)))
    let rangeElems = String(elems[1].dropFirst(2)).components(separatedBy: "..")
    let v21 = Int(rangeElems[0])
    let v22 = Int(rangeElems[1])
    if (elems[0].prefix(1) == "x") {
        return Vein(x1: v1!, x2: v1!, y1: v21!, y2: v22!)
    }
    return Vein(x1: v21!, x2: v22!, y1: v1!, y2: v1!)
}

func waterReach(veins: [Vein], x: Int, y: Int) -> (Int, Int) {
    let minY = veins.min { a, b in a.y1 < b.y1 }!.y1
    let maxY = veins.max { a, b in a.y2 < b.y2 }!.y2
    let minX = veins.min { a, b in a.x1 < b.x1 }!.x1 - 1
    let maxX = veins.max { a, b in a.x2 < b.x2 }!.x2 + 1
    let H = maxY - minY + 1
    let W = maxX - minX + 1
    var grid = Array(repeating: Array(repeating: ".", count: W), count: H)
    var drops = Array(repeating: Array(repeating: false, count: W), count: H)

    func fill(vein: Vein) {
        for y in vein.y1...vein.y2 {
            let i = y - minY
            for x in vein.x1...vein.x2 {
                let j = x - minX
                grid[i][j] = "#"
            }
        }
    }
    veins.forEach(fill)

    func drop(x: Int, y: Int) -> Int {
        if (x < 0 || x >= W || y < 0 || y >= H) {
            return 0
        }
        var s = 0
        var i = y
        while (i < H && (grid[i][x] == "." || grid[i][x] == "|")) {
            if (grid[i][x] == ".") {
                s += 1
            }
            grid[i][x] = "|"
            i += 1
        }
        if (i < H && i - 1 >= 0) {
            i -= 1
            var hasDrop = false
            var lj = x
            while (lj >= 0 && (grid[i][lj] == "." || grid[i][lj] == "|") && (grid[i + 1][lj] == "#" || grid[i + 1][lj] == "~")) {
                if (grid[i][lj] == ".") {
                    s += 1
                }
                grid[i][lj] = "|"
                lj -= 1
            }
            if (lj >= 0 && grid[i][lj] != "#" && (grid[i + 1][lj] == "." || grid[i + 1][lj] == "|")) {
                if (grid[i][lj] == ".") {
                    s += 1
                }
                grid[i][lj] = "|"
                hasDrop = true
                if (!drops[i + 1][lj]) {
                    drops[i + 1][lj] = true
                    s += drop(x: lj, y: i + 1)
                }
            }
            var rj = x
            while (rj >= 0 && (grid[i][rj] == "." || grid[i][rj] == "|") && (grid[i + 1][rj] == "#" || grid[i + 1][rj] == "~")) {
                if (grid[i][rj] == ".") {
                    s += 1
                }
                grid[i][rj] = "|"
                rj += 1
            }
            if (rj < W && grid[i][rj] != "#" && (grid[i + 1][rj] == "." || grid[i + 1][rj] == "|")) {
                if (grid[i][rj] == ".") {
                    s += 1
                }
                grid[i][rj] = "|"
                hasDrop = true
                if (!drops[i + 1][rj]) {
                    drops[i + 1][rj] = true
                    s += drop(x: rj, y: i + 1)
                }
            }
            if (!hasDrop) {
                for j in (lj + 1)...(rj - 1) {
                    grid[i][j] = "~"
                }
                s += drop(x: x, y: i - 1)
            }
        }
        return s
    }

    let reach = drop(x: max(x, minX) - minX, y: max(y, minY) - minY)

    var remaining = 0
    for i in 0..<H {
        for j in 0..<W {
            if (grid[i][j] == "~") {
                remaining += 1
            }
        }
    }

    return (reach, remaining)
}

let filename = "17.input"
let currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
let url = URL(fileURLWithPath: filename, relativeTo: currentDirectoryURL)
let contents = try! String(contentsOfFile: url.path)
let lines = contents.split { $0 == "\n" }.map(String.init)
let veins = lines.map(createVein)

let (part1, part2) = waterReach(veins: veins, x: 500, y: 0)

print("Part 1: \(part1)")
print("Part 2: \(part2)")
