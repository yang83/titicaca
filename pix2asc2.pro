function pix2asc2, FILENAME, posx, posy

        fiss2map, FILENAME, map, WV=-4, /ROTNSHIFT
        asc1=pix2asc(fiss_rotate_pixel_position(FILENAME, posx, posy, FILENAME, /ROTNSHIFT), map)
        RETURN, asc1
end
