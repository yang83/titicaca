pro mkmap_h, f1, f2, wv1=wv1, wv2=wv2, DRANGE1=DRANGE1, DRANGE2=DRANGE2, DRANGE3=DRANGE3, DRANGE4=DRANGE4, DRANGE5=DRANGE5, DRANGE6=DRANGE6, XRANGE=XRANGE, YRANGE=YRANGE

        device, retain=2
        !P.MULTI=[0, 3, 2]
        fiss2map, f1[0], map1, wv=[-1, 0, 1], /ROTNSHIFT
        
        window, xs=1280, ys=1024
        for i=0, n_elements(f1)-1 do begin
            fiss2map, f1[i], map1, wv=[-1, 0, 1], /ROTNSHIFT
            fiss2map, f2[i], map2, wv=[-1, 0, 1], /ROTNSHIFT


            plot_map, map1[0], DRANGE=DRANGE1, XRANGE=XRANGE, YRANGE=YRANGE
            plot_map, map1[1], DRANGE=DRANGE2, XRANGE=XRANGE, YRANGE=YRANGE
            plot_map, map1[2], DRANGE=DRANGE3, XRANGE=XRANGE, YRANGE=YRANGE
            plot_map, map2[0], DRANGE=DRANGE4, XRANGE=XRANGE, YRANGE=YRANGE
            plot_map, map2[1], DRANGE=DRANGE5, XRANGE=XRANGE, YRANGE=YRANGE
            plot_map, map2[2], DRANGE=DRANGE6, XRANGE=XRANGE, YRANGE=YRANGE
            write_png, f1[i]+'_m.png', TVRD()
        endfor

end
