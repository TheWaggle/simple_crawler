{time, _data} = :timer.tc(SimpleCrawler, :main, [])
IO.inspect(time / 60000000)
