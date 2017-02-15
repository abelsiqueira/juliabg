#!/usr/local/bin/julia

using Images, Colors

function julia(cx, cy; lines = 100, cols = 100, maxiter=10)
  Cx = 0.0
  l = 2.0
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
  θ = 0.0
  rows = rand(1:4)
  cols = rows + div(rows, 2)
  w, h = 1920, 1080
  gw, gh = div(w, cols), div(h, rows)
  A = zeros(3, h, w)
  for gi = 1:rows
    for gj = 1:cols
      θ = rand() * 2π
      I = (gi-1) * gh + (1:gh)
      J = (gj-1) * gw + (1:gw)
      for i = 1:3
        r = 0.62 + (1.7 - 0.62) * rand()
        cx, cy = r * sin(θ), r * cos(θ)
        θ += 2π/3*rand()
        A[i,I,J] = julia(cx, cy, lines=gh, cols=gw, maxiter=100)
      end
    end
  end
  f = joinpath(ENV["HOME"], "juliabg.png")
  save(f, colorview(RGB, A))
  ENV["DISPLAY"] = ":0"
  run(`feh --bg-max --no-fehbg $f`)
end

genjuliabg()

