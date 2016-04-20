
### Ben Scott # 2015-10-26 # Perlin Noise ###

'use strict' # just like JavaScript

### Constants & Aliases ###
{abs,cos,floor,PI,random,sqrt} = Math
cos_s = (i) -> 0.5*(1.0-cos(i*PI))

### `Perlin`

An instance of this class will return pseudo-random values
in a naturally ordered, harmonic sequence.
- `@inc` **real** : increment value
- `@size` **int** : size of array
- `@faloff` **real** : Octaves for smoothing
- `@yw0,@yw1` **int** : Y Wrap
- `@zw0,@zw1` **int** : Z Wrap
- `@octave` **real** : Octaves for smoothing
###
class Perlin
    [@size,@falloff,@octave] = [4095,0.5,4]
    [@yw0,@zw0] = [4,8]
    [@yw1,@zw1] = [1<<@yw0,1<<@yw1]

    constructor: (@inc=0.01) ->
        @arr = (random() for i in [0..@size])
        @xoff = 0.0

    next: (x=-1,y=0,z=0) ->
        [x,y,z] = [abs(x),abs(y),abs(z)]
        [x0,y0,z0] = [floor(x),floor(y),floor(z)]
        [x1,y1,z1] = [x-x0,y-y0,z-z0]
        [rx1,ry1] = [0,0]
        [r,amp] = [0,0.5]
        [n0,n1,n2] = [0,0,0]

        for i in [0...@octave]
            d0 = x0+(y0<<yw0)+(z0<<zw0)
            [rx1,ry1] = [cos_s(x1),cos_s(y1)]
            n0 = @arr[d0&@size]
            n0 += rx1*(@arr[(d0+1)&@size]-n0)
            n1 = @arr[(d0+yw1)&@size]
            n1 += rx1*(@arr[(d0+yw1+1)&@size]-n1)
            n0 += ry1*(n1-n0)
            d0 += @zw1
            n1 = @arr[d0&@size]
            n1 += rx1*(@arr[(d0+1)&@size]-n1)
            n2 = @arr[(d0+@yw1)&@size]
            n2 += rx1*(@arr[(d0+@yw1+1)&@size]-n2)
            n1 += ry1*(n2-n1)
            n0 += cos_s(z1)*(n1-n0)
            r += n0*amp
            amp *= @falloff
            [x0,y0,z0] = [x0<<1,y0<<1,z0<<1]
            [x1,y1,z1] = [x1*2,y1*2,z1*2]
            [x0,x1] = [x0+1,x1-1] if (x1>=1.0)
            [y0,y1] = [y0+1,y1-1] if (y1>=1.0)
            [z0,z1] = [z0+1,z1-1] if (z1>=1.0)
        return r

