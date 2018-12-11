function eps_pos, XSIZE, HOWMANY_X, HOWMANY_Y, POSITION=POSITION, PTR_POS_RET, FRACTION=FRACTION
;Purpose : to return a size of the y axis to howmany_x * howmany_y image sets.
;fraction : x axis FOV / y_axis FOV
;2015 H.YANG
        ;RETURN VALUE : YSIZE

        IF NOT KEYWORD_SET(POSITION) THEN POSITION=[0.1, 0.1, 0.9, 0.9]
        IF NOT KEYWORD_SET(FRACTION) THEN FRACTION=1.

        dx=(POSITION[2]-POSITION[0])/HOWMANY_X
        dy=(POSITION[3]-POSITION[1])/HOWMANY_Y

        a_arr=!NULL
        FOR j=0, HOWMANY_Y-1 DO BEGIN
            FOR i=0, HOWMANY_X-1 DO BEGIN
                x1      =       POSITION[0]+dx*i
                x2      =       POSITION[0]+dx*(i+1)
                y1      =       POSITION[1]+dy*j
                y2      =       POSITION[1]+dy*(j+1)
                a=ptr_new([x1, y1, x2, y2])

                a_arr=[a_arr, a]
               
            ENDFOR
        ENDFOR

        PTR_POS_RET=a_arr

        return, FLOAT(XSIZE)*dx/dy/fraction
end
            
