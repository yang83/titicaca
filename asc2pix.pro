function asc2pix, asc_x, asc_y, MAP, REF_FILE=REF_FILE;, FISS_FILENAME=FISS_FILENAME, MAGNIFY=MAGNIFY, ENLARGE=ENLARGE

;ASC2PIX
; OUTPUT : 2dim array for [pix_x, pix_y]
;          IF REF_FILE keyword set, [pix_x, pix_y] information is for the image before rotation.
;          else [pix_x, pix_y] is on the MAP.

;       2015 Mar 3 (H. YANG) REF_FILE keyword added.

        IF KEYWORD_SET(REF_FILE) THEN BEGIN
            h=headfits(REF_FILE)
            dx=fxpar(h, 'CDELT2')
            dy=fxpar(h, 'CDELT3')
            IF dx eq 0. then dx=0.16
            IF dy eq 0. then dy=0.16
            xc=fxpar(h, 'TEL_XPOS')
            yc=fxpar(h, 'TEL_YPOS')
            sz=fxpar(h, 'NAXIS2')>fxpar(h, 'NAXIS3')
            pix_x   =       sz/2.+(asc_x-xc)/dx
            pix_y   =       sz/2.+(asc_y-yc)/dy
            orig_pixel=fiss_original_pixel_position_before_rotnshift(REF_FILE, pix_x, pix_y)
            return, orig_pixel
        ENDIF ELSE BEGIN
            IF KEYWORD_SET(MAP) THEN BEGIN
                xc=map.xc
                yc=map.yc
                dx=map.dx
                dy=map.dy
                sz=size(map.data, /DIMENSION)
                pix_x   =       sz[0]/2.+(asc_x-xc)/dx
                pix_y   =       sz[1]/2.+(asc_y-yc)/dy
                return, [[pix_x], [pix_y]]
            ENDIF ELSE return, !NULL
        ENDELSE

;        IF KEYWORD_SET(FISS_FILENAME) THEN BEGIN
;            h=headfits(FISS_FILENAME)
           
 ;           x_shift=fxpar(h, 'YSHIFT_X')
 ;           y_shift=fxpar(h, 'YSHIFT_Y')
            
 ;           pix_x=pix_x-x_shift*MAGNIFY
 ;           pix_y=pix_y-y_shift*MAGNIFY
            
 ;           rot_angle   =fxpar(h, 'YROTANG')

                
 ;           res=fiss_rotate_pixel_position(FISS_FILENAME, 


;            im          =readfits(FISS_FILENAME)
;            sz1         =size(im, /DIMENSION)
;            imsize      =(sz1[1]>sz1[2])*ENLARGE
                

                
end
