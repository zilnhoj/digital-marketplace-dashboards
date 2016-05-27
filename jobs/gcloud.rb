# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
require "http"

current_users = 0

SCHEDULER.every '2s' do
	# last_users = current_users
	last_users = 20
	gcloud_data = HTTP.get("https://spreadsheets.google.com/feeds/list/1aIOMwIxpqZsy7tIyjj-9BOIsywLWkuiXvvaK-EUZqt4/od6/public/basic?alt=json")
	gcloud_data = gcloud_data.parse
	# g_cloud_framework_view = gcloud_data['feed']['entry'][0]['title']['$t']
	rt_users = gcloud_data['feed']['entry'][0]['content']['$t']
	rt_users = rt_users.delete "activeusers: "
	current_users = rt_users.to_i
	
	send_event('g_cloud_view', { current: current_users, last: last_users })
end

# current_valuation = 0
# current_karma = 0

# SCHEDULER.every '2s' do
#   last_valuation = current_valuation
#   last_karma     = current_karma
#   current_valuation = rand(100)
#   current_karma     = rand(200000)

#   send_event('valuation', { current: current_valuation, last: last_valuation })
#   send_event('karma', { current: current_karma, last: last_karma })
#   send_event('synergy',   { value: rand(100) })
# end