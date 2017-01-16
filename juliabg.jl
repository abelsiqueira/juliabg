#!/usr/local/bin/julia

using Images, Colors

function julia(cx, cy; lines = 100, cols = 100, maxiter=10)
  Cx = 0.0
  l = 1.4
  r = l*cols/lines
  y = linspace(-l, l, lines)
  x = linspace(Cx - r, Cx + r, cols)
  K = zeros(lines, cols)
  for i = 1:lines
    y0 = y[lines-i+1]
    for j = 1:cols
      x0 = x[j]
      z = x0 + im*y0
      for k = 0:maxiter
        z = z^2 + cx + im*cy
        if abs(z) > 4
          K[i,j] = 1-exp(-k/10)
          break
        end
      end
    end
  end
  return K
end

"""genjuliabg()

This function assumes that there is a file called juliabg.png on this
folder. It simply updates that file.
"""
function genjuliabg()
  f = joinpath(ENV["HOME"], "juliabg.png")
  θ = 0.0
  w, h = 1920, 1080
  A = zeros(h, w, 3)
  r = 0.62 + (1.7 - 0.62) * rand()
  θ = rand() * 2π
  for i = 1:3
    cx, cy = r * sin(θ), r * cos(θ)
    θ += π/2
    A[:,:,i] = julia(cx, cy, lines=h, cols=w, maxiter=100)
  end
  save(f, convert(Image, A))
  ENV["DISPLAY"] = ":0"
  run(`feh --bg-max --no-fehbg $f`)
end

genjuliabg()

