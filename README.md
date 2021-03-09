# ThreeSpline
ver 2.0.1 (Experimental)

## Use Example

### input
```
x = Array[115.2936, 162.95472, 232.77408]
y = Array[192.76704, 192.20424, 201.03215999999998]
tspline = ThreeSpline.new(x,y)
section = 200
puts tspline.third_cubic_spline(section)
```
### output
```
203.82235436700725
```
## Issue（Japanese）
* 外挿されるデータ点は不正な値を返す
* 情報落ち対策がされないため、渡すデータ点が細かいと精度が下がる
* 行列計算に無駄がに多いのでもっと効率化できるはず