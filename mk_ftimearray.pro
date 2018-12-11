function mk_ftimearray, strt

   IF NOT KEYWORD_SET(strt) THEN return, 0
strt1=!NULL
   h=headfits(strt[0])

   str2=fxpar(h, 'DATE-OBS')
   str3=fxpar(h, 'DATE')
   
   IF KEYWORD_SET(str2) THEN nelem2=N_ELEMENTS(strsplit(str2, 'T-: ')) ELSE nelem2=0
   IF KEYWORD_SET(str3) THEN nelem3=N_ELEMENTS(strsplit(str3, 'T-: ')) ELSE nelem3=0

   n2= nelem2 eq 6
   n3= nelem3 eq 6
   
   IF n3 THEN headername='DATE'
   IF n2 THEN headername='DATE-OBS'
   
   ;headername
   FOR i=0, n_ELEMENTS(strt)-1 DO $
      strt1=[strt1, fxpar(headfits(strt[i]), headername)]
      
   RETURN, mkdatetoftime(strt1)
end
