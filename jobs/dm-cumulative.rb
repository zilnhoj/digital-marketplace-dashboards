require "http"

SCHEDULER.every '10s' do
	gcloud_cumulative = HTTP.headers(:accept => "application/json").get("https://spreadsheets.google.com/feeds/list/1t_Kr32IL7siM_-l0kGZ5JgpHCtT4upDqcWbDhK67AhY/od6/public/basic?alt=json")
	gcloud_cumulative = gcloud_cumulative.parse

	data_points = []
	gcloud_cumulative['feed']['entry'].each do |d| 
		# date = Data.parse(d["title"]["$t"])
		date = DateTime.parse(d["title"]["$t"]).to_time.to_i
		data = d['content']['$t']
		cumulative_value = /\d.{2,5}/.match(data)[0].to_i
		data_points << { x: date, y: cumulative_value }
		# data_points = data_points.push(data_hash)
		# data_points = [data_points]
	end
	puts data_points.class
	puts data_points
	send_event(:cumulative, points: data_points, displayedValue: data_points.first["y"])
end
