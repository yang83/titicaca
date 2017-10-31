PRO tio_imalign, FILE_ARRAY,  ANGLE_INFO, FIRST=FIRST, WINDOW_SIZE=WINDOW_SIZE, X_WINDOW_SIZE=X_WINDOW_SIZE, Y_WINDOW_SIZE=Y_WINDOW_SIZE, REFERENCE_ANGLE=REFERENCE_ANGLE, REFERENCE_FILE=REFERENCE_FILE, OFFSET_INFO, $
    POSX=POSX, POSY=POSY

        IF NOT KEYWORD_SET(REFERENCE_FILE) THEN REFERENCE_FILE=FILE_ARRAY[0]
        IF NOT KEYWORD_SET(REFERENCE_ANGLE) THEN REFERENCE_ANGLE=ANGLE_INFO[0]
        
        tio2map, REFERENCE_FILE, map1, ANGLE=REFERENCE_ANGLE
        ;map1.xc=0 & map1.yc=0 & map1.dx=1 & map1.dy=1
        im1=map1.data 
        IF NOT KEYWORD_SET(POSX) THEN BEGIN
                WINDOW, XS=800, YS=800
                PLOT_IMAGE, im1, POSITION=[0, 0, 1, 1]
                print, '=================================='
                print, 'choose the position for alignment.'
                cursor, POSX, POSY, /data
                print, 'POS (X, Y) : (', POSX, ', ', POSY, ')'
                print, '=================================='
        ENDIF

        IF WINDOW_SIZE THEN BEGIN
                XRANGE=[-WINDOW_SIZE, WINDOW_SIZE] 
                YRANGE=[-WINDOW_SIZE, WINDOW_SIZE]
        ENDIF
        IF KEYWORD_SET(X_WINDOW_SIZE) THEN XRANGE=[-X_WINDOW_SIZE, X_WINDOW_SIZE] 
        IF KEYWORD_SET(Y_WINDOW_SIZE) THEN YRANGE=[-Y_WINDOW_SIZE, Y_WINDOW_SIZE]
        IF NOT KEYWORD_SET(XRANGE) THEN XRANGE=[-100, 100]
        IF NOT KEYWORD_SET(YRANGE) THEN YRANGE=[-100, 100]


        OFFSET_X=!NULL & OFFSET_Y=!NULL
        sz=size(im1)
        ima=MAKE_ARRAY(sz[1], sz[2], 10, TYPE=sz[3])
        SCROLLWINDOW, XS=1200, YS=1200
        FOR i=0, N_ELEMENTS(FILE_ARRAY)-1 DO BEGIN
                tio2map, FILE_ARRAY[i], map2, ANGLE=ANGLE_INFO[i]
                im2=map2.data

                sim1=im1[POSX+XRANGE[0]*2:POSX+XRANGE[1]*2, POSY+YRANGE[0]*2:POSY+YRANGE[1]*2]     
                sim2=im2[POSX+XRANGE[0]*2:POSX+XRANGE[1]*2, POSY+YRANGE[0]*2:POSY+YRANGE[1]*2]
                xyshift =       alignoffset(sim1, sim2)
              

                im2x=shift_sub(im2, xyshift[0], xyshift[1])
                sim1=im1[POSX+XRANGE[0]:POSX+XRANGE[1], POSY+YRANGE[0]:POSY+YRANGE[1]]      
                sim2=im2x[POSX+XRANGE[0]:POSX+XRANGE[1], POSY+YRANGE[0]:POSY+YRANGE[1]]

                xyshift2 =       alignoffset(sim1, sim2)
              
                print, STRING(i, FORMAT='(i03)')+'/'+STRING(N_ELEMENTS(FILE_ARRAY), FORMAT='(I4)')
                print, '  xyshift = ', xyshift 
                print, 'xyshift2 = ', xyshift2
                
                im2x=shift_sub(im2, xyshift[0]+xyshift2[0], xyshift[1]+xyshift2[1])      
                sim2=im2x[POSX+XRANGE[0]:POSX+XRANGE[1], POSY+YRANGE[0]:POSY+YRANGE[1]]

                
                IF NOT KEYWORD_SET(FIRST) THEN BEGIN
                    ima[*, *, i mod 10]=im2x
                    im1=total(ima, 3)/10.
                ENDIF
                FILENAME        =       (STRSPLIT(FILE_ARRAY(i), '.', /EXTRACT))[0] + 's'
                
               
                tvscl, congrid(sim2, 50, 50), i
                write_png, FILENAME+'.png', bytscl(sim2)
                OFFSET_X=[OFFSET_X, xyshift[0]+xyshift2[0]] & OFFSET_Y=[OFFSET_Y, xyshift[1]+xyshift2[1]]
        ENDFOR
        OFFSET_INFO=[[OFFSET_X], [OFFSET_Y]]
end

        
