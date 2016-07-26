function mk_ftimearray, strt


strt1=!NULL
   FOR i=0, n_ELEMENTS(strt)-1 DO $
      strt1=[strt1, fxpar(headfits(strt[i]), 'DATE')]
       
      
   RETURN, mkdatetoftime(strt1)
end
