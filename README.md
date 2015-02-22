Edgarex
=======

#### Fetching an index
```elixir
alias Edgarex.Fetcher

#get the first 50 records in `crawler.idx` for 2014, quarter 4.
#note that this is a stream, and will only download the chunks 
#from the ftp server that you need. As a result, Enum.take(stream, 50)
#will complete much faster than Enum.into([]), which will exhaust the stream
some_items = Fetcher.crawler(2014, 4) |> Enum.take(50)

#An item in `some_items` might look like
%{
	cik: "1623034", 
	company_name: "101 Sheridan Apartments, LLC",
	date_filed: "2014-10-30", 
	form_type: "D",
	url: "http://www.sec.gov/Archives/edgar/data/1623034/0001623034-14-000001-index.htm"
}



#similarly, you can get other indexes, which look similar
#get the `form.idx` for 2014, quarter 4
Fetcher.form(2014, 4)

#get the `xbrl.idx` for 2014, quarter 4
Fetcher.xbrl(2014, 4)

#get the `master.idx` for 2014, quarter 4
Fetcher.master(2014, 4)


```

