function mod_slitdata_missing, im

; INPUT : im : image has slit missing data.
; OUTPUT : im : image modified.
; 2014 Jun 25 H. Yang Created.

;        fa=findfile('20130817/ar/for_surge/*.fts')
        
 ;       im=readfits(fa[6], h)

        total_mean=mean(im)
        for i=1, n_elements(im[0, 0, *])-2 do begin
            if mean(im[*, *, i]) le 0 then begin
                  im[* ,*, i]= (im[*, *, i-1]+im[*, *, i+1])/2.
            endif
        endfor

return, im
end
