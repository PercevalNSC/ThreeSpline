require 'matrix'

class ThreeSpline
  #3次スプライン補間を処理するためのクラス

  def initialize(input_xdata,input_ydata)
    @xdata = input_xdata
    @ydata = input_ydata

    #スプライン補間のための事前行列計算
    self.makeh
    self.makew
    self.makem
    self.makev
    self.makea
    self.makeb
    self.makec
    self.maked
  end

  def makeh
    #need : x
    size = @xdata.size-1
    @h = Array.new(size,0)
    for i in 0..size-1
      @h[i] = @xdata[i+1] - @xdata[i]
    end
    #puts "make h"
  end
  def makew
    #need : y,h
    size = @ydata.size-1
    @w = Array.new(size,0)
    for i in 1..size-1
      @w[i] = 6*((@ydata[i+1] - @ydata[i]).to_f / @h[i] - (@ydata[i-1] - @ydata[i]).to_f / @h[i-1])
    end
    @w.delete_at(0)
    #puts "make h"
  end
  def makem
    #need : h
    size = @h.size
    @m = Matrix.zero(size-1)
    left = @m.to_a
    for i in 0..size-2
      left[i][i] = 2*(@h[i]+@h[i+1])
    end
    for i in 0..size-3
      left[i][i+1] = @h[i+1]
      left[i+1][i] = @h[i+1]
    end
    @m = Matrix[*left]
    #puts "make m"
  end
  def makev
    #need : m,w
    v1 = @m.lup.solve(@w).to_a
    @v = Array[0] + v1 + Array[0]
    #puts "make v"
  end
  def makea
    size = @v.size
    @a = Array.new(size-1,0)
    for i in 0..size-2
      @a[i] = (@v[i+1] - @v[i])/(6 * (@xdata[i+1] - @xdata[i]))
    end
    #puts "make a"
  end
  def makeb
    size = @v.size
    @b = Array.new(size-1,0)
    for i in 0..size-2
      @b[i] = @v[i] / 2
    end
    #puts "make b"
  end
  def makec
    size = @v.size
    @c = Array.new(size-1,0)
    for i in 0..size-2
      @c[i] = (@ydata[i+1] - @ydata[i])/(@xdata[i+1] - @xdata[i]) - (@xdata[i+1] - @xdata[i])*(2*@v[i] + @v[i+1]) / 6
    end
    #puts "make c"
  end
  def maked
    size = @ydata.size
    @d = Array.new(size-1,0)
    for i in 0..size-2
      @d[i] = @ydata[i]
    end
    #puts "make d"
  end

  #xsに指定した値がxdataのどの間なのかをさがす。
  #xsは事前に昇順ソートされていること。
  def search_section(xs)
    #TODO
    @xdata.each_with_index do |data,index|
      if xs < data then
        return index
      end
    end
    return @xdata.size
  end

  #initializeで作られた配列をもとに、xsの値を計算する。
  def third_cubic_spline(xs)
    i = search_section(xs)
    hs = xs - @xdata[i]
    return  @a[i] * hs**3 + @b[i] * hs**2 + @c[i] * hs + @d[i]
  end

end

#test
=begin
x = Array[115.2936, 162.95472, 232.77408, 309.28272000000004, 387.78528, 466.57728, 544.83864, 622.07088, 697.90416, 772.04904, 844.2160799999999, 914.19624, 981.7644, 1046.7276, 1108.8768, 1168.03512, 1224.04176, 1276.7359199999999, 1325.9568, 1371.57576, 1413.46416, 1451.49336, 1485.58296, 1515.6204, 1541.5252799999998, 1563.2171999999998, 1580.63184, 1593.75312, 1602.5167199999999, 1606.90656]
y = Array[192.76704, 192.20424, 201.03215999999998, 207.85008000000002, 210.66407999999998, 211.22688, 211.11432, 207.73752, 201.46632000000002, 193.37808, 184.21248, 174.41976, 164.3376, 154.15896, 143.98031999999998, 133.89816, 123.94463999999999, 114.11976000000001, 104.45568, 94.9524, 85.57776000000001, 76.33176, 67.23048, 58.241760000000006, 49.38168, 40.650240000000004, 32.0796, 23.78232, 16.19256, 10.95048]
section = 1556
tspline = ThreeSpline.new(x,y)
puts tspline.third_cubic_spline(section)
=end