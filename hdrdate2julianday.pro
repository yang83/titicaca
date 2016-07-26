pro hdrdate2julianday, datestr, year, month, day, hours=hours
	start_str_temp      =   strsplit(datestr, ' -T', /extract)
	year				=	start_str_temp(0)
	month				=	start_str_temp(1)
	day					=	start_str_temp(2)
	ftime				=	mkdatetoftime(start_str_temp(3))
	hours				=	ftime
end
