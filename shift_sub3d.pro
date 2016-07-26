function shift_sub3d, image, x0, y0, z0, cubic=cubic
;+
; NAME: SHIFT_SUB
; PURPOSE:
;     Shift an image with subpixel accuracies
; CALLING SEQUENCE:
;      Result = shift_sub(image, x0, y0)
; HISTORY
;      2004 August, J. Chae, Added the keyword:cubic  for cubic spline interpolation option
;	   2013 Oct, Heesu Yang, Added z axis.
;-

;if keyword_set(z0) then  
if fix(x0)-x0 eq 0. and fix(y0)-y0 eq 0. and fix(z0)-z0 eq 0. then return, shift(image, x0, y0, z0)

s =size(image, /DIMENSION)

;x=findgen(s(0))#replicate(1., s(1))

;y=replicate(1., s(0))#findgen(s(1))

x=cgscalevector(findgen(s[0]), -x0, -x0+s[0]-1)
y=cgscalevector(findgen(s[1]), -y0, -y0+s[1]-1)	
z=cgscalevector(findgen(s[2]), -z0, -z0+s[2]-1)
	
	
x1= x>0<(s(0)-1.)
y1= y>0<(s(1)-1.)
z1= z>0<(s(2)-1.)
return, interpolate(image, x1, y1, z1, /GRID)
end
