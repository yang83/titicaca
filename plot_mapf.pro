function plot_mapf, map, XRANGE=XRANGE, YRANGE=YRANGE, SQUARE=SQUARE, DRANGE=DRANGE, POSITION=POSITION, LOG=LOG, AXIS_STYLE=AXIS_STYLE, _extra=extra
        sz=size(map.data, /DIMENSION)
       
        IF KEYWORD_SET(DRANGE) THEN BEGIN
            MIN_VALUE=DRANGE[0]
            MAX_VALUE=DRANGE[1]
        ENDIF
        IF AXIS_STYLE eq !NULL THEN AXIS_STYLE=2
        IF NOT KEYWORD_SET(XRANGE) THEN XRANGE=[map.xc-map.dx*sz[0]/2., map.xc+map.dx*sz[0]/2.] 
        IF NOT KEYWORD_SET(YRANGE) THEN YRANGE=[map.yc-map.dy*sz[1]/2., map.yc+map.dy*sz[1]/2.]
        ratio_pos=1
        ratio_win=1
        IF KEYWORD_SET(POSITION) THEN BEGIN
            t=getwindows()
            r=t[-1].dimensions
            ratio_win=r[0]/r[1]
            ratio_pos=(POSITION[2]-POSITION[0])/(POSITION[3]-POSITION[1])
            ASPECT_RATIO=(XRANGE[1]-XRANGE[0])/(YRANGE[1]-YRANGE[0])/ratio_pos/ratio_win
        ENDIF

        IF KEYWORD_SET(SQUARE) THEN $
            ASPECT_RATIO=(XRANGE[1]-XRANGE[0])/(YRANGE[1]-YRANGE[0])

            ;ASPECT_RATIO=(map.dx*sz[0])/(map.dy*sz[1])
        x=map.xc-map.dx*sz[0]/2.+FINDGEN(sz[0])*map.dx
        y=map.yc-map.dy*sz[1]/2.+FINDGEN(sz[1])*map.dy

        IF KEYWORD_SET(LOG) THEN BEGIN
            map.data=alog10(map.data)
            MIN_VALUE=alog10(MIN_VALUE)
            MAX_VALUE=alog10(MAX_VALUE)
        ENDIF
        return, IMAGE(map.data, x, y, AXIS_STYLE=AXIS_STYLE, XRANGE=XRANGE, YRANGE=YRANGE, ASPECT_RATIO=ASPECT_RATIO, MIN_VALUE=MIN_VALUE, MAX_VALUE=MAX_VALUE, POSITION=POSITION, _STRICT_EXTRA=extra)

        end
