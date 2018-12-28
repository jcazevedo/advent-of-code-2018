(require '[clojure.string :as str])

(defn uf-make [n]
  [(vec (replicate n 0)) (vec (range n))])

(defn uf-rank [uf]
  (uf 0))

(defn uf-parent [uf]
  (uf 1))

(defn uf-set-parent [uf i p]
  [(uf-rank uf) (assoc (uf-parent uf) i p)])

(defn uf-set-rank [uf i r]
  [(assoc (uf-rank uf) i r) (uf-parent uf)])

(defn uf-find-set [uf i]
  (let [parent ((uf-parent uf) i)]
    (if (== parent i) i (uf-find-set uf parent))))

(defn uf-connected [uf i j]
  (let [parent-i (uf-find-set uf i)
        parent-j (uf-find-set uf j)]
    (== parent-i parent-j)))

(defn uf-union-set [uf i j]
  (if (uf-connected uf i j)
    uf
    (let [x (uf-find-set uf i)
          y (uf-find-set uf j)
          rank-x ((uf-rank uf) x)
          rank-y ((uf-rank uf) y)]
      (if (> rank-x rank-x)
        (uf-set-parent uf y x)
        (let [new-uf (uf-set-parent uf x y)]
          (if (== rank-x rank-y) (uf-set-rank new-uf y (+ rank-y 1)) new-uf))))))

(defn manhattan-distance [c1 c2]
  (let [x1 (c1 0) y1 (c1 1) z1 (c1 2) k1 (c1 3)
        x2 (c2 0) y2 (c2 1) z2 (c2 2) k2 (c2 3)]
    (+ (Math/abs (- x1 x2)) (Math/abs (- y1 y2)) (Math/abs (- z1 z2)) (Math/abs (- k1 k2)))))

(defn create-coord [s]
  (vec (map (fn [x] (Integer/parseInt x)) (str/split s #","))))

(defn foldl [f val coll]
  (if (empty? coll) val
      (foldl f (f val (first coll)) (rest coll))))

(defn n-constellations [coords]
  (let [uf (uf-make (count coords))
        i-coords (map-indexed vector coords)]
    ((foldl
      (fn [acc1 coord1]
        (foldl (fn [acc2 coord2]
                 (let [uf (acc2 0)
                       const (acc2 1)]
                   (if (and (<= (manhattan-distance (coord1 1) (coord2 1)) 3)
                            (not (uf-connected uf (coord1 0) (coord2 0))))
                     [(uf-union-set uf (coord1 0) (coord2 0)) (- const 1)]
                     [uf const])))
               acc1
               i-coords))
      [uf (count coords)]
      i-coords) 1)))

(with-open [rdr (clojure.java.io/reader "25.input")]
  (let [coords (map create-coord (line-seq rdr))]
    (println (str "Part 1: " (n-constellations coords)))))
