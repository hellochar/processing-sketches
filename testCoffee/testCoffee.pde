blockSize = 10

setup: ->
  size 500, 500
  @nullIterate = (x, y) =>
    living = @nearbyOfType(x, y, @golIterate)

    return @golIterate if living is 2
    return @nullIterate
  
  @golIterate = (x, y) =>
    living = @nearbyOfType(x, y, @golIterate)
    
    return @golIterate if living in [2, 3]
    return @nullIterate
  
  @nullIterate.color = color(255)
  @golIterate.color = color(0)


  @cells = ((@init(x, y) for x in [0...width/blockSize]) for y in [0...height/blockSize])
  
  frameRate(10)

draw: ->
  console.log mousePressed
  if mousePressed == true
    noStroke()
    next = ((0 for x in [0...width/blockSize]) for y in [0...height/blockSize])
    for x in [0...@cells.length]
      for y in [0...@cells[x].length]
        entry = @cells[x][y]
        fill(entry.color)
        rect(x*blockSize, y*blockSize, blockSize, blockSize)
        
        next[x][y] = entry(x, y)
    
    @cells = next
  
  return

getAt: (x, y) ->
  x = (x + @cells.length) % @cells.length
  y = (y + @cells[0].length) % @cells[0].length
  @cells[x][y]
      
nearby: (x, y) ->
  [].concat.apply([], ((@getAt(i, j) for i in [x-1..x+1] when (i != x || j != y)) for j in [y-1..y+1]))
  
nearbyOfType: (x, y, type) ->
    @nearby(x,y).filter((f) => f == type).length
    
init: (x, y) ->
  if(random() < .5) then @nullIterate else @golIterate
